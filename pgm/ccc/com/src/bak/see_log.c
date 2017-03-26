
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>


static char *see_error_log(see_conf_t *cf, see_command_t *cmd, void *conf);
static char *see_log_set_levels(see_conf_t *cf, see_log_t *log);
static void see_log_insert(see_log_t *log, see_log_t *new_log);


#if (SEE_DEBUG)

static void see_log_memory_writer(see_log_t *log, see_uint_t level,
    u_char *buf, size_t len);
static void see_log_memory_cleanup(void *data);


typedef struct {
    u_char        *start;
    u_char        *end;
    u_char        *pos;
    see_atomic_t   written;
} see_log_memory_buf_t;

#endif


static see_command_t  see_errlog_commands[] = {

    { see_string("error_log"),
      SEE_MAIN_CONF|SEE_CONF_1MORE,
      see_error_log,
      0,
      0,
      NULL },

      see_null_command
};


static see_core_module_t  see_errlog_module_ctx = {
    see_string("errlog"),
    NULL,
    NULL
};


see_module_t  see_errlog_module = {
    SEE_MODULE_V1,
    &see_errlog_module_ctx,                /* module context */
    see_errlog_commands,                   /* module directives */
    SEE_CORE_MODULE,                       /* module type */
    NULL,                                  /* init master */
    NULL,                                  /* init module */
    NULL,                                  /* init process */
    NULL,                                  /* init thread */
    NULL,                                  /* exit thread */
    NULL,                                  /* exit process */
    NULL,                                  /* exit master */
    SEE_MODULE_V1_PADDING
};


static see_log_t        see_log;
static see_open_file_t  see_log_file;
see_uint_t              see_use_stderr = 1;


static see_str_t err_levels[] = {
    see_null_string,
    see_string("emerg"),
    see_string("alert"),
    see_string("crit"),
    see_string("error"),
    see_string("warn"),
    see_string("notice"),
    see_string("info"),
    see_string("debug")
};

static const char *debug_levels[] = {
    "debug_core", "debug_alloc", "debug_mutex", "debug_event",
    "debug_http", "debug_mail", "debug_stream"
};


#if (SEE_HAVE_VARIADIC_MACROS)

void
see_log_error_core(see_uint_t level, see_log_t *log, see_err_t err,
    const char *fmt, ...)

#else

void
see_log_error_core(see_uint_t level, see_log_t *log, see_err_t err,
    const char *fmt, va_list args)

#endif
{
#if (SEE_HAVE_VARIADIC_MACROS)
    va_list      args;
#endif
    u_char      *p, *last, *msg;
    ssize_t      n;
    see_uint_t   wrote_stderr, debug_connection;
    u_char       errstr[SEE_MAX_ERROR_STR];

    last = errstr + SEE_MAX_ERROR_STR;

    p = see_cpymem(errstr, see_cached_err_log_time.data,
                   see_cached_err_log_time.len);

    p = see_slprintf(p, last, " [%V] ", &err_levels[level]);

    /* pid#tid */
    p = see_slprintf(p, last, "%P#" SEE_TID_T_FMT ": ",
                    see_log_pid, see_log_tid);

    if (log->connection) {
        p = see_slprintf(p, last, "*%uA ", log->connection);
    }

    msg = p;

#if (SEE_HAVE_VARIADIC_MACROS)

    va_start(args, fmt);
    p = see_vslprintf(p, last, fmt, args);
    va_end(args);

#else

    p = see_vslprintf(p, last, fmt, args);

#endif

    if (err) {
        p = see_log_errno(p, last, err);
    }

    if (level != SEE_LOG_DEBUG && log->handler) {
        p = log->handler(log, p, last - p);
    }

    if (p > last - SEE_LINEFEED_SIZE) {
        p = last - SEE_LINEFEED_SIZE;
    }

    see_linefeed(p);

    wrote_stderr = 0;
    debug_connection = (log->log_level & SEE_LOG_DEBUG_CONNECTION) != 0;

    while (log) {

        if (log->log_level < level && !debug_connection) {
            break;
        }

        if (log->writer) {
            log->writer(log, level, errstr, p - errstr);
            goto next;
        }

        if (see_time() == log->disk_full_time) {

            /*
             * on FreeBSD writing to a full filesystem with enabled softupdates
             * may block process for much longer time than writing to non-full
             * filesystem, so we skip writing to a log for one second
             */

            goto next;
        }

        n = see_write_fd(log->file->fd, errstr, p - errstr);

        if (n == -1 && see_errno == SEE_ENOSPC) {
            log->disk_full_time = see_time();
        }

        if (log->file->fd == see_stderr) {
            wrote_stderr = 1;
        }

    next:

        log = log->next;
    }

    if (!see_use_stderr
        || level > SEE_LOG_WARN
        || wrote_stderr)
    {
        return;
    }

    msg -= (7 + err_levels[level].len + 3);

    (void) see_sprintf(msg, "nginx: [%V] ", &err_levels[level]);

    (void) see_write_console(see_stderr, msg, p - msg);
}


