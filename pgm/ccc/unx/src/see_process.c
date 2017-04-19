
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
//#define SEE_PROCESS_HELPER 1
//#define SEE_REOPEN_SIGNAL 1
//#define SEE_CHANGEBIN_SIGNAL 1
#define SEE_PROCESS_MASTER 1

static int see_sttrun(see_config_t *p_conf,char * pc_future, char *pc_sttname);

typedef struct {
    int     signo;
    char   *signame;
    char   *name;
    void (*handler)(int signo);
} see_signal_t;


see_signal_t  signals[] = {
    {
        SIGHUP,
        "SIGHUP",
        "reload",
        see_signal_handler
    },

    {
        SIGTERM,
        "SIGTERM",
        "stop",
        see_signal_handler
    },

    {
        SIGQUIT,
        "SIGQUIT",
        "quit",
        see_signal_handler
    },

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
    int             ignore;
    see_signal_t    *sig;

    ignore = 0;

    for(sig = signals; sig->signo != 0; sig++) {
        if(sig->signo == signo) {
            break;
        }
    }

    //see_time_sigsafe_update();

    //action = (char *)"";

    switch(see_process) {

    case 1:
    case 2:
        switch(signo) {

        case SIGHUP:
            if(!see_daemonized) {
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

    if(ignore) {
        /*
        see_log_error(SEE_LOG_CRIT, see_cycle->log, 0,
                      "the changing binary signal is ignored: "
                      "you should shutdown or terminate "
                      "before either old or new binary's process");
        */
    }

    if(signo == SIGCHLD) {
        //see_process_get_status();
    }

    //see_set_errno(err);
}


/*
 * see_waiter() 实现两个功能
 * 1、 从ZMQ等待指令
 * 2、 根据指令 fork 一个 策略进程 进程进程
 */
int see_waiter(see_config_t *p_conf)
{
    int i_rtn=0;
    int pid = 0;

    if(1) {
        see_err_log(0,0,"<IN> see_waiter() !");
    }

    gp_conf->v_sub_sock = see_zmq_sub_init(gp_conf->ca_zmq_sub_url,"waiter");
    while(1) {
        //see_zmq_sub();
        char pc_future[] = "TA705" ;
        char pc_sttname[] = "stt02" ;
        char buf[128] ;
        char * cmd;

        /*
          get  char * pc_future, char *pc_stt_name from see_zmq_sub() !!!
        */
        printf("oooooooooooooooooooooooooooooooooooooooooooooooooooooooooo\n");
        see_memzero(buf,128);
        i_rtn = see_zmq_sub_recv(p_conf->v_sub_sock,buf,128,0) ;
        if(i_rtn <=0) {
            see_err_log(0,0," waiter: see_zmq_pub_recv error, errno: %d \n",errno) ;
        }
        printf("%s\n",buf);
        cmd = &buf[6];

        pid = fork();
        switch(pid) {
        case -1:
            return -1;

        case 0:
            pid = getpid();
            setproctitle("%s %s [%s %s %s]", "future.x :", "sttrun",pc_sttname,pc_future,cmd);
            while(1) {
                // 这里有问题, v_pub_sock v_sub_sock 不同的进程 最好分开
                //gp_conf->v_pub_sock = see_zmq_pub_init(gp_conf->ca_zmq_pub_url);
                //gp_conf->v_sub_sock = see_zmq_sub_init(gp_conf->ca_zmq_sub_url,"TA705");
                see_sttrun(p_conf,pc_future, pc_sttname) ;
                sleep(1);
            }
            break;

        default:
            printf(" main of waiter !! \n");
            break;
        }
    }
    return 0;
}

int see_fork_waiter()
{
    int pid;
    pid = fork();
    switch(pid) {
    case -1:
        return -1;

    case 0:
        pid = getpid();
        setproctitle("%s %s", "future.x :", "waiter");
        /*
         *  see_waiter() 功能
         *  1、 从ZMQ里等命令
         *  2、 生成新的进程 进行 策略计算
        */
        see_waiter(gp_conf) ;

        break;

    default:
        break;
    }
    return 0;
}

static int see_sttrun(see_config_t *p_conf,char * pc_future, char *pc_sttname)
{
    //stt_kkall_t K;
    //stt_kkall_init(p_conf, pc_future, pc_sttname, &K);
    //stt_run() ;
    while(1) {
        int k;
        k =1;
        see_err_log(0,0,"%d",k);
        sleep(1);
    }
    return 0;
}
