
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_PROCESS_H_INCLUDED_
#define _SEE_PROCESS_H_INCLUDED_

#include <see_com_common.h>

typedef pid_t       see_pid_t;

#define SEE_INVALID_PID  -1

#define see_signal_helper(n)     SIG##n
#define see_signal_value(n)      see_signal_helper(n)
#define ngx_value_helper(n)      #n
#define see_value(n)             see_value_helper(n)

#define see_random               random

#define SEE_SHUTDOWN_SIGNAL      QUIT
#define SEE_TERMINATE_SIGNAL     TERM
#define SEE_NOACCEPT_SIGNAL      WINCH
#define SEE_RECONFIGURE_SIGNAL   HUP
#define SEE_REOPEN_SIGNAL        USR1
#define SEE_CHANGEBIN_SIGNAL     USR2

#define see_cdecl
#define see_libc_cdecl

/*
typedef struct {
    see_pid_t           pid;
    int                 status;
    see_socket_t        channel[2];

    see_spawn_proc_pt   proc;
    void               *data;
    char               *name;

    unsigned            respawn:1;
    unsigned            just_spawn:1;
    unsigned            detached:1;
    unsigned            exiting:1;
    unsigned            exited:1;
} see_process_t;


typedef struct {
    char         *path;
    char         *name;
    char *const  *argv;
    char *const  *envp;
} see_exec_ctx_t;


#define SEE_MAX_PROCESSES         1024

#define SEE_PROCESS_NORESPAWN     -1
#define SEE_PROCESS_JUST_SPAWN    -2
#define SEE_PROCESS_RESPAWN       -3
#define SEE_PROCESS_JUST_RESPAWN  -4
#define SEE_PROCESS_DETACHED      -5


#define see_getpid   getpid

#ifndef see_log_pid
#define see_log_pid  see_pid
#endif

*/
int see_waiter(see_config_t *p_conf);
int see_fork_waiter();


#endif /* _SEE_PROCESS_H_INCLUDED_ */
