
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>
#include <see_event.h>
#include <see_channel.h>


static void see_start_worker_processes(see_cycle_t *cycle, see_int_t n,
    see_int_t type);
static void see_start_cache_manager_processes(see_cycle_t *cycle,
    see_uint_t respawn);
static void see_pass_open_channel(see_cycle_t *cycle, see_channel_t *ch);
static void see_signal_worker_processes(see_cycle_t *cycle, int signo);
static see_uint_t see_reap_children(see_cycle_t *cycle);
static void see_master_process_exit(see_cycle_t *cycle);
static void see_worker_process_cycle(see_cycle_t *cycle, void *data);
static void see_worker_process_init(see_cycle_t *cycle, see_int_t worker);
static void see_worker_process_exit(see_cycle_t *cycle);
static void see_channel_handler(see_event_t *ev);
static void see_cache_manager_process_cycle(see_cycle_t *cycle, void *data);
static void see_cache_manager_process_handler(see_event_t *ev);
static void see_cache_loader_process_handler(see_event_t *ev);


see_uint_t    see_process;
see_uint_t    see_worker;
see_pid_t     see_pid;

sig_atomic_t  see_reap;
sig_atomic_t  see_sigio;
sig_atomic_t  see_sigalrm;
sig_atomic_t  see_terminate;
sig_atomic_t  see_quit;
sig_atomic_t  see_debug_quit;
see_uint_t    see_exiting;
sig_atomic_t  see_reconfigure;
sig_atomic_t  see_reopen;

sig_atomic_t  see_change_binary;
see_pid_t     see_new_binary;
see_uint_t    see_inherited;
see_uint_t    see_daemonized;

sig_atomic_t  see_noaccept;
see_uint_t    see_noaccepting;
see_uint_t    see_restart;


static u_char  master_process[] = "master process";


static see_cache_manager_ctx_t  see_cache_manager_ctx = {
    see_cache_manager_process_handler, "cache manager process", 0
};

static see_cache_manager_ctx_t  see_cache_loader_ctx = {
    see_cache_loader_process_handler, "cache loader process", 60000
};


static see_cycle_t      see_exit_cycle;
static see_log_t        see_exit_log;
static see_open_file_t  see_exit_log_file;


