#include <iostream>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include "ThostFtdcMdApi.h"
#include <future.h>
#include <see_ctpget.h>
#include "MdSpi.h"

using namespace std;
//see_config_t         gt_conf ;
//see_config_t        *gp_conf ;
//see_shm_t            gt_shm ;

static see_inline void see_write_stderr(const char *text);
static see_inline ssize_t see_write_fd(see_fd_t fd, void *buf, size_t n);
static void see_show_version();


int
main(int argc,char *argv[])
{
    int pid = 0;
    see_show_version();

    see_signal_init();                 // ÐèÒªÏêÏ¸¿¼ÂÇ
    signal(SIGHUP, SIG_IGN);
    signal(SIGPIPE, SIG_IGN);
    see_daemon(1,0) ;

    gt_shm.size = sizeof(see_config_t);
    see_shm_alloc(&gt_shm);
    gp_conf = (see_config_t *)gt_shm.addr;
    //see_shm_free(&shm);

    see_config_init(gp_conf);

    if(argc<=1) {
        printf(" future.x will enter into product mode! \n");
        gp_conf->c_test = 'p';
    } else {
        if(memcmp(argv[1],"-t",2)==0) {
            printf(" future.x will enter into test mode! \n");
            gp_conf->c_test = 't';
        }
        if(memcmp(argv[1],"-p",2)==0) {
            gp_conf->c_test = 'p';
        }
    }

    pid = getpid();
    setproctitle_init(argc, argv, environ);
    setproctitle("%s %s", "future.x :", "Master");

    pid = fork();
    switch(pid) {
    case -1:
        return -1;

    case 0:
        pid = getpid();
        setproctitle("%s %s", "future.x :", "Waiter");
        

        /* for test B 
        see_shm_alloc(&shm);
        while(1) {
            iu ++;
            memset(shm.addr, '\0', 100);
            memset(shm.addr, 'l',88);
            sprintf((char *)shm.addr, " this a test %d \n",iu);
            printf((const char *) shm.addr);
            sleep(1);
            break ;
        }
         for test E */


        see_waiter(gp_conf) ;

        break;

    default:
        break;
    }
    see_ctpget();

} /* end of main() */




static void
see_show_version()
{
    see_write_stderr(" -- future.x -- version: " FUTURE_VER_BUILD SEE_LINEFEED);

    //if (ngx_show_help) {
    if(1) {
        see_write_stderr(
            "Usage: future.x [-?hvVtTq] [-s signal] [-c filename] "
            "[-p prefix] [-g directives]" SEE_LINEFEED
            SEE_LINEFEED
            "Options:" SEE_LINEFEED
            "  -?,-h         : this help" SEE_LINEFEED
            "  -v            : show version and exit" SEE_LINEFEED
            "  -V            : show version and configure options then exit"
            SEE_LINEFEED
            "  -t            : test configuration and exit" SEE_LINEFEED
            "  -T            : test configuration, dump it and exit"
            SEE_LINEFEED
            "  -q            : suppress non-error messages "
            "during configuration testing" SEE_LINEFEED
            "  -s signal     : send signal to a master process: "
            "stop, quit, reopen, reload" SEE_LINEFEED
            "  -p prefix     : set prefix path (default: NONE)" SEE_LINEFEED
            "  -g directives : set global directives out of configuration "
            "file" SEE_LINEFEED SEE_LINEFEED
        );
    }
}

static see_inline void
see_write_stderr(const char *text)
{
    (void) see_write_fd(see_stderr, (void *)text, see_strlen(text));
}

static see_inline ssize_t
see_write_fd(see_fd_t fd, void *buf, size_t n)
{
    return write(fd, buf, n);
}