#if !(SEE_HAVE_VARIADIC_MACROS)

void see_cdecl
see_log_error(see_uint_t level, see_log_t *log, see_err_t err,
    const char *fmt, ...)
{
    va_list  args;

    if (log->log_level >= level) {
        va_start(args, fmt);
        see_log_error_core(level, log, err, fmt, args);
        va_end(args);
    }
}


void see_cdecl
see_log_debug_core(see_log_t *log, see_err_t err, const char *fmt, ...)
{
    va_list  args;

    va_start(args, fmt);
    see_log_error_core(SEE_LOG_DEBUG, log, err, fmt, args);
    va_end(args);
}

#endif


void see_cdecl
see_log_abort(see_err_t err, const char *fmt, ...)
{
    u_char   *p;
    va_list   args;
    u_char    errstr[SEE_MAX_CONF_ERRSTR];

    va_start(args, fmt);
    p = see_vsnprintf(errstr, sizeof(errstr) - 1, fmt, args);
    va_end(args);

    see_log_error(SEE_LOG_ALERT, see_cycle->log, err,
                  "%*s", p - errstr, errstr);
}


void see_cdecl
see_log_stderr(see_err_t err, const char *fmt, ...)
{
    u_char   *p, *last;
    va_list   args;
    u_char    errstr[SEE_MAX_ERROR_STR];

    last = errstr + SEE_MAX_ERROR_STR;

    p = see_cpymem(errstr, "nginx: ", 7);

    va_start(args, fmt);
    p = see_vslprintf(p, last, fmt, args);
    va_end(args);

    if (err) {
        p = see_log_errno(p, last, err);
    }

    if (p > last - SEE_LINEFEED_SIZE) {
        p = last - SEE_LINEFEED_SIZE;
    }

    see_linefeed(p);

    (void) see_write_console(see_stderr, errstr, p - errstr);
}


u_char *
see_log_errno(u_char *buf, u_char *last, see_err_t err)
{
    if (buf > last - 50) {

        /* leave a space for an error code */

        buf = last - 50;
        *buf++ = '.';
        *buf++ = '.';
        *buf++ = '.';
    }

#if (SEE_WIN32)
    buf = see_slprintf(buf, last, ((unsigned) err < 0x80000000)
                                       ? " (%d: " : " (%Xd: ", err);
#else
    buf = see_slprintf(buf, last, " (%d: ", err);
#endif

    buf = see_strerror(err, buf, last - buf);

    if (buf < last) {
        *buf++ = ')';
    }

    return buf;
}