void
see_master_process_cycle(see_cycle_t *cycle)
{
    char              *title;
    u_char            *p;
    size_t             size;
    see_int_t          i;
    see_uint_t         n, sigio;
    sigset_t           set;
    struct itimerval   itv;
    see_uint_t         live;
    see_msec_t         delay;
    see_listening_t   *ls;
    see_core_conf_t   *ccf;

    sigemptyset(&set);
    sigaddset(&set, SIGCHLD);
    sigaddset(&set, SIGALRM);
    sigaddset(&set, SIGIO);
    sigaddset(&set, SIGINT);
    sigaddset(&set, see_signal_value(NGX_RECONFIGURE_SIGNAL));
    sigaddset(&set, see_signal_value(NGX_REOPEN_SIGNAL));
    sigaddset(&set, see_signal_value(NGX_NOACCEPT_SIGNAL));
    sigaddset(&set, see_signal_value(NGX_TERMINATE_SIGNAL));
    sigaddset(&set, see_signal_value(NGX_SHUTDOWN_SIGNAL));
    sigaddset(&set, see_signal_value(NGX_CHANGEBIN_SIGNAL));

    if (sigprocmask(SIG_BLOCK, &set, NULL) == -1) {
        see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                      "sigprocmask() failed");
    }

    sigemptyset(&set);


    size = sizeof(master_process);

    for (i = 0; i < see_argc; i++) {
        size += see_strlen(see_argv[i]) + 1;
    }

    title = see_pnalloc(cycle->pool, size);
    if (title == NULL) {
        /* fatal */
        exit(2);
    }

    p = see_cpymem(title, master_process, sizeof(master_process) - 1);
    for (i = 0; i < see_argc; i++) {
        *p++ = ' ';
        p = see_cpystrn(p, (u_char *) see_argv[i], size);
    }

    see_setproctitle(title);


    ccf = (see_core_conf_t *) see_get_conf(cycle->conf_ctx, see_core_module);

    see_start_worker_processes(cycle, ccf->worker_processes,
                               NGX_PROCESS_RESPAWN);
    see_start_cache_manager_processes(cycle, 0);

    see_new_binary = 0;
    delay = 0;
    sigio = 0;
    live = 1;

    for ( ;; ) {
        if (delay) {
            if (see_sigalrm) {
                sigio = 0;
                delay *= 2;
                see_sigalrm = 0;
            }

            see_log_debug1(NGX_LOG_DEBUG_EVENT, cycle->log, 0,
                           "termination cycle: %M", delay);

            itv.it_interval.tv_sec = 0;
            itv.it_interval.tv_usec = 0;
            itv.it_value.tv_sec = delay / 1000;
            itv.it_value.tv_usec = (delay % 1000 ) * 1000;

            if (setitimer(ITIMER_REAL, &itv, NULL) == -1) {
                see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                              "setitimer() failed");
            }
        }

        see_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "sigsuspend");

        sigsuspend(&set);

        see_time_update();

        see_log_debug1(NGX_LOG_DEBUG_EVENT, cycle->log, 0,
                       "wake up, sigio %i", sigio);

        if (see_reap) {
            see_reap = 0;
            see_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "reap children");

            live = see_reap_children(cycle);
        }

        if (!live && (see_terminate || see_quit)) {
            see_master_process_exit(cycle);
        }

        if (see_terminate) {
            if (delay == 0) {
                delay = 50;
            }

            if (sigio) {
                sigio--;
                continue;
            }

            sigio = ccf->worker_processes + 2 /* cache processes */;

            if (delay > 1000) {
                see_signal_worker_processes(cycle, SIGKILL);
            } else {
                see_signal_worker_processes(cycle,
                                       see_signal_value(NGX_TERMINATE_SIGNAL));
            }

            continue;
        }

        if (see_quit) {
            see_signal_worker_processes(cycle,
                                        see_signal_value(NGX_SHUTDOWN_SIGNAL));

            ls = cycle->listening.elts;
            for (n = 0; n < cycle->listening.nelts; n++) {
                if (see_close_socket(ls[n].fd) == -1) {
                    see_log_error(NGX_LOG_EMERG, cycle->log, see_socket_errno,
                                  see_close_socket_n " %V failed",
                                  &ls[n].addr_text);
                }
            }
            cycle->listening.nelts = 0;

            continue;
        }

        if (see_reconfigure) {
            see_reconfigure = 0;

            if (see_new_binary) {
                see_start_worker_processes(cycle, ccf->worker_processes,
                                           NGX_PROCESS_RESPAWN);
                see_start_cache_manager_processes(cycle, 0);
                see_noaccepting = 0;

                continue;
            }

            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "reconfiguring");

            cycle = see_init_cycle(cycle);
            if (cycle == NULL) {
                cycle = (see_cycle_t *) see_cycle;
                continue;
            }

            see_cycle = cycle;
            ccf = (see_core_conf_t *) see_get_conf(cycle->conf_ctx,
                                                   see_core_module);
            see_start_worker_processes(cycle, ccf->worker_processes,
                                       NGX_PROCESS_JUST_RESPAWN);
            see_start_cache_manager_processes(cycle, 1);

            /* allow new processes to start */
            see_msleep(100);

            live = 1;
            see_signal_worker_processes(cycle,
                                        see_signal_value(NGX_SHUTDOWN_SIGNAL));
        }

        if (see_restart) {
            see_restart = 0;
            see_start_worker_processes(cycle, ccf->worker_processes,
                                       NGX_PROCESS_RESPAWN);
            see_start_cache_manager_processes(cycle, 0);
            live = 1;
        }

        if (see_reopen) {
            see_reopen = 0;
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "reopening logs");
            see_reopen_files(cycle, ccf->user);
            see_signal_worker_processes(cycle,
                                        see_signal_value(NGX_REOPEN_SIGNAL));
        }

        if (see_change_binary) {
            see_change_binary = 0;
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "changing binary");
            see_new_binary = see_exec_new_binary(cycle, see_argv);
        }

        if (see_noaccept) {
            see_noaccept = 0;
            see_noaccepting = 1;
            see_signal_worker_processes(cycle,
                                        see_signal_value(NGX_SHUTDOWN_SIGNAL));
        }
    }
}


