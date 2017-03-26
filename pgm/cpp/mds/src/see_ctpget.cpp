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
*   FUTURE_NUMBER ����ʾ�ж��ٸ��ڻ���
*   pc_futures ��ָ�����飬����  i_rtn = see_futures_init(pc_futures,ca_futures) ;
*   ���г�ʼ����see_futures_init ���../../etc/tbl/see_future_table�ļ����������Щ�ڻ���
*   ������Щ�ڻ���ʼ���� ca_futures��pc_futures��
*/

using namespace std;
/*   globle parameters !!!  */
see_config_t        t_conf ;
/*   globle parameters !!!  */

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

int
main(int argc,char *argv[])
{

    int i_rtn;
    see_config_init( &t_conf );
    //see_stt_blocks_init( &t_conf );

    see_signal_init() ;                 // ��Ҫ��ϸ���� 
    signal(SIGHUP, SIG_IGN);
    signal(SIGPIPE, SIG_IGN);
    see_daemon(1,0) ;

    i_rtn = pthread_create(&t_conf.p_dat, NULL, see_pthread_dat, &t_conf);
    if  (i_rtn == -1) {
            printf("create thread (save data to database !) failed erron= %d/n", errno);
            return -1;
    }
    //pthread_create(&t_conf.p_bar, NULL, see_pthread_bar, &t_conf);
    //sleep(1) ;


    iInstrumentID = 100;
	pUserApi1 = CThostFtdcMdApi::CreateFtdcMdApi("1.con");			// ����UserApi 
	CThostFtdcMdSpi* pUserSpi1 = new CMdSpi();                      // ����UserSpi  ���Դ������


	pUserApi1->RegisterSpi(pUserSpi1);      						// ע���¼���
	pUserApi1->RegisterFront(FRONT_ADDR4);	           				// connect

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

    //	pUserApi->Release();

} /* end of main() */
