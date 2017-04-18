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

//extern see_config_t         gt_conf;
//extern see_config_t        *gp_conf;
//extern see_shm_t            gt_shm;

#define nginx_version           1011006
#define FUTURE_VERSION          "1.11.6"
#define FUTURE_VER              "nginx/" FUTURE_VERSION
#define FUTURE_VER_BUILD        FUTURE_VER "( 1000 )"
#define SEE_LINEFEED             "\x0a"
#define SEE_LINEFEED_SIZE        1


typedef int see_fd_t;
#define see_stderr               STDERR_FILENO
#define see_strlen(s)       strlen((const char *) s)
#define see_inline      inline