void
see_single_process_cycle(see_cycle_t *cycle)
{
    see_uint_t  i;

    if (see_set_environment(cycle, NULL) == NULL) {
        /* fatal */
        exit(2);
    }

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->init_process) {
            if (cycle->modules[i]->init_process(cycle) == NGX_ERROR) {
                /* fatal */
                exit(2);
            }
        }
    }

    for ( ;; ) {
        see_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "worker cycle");

        see_process_events_and_timers(cycle);

        if (see_terminate || see_quit) {

            for (i = 0; cycle->modules[i]; i++) {
                if (cycle->modules[i]->exit_process) {
                    cycle->modules[i]->exit_process(cycle);
                }
            }

            see_master_process_exit(cycle);
        }

        if (see_reconfigure) {
            see_reconfigure = 0;
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "reconfiguring");

            cycle = see_init_cycle(cycle);
            if (cycle == NULL) {
                cycle = (see_cycle_t *) see_cycle;
                continue;
            }

            see_cycle = cycle;
        }

        if (see_reopen) {
            see_reopen = 0;
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "reopening logs");
            see_reopen_files(cycle, (see_uid_t) -1);
        }
    }
}


static void
see_start_worker_processes(see_cycle_t *cycle, see_int_t n, see_int_t type)
{
    see_int_t      i;
    see_channel_t  ch;

    see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "start worker processes");

    see_memzero(&ch, sizeof(see_channel_t));

    ch.command = NGX_CMD_OPEN_CHANNEL;

    for (i = 0; i < n; i++) {

        see_spawn_process(cycle, see_worker_process_cycle,
                          (void *) (intptr_t) i, "worker process", type);

        ch.pid = see_processes[see_process_slot].pid;
        ch.slot = see_process_slot;
        ch.fd = see_processes[see_process_slot].channel[0];

        see_pass_open_channel(cycle, &ch);
    }
}


static void
see_start_cache_manager_processes(see_cycle_t *cycle, see_uint_t respawn)
{
    see_uint_t       i, manager, loader;
    see_path_t     **path;
    see_channel_t    ch;

    manager = 0;
    loader = 0;

    path = see_cycle->paths.elts;
    for (i = 0; i < see_cycle->paths.nelts; i++) {

        if (path[i]->manager) {
            manager = 1;
        }

        if (path[i]->loader) {
            loader = 1;
        }
    }

    if (manager == 0) {
        return;
    }

    see_spawn_process(cycle, see_cache_manager_process_cycle,
                      &see_cache_manager_ctx, "cache manager process",
                      respawn ? NGX_PROCESS_JUST_RESPAWN : NGX_PROCESS_RESPAWN);

    see_memzero(&ch, sizeof(see_channel_t));

    ch.command = NGX_CMD_OPEN_CHANNEL;
    ch.pid = see_processes[see_process_slot].pid;
    ch.slot = see_process_slot;
    ch.fd = see_processes[see_process_slot].channel[0];

    see_pass_open_channel(cycle, &ch);

    if (loader == 0) {
        return;
    }

    see_spawn_process(cycle, see_cache_manager_process_cycle,
                      &see_cache_loader_ctx, "cache loader process",
                      respawn ? NGX_PROCESS_JUST_SPAWN : NGX_PROCESS_NORESPAWN);

    ch.command = NGX_CMD_OPEN_CHANNEL;
    ch.pid = see_processes[see_process_slot].pid;
    ch.slot = see_process_slot;
    ch.fd = see_processes[see_process_slot].channel[0];

    see_pass_open_channel(cycle, &ch);
}


