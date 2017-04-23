#include <see_com_common.h>

static int ia_signal_array[] = {
    SIGHUP,   SIGINT,   SIGQUIT,  SIGILL,     SIGTRAP,    SIGABRT,
    SIGIOT,   SIGBUS,   SIGFPE,   SIGKILL,    SIGUSR1,    SIGSEGV,
    SIGUSR2,  SIGPIPE,  SIGALRM,  SIGTERM,    SIGSTKFLT,  SIGCLD,
    SIGCHLD,  SIGCONT,  SIGSTOP,  SIGTSTP,    SIGTTIN,    SIGTTOU,
    SIGURG,   SIGXCPU,  SIGXFSZ,  SIGVTALRM,  SIGPROF,    SIGWINCH,
    SIGPOLL,  SIGIO,    SIGPWR,   SIGSYS,     SIGUNUSED
};

static void see_signal_handler(int i_signal_no) ;

int see_signal_init()
{
//    int rtn = 0 ;
    int i_signal_count = sizeof(ia_signal_array) / sizeof(int);
    int i ;
    for( i = 0 ; i < i_signal_count ; ++i)
    {
        signal(ia_signal_array[i], see_signal_handler);
    }
    return i_signal_count ;
}

static void see_signal_handler(int i_signal_no)
{
//    int rtn = 0 ;
    switch(i_signal_no)
    {
        case SIGHUP:
             see_errlog(1000, "signal SIGHUP occured",RPT_TO_LOG,0,0);
            break;
        case SIGINT:
             see_errlog(1000, "signal SIGINT occured",RPT_TO_LOG,0,0);
            break;
         case SIGQUIT:
             see_errlog(1000, "signal SIGQUIT occured",RPT_TO_LOG,0,0);
            break;
         case SIGILL:
             see_errlog(1000, "signal SIGILL occured",RPT_TO_LOG,0,0);
            break;
         case SIGTRAP:
             see_errlog(1000, "signal SIGTRAP occured",RPT_TO_LOG,0,0);
            break;
         case SIGABRT:
             see_errlog(1000, "signal SIGABRT occured",RPT_TO_LOG,0,0);
            break;
        //case SIGIOT:
        //    break;
        case SIGBUS:
             see_errlog(1000, "signal SIGBUS occured",RPT_TO_LOG,0,0);
            break;
        case SIGFPE:
             see_errlog(1000, "signal SIGFPE occured",RPT_TO_LOG,0,0);
            break;
        case SIGKILL:
             see_errlog(1000, "signal SIGKILL occured",RPT_TO_LOG,0,0);
            break;
        case SIGUSR1:
             see_errlog(1000, "signal SIGUSR1 occured",RPT_TO_LOG,0,0);
            break;
        case SIGSEGV:
             see_errlog(1000, "signal SIGSEGV occured",RPT_TO_LOG,0,0);
            break;
        case SIGUSR2:
             see_errlog(1000, "signal SSIGUSR2 occured",RPT_TO_LOG,0,0);
            break;
        case SIGPIPE:
             see_errlog(1000, "signal SIGPIPE occured",RPT_TO_LOG,0,0);
            break;
        case SIGALRM:
             see_errlog(1000, "signal SIGALRM occured",RPT_TO_LOG,0,0);
            break;
        case SIGTERM:
             see_errlog(1000, "signal SIGTERM occured",RPT_TO_LOG,0,0);
            break;
        case SIGSTKFLT:
             see_errlog(1000, "signal SIGSTKFLT occured",RPT_TO_LOG,0,0);
            break;
        case SIGCLD:
             see_errlog(1000, "signal SIGCLD occured",RPT_TO_LOG,0,0);
            break;
        //case SIGCHLD:
        //    break;
        case SIGCONT:
             see_errlog(1000, "signal SIGCONT occured",RPT_TO_LOG,0,0);
            break;
        case SIGSTOP:
             see_errlog(1000, "signal SIGSTOP occured",RPT_TO_LOG,0,0);
            break;
        case SIGTSTP:
             see_errlog(1000, "signal SIGTSTP occured",RPT_TO_LOG,0,0);
            break;
        case SIGTTIN:
             see_errlog(1000, "signal SIGTTIN occured",RPT_TO_LOG,0,0);
            break;
        case SIGTTOU:
             see_errlog(1000, "signal SIGTTOU occured",RPT_TO_LOG,0,0);
            break;
        case SIGURG:
             see_errlog(1000, "signal SIGURG occured",RPT_TO_LOG,0,0);
            break;
        case SIGXCPU:
             see_errlog(1000, "signal SIGXCPU occured",RPT_TO_LOG,0,0);
            break;
        case SIGXFSZ:
             see_errlog(1000, "signal SIGXFSZ occured",RPT_TO_LOG,0,0);
            break;
        case SIGVTALRM:
             see_errlog(1000, "signal SIGVTALRM occured",RPT_TO_LOG,0,0);
            break;
        case SIGPROF:
             see_errlog(1000, "signal SIGPROF occured",RPT_TO_LOG,0,0);
            break;
        case SIGWINCH:
             see_errlog(1000, "signal SIGWINCH occured",RPT_TO_LOG,0,0);
            break;
        case SIGPOLL:
             see_errlog(1000, "signal SIGPOLL occured",RPT_TO_LOG,0,0);
            break;
        //case SIGIO:
        //    break;
        case SIGPWR:
             see_errlog(1000, "signal SIGPWR occured",RPT_TO_LOG,0,0);
            break;
        case SIGSYS:
             see_errlog(1000, "signal SIGSYS occured",RPT_TO_LOG,0,0);
            break;
        //case SIGUNUSED:
        //    break;
        default:
            see_err_log(0,0,"signal %d orccured !!", i_signal_no);
    }
 
//    exit(i_signal_no);
}
