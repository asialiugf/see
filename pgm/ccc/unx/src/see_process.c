
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */

#include <see_com_common.h>

//static void see_execute_proc(void *data);
static void see_signal_handler(int signo);
int see_parser_cmd(stt_command_t *cmd,char *buf);
int see_fork_sttrun(char * pc_future, char *pc_sttname);
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

static int see_sttrun(char * pc_future, char *pc_sttname);

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
int see_waiter()
{
    int rc=0;
    int pid = 0;
    char buf[256] ;
    stt_command_t cmd;

    if(1) {
        see_err_log(0,0,"<IN> see_waiter() !");
    }

    //see_signal_init();
    /*
    struct sigaction action;
    action.sa_handler = SIG_IGN;
    sigemptyset(&action.sa_mask);
    sigaction(SIGCHLD, &action, NULL);
    */

    pid = getpid();
    see_zmq_ctxsock_t sub_ctxsock;


    while(1) {
        rc = see_zmq_sub_init(gp_conf->ca_zmq_sub_url,&sub_ctxsock,"waiter");
        printf("oooooooooooooooooooooooooooooooooooooooooooooooooooooooooo pid: %d \n",pid);
        see_memzero(&cmd,sizeof(stt_command_t));
        see_memzero(buf,256);

        /* 这里还要接收 关闭 stt进程的信息 */
        rc = see_zmq_sub_recv(sub_ctxsock.sock,buf,256,0) ;
        if(rc <0) {
            see_err_log(0,0," see_waiter: see_zmq_pub_recv error, errno: %d \n",errno) ;
            printf(" zmq err!!\n");
            sleep(1);
            continue;
        }
        printf("new: %s\n",buf);
        printf("new2: %s\n",&buf[6]);
        rc = see_parser_cmd(&cmd,&buf[6]);
        if(rc!=0) {
            see_err_log(0,0," see_waiter(): see_parser_cmd() error, buf is: %s",&buf[6]);
            printf(" parser error \n");
            sleep(1);
            continue;
        }
        printf("%s %s %s %s %s %s %d\n",cmd.ca_future,
               cmd.ca_sttname,
               cmd.ca_actionday_s,
               cmd.ca_actionday_e,
               cmd.ca_updatetime_s,
               cmd.ca_updatetime_e,
               cmd.num);
        printf("tttttttttttttttttttt\n");

        see_zmq_sub_close(&sub_ctxsock);
        see_fork_sttrun(cmd.ca_future,cmd.ca_sttname);
    }
    return 0;
}

int see_parser_cmd(stt_command_t *cmd,char *buf)
{
    int rc=0;
    /*
    char           ca_future[31];
    char           ca_sttname[31];
    char           ca_actionday_s[9];
    char           ca_actionday_e[9];
    char           ca_updatetime_s[9];
    char           ca_updatetime_e[9];
    int            num;
    */
    cJSON *json;
    cJSON *jtmp;
    cJSON *jdat;

    json = cJSON_Parse(buf);
    if(json) {
        jdat = cJSON_GetObjectItem(json, "data");
        if(jdat) {
            jtmp = cJSON_GetObjectItem(jdat, "future");
            if(jtmp == NULL) {
                rc = -1;
            }
            memcpy(cmd->ca_future, jtmp->valuestring, strlen(jtmp->valuestring));
            printf("json: ca_future: %s\n",cmd->ca_future);

            jtmp = cJSON_GetObjectItem(jdat, "sttname");
            if(jtmp == NULL) {
                return -1;
            }
            memcpy(cmd->ca_sttname, jtmp->valuestring, strlen(jtmp->valuestring));

            jtmp = cJSON_GetObjectItem(jdat, "actionday_s");
            if(jtmp == NULL) {
                //(char *)cmd->ca_actionday_s = NULL;
            }
            memcpy(cmd->ca_actionday_s, jtmp->valuestring, strlen(jtmp->valuestring));

            jtmp = cJSON_GetObjectItem(jdat, "actionday_e");
            if(jtmp == NULL) {
                //(char *)cmd->ca_actionday_e = NULL;
            }
            memcpy(cmd->ca_actionday_e, jtmp->valuestring, strlen(jtmp->valuestring));

            jtmp = cJSON_GetObjectItem(jdat, "updatetime_s");
            if(jtmp == NULL) {
                //(char *)cmd->ca_updatetime_s = NULL;
            }
            memcpy(cmd->ca_updatetime_s, jtmp->valuestring, strlen(jtmp->valuestring));

            jtmp = cJSON_GetObjectItem(jdat, "updatetime_e");
            if(jtmp == NULL) {
                //(char *)cmd->ca_updatetime_e = NULL;
            }
            memcpy(cmd->ca_updatetime_e, jtmp->valuestring, strlen(jtmp->valuestring));

            jtmp = cJSON_GetObjectItem(jdat, "number");
            if(jtmp == NULL) {
                cmd->num = 10000;
            }
            cmd->num = jtmp->valueint;
        } else {
            see_err_log(0,0," see_parser_cmd(): error! no \"data\", buf is : %s ",buf);
            rc = -1;
        }
        cJSON_Delete(json);
        rc =0;
    } else {
        see_err_log(0,0," see_parser_cmd(): cJSON_Parse(buf) error! buf is : %s ",buf);
        rc = -1;
    }
    return rc;
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
        see_waiter() ;
        break;

    default:
        break;
    }
    return 0;
}