static void
see_pass_open_channel(see_cycle_t *cycle, see_channel_t *ch)
{
    see_int_t  i;

    for (i = 0; i < see_last_process; i++) {

        if (i == see_process_slot
            || see_processes[i].pid == -1
            || see_processes[i].channel[0] == -1)
        {
            continue;
        }

        see_log_debug6(NGX_LOG_DEBUG_CORE, cycle->log, 0,
                      "pass channel s:%i pid:%P fd:%d to s:%i pid:%P fd:%d",
                      ch->slot, ch->pid, ch->fd,
                      i, see_processes[i].pid,
                      see_processes[i].channel[0]);

        /* TODO: NGX_AGAIN */

        see_write_channel(see_processes[i].channel[0],
                          ch, sizeof(see_channel_t), cycle->log);
    }
}


static void
see_signal_worker_processes(see_cycle_t *cycle, int signo)
{
    see_int_t      i;
    see_err_t      err;
    see_channel_t  ch;

    see_memzero(&ch, sizeof(see_channel_t));

#if (NGX_BROKEN_SCM_RIGHTS)

    ch.command = 0;

#else

    switch (signo) {

    case see_signal_value(NGX_SHUTDOWN_SIGNAL):
        ch.command = NGX_CMD_QUIT;
        break;

    case see_signal_value(NGX_TERMINATE_SIGNAL):
        ch.command = NGX_CMD_TERMINATE;
        break;

    case see_signal_value(NGX_REOPEN_SIGNAL):
        ch.command = NGX_CMD_REOPEN;
        break;

    default:
        ch.command = 0;
    }

#endif

    ch.fd = -1;


    for (i = 0; i < see_last_process; i++) {

        see_log_debug7(NGX_LOG_DEBUG_EVENT, cycle->log, 0,
                       "child: %i %P e:%d t:%d d:%d r:%d j:%d",
                       i,
                       see_processes[i].pid,
                       see_processes[i].exiting,
                       see_processes[i].exited,
                       see_processes[i].detached,
                       see_processes[i].respawn,
                       see_processes[i].just_spawn);

        if (see_processes[i].detached || see_processes[i].pid == -1) {
            continue;
        }

        if (see_processes[i].just_spawn) {
            see_processes[i].just_spawn = 0;
            continue;
        }

        if (see_processes[i].exiting
            && signo == see_signal_value(NGX_SHUTDOWN_SIGNAL))
        {
            continue;
        }

        if (ch.command) {
            if (see_write_channel(see_processes[i].channel[0],
                                  &ch, sizeof(see_channel_t), cycle->log)
                == NGX_OK)
            {
                if (signo != see_signal_value(NGX_REOPEN_SIGNAL)) {
                    see_processes[i].exiting = 1;
                }

                continue;
            }
        }

        see_log_debug2(NGX_LOG_DEBUG_CORE, cycle->log, 0,
                       "kill (%P, %d)", see_processes[i].pid, signo);

        if (kill(see_processes[i].pid, signo) == -1) {
            err = see_errno;
            see_log_error(NGX_LOG_ALERT, cycle->log, err,
                          "kill(%P, %d) failed", see_processes[i].pid, signo);

            if (err == NGX_ESRCH) {
                see_processes[i].exited = 1;
                see_processes[i].exiting = 0;
                see_reap = 1;
            }

            continue;
        }

        if (signo != see_signal_value(NGX_REOPEN_SIGNAL)) {
            see_processes[i].exiting = 1;
        }
    }
}


