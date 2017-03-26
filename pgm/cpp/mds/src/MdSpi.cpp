#include <iostream>
#include <string.h>
#include <pthread.h>
#include <MdSpi.h>
#include <AAextern.h>

int i_sock;
int i_tick_len = sizeof(CThostFtdcDepthMarketDataField) ;
//const char ca_nano_url[] = "ipc:///tmp/heaven.ipc";

using namespace std;

void CMdSpi::OnRspError(CThostFtdcRspInfoField *pRspInfo,
                        int nRequestID, bool bIsLast)
{
    cerr << "--->>> "<< "OnRspError" << endl;
    IsErrorRspInfo(pRspInfo);
}

void CMdSpi::OnFrontDisconnected(int nReason)
{
    cerr << "--->>> " << "OnFrontDisconnected" << endl;
    cerr << "--->>> Reason = " << nReason << endl;
}

void CMdSpi::OnHeartBeatWarning(int nTimeLapse)
{
    cerr << "--->>> " << "OnHeartBeatWarning" << endl;
    cerr << "--->>> nTimerLapse = " << nTimeLapse << endl;
}

void CMdSpi::OnFrontConnected()
{

    cerr << "OnFrontConnected() "  << endl;
    i_sock = see_pipeline_server(t_conf.ca_nn_pubsub_url);             // become a nanomsg pub server !!
    ReqUserLogin1();                                             // user login !!!  用户登录请求
}

void CMdSpi::ReqUserLogin1()
{
    int i_rtn;
    CThostFtdcReqUserLoginField req;

    memset(&req, 0, sizeof(req));
    strcpy(req.BrokerID, BROKER_ID);
    strcpy(req.UserID, INVESTOR_ID);
    strcpy(req.Password, PASSWORD);

    i_rtn = pUserApi1->ReqUserLogin(&req, ++iRequestID);
    if(i_rtn != 0) {
        memset(ca_errmsg,'\0',100);
        sprintf(ca_errmsg,"ReqUserLogin1(): pUserApi1->ReqUserLogin() error: %d\n", i_rtn);
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);
    }

    memset(ca_errmsg,'\0',100);
    sprintf(ca_errmsg,"ReqUserLogin :----OK!!!-------%d\n", i_rtn);
    see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);


}

void CMdSpi::OnRspUserLogin(CThostFtdcRspUserLoginField *pRspUserLogin,
                            CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    cerr << "--->>> " << "OnRspUserLogin~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" << endl;
    if(bIsLast && !IsErrorRspInfo(pRspInfo)) {
        pUserApi1->GetTradingDay();               // 获取当前交易日
        SubscribeMarketData1();	                   // 请求订阅行情
    }
}

void CMdSpi::SubscribeMarketData1()
{
    int i_rtn;
    i_rtn = pUserApi1->SubscribeMarketData(t_conf.pc_futures, iInstrumentID);      // 请求订阅行情 !!
    if(i_rtn != 0) {
        memset(ca_errmsg,'\0',100);
        sprintf(ca_errmsg,"ubscribeMarketData error :%d\n", i_rtn);
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);
    }
}

void CMdSpi::OnRspSubMarketData(CThostFtdcSpecificInstrumentField *pSpecificInstrument, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    cerr << "OnRspSubMarketData !!!";
    cerr << pRspInfo->ErrorMsg;
    cerr << "ErrorID:" <<  pRspInfo->ErrorID << endl;
    cerr << "pSpecificInstrument ->InstrumentID  " << pSpecificInstrument->InstrumentID << endl;
    cerr << nRequestID << endl << endl;
}

void CMdSpi::OnRspUnSubMarketData(CThostFtdcSpecificInstrumentField *pSpecificInstrument, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    cerr << "OnRspUnSubMarketData" << endl;
}

void CMdSpi::OnRtnDepthMarketData(CThostFtdcDepthMarketDataField *buf)
{
    int bytes;
    int i_idx;
    // see_save_tick( (char *)buf, i_tick_len );

    bytes = nn_send(i_sock, (char *)buf, i_tick_len,NN_DONTWAIT);          // 收到数据，发送到存储进程 进行存储！
    if(bytes != i_tick_len) {
        memset(ca_errmsg,'\0',100);
        sprintf(ca_errmsg, "MdSpi.cpp: nn_send error : %s-%s-%s-%s bytes:%d",
                buf->InstrumentID,
                buf->TradingDay,
                buf->ActionDay,
                buf->UpdateTime,bytes);
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);
    }

    i_idx = see_get_future_index(t_conf.pc_futures,buf->InstrumentID);   //i_idx 合约所在的数组下标
    if(i_idx == SEE_ERROR) {
        sprintf(ca_errmsg,"future %s is not in pc_futures : %s",buf->InstrumentID,buf->InstrumentID);
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);
    }
    see_handle_bars(t_conf.pt_fut_blks[i_idx], (char *)buf);
}

void OnRspQryDepthMarketData(CThostFtdcDepthMarketDataField *buf, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    cerr << "OnRspQryDepthMarketData" << endl;
}
bool CMdSpi::IsErrorRspInfo(CThostFtdcRspInfoField *pRspInfo)
{
    // 如果ErrorID != 0, 说明收到了错误的响应
    bool bResult = ((pRspInfo) && (pRspInfo->ErrorID != 0));
    if(bResult)
        cerr << "--->>> ErrorID=" << pRspInfo->ErrorID << ", ErrorMsg=" << pRspInfo->ErrorMsg << endl;
    return bResult;
}
