
/*
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>
#include <see_event.h>


#define SEE_SYSLOG_MAX_STR                                                    \
    SEE_MAX_ERROR_STR + sizeof("<255>Jan 01 00:00:00 ") - 1                   \
    + (SEE_MAXHOSTNAMELEN - 1) + 1 /* space */                                \
    + 32 /* tag */ + 2 /* colon, space */


static char *see_syslog_parse_args(see_conf_t *cf, see_syslog_peer_t *peer);
static see_int_t see_syslog_init_peer(see_syslog_peer_t *peer);
static void see_syslog_cleanup(void *data);


static char  *facilities[] = {
    "kern", "user", "mail", "daemon", "auth", "intern", "lpr", "news", "uucp",
    "clock", "authpriv", "ftp", "ntp", "audit", "alert", "cron", "local0",
    "local1", "local2", "local3", "local4", "local5", "local6", "local7",
    NULL
};

/* note 'error/warn' like in nginx.conf, not 'err/warning' */
static char  *severities[] = {
    "emerg", "alert", "crit", "error", "warn", "notice", "info", "debug", NULL
};

static see_log_t    see_syslog_dummy_log;
static see_event_t  see_syslog_dummy_event;


char *
see_syslog_process_conf(see_conf_t *cf, see_syslog_peer_t *peer)
{
    peer->pool = cf->pool;
    peer->facility = SEE_CONF_UNSET_UINT;
    peer->severity = SEE_CONF_UNSET_UINT;

    if (see_syslog_parse_args(cf, peer) != SEE_CONF_OK) {
        return SEE_CONF_ERROR;
    }

    if (peer->server.sockaddr == NULL) {
        see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                           "no syslog server specified");
        return SEE_CONF_ERROR;
    }

    if (peer->facility == SEE_CONF_UNSET_UINT) {
        peer->facility = 23; /* local7 */
    }

    if (peer->severity == SEE_CONF_UNSET_UINT) {
        peer->severity = 6; /* info */
    }

    if (peer->tag.data == NULL) {
        see_str_set(&peer->tag, "nginx");
    }

    peer->conn.fd = (see_socket_t) -1;

    return SEE_CONF_OK;
}


static char *
see_syslog_parse_args(see_conf_t *cf, see_syslog_peer_t *peer)
{
    u_char      *p, *comma, c;
    size_t       len;
    see_str_t   *value;
    see_url_t    u;
    see_uint_t   i;

    value = cf->args->elts;

    p = value[1].data + sizeof("syslog:") - 1;

    for ( ;; ) {
        comma = (u_char *) see_strchr(p, ',');

        if (comma != NULL) {
            len = comma - p;
            *comma = '\0';

        } else {
            len = value[1].data + value[1].len - p;
        }

        if (see_strncmp(p, "server=", 7) == 0) {

            if (peer->server.sockaddr != NULL) {
                see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                   "duplicate syslog \"server\"");
                return SEE_CONF_ERROR;
            }

            see_memzero(&u, sizeof(see_url_t));

            u.url.data = p + 7;
            u.url.len = len - 7;
            u.default_port = 514;

            if (see_parse_url(cf->pool, &u) != SEE_OK) {
                if (u.err) {
                    see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                       "%s in syslog server \"%V\"",
                                       u.err, &u.url);
                }

                return SEE_CONF_ERROR;
            }

            peer->server = u.addrs[0];

        } else if (see_strncmp(p, "facility=", 9) == 0) {

            if (peer->facility != SEE_CONF_UNSET_UINT) {
                see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                   "duplicate syslog \"facility\"");
                return SEE_CONF_ERROR;
            }

            for (i = 0; facilities[i] != NULL; i++) {

                if (see_strcmp(p + 9, facilities[i]) == 0) {
                    peer->facility = i;
                    goto next;
                }
            }

            see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                               "unknown syslog facility \"%s\"", p + 9);
            return SEE_CONF_ERROR;

        } else if (see_strncmp(p, "severity=", 9) == 0) {

            if (peer->severity != SEE_CONF_UNSET_UINT) {
                see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                   "duplicate syslog \"severity\"");
                return SEE_CONF_ERROR;
            }

            for (i = 0; severities[i] != NULL; i++) {

                if (see_strcmp(p + 9, severities[i]) == 0) {
                    peer->severity = i;
                    goto next;
                }
            }

            see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                               "unknown syslog severity \"%s\"", p + 9);
            return SEE_CONF_ERROR;

        } else if (see_strncmp(p, "tag=", 4) == 0) {

            if (peer->tag.data != NULL) {
                see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                   "duplicate syslog \"tag\"");
                return SEE_CONF_ERROR;
            }

            /*
             * RFC 3164: the TAG is a string of ABNF alphanumeric characters
             * that MUST NOT exceed 32 characters.
             */
            if (len - 4 > 32) {
                see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                   "syslog tag length exceeds 32");
                return SEE_CONF_ERROR;
            }

            for (i = 4; i < len; i++) {
                c = see_tolower(p[i]);

                if (c < '0' || (c > '9' && c < 'a' && c != '_') || c > 'z') {
                    see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                       "syslog \"tag\" only allows "
                                       "alphanumeric characters "
                                       "and underscore");
                    return SEE_CONF_ERROR;
                }
            }

            peer->tag.data = p + 4;
            peer->tag.len = len - 4;

        } else if (len == 10 && see_strncmp(p, "nohostname", 10) == 0) {
            peer->nohostname = 1;

        } else {
            see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                               "unknown syslog parameter \"%s\"", p);
            return SEE_CONF_ERROR;
        }

    next:

        if (comma == NULL) {
            break;
        }

        p = comma + 1;
    }

    return SEE_CONF_OK;
}


