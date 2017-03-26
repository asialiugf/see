
/*
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_SYSLOG_H_INCLUDED_
#define _SEE_SYSLOG_H_INCLUDED_


typedef struct {
    see_pool_t       *pool;
    see_uint_t        facility;
    see_uint_t        severity;
    see_str_t         tag;

    see_addr_t        server;
    see_connection_t  conn;
    unsigned          busy:1;
    unsigned          nohostname:1;
} see_syslog_peer_t;


char *see_syslog_process_conf(see_conf_t *cf, see_syslog_peer_t *peer);
u_char *see_syslog_add_header(see_syslog_peer_t *peer, u_char *buf);
void see_syslog_writer(see_log_t *log, see_uint_t level, u_char *buf,
    size_t len);
ssize_t see_syslog_send(see_syslog_peer_t *peer, u_char *buf, size_t len);


#endif /* _SEE_SYSLOG_H_INCLUDED_ */
