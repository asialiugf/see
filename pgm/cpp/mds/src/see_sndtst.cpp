// testTraderApi.cpp : 定义控制台应用程序的入口点。
//
#include <iostream>
#include <string.h>
#include "ThostFtdcMdApi.h"
#include <future.h>
#include "MdSpi.h"
#include <pthread.h>
#include <unistd.h>

char ca_errmsg[512] ;

/* =========== testing ================== */
int pub_sock ;
int msg_len = sizeof( CThostFtdcDepthMarketDataField ) ;
const char myurl1[] = "ipc:///tmp/heaven.ipc" ;
/* =========== testing ================== */

using namespace std;

CThostFtdcMdApi* pUserApi1;                             // UserApi对象

char FRONT_ADDR1[] = "tcp://180.168.146.187:10010";		// 前置地址
char FRONT_ADDR2[] = "tcp://180.168.146.187:10011";		// 前置地址
char FRONT_ADDR3[] = "tcp://218.202.237.33:10012";		// 前置地址

TThostFtdcBrokerIDType	 BROKER_ID = "9999";			// 经纪公司代码
TThostFtdcInvestorIDType INVESTOR_ID = "068520";		// 投资者代码
TThostFtdcPasswordType   PASSWORD = "*****";		    // 用户密码

char ca_futures[FUTURE_NUMBER][FUTRUE_ID_LEN] ;
char *ppFutureID[FUTURE_NUMBER];                        // 行情订阅列表

int iInstrumentID = 3;									// 行情订阅数量
int iRequestID = 1;                                     // 请求编号

//static int              i_idx ;
//see_config_t            gt_conf ;
//see_config_t            *gp_conf ;

int
main(int argc,char *argv[])
{

    see_signal_init() ;
 
    see_daemon(1,0) ;

/* ---------- 测试 开始------------------ */ 
/*
../../etc/tbl/tick_file_name.txt 是tick.bin文件列表，
一个一个文件打开，通过nn_send每一条tick信息。
tick.bin文件放在 ../../dat/tst_dat/ 目录下。

*/

    int i_rtn = 0 ;
    int bytes ;
    int i_count ;
    static char ca_tick_file_list[] = "../../etc/tbl/tick_file_name.txt" ;
    static char ca_line[100] ;
    static char ca_tick_file[256] ;
    FILE *pf ;
    FILE *pf_tick_file ;
    CThostFtdcDepthMarketDataField * market_data ;
    CThostFtdcDepthMarketDataField tick_data ;
    //gp_conf = &gt_conf ;
    see_config_init();
    //see_stt_blocks_init( gp_conf );

    pub_sock = see_pair_server( gp_conf->ca_nn_pubsub_url );   

    sleep(2) ;
    pf = fopen(ca_tick_file_list,"r");
    if (pf == NULL) {
        see_errlog(1000,(char *)"open future table error!!",RPT_TO_LOG,0,0) ;
        return -1 ;
    }   
    memset( ca_line,'\0',100 ) ; 

    i_count = 0 ;
    while ( fgets(ca_line, 100, pf ) != NULL ){
        int len = strlen(ca_line)-1 ;
        ca_line[len] = '\0' ;
        memset( ca_tick_file,'\0',256 ) ; 
        strcat( ca_tick_file,(char *)"../../dat/tst_dat/") ;
        strcat( ca_tick_file,ca_line ) ;
        
        pf_tick_file = fopen(ca_tick_file,"rb");
        if (pf_tick_file == NULL) {
            see_errlog(1000,(char *)"open future table error!!",RPT_TO_LOG,0,0) ;
            continue ;
        }

        while ( (i_rtn = fread(&tick_data,msg_len,1,pf_tick_file)) != 0 ) 
        {
            market_data = &tick_data ;
            tick_data.BidVolume5 = i_count ;
            bytes = nn_send (pub_sock, (char *) market_data, msg_len,NN_DONTWAIT);
            if ( bytes != msg_len ){
                see_errlog( 1000,(char *)"send error!!",RPT_TO_LOG,0,0 ) ;
            }
            i_count++ ;

            //see_disp_tick( (char*) &tick_data );

            usleep(50) ;
        }
        fclose(pf_tick_file);
    }   
    fclose(pf);
    nn_close( pub_sock ) ;

    sleep(2);
    exit (0) ;

/*  ------------测试 结束 ----------------  */

    iInstrumentID = 100;
	pUserApi1 = CThostFtdcMdApi::CreateFtdcMdApi("1.con");			// 创建UserApi
	CThostFtdcMdSpi* pUserSpi1 = new CMdSpi();                      // 创建UserSpi  可以创建多个
	pUserApi1->RegisterSpi(pUserSpi1);      						// 注册事件类
	pUserApi1->RegisterFront(FRONT_ADDR2);	           				// connect

	pUserApi1->Init();
    cout << "after Init() !" << endl;

    pthread_t pthID = pthread_self();
    cerr << "================main 02 =============================  pthId:" << pthID << endl;

	pUserApi1->Join();
    cout << "after Join() !" << endl;

    pthID = pthread_self();
    cerr << "03 pthId:" << pthID << endl;

    //	pUserApi->Release();

} /* end of main() */
