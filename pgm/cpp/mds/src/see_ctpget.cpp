#include <iostream>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include "ThostFtdcMdApi.h"
#include <future.h>
#include "MdSpi.h"


/*
*   FUTURE_NUMBER ：表示有多少个期货。
*   pc_futures 是指针数组，经过  i_rtn = see_futures_init(pc_futures,ca_futures) ;
*   进行初始化，see_futures_init 会从../../etc/tbl/see_future_table文件里读出有哪些期货，
*   并将这些期货初始化到 ca_futures和pc_futures中
*/

using namespace std;

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

int see_ctpget()
{
    int i_rtn;


    if(gp_conf->i_save_tick_only != 1) {
        pthread_mutex_init(&gp_conf->mutex_dat, NULL);
        pthread_mutex_init(&gp_conf->mutex_bar, NULL);
        pthread_cond_init(&gp_conf->cond_dat, NULL);
        pthread_cond_init(&gp_conf->cond_bar, NULL);
        i_rtn = pthread_create(&gp_conf->p_dat, NULL, see_pthread_dat, gp_conf);
        if(i_rtn == -1) {
            see_err_log(0,0,"see_ctpget(): pthread_create() error!  errno=%d\n",errno);
            return -1;
        }
    }
    //pthread_create(&gp_conf->p_bar, NULL, see_pthread_bar, &gp_conf);
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

int see_fork_ctpget()
{
    int rc;
    int pid;
    int i = 0;
    char ca_futures[1024];
    pid = fork();
    switch(pid) {
    case -1:
        return -1;

    case 0:
        pid = getpid();
        see_memzero(ca_futures,1024);
        for(i=0; i<gp_conf->i_future_num; i++) {
            strcat(ca_futures,gp_conf->ca_futures[i]) ;
            strcat(ca_futures," ");
        }
        setproctitle("%s %s [%s]", "future.x :", "ctpget",ca_futures);

        if(gp_conf->i_save_tick_only == 1) {
            see_ctpget() ;
        } else {

            /*
             *  see_ctpget() 会通过 zmq 将 ohlc传给 sttrun() 在这里初始化。
             *  每个future.x 只生成一个ctpget ，所以可以用全局的 gp_conf来保存 zmq_ctxsock。
             *  如果要生成多个ctpget， 请运行多个 future.x 即可, 每个future.x 有自己独立的 gp_conf
            */
            if(gp_conf->send_on) {
                rc = see_zmq_pub_init(gp_conf->ca_zmq_pub_url,&gp_conf->pub_ctxsock);
                if(rc<0) {
                    see_err_log(0,0,"see_fork_ctpget(): see_zmq_pub_init() error !");
                    exit(-1);
                }
                //rc = see_zmq_sub_init(gp_conf->ca_zmq_sub_url,&gp_conf->sub_ctxsock,"test01");
            }

            if(gp_conf->stt_on) {
                //see_sttrun_init() ;
                /* 哪个future 用哪个 策略？ */
            }

            see_ctpget() ;

            if(gp_conf->send_on) {
                rc = see_zmq_pub_close(&gp_conf->pub_ctxsock);
                if(rc<0) {
                    see_err_log(0,0,"see_fork_ctpget(): see_zmq_pub_init() error !");
                    exit(-1);
                }
                //see_zmq_sub_close(&gp_conf->sub_ctxsock);
            }
        }

        break;

    default:
        break;
    }
    return 0;
}