static see_uint_t
see_reap_children(see_cycle_t *cycle)
{
    see_int_t         i, n;
    see_uint_t        live;
    see_channel_t     ch;
    see_core_conf_t  *ccf;

    see_memzero(&ch, sizeof(see_channel_t));

    ch.command = NGX_CMD_CLOSE_CHANNEL;
    ch.fd = -1;

    live = 0;
    for (i = 0; i < see_last_process; i++) {

        see_log_debug7(NGX_LOG_DEBUG_EVENT, cycle->log, 0,
                       "child: %i %P e:%d t:%d d:%d r:%d j:%d",
                       i,
                       see_processes[i].pid,
                       see_processes[i].exiting,
                       see_processes[i].exited,
                       see_processes[i].detached,
                       see_processes[i].respawn,
                       see_processes[i].just_spawn);

        if (see_processes[i].pid == -1) {
            continue;
        }

        if (see_processes[i].exited) {

            if (!see_processes[i].detached) {
                see_close_channel(see_processes[i].channel, cycle->log);

                see_processes[i].channel[0] = -1;
                see_processes[i].channel[1] = -1;

                ch.pid = see_processes[i].pid;
                ch.slot = i;

                for (n = 0; n < see_last_process; n++) {
                    if (see_processes[n].exited
                        || see_processes[n].pid == -1
                        || see_processes[n].channel[0] == -1)
                    {
                        continue;
                    }

                    see_log_debug3(NGX_LOG_DEBUG_CORE, cycle->log, 0,
                                   "pass close channel s:%i pid:%P to:%P",
                                   ch.slot, ch.pid, see_processes[n].pid);

                    /* TODO: NGX_AGAIN */

                    see_write_channel(see_processes[n].channel[0],
                                      &ch, sizeof(see_channel_t), cycle->log);
                }
            }

            if (see_processes[i].respawn
                && !see_processes[i].exiting
                && !see_terminate
                && !see_quit)
            {
                if (see_spawn_process(cycle, see_processes[i].proc,
                                      see_processes[i].data,
                                      see_processes[i].name, i)
                    == NGX_INVALID_PID)
                {
                    see_log_error(NGX_LOG_ALERT, cycle->log, 0,
                                  "could not respawn %s",
                                  see_processes[i].name);
                    continue;
                }


                ch.command = NGX_CMD_OPEN_CHANNEL;
                ch.pid = see_processes[see_process_slot].pid;
                ch.slot = see_process_slot;
                ch.fd = see_processes[see_process_slot].channel[0];

                see_pass_open_channel(cycle, &ch);

                live = 1;

                continue;
            }

            if (see_processes[i].pid == see_new_binary) {

                ccf = (see_core_conf_t *) see_get_conf(cycle->conf_ctx,
                                                       see_core_module);

                if (see_rename_file((char *) ccf->oldpid.data,
                                    (char *) ccf->pid.data)
                    == NGX_FILE_ERROR)
                {
                    see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                                  see_rename_file_n " %s back to %s failed "
                                  "after the new binary process \"%s\" exited",
                                  ccf->oldpid.data, ccf->pid.data, see_argv[0]);
                }

                see_new_binary = 0;
                if (see_noaccepting) {
                    see_restart = 1;
                    see_noaccepting = 0;
                }
            }

            if (i == see_last_process - 1) {
                see_last_process--;

            } else {
                see_processes[i].pid = -1;
            }

        } else if (see_processes[i].exiting || !see_processes[i].detached) {
            live = 1;
        }
    }

    return live;
}


static void
see_master_process_exit(see_cycle_t *cycle)
{
    see_uint_t  i;

    see_delete_pidfile(cycle);

    see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exit");

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->exit_master) {
            cycle->modules[i]->exit_master(cycle);
        }
    }

    see_close_listening_sockets(cycle);

    /*
     * Copy see_cycle->log related data to the special static exit cycle,
     * log, and log file structures enough to allow a signal handler to log.
     * The handler may be called when standard see_cycle->log allocated from
     * see_cycle->pool is already destroyed.
     */


    see_exit_log = *see_log_get_file_log(see_cycle->log);

    see_exit_log_file.fd = see_exit_log.file->fd;
    see_exit_log.file = &see_exit_log_file;
    see_exit_log.next = NULL;
    see_exit_log.writer = NULL;

    see_exit_cycle.log = &see_exit_log;
    see_exit_cycle.files = see_cycle->files;
    see_exit_cycle.files_n = see_cycle->files_n;
    see_cycle = &see_exit_cycle;

    see_destroy_pool(cycle->pool);

    exit(0);
}


