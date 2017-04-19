#include <iostream>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include "ThostFtdcMdApi.h"
#include <future.h>
#include "MdSpi.h"
/*
extern "C"
{
#include <see_com_common.h>
}
*/
int test = 0 ;

/*
*   FUTURE_NUMBER ����ʾ�ж��ٸ��ڻ���
*   pc_futures ��ָ�����飬����  i_rtn = see_futures_init(pc_futures,ca_futures) ;
*   ���г�ʼ����see_futures_init ���../../etc/tbl/see_future_table�ļ����������Щ�ڻ���
*   ������Щ�ڻ���ʼ���� ca_futures��pc_futures��
*/

using namespace std;
/*   globle parameters !!!  */
//see_config_t        gt_conf ;

char ca_errmsg[256] ;
char ca_jsonfile[] = "../../etc/json/see_brokers.json" ;

CThostFtdcMdApi* pUserApi1;                             // UserApi����

char FRONT_ADDR4[] = "tcp://116.228.246.81:41213";		// ǰ�õ�ַ  �����ڻ�
TThostFtdcBrokerIDType	    BROKER_ID       = "8070";			// ���͹�˾���� �����ڻ�
TThostFtdcInvestorIDType    INVESTOR_ID     = "********";		// Ͷ���ߴ���
TThostFtdcPasswordType      PASSWORD        = "******";		    // �û�����

int     iInstrumentID = 3;									// ���鶩������
int     iRequestID = 1;                                     // ������

cJSON   *json ;
cJSON   *broker ;
cJSON   *ip ;

int see_ctpget()
{
    int i_rtn;
    i_rtn = pthread_create(&gt_conf.p_dat, NULL, see_pthread_dat, &gt_conf);
    if(i_rtn == -1) {
        printf("create thread (save data to database !) failed erron= %d/n", errno);
        return -1;
    }
    //pthread_create(&gt_conf.p_bar, NULL, see_pthread_bar, &gt_conf);
    //sleep(1) ;


    iInstrumentID = 100;
    pUserApi1 = CThostFtdcMdApi::CreateFtdcMdApi("1.con");          // ����UserApi
    CThostFtdcMdSpi* pUserSpi1 = new CMdSpi();                      // ����UserSpi  ���Դ������


    pUserApi1->RegisterSpi(pUserSpi1);                              // ע���¼���
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

int see_fork_ctpget() {
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
        for(i=0;i<gp_conf->i_future_num;i++){
             strcat(ca_futures,gp_conf->ca_futures[i]) ;
        }
        
        setproctitle("%s %s [%s]", "future.x :", "ctpget",ca_futures);
        see_ctpget() ;

        break;

    default:
        break;
    }
    return 0;
}
