extern "C"
{
    #include <see_com_common.h>
}
// USER_API参数
extern char ca_errmsg[];
extern char FRONT_ADDR1[];
extern char FRONT_ADDR2[];
extern char FRONT_ADDR3[];
extern TThostFtdcBrokerIDType   BROKER_ID;
extern TThostFtdcInvestorIDType INVESTOR_ID;
extern TThostFtdcPasswordType   PASSWORD;
extern int                      iInstrumentID;
extern int                      iRequestID;
extern CThostFtdcMdApi         *pUserApi1;

extern see_config_t        t_conf ;
