#include <iostream>
#include <string.h>
#include <pthread.h>
#include <MdSpi.h>
#include <future.h>

int i_tick_len = sizeof(CThostFtdcDepthMarketDataField) ;

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
    ReqUserLogin1();                                             // user login !!!  用户登录请求
}

void CMdSpi::ReqUserLogin1()
{
    int rc;
    CThostFtdcReqUserLoginField req;

    memset(&req, 0, sizeof(req));
    strcpy(req.BrokerID, BROKER_ID);
    strcpy(req.UserID, INVESTOR_ID);
    strcpy(req.Password, PASSWORD);

    rc = pUserApi1->ReqUserLogin(&req, ++iRequestID);
    if(rc != 0) {
        see_err_log(0,0,"ReqUserLogin1(): pUserApi1->ReqUserLogin() error: %d\n", rc);
    }
    see_err_log(0,0,"ReqUserLogin :----OK!!!-------%d\n", rc);
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
    int rc;
    rc = pUserApi1->SubscribeMarketData(gp_conf->pc_futures, iInstrumentID);      // 请求订阅行情 !!
    if(rc != 0) {
        see_err_log(0,0,"ubscribeMarketData error :%d\n", rc);
    }
}

void CMdSpi::OnRspSubMarketData(CThostFtdcSpecificInstrumentField  *pSpecificInstrument,
                                CThostFtdcRspInfoField             *pRspInfo,
                                int                                 nRequestID,
                                bool                                bIsLast)
{
    cerr << "OnRspSubMarketData !!!";
    cerr << pRspInfo->ErrorMsg;
    cerr << "ErrorID:" <<  pRspInfo->ErrorID << endl;
    cerr << "pSpecificInstrument ->InstrumentID  " << pSpecificInstrument->InstrumentID << endl;
    cerr << nRequestID << endl << endl;
}

void CMdSpi::OnRspUnSubMarketData(CThostFtdcSpecificInstrumentField  *pSpecificInstrument,
                                  CThostFtdcRspInfoField             *pRspInfo,
                                  int                                 nRequestID,
                                  bool                                bIsLast)
{
    cerr << "OnRspUnSubMarketData" << endl;
}

void CMdSpi::OnRtnDepthMarketData(CThostFtdcDepthMarketDataField *buf)
{
    int i_idx;

    i_idx = see_get_future_index(gp_conf->pc_futures,buf->InstrumentID);   //i_idx 合约所在的数组下标
    if(i_idx == SEE_ERROR) {
        see_err_log(0,0,"future %s is not in pc_futures : %s",buf->InstrumentID,
                    buf->InstrumentID);
    }
    see_handle_bars(gp_conf->pt_fut_blks[i_idx], buf);
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
