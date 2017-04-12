
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _NGX_PROCESS_CYCLE_H_INCLUDED_
#define _NGX_PROCESS_CYCLE_H_INCLUDED_


#include <see_config.h>
#include <see_core.h>


#define NGX_CMD_OPEN_CHANNEL   1
#define NGX_CMD_CLOSE_CHANNEL  2
#define NGX_CMD_QUIT           3
#define NGX_CMD_TERMINATE      4
#define NGX_CMD_REOPEN         5


#define NGX_PROCESS_SINGLE     0
#define NGX_PROCESS_MASTER     1
#define NGX_PROCESS_SIGNALLER  2
#define NGX_PROCESS_WORKER     3
#define NGX_PROCESS_HELPER     4


typedef struct {
    see_event_handler_pt       handler;
    char                      *name;
    see_msec_t                 delay;
} see_cache_manager_ctx_t;


void see_master_process_cycle(see_cycle_t *cycle);
void see_single_process_cycle(see_cycle_t *cycle);


extern see_uint_t      see_process;
extern see_uint_t      see_worker;
extern see_pid_t       see_pid;
extern see_pid_t       see_new_binary;
extern see_uint_t      see_inherited;
extern see_uint_t      see_daemonized;
extern see_uint_t      see_exiting;

extern sig_atomic_t    see_reap;
extern sig_atomic_t    see_sigio;
extern sig_atomic_t    see_sigalrm;
extern sig_atomic_t    see_quit;
extern sig_atomic_t    see_debug_quit;
extern sig_atomic_t    see_terminate;
extern sig_atomic_t    see_noaccept;
extern sig_atomic_t    see_reconfigure;
extern sig_atomic_t    see_reopen;
extern sig_atomic_t    see_change_binary;


#endif /* _NGX_PROCESS_CYCLE_H_INCLUDED_ */
