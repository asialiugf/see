
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */

#include <see_com_common.h>

//static void see_execute_proc(void *data);
static void see_signal_handler(int signo);
//static void see_process_get_status(void);
//static void see_unlock_mutexes(see_pid_t pid);

int see_change_binary;
int see_sigalrm;
int see_sigio;
int see_reap;
int see_reopen;
int see_debug_quit;
int see_process;
int see_noaccept;
int see_daemonized;
int see_new_binary;
int see_quit;
int see_terminate;

#define SEE_PROCESS_WORKER 1
#define SEE_PROCESS_HELPER 1
#define SEE_REOPEN_SIGNAL 1
#define SEE_CHANGEBIN_SIGNAL 1
#define SEE_PROCESS_MASTER 1


typedef struct {
    int     signo;
    char   *signame;
    char   *name;
    void  (*handler)(int signo);
} see_signal_t;


see_signal_t  signals[] = {
    { SIGHUP,
      "SIGHUP",
      "reload",
      see_signal_handler },

    { SIGTERM,
      "SIGTERM",
      "stop",
      see_signal_handler },

    { SIGQUIT,
      "SIGQUIT", 
      "quit",
      see_signal_handler },

    { SIGALRM, "SIGALRM", "", see_signal_handler },
    { SIGINT, "SIGINT", "", see_signal_handler },
    { SIGIO, "SIGIO", "", see_signal_handler },
    { SIGCHLD, "SIGCHLD", "", see_signal_handler },
    { SIGSYS, "SIGSYS, SIG_IGN", "", SIG_IGN },
    { SIGPIPE, "SIGPIPE, SIG_IGN", "", SIG_IGN },
    { 0, NULL, "", NULL }
};

see_pid_t
see_spawn_process()
{
    return 0;
}

void
see_signal_handler(int signo)
{
    //char            *action;
    int        ignore;
    see_signal_t    *sig;

    ignore = 0;

    for (sig = signals; sig->signo != 0; sig++) {
        if (sig->signo == signo) {
            break;
        }
    }

    //see_time_sigsafe_update();

    //action = (char *)"";

    switch (see_process) {

    case 1:
    case 2:
        switch (signo) {

        case SIGHUP:
            if (!see_daemonized) {
                break;
            }
            see_debug_quit = 1;
        case SIGQUIT:
            see_quit = 1;
            //action = ", shutting down";
            break;

        case SIGTERM:
        case SIGINT:
            see_terminate = 1;
            //action = ", exiting";
            break;

        case SIGIO:
            //action = ", ignoring";
            break;
        }

        break;
    }

    /*
    see_log_error(SEE_LOG_NOTICE, see_cycle->log, 0,
                  "signal %d (%s) received%s", signo, sig->signame, action);
    */

    if (ignore) {
        /*
        see_log_error(SEE_LOG_CRIT, see_cycle->log, 0,
                      "the changing binary signal is ignored: "
                      "you should shutdown or terminate "
                      "before either old or new binary's process");
        */
    }

    if (signo == SIGCHLD) {
        //see_process_get_status();
    }

    //see_set_errno(err);
}