static void
see_worker_process_cycle(see_cycle_t *cycle, void *data)
{
    see_int_t worker = (intptr_t) data;

    see_process = NGX_PROCESS_WORKER;
    see_worker = worker;

    see_worker_process_init(cycle, worker);

    see_setproctitle("worker process");

    for ( ;; ) {

        if (see_exiting) {
            see_event_cancel_timers();

            if (see_event_timer_rbtree.root == see_event_timer_rbtree.sentinel)
            {
                see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exiting");

                see_worker_process_exit(cycle);
            }
        }

        see_log_debug0(NGX_LOG_DEBUG_EVENT, cycle->log, 0, "worker cycle");

        see_process_events_and_timers(cycle);

        if (see_terminate) {
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exiting");

            see_worker_process_exit(cycle);
        }

        if (see_quit) {
            see_quit = 0;
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0,
                          "gracefully shutting down");
            see_setproctitle("worker process is shutting down");

            if (!see_exiting) {
                see_exiting = 1;
                see_close_listening_sockets(cycle);
                see_close_idle_connections(cycle);
            }
        }

        if (see_reopen) {
            see_reopen = 0;
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "reopening logs");
            see_reopen_files(cycle, -1);
        }
    }
}


static void
see_worker_process_init(see_cycle_t *cycle, see_int_t worker)
{
    sigset_t          set;
    see_int_t         n;
    see_time_t       *tp;
    see_uint_t        i;
    see_cpuset_t     *cpu_affinity;
    struct rlimit     rlmt;
    see_core_conf_t  *ccf;
    see_listening_t  *ls;

    if (see_set_environment(cycle, NULL) == NULL) {
        /* fatal */
        exit(2);
    }

    ccf = (see_core_conf_t *) see_get_conf(cycle->conf_ctx, see_core_module);

    if (worker >= 0 && ccf->priority != 0) {
        if (setpriority(PRIO_PROCESS, 0, ccf->priority) == -1) {
            see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                          "setpriority(%d) failed", ccf->priority);
        }
    }

    if (ccf->rlimit_nofile != NGX_CONF_UNSET) {
        rlmt.rlim_cur = (rlim_t) ccf->rlimit_nofile;
        rlmt.rlim_max = (rlim_t) ccf->rlimit_nofile;

        if (setrlimit(RLIMIT_NOFILE, &rlmt) == -1) {
            see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                          "setrlimit(RLIMIT_NOFILE, %i) failed",
                          ccf->rlimit_nofile);
        }
    }

    if (ccf->rlimit_core != NGX_CONF_UNSET) {
        rlmt.rlim_cur = (rlim_t) ccf->rlimit_core;
        rlmt.rlim_max = (rlim_t) ccf->rlimit_core;

        if (setrlimit(RLIMIT_CORE, &rlmt) == -1) {
            see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                          "setrlimit(RLIMIT_CORE, %O) failed",
                          ccf->rlimit_core);
        }
    }

    if (geteuid() == 0) {
        if (setgid(ccf->group) == -1) {
            see_log_error(NGX_LOG_EMERG, cycle->log, see_errno,
                          "setgid(%d) failed", ccf->group);
            /* fatal */
            exit(2);
        }

        if (initgroups(ccf->username, ccf->group) == -1) {
            see_log_error(NGX_LOG_EMERG, cycle->log, see_errno,
                          "initgroups(%s, %d) failed",
                          ccf->username, ccf->group);
        }

        if (setuid(ccf->user) == -1) {
            see_log_error(NGX_LOG_EMERG, cycle->log, see_errno,
                          "setuid(%d) failed", ccf->user);
            /* fatal */
            exit(2);
        }
    }

    if (worker >= 0) {
        cpu_affinity = see_get_cpu_affinity(worker);

        if (cpu_affinity) {
            see_setaffinity(cpu_affinity, cycle->log);
        }
    }

#if (NGX_HAVE_PR_SET_DUMPABLE)

    /* allow coredump after setuid() in Linux 2.4.x */

    if (prctl(PR_SET_DUMPABLE, 1, 0, 0, 0) == -1) {
        see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                      "prctl(PR_SET_DUMPABLE) failed");
    }

