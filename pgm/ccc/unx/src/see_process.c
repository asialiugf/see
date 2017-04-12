
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>
#include <see_event.h>
#include <see_channel.h>


typedef struct {
    int     signo;
    char   *signame;
    char   *name;
    void  (*handler)(int signo);
} see_signal_t;



static void see_execute_proc(see_cycle_t *cycle, void *data);
static void see_signal_handler(int signo);
static void see_process_get_status(void);
static void see_unlock_mutexes(see_pid_t pid);


int              see_argc;
char           **see_argv;
char           **see_os_argv;

long int        see_process_slot;
see_socket_t     see_channel;
long int        see_last_process;
see_process_t    see_processes[SEE_MAX_PROCESSES];

see_signal_t  signals[] = {
    { see_signal_value(SEE_RECONFIGURE_SIGNAL),
      "SIG" see_value(SEE_RECONFIGURE_SIGNAL),
      "reload",
      see_signal_handler },

    { see_signal_value(SEE_REOPEN_SIGNAL),
      "SIG" see_value(SEE_REOPEN_SIGNAL),
      "reopen",
      see_signal_handler },

    { see_signal_value(SEE_NOACCEPT_SIGNAL),
      "SIG" see_value(SEE_NOACCEPT_SIGNAL),
      "",
      see_signal_handler },

    { see_signal_value(SEE_TERMINATE_SIGNAL),
      "SIG" see_value(SEE_TERMINATE_SIGNAL),
      "stop",
      see_signal_handler },

    { see_signal_value(SEE_SHUTDOWN_SIGNAL),
      "SIG" see_value(SEE_SHUTDOWN_SIGNAL),
      "quit",
      see_signal_handler },

    { see_signal_value(SEE_CHANGEBIN_SIGNAL),
      "SIG" see_value(SEE_CHANGEBIN_SIGNAL),
      "",
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
see_spawn_process(see_cycle_t *cycle, see_spawn_proc_pt proc, void *data,
    char *name, long int respawn)
{
    u_long     on;
    see_pid_t  pid;
    long int  s;

    if (respawn >= 0) {
        s = respawn;

    } else {
        for (s = 0; s < see_last_process; s++) {
            if (see_processes[s].pid == -1) {
                break;
            }
        }

        if (s == SEE_MAX_PROCESSES) {
            see_log_error(SEE_LOG_ALERT, cycle->log, 0,
                          "no more than %d processes can be spawned",
                          SEE_MAX_PROCESSES);
            return SEE_INVALID_PID;
        }
    }


    if (respawn != SEE_PROCESS_DETACHED) {

        /* Solaris 9 still has no AF_LOCAL */

        if (socketpair(AF_UNIX, SOCK_STREAM, 0, see_processes[s].channel) == -1)
        {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          "socketpair() failed while spawning \"%s\"", name);
            return SEE_INVALID_PID;
        }

        see_log_debug2(SEE_LOG_DEBUG_CORE, cycle->log, 0,
                       "channel %d:%d",
                       see_processes[s].channel[0],
                       see_processes[s].channel[1]);

        if (see_nonblocking(see_processes[s].channel[0]) == -1) {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          see_nonblocking_n " failed while spawning \"%s\"",
                          name);
            see_close_channel(see_processes[s].channel, cycle->log);
            return SEE_INVALID_PID;
        }

        if (see_nonblocking(see_processes[s].channel[1]) == -1) {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          see_nonblocking_n " failed while spawning \"%s\"",
                          name);
            see_close_channel(see_processes[s].channel, cycle->log);
            return SEE_INVALID_PID;
        }

        on = 1;
        if (ioctl(see_processes[s].channel[0], FIOASYNC, &on) == -1) {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          "ioctl(FIOASYNC) failed while spawning \"%s\"", name);
            see_close_channel(see_processes[s].channel, cycle->log);
            return SEE_INVALID_PID;
        }

        if (fcntl(see_processes[s].channel[0], F_SETOWN, see_pid) == -1) {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          "fcntl(F_SETOWN) failed while spawning \"%s\"", name);
            see_close_channel(see_processes[s].channel, cycle->log);
            return SEE_INVALID_PID;
        }

        if (fcntl(see_processes[s].channel[0], F_SETFD, FD_CLOEXEC) == -1) {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          "fcntl(FD_CLOEXEC) failed while spawning \"%s\"",
                           name);
            see_close_channel(see_processes[s].channel, cycle->log);
            return SEE_INVALID_PID;
        }

        if (fcntl(see_processes[s].channel[1], F_SETFD, FD_CLOEXEC) == -1) {
            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          "fcntl(FD_CLOEXEC) failed while spawning \"%s\"",
                           name);
            see_close_channel(see_processes[s].channel, cycle->log);
            return SEE_INVALID_PID;
        }

        see_channel = see_processes[s].channel[1];

    } else {
        see_processes[s].channel[0] = -1;
        see_processes[s].channel[1] = -1;
    }

    see_process_slot = s;


    pid = fork();

    switch (pid) {

    case -1:
        see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                      "fork() failed while spawning \"%s\"", name);
        see_close_channel(see_processes[s].channel, cycle->log);
        return SEE_INVALID_PID;

    case 0:
        see_pid = see_getpid();
        proc(cycle, data);
        break;

    default:
        break;
    }

    see_log_error(SEE_LOG_NOTICE, cycle->log, 0, "start %s %P", name, pid);

    see_processes[s].pid = pid;
    see_processes[s].exited = 0;

    if (respawn >= 0) {
        return pid;
    }

    see_processes[s].proc = proc;
    see_processes[s].data = data;
    see_processes[s].name = name;
    see_processes[s].exiting = 0;

    switch (respawn) {

    case SEE_PROCESS_NORESPAWN:
        see_processes[s].respawn = 0;
        see_processes[s].just_spawn = 0;
        see_processes[s].detached = 0;
        break;

    case SEE_PROCESS_JUST_SPAWN:
        see_processes[s].respawn = 0;
        see_processes[s].just_spawn = 1;
        see_processes[s].detached = 0;
        break;

    case SEE_PROCESS_RESPAWN:
        see_processes[s].respawn = 1;
        see_processes[s].just_spawn = 0;
        see_processes[s].detached = 0;
        break;

    case SEE_PROCESS_JUST_RESPAWN:
        see_processes[s].respawn = 1;
        see_processes[s].just_spawn = 1;
        see_processes[s].detached = 0;
        break;

    case SEE_PROCESS_DETACHED:
        see_processes[s].respawn = 0;
        see_processes[s].just_spawn = 0;
        see_processes[s].detached = 1;
        break;
    }

    if (s == see_last_process) {
        see_last_process++;
    }

    return pid;
}


