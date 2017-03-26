
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_TIMES_H_INCLUDED_
#define _SEE_TIMES_H_INCLUDED_


#include <see_com_common.h>
#include <see_core.h>


typedef struct {
    time_t      sec;
    see_uint_t  msec;
    see_int_t   gmtoff;
} see_time_t;


void see_time_init(void);
void see_time_update(void);
void see_time_sigsafe_update(void);
u_char *see_http_time(u_char *buf, time_t t);
u_char *see_http_cookie_time(u_char *buf, time_t t);
void see_gmtime(time_t t, see_tm_t *tp);

time_t see_next_time(time_t when);
#define see_next_time_n      "mktime()"


extern volatile see_time_t  *see_cached_time;

#define see_time()           see_cached_time->sec
#define see_timeofday()      (see_time_t *) see_cached_time

extern volatile see_str_t    see_cached_err_log_time;
extern volatile see_str_t    see_cached_http_time;
extern volatile see_str_t    see_cached_http_log_time;
extern volatile see_str_t    see_cached_http_log_iso8601;
extern volatile see_str_t    see_cached_syslog_time;

/*
 * milliseconds elapsed since epoch and truncated to see_msec_t,
 * used in event timers
 */
extern volatile see_msec_t  see_current_msec;


#endif /* _SEE_TIMES_H_INCLUDED_ */