see_log_t *
see_log_init(u_char *prefix)
{
    u_char  *p, *name;
    size_t   nlen, plen;

    see_log.file = &see_log_file;
    see_log.log_level = SEE_LOG_NOTICE;

    name = (u_char *) SEE_ERROR_LOG_PATH;

    /*
     * we use see_strlen() here since BCC warns about
     * condition is always false and unreachable code
     */

    nlen = see_strlen(name);

    if (nlen == 0) {
        see_log_file.fd = see_stderr;
        return &see_log;
    }

    p = NULL;

#if (SEE_WIN32)
    if (name[1] != ':') {
#else
    if (name[0] != '/') {
#endif

        if (prefix) {
            plen = see_strlen(prefix);

        } else {
#ifdef SEE_PREFIX
            prefix = (u_char *) SEE_PREFIX;
            plen = see_strlen(prefix);
#else
            plen = 0;
#endif
        }

        if (plen) {
            name = malloc(plen + nlen + 2);
            if (name == NULL) {
                return NULL;
            }

            p = see_cpymem(name, prefix, plen);

            if (!see_path_separator(*(p - 1))) {
                *p++ = '/';
            }

            see_cpystrn(p, (u_char *) SEE_ERROR_LOG_PATH, nlen + 1);

            p = name;
        }
    }

    see_log_file.fd = see_open_file(name, SEE_FILE_APPEND,
                                    SEE_FILE_CREATE_OR_OPEN,
                                    SEE_FILE_DEFAULT_ACCESS);

    if (see_log_file.fd == SEE_INVALID_FILE) {
        see_log_stderr(see_errno,
                       "[alert] could not open error log file: "
                       see_open_file_n " \"%s\" failed", name);
#if (SEE_WIN32)
        see_event_log(see_errno,
                       "could not open error log file: "
                       see_open_file_n " \"%s\" failed", name);
#endif

        see_log_file.fd = see_stderr;
    }

    if (p) {
        see_free(p);
    }

    return &see_log;
}


see_int_t
see_log_open_default(see_cycle_t *cycle)
{
    see_log_t         *log;
    static see_str_t   error_log = see_string(SEE_ERROR_LOG_PATH);

    if (see_log_get_file_log(&cycle->new_log) != NULL) {
        return SEE_OK;
    }

    if (cycle->new_log.log_level != 0) {
        /* there are some error logs, but no files */

        log = see_pcalloc(cycle->pool, sizeof(see_log_t));
        if (log == NULL) {
            return SEE_ERROR;
        }

    } else {
        /* no error logs at all */
        log = &cycle->new_log;
    }

    log->log_level = SEE_LOG_ERR;

    log->file = see_conf_open_file(cycle, &error_log);
    if (log->file == NULL) {
        return SEE_ERROR;
    }

    if (log != &cycle->new_log) {
        see_log_insert(&cycle->new_log, log);
    }

    return SEE_OK;
}


see_int_t
see_log_redirect_stderr(see_cycle_t *cycle)
{
    see_fd_t  fd;

    if (cycle->log_use_stderr) {
        return SEE_OK;
    }

    /* file log always exists when we are called */
    fd = see_log_get_file_log(cycle->log)->file->fd;

    if (fd != see_stderr) {
        if (see_set_stderr(fd) == SEE_FILE_ERROR) {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          see_set_stderr_n " failed");

            return SEE_ERROR;
        }
    }

    return SEE_OK;
}


see_log_t *
see_log_get_file_log(see_log_t *head)
{
    see_log_t  *log;

    for (log = head; log; log = log->next) {
        if (log->file != NULL) {
            return log;
        }
    }

    return NULL;
}


static char *
see_log_set_levels(see_conf_t *cf, see_log_t *log)
{
    see_uint_t   i, n, d, found;
    see_str_t   *value;

    if (cf->args->nelts == 2) {
        log->log_level = SEE_LOG_ERR;
        return SEE_CONF_OK;
    }

    value = cf->args->elts;

    for (i = 2; i < cf->args->nelts; i++) {
        found = 0;

        for (n = 1; n <= SEE_LOG_DEBUG; n++) {
            if (see_strcmp(value[i].data, err_levels[n].data) == 0) {

                if (log->log_level != 0) {
                    see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                       "duplicate log level \"%V\"",
                                       &value[i]);
                    return SEE_CONF_ERROR;
                }

                log->log_level = n;
                found = 1;
                break;
            }
        }

        for (n = 0, d = SEE_LOG_DEBUG_FIRST; d <= SEE_LOG_DEBUG_LAST; d <<= 1) {
            if (see_strcmp(value[i].data, debug_levels[n++]) == 0) {
                if (log->log_level & ~SEE_LOG_DEBUG_ALL) {
                    see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                                       "invalid log level \"%V\"",
                                       &value[i]);
                    return SEE_CONF_ERROR;
                }

                log->log_level |= d;
                found = 1;
                break;
            }
        }


        if (!found) {
            see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                               "invalid log level \"%V\"", &value[i]);
            return SEE_CONF_ERROR;
        }
    }

    if (log->log_level == SEE_LOG_DEBUG) {
        log->log_level = SEE_LOG_DEBUG_ALL;
    }

    return SEE_CONF_OK;
}


static char *
see_error_log(see_conf_t *cf, see_command_t *cmd, void *conf)
{
    see_log_t  *dummy;

    dummy = &cf->cycle->new_log;

    return see_log_set_log(cf, &dummy);
}