see_pid_t
see_execute(see_cycle_t *cycle, see_exec_ctx_t *ctx)
{
    return see_spawn_process(cycle, see_execute_proc, ctx, ctx->name,
                             SEE_PROCESS_DETACHED);
}


static void
see_execute_proc(see_cycle_t *cycle, void *data)
{
    see_exec_ctx_t  *ctx = data;

    if (execve(ctx->path, ctx->argv, ctx->envp) == -1) {
        see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                      "execve() failed while executing %s \"%s\"",
                      ctx->name, ctx->path);
    }

    exit(1);
}

/*
　　struct sigaction {
　　    void (*sa_handler)();   / 处理函数或SIG_IGN(忽略)或SIG_DFL(默认) /
　　    sigset_t sa_mask;       / 处理函数过程中被阻塞 /
　　    int sa_flags;           / 标志位，对信号进程处理选项 /
　　} ;
*/
long int
see_init_signals(see_log_t *log)
{
    see_signal_t      *sig;
    struct sigaction   sa;

    for (sig = signals; sig->signo != 0; sig++) {
        see_memzero(&sa, sizeof(struct sigaction));
        sa.sa_handler = sig->handler;
        sigemptyset(&sa.sa_mask);
        if (sigaction(sig->signo, &sa, NULL) == -1) {
            see_log_error(SEE_LOG_ALERT, log, see_errno,
                          "sigaction(%s) failed, ignored", sig->signame);
            //return SEE_ERROR;
        }
    }
    return SEE_OK;
}


