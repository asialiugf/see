#include <iostream>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include "ThostFtdcMdApi.h"
//#include <AAextern.h>
#include "MdSpi.h"

extern "C"
{
#include <see_com_common.h>
    double hh[10000] ;
    double ll[10000] ;
    double cc[10000] ;
    double oo[10000] ;
}

int test = 0 ;

/*
*   FUTURE_NUMBER ：表示有多少个期货。
*   pc_futures 是指针数组，经过  i_rtn = see_futures_init(pc_futures,ca_futures) ;
*   进行初始化，see_futures_init 会从../../etc/tbl/see_future_table文件里读出有哪些期货，
*   并将这些期货初始化到 ca_futures和pc_futures中
*/

using namespace std;
/*   globle parameters !!!  */
see_config_t        t_conf ;

char ca_errmsg[256] ;
char ca_jsonfile[] = "../../etc/json/see_brokers.json" ;

CThostFtdcMdApi* pUserApi1;                             // UserApi对象

char FRONT_ADDR4[] = "tcp://116.228.246.81:41213";		// 前置地址  招商期货
TThostFtdcBrokerIDType	    BROKER_ID       = "8070";			// 经纪公司代码 招商期货
TThostFtdcInvestorIDType    INVESTOR_ID     = "********";		// 投资者代码
TThostFtdcPasswordType      PASSWORD        = "******";		    // 用户密码

int     iInstrumentID = 3;									// 行情订阅数量
int     iRequestID = 1;                                     // 请求编号

cJSON   *json ;
cJSON   *broker ;
cJSON   *ip ;



#define nginx_version      1011006
#define FUTURE_VERSION      "1.11.6"
#define FUTURE_VER          "nginx/" FUTURE_VERSION
#define FUTURE_VER_BUILD    FUTURE_VER "( 1000 )"
#define SEE_LINEFEED             "\x0a"
#define SEE_LINEFEED_SIZE        1


typedef int see_fd_t;
#define see_stderr               STDERR_FILENO
#define see_strlen(s)       strlen((const char *) s)
#define see_inline      inline

static see_inline void see_write_stderr(const char *text);
static see_inline ssize_t see_write_fd(see_fd_t fd, void *buf, size_t n);
static void see_show_version();

int ctpget()
{
    int i_rtn;
    i_rtn = pthread_create(&t_conf.p_dat, NULL, see_pthread_dat, &t_conf);
    if(i_rtn == -1) {
        printf("create thread (save data to database !) failed erron= %d/n", errno);
        return -1;
    }
    //pthread_create(&t_conf.p_bar, NULL, see_pthread_bar, &t_conf);
    //sleep(1) ;


    iInstrumentID = 100;
    pUserApi1 = CThostFtdcMdApi::CreateFtdcMdApi("1.con");          // 创建UserApi
    CThostFtdcMdSpi* pUserSpi1 = new CMdSpi();                      // 创建UserSpi  可以创建多个


    pUserApi1->RegisterSpi(pUserSpi1);                              // 注册事件类
    pUserApi1->RegisterFront(FRONT_ADDR4);                          // connect

    pUserApi1->Init();
    cout << "after Init() !" << endl;

    //pUserApi1->SubscribeMarketData(pc_futures, iInstrumentID);
    //cout << "  pUserApi1->SubscribeMarketData !!!" << endl ;

    pthread_t pthID = pthread_self();
    cerr << "================main 02 =============================  pthId:" << pthID << endl;

    pUserApi1->Join();
    cout << "after Join() !" << endl;

    pthID = pthread_self();
    cerr << "03 pthId:" << pthID << endl;
    return 0;
}

int
main(int argc,char *argv[])
{

    /*
    char ca_kkkf[100] ;
    memset( ca_kkkf,'o',99 );
    ca_kkkf[99] ='\0';
    see_err_log(ca_kkkf,strlen(ca_kkkf),"%s %d\n","kkkk",sizeof(ca_kkkf));
    exit(1);
    */

    int iu = 0;
    see_shm_t shm;
    shm.size = sizeof(see_fut_mem_t)*100;
    see_shm_alloc(&shm);
    memset(shm.addr, '\0', 100);
    memset(shm.addr, 'p',88);
    printf((const char *) shm.addr);
    see_shm_free(&shm);

    int pid = 0;
    //see_stt_blocks_init( &t_conf );
    see_show_version();

    see_signal_init();                 // 需要详细考虑
    signal(SIGHUP, SIG_IGN);
    signal(SIGPIPE, SIG_IGN);
    see_daemon(1,0) ;
    see_config_init(&t_conf);

    stt_bars_t K;
    stt_init(&K, (char *)"stt01",t_conf.j_conf);
    stt_init(&K, (char *)"stt03",t_conf.j_conf);
    stt_init(&K, (char *)"stt02",t_conf.j_conf);
    
    int x;
    for (x = 99;x < 199; x++) {
        printf ( "%lf\n",K.B[K.p[1]]->oo[x]) ;
    }

    cJSON   *j_strategy ;
    j_strategy = cJSON_GetObjectItem(t_conf.j_conf, "strategy");
    if(j_strategy <=0) {
        printf(" json error!\n ") ;
    }
    if(j_strategy) {
        int num ;
        int num2 ;
        cJSON *j_stt;
        cJSON *j_map;
        cJSON *j_ttt;
        cJSON *j_period;
        cJSON *j_ccc;
        int i;
        int k;

        num = cJSON_GetArraySize(j_strategy);
        for(i = 0; i< num ; i++) {
            j_stt = cJSON_GetArrayItem(j_strategy,i);
            if(j_stt) {
                printf("%s\n",j_stt->string);
                j_ttt = cJSON_GetObjectItem(j_stt, "period");
                num2 = cJSON_GetArraySize(j_ttt);
                for(k=0; k<num2; k++) {
                    j_period = cJSON_GetArrayItem(j_ttt,k);
                    if(j_period) {
                        printf("%s \n", j_period->valuestring) ;
                        j_map = cJSON_GetObjectItem(t_conf.j_conf,"period_map");
                        j_ccc = cJSON_GetObjectItem(j_map,j_period->valuestring);
                        printf("%s: %s %d \n",j_stt->string, j_period->valuestring,j_ccc->valueint);
                    }
                }
            }
        }
    }

    exit(1);

    if(argc<=1) {
        printf(" ctpget.x will enter into product mode! \n");
        t_conf.c_test = 'p';
    } else {
        if(memcmp(argv[1],"-t",2)==0) {
            printf(" ctpget.x will enter into test mode! \n");
            t_conf.c_test = 't';
        }
        if(memcmp(argv[1],"-p",2)==0) {
            t_conf.c_test = 'p';
        }
    }

    pid = getpid();
    setproctitle_init(argc, argv, environ);
    setproctitle("%s %s", "future.x :", "master");

    pid = fork();
    switch(pid) {
    case -1:
        return -1;

    case 0:
        pid = getpid();
        setproctitle("%s %s [ %s ]", "future.x :", "ctpget","TA701 TA701 TA701");
        see_shm_alloc(&shm);

        while(1) {
            iu ++;
            memset(shm.addr, '\0', 100);
            memset(shm.addr, 'l',88);
            sprintf((char *)shm.addr, " this a test %d \n",iu);
            printf((const char *) shm.addr);
            sleep(1);
        }

        ctpget() ;
        break;

    default:
        while(1) {
            sleep(100);
        }
        break;
    }

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