u_char *
see_syslog_add_header(see_syslog_peer_t *peer, u_char *buf)
{
    see_uint_t  pri;

    pri = peer->facility * 8 + peer->severity;

    if (peer->nohostname) {
        return see_sprintf(buf, "<%ui>%V %V: ", pri, &see_cached_syslog_time,
                           &peer->tag);
    }

    return see_sprintf(buf, "<%ui>%V %V %V: ", pri, &see_cached_syslog_time,
                       &see_cycle->hostname, &peer->tag);
}


void
see_syslog_writer(see_log_t *log, see_uint_t level, u_char *buf,
    size_t len)
{
    u_char             *p, msg[SEE_SYSLOG_MAX_STR];
    see_uint_t          head_len;
    see_syslog_peer_t  *peer;

    peer = log->wdata;

    if (peer->busy) {
        return;
    }

    peer->busy = 1;
    peer->severity = level - 1;

    p = see_syslog_add_header(peer, msg);
    head_len = p - msg;

    len -= SEE_LINEFEED_SIZE;

    if (len > SEE_SYSLOG_MAX_STR - head_len) {
        len = SEE_SYSLOG_MAX_STR - head_len;
    }

    p = see_snprintf(p, len, "%s", buf);

    (void) see_syslog_send(peer, msg, p - msg);

    peer->busy = 0;
}


ssize_t
see_syslog_send(see_syslog_peer_t *peer, u_char *buf, size_t len)
{
    ssize_t  n;

    if (peer->conn.fd == (see_socket_t) -1) {
        if (see_syslog_init_peer(peer) != SEE_OK) {
            return SEE_ERROR;
        }
    }

    /* log syslog socket events with valid log */
    peer->conn.log = see_cycle->log;

    if (see_send) {
        n = see_send(&peer->conn, buf, len);

    } else {
        /* event module has not yet set see_io */
        n = see_os_io.send(&peer->conn, buf, len);
    }

#if (SEE_HAVE_UNIX_DOMAIN)

    if (n == SEE_ERROR && peer->server.sockaddr->sa_family == AF_UNIX) {

        if (see_close_socket(peer->conn.fd) == -1) {
            see_log_error(SEE_LOG_ALERT, see_cycle->log, see_socket_errno,
                          see_close_socket_n " failed");
        }

        peer->conn.fd = (see_socket_t) -1;
    }

#endif

    return n;
}


static see_int_t
see_syslog_init_peer(see_syslog_peer_t *peer)
{
    see_socket_t         fd;
    see_pool_cleanup_t  *cln;

    peer->conn.read = &see_syslog_dummy_event;
    peer->conn.write = &see_syslog_dummy_event;

    see_syslog_dummy_event.log = &see_syslog_dummy_log;

    fd = see_socket(peer->server.sockaddr->sa_family, SOCK_DGRAM, 0);
    if (fd == (see_socket_t) -1) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_socket_errno,
                      see_socket_n " failed");
        return SEE_ERROR;
    }

    if (see_nonblocking(fd) == -1) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_socket_errno,
                      see_nonblocking_n " failed");
        goto failed;
    }

    if (connect(fd, peer->server.sockaddr, peer->server.socklen) == -1) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_socket_errno,
                      "connect() failed");
        goto failed;
    }

    cln = see_pool_cleanup_add(peer->pool, 0);
    if (cln == NULL) {
        goto failed;
    }

    cln->data = peer;
    cln->handler = see_syslog_cleanup;

    peer->conn.fd = fd;

    /* UDP sockets are always ready to write */
    peer->conn.write->ready = 1;

    return SEE_OK;

failed:

    if (see_close_socket(fd) == -1) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_socket_errno,
                      see_close_socket_n " failed");
    }

    return SEE_ERROR;
}


static void
see_syslog_cleanup(void *data)
{
    see_syslog_peer_t  *peer = data;

    /* prevents further use of this peer */
    peer->busy = 1;

    if (peer->conn.fd == (see_socket_t) -1) {
        return;
    }

    if (see_close_socket(peer->conn.fd) == -1) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_socket_errno,
                      see_close_socket_n " failed");
    }
}