void
see_signal_handler(int signo)
{
    char            *action;
    int              ignore;
    int              err;
    see_signal_t    *sig;

    ignore = 0;
    err = errno;

    for (sig = signals; sig->signo != 0; sig++) {
        if (sig->signo == signo) {
            break;
        }
    }

    see_time_sigsafe_update();

    action = "";

    switch (see_process) {

    case SEE_PROCESS_MASTER:
    case SEE_PROCESS_SINGLE:
        switch (signo) {

        case see_signal_value(SEE_SHUTDOWN_SIGNAL):
            see_quit = 1;
            action = ", shutting down";
            break;

        case see_signal_value(SEE_TERMINATE_SIGNAL):
        case SIGINT:
            see_terminate = 1;
            action = ", exiting";
            break;

        case see_signal_value(SEE_NOACCEPT_SIGNAL):
            if (see_daemonized) {
                see_noaccept = 1;
                action = ", stop accepting connections";
            }
            break;

        case see_signal_value(SEE_RECONFIGURE_SIGNAL):
            see_reconfigure = 1;
            action = ", reconfiguring";
            break;

        case see_signal_value(SEE_REOPEN_SIGNAL):
            see_reopen = 1;
            action = ", reopening logs";
            break;

        case see_signal_value(SEE_CHANGEBIN_SIGNAL):
            if (getppid() > 1 || see_new_binary > 0) {

                /*
                 * Ignore the signal in the new binary if its parent is
                 * not the init process, i.e. the old binary's process
                 * is still running.  Or ignore the signal in the old binary's
                 * process if the new binary's process is already running.
                 */

                action = ", ignoring";
                ignore = 1;
                break;
            }

            see_change_binary = 1;
            action = ", changing binary";
            break;

        case SIGALRM:
            see_sigalrm = 1;
            break;

        case SIGIO:
            see_sigio = 1;
            break;

        case SIGCHLD:
            see_reap = 1;
            break;
        }

        break;

    case SEE_PROCESS_WORKER:
    case SEE_PROCESS_HELPER:
        switch (signo) {

        case see_signal_value(SEE_NOACCEPT_SIGNAL):
            if (!see_daemonized) {
                break;
            }
            see_debug_quit = 1;
        case see_signal_value(SEE_SHUTDOWN_SIGNAL):
            see_quit = 1;
            action = ", shutting down";
            break;

        case see_signal_value(SEE_TERMINATE_SIGNAL):
        case SIGINT:
            see_terminate = 1;
            action = ", exiting";
            break;

        case see_signal_value(SEE_REOPEN_SIGNAL):
            see_reopen = 1;
            action = ", reopening logs";
            break;

        case see_signal_value(SEE_RECONFIGURE_SIGNAL):
        case see_signal_value(SEE_CHANGEBIN_SIGNAL):
        case SIGIO:
            action = ", ignoring";
            break;
        }

        break;
    }

    see_log_error(SEE_LOG_NOTICE, see_cycle->log, 0,
                  "signal %d (%s) received%s", signo, sig->signame, action);

    if (ignore) {
        see_log_error(SEE_LOG_CRIT, see_cycle->log, 0,
                      "the changing binary signal is ignored: "
                      "you should shutdown or terminate "
                      "before either old or new binary's process");
    }

    if (signo == SIGCHLD) {
        see_process_get_status();
    }

    see_set_errno(err);
}