#endif

    if (ccf->working_directory.len) {
        if (chdir((char *) ccf->working_directory.data) == -1) {
            see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                          "chdir(\"%s\") failed", ccf->working_directory.data);
            /* fatal */
            exit(2);
        }
    }

    sigemptyset(&set);

    if (sigprocmask(SIG_SETMASK, &set, NULL) == -1) {
        see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                      "sigprocmask() failed");
    }

    tp = see_timeofday();
    srandom(((unsigned) see_pid << 16) ^ tp->sec ^ tp->msec);

    /*
     * disable deleting previous events for the listening sockets because
     * in the worker processes there are no events at all at this point
     */
    ls = cycle->listening.elts;
    for (i = 0; i < cycle->listening.nelts; i++) {
        ls[i].previous = NULL;
    }

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->init_process) {
            if (cycle->modules[i]->init_process(cycle) == NGX_ERROR) {
                /* fatal */
                exit(2);
            }
        }
    }

    for (n = 0; n < see_last_process; n++) {

        if (see_processes[n].pid == -1) {
            continue;
        }

        if (n == see_process_slot) {
            continue;
        }

        if (see_processes[n].channel[1] == -1) {
            continue;
        }

        if (close(see_processes[n].channel[1]) == -1) {
            see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                          "close() channel failed");
        }
    }

    if (close(see_processes[see_process_slot].channel[0]) == -1) {
        see_log_error(NGX_LOG_ALERT, cycle->log, see_errno,
                      "close() channel failed");
    }

#if 0
    see_last_process = 0;
#endif

    if (see_add_channel_event(cycle, see_channel, NGX_READ_EVENT,
                              see_channel_handler)
        == NGX_ERROR)
    {
        /* fatal */
        exit(2);
    }
}


static void
see_worker_process_exit(see_cycle_t *cycle)
{
    see_uint_t         i;
    see_connection_t  *c;

    for (i = 0; cycle->modules[i]; i++) {
        if (cycle->modules[i]->exit_process) {
            cycle->modules[i]->exit_process(cycle);
        }
    }

    if (see_exiting) {
        c = cycle->connections;
        for (i = 0; i < cycle->connection_n; i++) {
            if (c[i].fd != -1
                && c[i].read
                && !c[i].read->accept
                && !c[i].read->channel
                && !c[i].read->resolver)
            {
                see_log_error(NGX_LOG_ALERT, cycle->log, 0,
                              "*%uA open socket #%d left in connection %ui",
                              c[i].number, c[i].fd, i);
                see_debug_quit = 1;
            }
        }

        if (see_debug_quit) {
            see_log_error(NGX_LOG_ALERT, cycle->log, 0, "aborting");
            see_debug_point();
        }
    }

    /*
     * Copy see_cycle->log related data to the special static exit cycle,
     * log, and log file structures enough to allow a signal handler to log.
     * The handler may be called when standard see_cycle->log allocated from
     * see_cycle->pool is already destroyed.
     */

    see_exit_log = *see_log_get_file_log(see_cycle->log);

    see_exit_log_file.fd = see_exit_log.file->fd;
    see_exit_log.file = &see_exit_log_file;
    see_exit_log.next = NULL;
    see_exit_log.writer = NULL;

    see_exit_cycle.log = &see_exit_log;
    see_exit_cycle.files = see_cycle->files;
    see_exit_cycle.files_n = see_cycle->files_n;
    see_cycle = &see_exit_cycle;

    see_destroy_pool(cycle->pool);

    see_log_error(NGX_LOG_NOTICE, see_cycle->log, 0, "exit");

    exit(0);
}