char *
see_log_set_log(see_conf_t *cf, see_log_t **head)
{
    see_log_t          *new_log;
    see_str_t          *value, name;
    see_syslog_peer_t  *peer;

    if (*head != NULL && (*head)->log_level == 0) {
        new_log = *head;

    } else {

        new_log = see_pcalloc(cf->pool, sizeof(see_log_t));
        if (new_log == NULL) {
            return SEE_CONF_ERROR;
        }

        if (*head == NULL) {
            *head = new_log;
        }
    }

    value = cf->args->elts;

    if (see_strcmp(value[1].data, "stderr") == 0) {
        see_str_null(&name);
        cf->cycle->log_use_stderr = 1;

        new_log->file = see_conf_open_file(cf->cycle, &name);
        if (new_log->file == NULL) {
            return SEE_CONF_ERROR;
        }

    } else if (see_strncmp(value[1].data, "memory:", 7) == 0) {

#if (SEE_DEBUG)
        size_t                 size, needed;
        see_pool_cleanup_t    *cln;
        see_log_memory_buf_t  *buf;

        value[1].len -= 7;
        value[1].data += 7;

        needed = sizeof("MEMLOG  :" SEE_LINEFEED)
                 + cf->conf_file->file.name.len
                 + SEE_SIZE_T_LEN
                 + SEE_INT_T_LEN
                 + SEE_MAX_ERROR_STR;

        size = see_parse_size(&value[1]);

        if (size == (size_t) SEE_ERROR || size < needed) {
            see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                               "invalid buffer size \"%V\"", &value[1]);
            return SEE_CONF_ERROR;
        }

        buf = see_pcalloc(cf->pool, sizeof(see_log_memory_buf_t));
        if (buf == NULL) {
            return SEE_CONF_ERROR;
        }

        buf->start = see_pnalloc(cf->pool, size);
        if (buf->start == NULL) {
            return SEE_CONF_ERROR;
        }

        buf->end = buf->start + size;

        buf->pos = see_slprintf(buf->start, buf->end, "MEMLOG %uz %V:%ui%N",
                                size, &cf->conf_file->file.name,
                                cf->conf_file->line);

        see_memset(buf->pos, ' ', buf->end - buf->pos);

        cln = see_pool_cleanup_add(cf->pool, 0);
        if (cln == NULL) {
            return SEE_CONF_ERROR;
        }

        cln->data = new_log;
        cln->handler = see_log_memory_cleanup;

        new_log->writer = see_log_memory_writer;
        new_log->wdata = buf;

#else
        see_conf_log_error(SEE_LOG_EMERG, cf, 0,
                           "nginx was built without debug support");
        return SEE_CONF_ERROR;
#endif

    } else if (see_strncmp(value[1].data, "syslog:", 7) == 0) {
        peer = see_pcalloc(cf->pool, sizeof(see_syslog_peer_t));
        if (peer == NULL) {
            return SEE_CONF_ERROR;
        }

        if (see_syslog_process_conf(cf, peer) != SEE_CONF_OK) {
            return SEE_CONF_ERROR;
        }

        new_log->writer = see_syslog_writer;
        new_log->wdata = peer;

    } else {
        new_log->file = see_conf_open_file(cf->cycle, &value[1]);
        if (new_log->file == NULL) {
            return SEE_CONF_ERROR;
        }
    }

    if (see_log_set_levels(cf, new_log) != SEE_CONF_OK) {
        return SEE_CONF_ERROR;
    }

    if (*head != new_log) {
        see_log_insert(*head, new_log);
    }

    return SEE_CONF_OK;
}


static void
see_log_insert(see_log_t *log, see_log_t *new_log)
{
    see_log_t  tmp;

    if (new_log->log_level > log->log_level) {

        /*
         * list head address is permanent, insert new log after
         * head and swap its contents with head
         */

        tmp = *log;
        *log = *new_log;
        *new_log = tmp;

        log->next = new_log;
        return;
    }

    while (log->next) {
        if (new_log->log_level > log->next->log_level) {
            new_log->next = log->next;
            log->next = new_log;
            return;
        }

        log = log->next;
    }

    log->next = new_log;
}


#if (SEE_DEBUG)

static void
see_log_memory_writer(see_log_t *log, see_uint_t level, u_char *buf,
    size_t len)
{
    u_char                *p;
    size_t                 avail, written;
    see_log_memory_buf_t  *mem;

    mem = log->wdata;

    if (mem == NULL) {
        return;
    }

    written = see_atomic_fetch_add(&mem->written, len);

    p = mem->pos + written % (mem->end - mem->pos);

    avail = mem->end - p;

    if (avail >= len) {
        see_memcpy(p, buf, len);

    } else {
        see_memcpy(p, buf, avail);
        see_memcpy(mem->pos, buf + avail, len - avail);
    }
}


static void
see_log_memory_cleanup(void *data)
{
    see_log_t *log = data;

    see_log_debug0(SEE_LOG_DEBUG_CORE, log, 0, "destroy memory log buffer");

    log->wdata = NULL;
}

#endif