static void
see_process_get_status(void)
{
    int              status;
    char            *process;
    see_pid_t        pid;
    see_err_t        err;
    long int        i;
    see_uint_t       one;

    one = 0;

    for ( ;; ) {
        pid = waitpid(-1, &status, WNOHANG);

        if (pid == 0) {
            return;
        }

        if (pid == -1) {
            err = see_errno;

            if (err == SEE_EINTR) {
                continue;
            }

            if (err == SEE_ECHILD && one) {
                return;
            }

            /*
             * Solaris always calls the signal handler for each exited process
             * despite waitpid() may be already called for this process.
             *
             * When several processes exit at the same time FreeBSD may
             * erroneously call the signal handler for exited process
             * despite waitpid() may be already called for this process.
             */

            if (err == SEE_ECHILD) {
                see_log_error(SEE_LOG_INFO, see_cycle->log, err,
                              "waitpid() failed");
                return;
            }

            see_log_error(SEE_LOG_ALERT, see_cycle->log, err,
                          "waitpid() failed");
            return;
        }


        one = 1;
        process = "unknown process";

        for (i = 0; i < see_last_process; i++) {
            if (see_processes[i].pid == pid) {
                see_processes[i].status = status;
                see_processes[i].exited = 1;
                process = see_processes[i].name;
                break;
            }
        }

        if (WTERMSIG(status)) {
#ifdef WCOREDUMP
            see_log_error(SEE_LOG_ALERT, see_cycle->log, 0,
                          "%s %P exited on signal %d%s",
                          process, pid, WTERMSIG(status),
                          WCOREDUMP(status) ? " (core dumped)" : "");
#else
            see_log_error(SEE_LOG_ALERT, see_cycle->log, 0,
                          "%s %P exited on signal %d",
                          process, pid, WTERMSIG(status));
#endif

        } else {
            see_log_error(SEE_LOG_NOTICE, see_cycle->log, 0,
                          "%s %P exited with code %d",
                          process, pid, WEXITSTATUS(status));
        }

        if (WEXITSTATUS(status) == 2 && see_processes[i].respawn) {
            see_log_error(SEE_LOG_ALERT, see_cycle->log, 0,
                          "%s %P exited with fatal code %d "
                          "and cannot be respawned",
                          process, pid, WEXITSTATUS(status));
            see_processes[i].respawn = 0;
        }

        see_unlock_mutexes(pid);
    }
}


static void
see_unlock_mutexes(see_pid_t pid)
{
    see_uint_t        i;
    see_shm_zone_t   *shm_zone;
    see_list_part_t  *part;
    see_slab_pool_t  *sp;

    /*
     * unlock the accept mutex if the abnormally exited process
     * held it
     */

    if (see_accept_mutex_ptr) {
        (void) see_shmtx_force_unlock(&see_accept_mutex, pid);
    }

    /*
     * unlock shared memory mutexes if held by the abnormally exited
     * process
     */

    part = (see_list_part_t *) &see_cycle->shared_memory.part;
    shm_zone = part->elts;

    for (i = 0; /* void */ ; i++) {

        if (i >= part->nelts) {
            if (part->next == NULL) {
                break;
            }
            part = part->next;
            shm_zone = part->elts;
            i = 0;
        }

        sp = (see_slab_pool_t *) shm_zone[i].shm.addr;

        if (see_shmtx_force_unlock(&sp->mutex, pid)) {
            see_log_error(SEE_LOG_ALERT, see_cycle->log, 0,
                          "shared memory zone \"%V\" was locked by %P",
                          &shm_zone[i].shm.name, pid);
        }
    }
}


void
see_debug_point(void)
{
    see_core_conf_t  *ccf;

    ccf = (see_core_conf_t *) see_get_conf(see_cycle->conf_ctx,
                                           see_core_module);

    switch (ccf->debug_points) {

    case SEE_DEBUG_POINTS_STOP:
        raise(SIGSTOP);
        break;

    case SEE_DEBUG_POINTS_ABORT:
        see_abort();
    }
}


long int
see_os_signal_process(see_cycle_t *cycle, char *name, see_pid_t pid)
{
    see_signal_t  *sig;

    for (sig = signals; sig->signo != 0; sig++) {
        if (see_strcmp(name, sig->name) == 0) {
            if (kill(pid, sig->signo) != -1) {
                return 0;
            }

            see_log_error(SEE_LOG_ALERT, cycle->log, see_errno,
                          "kill(%P, %d) failed", pid, sig->signo);
        }
    }

    return 1;
}