static void
see_channel_handler(see_event_t *ev)
{
    see_int_t          n;
    see_channel_t      ch;
    see_connection_t  *c;

    if (ev->timedout) {
        ev->timedout = 0;
        return;
    }

    c = ev->data;

    see_log_debug0(NGX_LOG_DEBUG_CORE, ev->log, 0, "channel handler");

    for ( ;; ) {

        n = see_read_channel(c->fd, &ch, sizeof(see_channel_t), ev->log);

        see_log_debug1(NGX_LOG_DEBUG_CORE, ev->log, 0, "channel: %i", n);

        if (n == NGX_ERROR) {

            if (see_event_flags & NGX_USE_EPOLL_EVENT) {
                see_del_conn(c, 0);
            }

            see_close_connection(c);
            return;
        }

        if (see_event_flags & NGX_USE_EVENTPORT_EVENT) {
            if (see_add_event(ev, NGX_READ_EVENT, 0) == NGX_ERROR) {
                return;
            }
        }

        if (n == NGX_AGAIN) {
            return;
        }

        see_log_debug1(NGX_LOG_DEBUG_CORE, ev->log, 0,
                       "channel command: %ui", ch.command);

        switch (ch.command) {

        case NGX_CMD_QUIT:
            see_quit = 1;
            break;

        case NGX_CMD_TERMINATE:
            see_terminate = 1;
            break;

        case NGX_CMD_REOPEN:
            see_reopen = 1;
            break;

        case NGX_CMD_OPEN_CHANNEL:

            see_log_debug3(NGX_LOG_DEBUG_CORE, ev->log, 0,
                           "get channel s:%i pid:%P fd:%d",
                           ch.slot, ch.pid, ch.fd);

            see_processes[ch.slot].pid = ch.pid;
            see_processes[ch.slot].channel[0] = ch.fd;
            break;

        case NGX_CMD_CLOSE_CHANNEL:

            see_log_debug4(NGX_LOG_DEBUG_CORE, ev->log, 0,
                           "close channel s:%i pid:%P our:%P fd:%d",
                           ch.slot, ch.pid, see_processes[ch.slot].pid,
                           see_processes[ch.slot].channel[0]);

            if (close(see_processes[ch.slot].channel[0]) == -1) {
                see_log_error(NGX_LOG_ALERT, ev->log, see_errno,
                              "close() channel failed");
            }

            see_processes[ch.slot].channel[0] = -1;
            break;
        }
    }
}


static void
see_cache_manager_process_cycle(see_cycle_t *cycle, void *data)
{
    see_cache_manager_ctx_t *ctx = data;

    void         *ident[4];
    see_event_t   ev;

    /*
     * Set correct process type since closing listening Unix domain socket
     * in a master process also removes the Unix domain socket file.
     */
    see_process = NGX_PROCESS_HELPER;

    see_close_listening_sockets(cycle);

    /* Set a moderate number of connections for a helper process. */
    cycle->connection_n = 512;

    see_worker_process_init(cycle, -1);

    see_memzero(&ev, sizeof(see_event_t));
    ev.handler = ctx->handler;
    ev.data = ident;
    ev.log = cycle->log;
    ident[3] = (void *) -1;

    see_use_accept_mutex = 0;

    see_setproctitle(ctx->name);

    see_add_timer(&ev, ctx->delay);

    for ( ;; ) {

        if (see_terminate || see_quit) {
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "exiting");
            exit(0);
        }

        if (see_reopen) {
            see_reopen = 0;
            see_log_error(NGX_LOG_NOTICE, cycle->log, 0, "reopening logs");
            see_reopen_files(cycle, -1);
        }

        see_process_events_and_timers(cycle);
    }
}


static void
see_cache_manager_process_handler(see_event_t *ev)
{
    see_uint_t    i;
    see_msec_t    next, n;
    see_path_t  **path;

    next = 60 * 60 * 1000;

    path = see_cycle->paths.elts;
    for (i = 0; i < see_cycle->paths.nelts; i++) {

        if (path[i]->manager) {
            n = path[i]->manager(path[i]->data);

            next = (n <= next) ? n : next;

            see_time_update();
        }
    }

    if (next == 0) {
        next = 1;
    }

    see_add_timer(ev, next);
}


static void
see_cache_loader_process_handler(see_event_t *ev)
{
    see_uint_t     i;
    see_path_t   **path;
    see_cycle_t   *cycle;

    cycle = (see_cycle_t *) see_cycle;

    path = cycle->paths.elts;
    for (i = 0; i < cycle->paths.nelts; i++) {

        if (see_terminate || see_quit) {
            break;
        }

        if (path[i]->loader) {
            path[i]->loader(path[i]->data);
            see_time_update();
        }
    }

    exit(0);
}