static int see_sttrun(char *pc_future, char *pc_sttname)
{
    int rc=0;
    char buf[256];
    /*
     * 设定sttrun 子进程的环境变量，全局变量
    */
    //see_child_t  sttrun_conf;

    see_zmq_ctxsock_t pub_ctxsock;
    see_zmq_ctxsock_t sub_ctxsock;
    /*
        while(1) {
            sleep(1);
        }
    */
    printf("sttrun is running!!!\n");

    rc = see_zmq_pub_init(gp_conf->ca_zmq_pub_url,&pub_ctxsock);
    rc = see_zmq_sub_init(gp_conf->ca_zmq_sub_url,&sub_ctxsock,"test01");

    //stt_kkall_t K;
    //stt_kkall_init(p_conf, pc_future, pc_sttname, &K);
    //stt_run() ;

    while(1) {
        see_memzero(buf,256);
        rc = see_zmq_sub_recv(sub_ctxsock.sock,buf,256,0) ;
        if(rc <0) {
            see_err_log(0,0," see_waiter: see_zmq_pub_recv error, errno: %d \n",errno) ;
            printf(" zmq err!!\n");
            sleep(1);
            continue;
        }
        //see_err_log(0,0,"sttrun---- %s",buf);
        printf("sttrun---: %s\n",buf);
    }


    int i_size;
    i_size = strlen(pc_future);
    if(i_size <=0) {
        return -1;
    }
    while(1) {
        rc = see_zmq_pub_send(pub_ctxsock.sock,pc_future);
        if(rc != i_size) {
            see_errlog(1000,"see_send_bar: send error !!",RPT_TO_LOG,0,0);
        }
        sleep(1);
    }
    return 0;
}

int see_fork_sttrun(char * pc_future, char *pc_sttname)
{
    int pid;
    int i = 0;

    pid = fork();
    switch(pid) {
    case -1:
        return -1;

    case 0:

        for(i = 0; i < sysconf(_SC_OPEN_MAX); i++) {
            if(i != STDIN_FILENO && i != STDOUT_FILENO && i != STDERR_FILENO)
                close(i);
        }

        pid = getpid();
        setproctitle("%s %s [%s:%s]", "future.x :", "sttrun",pc_future,pc_sttname);
        printf(" fork_sttrun \n");
        printf(" fork_sttrun \n");
        printf(" fork_sttrun \n");
        printf(" fork_sttrun \n");
        printf(" fork_sttrun \n");
        see_sttrun(pc_future, pc_sttname) ;
        break;

    default:
        break;
    }
    return 0;
}
