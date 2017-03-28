#include <see_com_common.h>

extern  double hh[10000];
extern  double ll[10000];
extern  double cc[10000];
extern  double oo[10000];

int       outBegIdx1;
int       outBegIdx2;
int       outBegIdx3;
int       outNBElement1;
int       outNBElement2;
int       outNBElement3;
double    HighestPrice1;
double    HighestPrice2;
double    HighestPrice3;
double    LowestPrice1;
double    LowestPrice2;
double    LowestPrice3;
double    outSlowK1[10000];
double    outSlowD1[10000];
double    outSlowJ1[10000];
double    J1[10000];
double    JE1[10000];
double    outSlowK2[10000];
double    outSlowD2[10000];
double    outSlowJ2[10000];
double    J2[10000];
double    JE2[10000];
double    outSlowK3[10000];
double    outSlowD3[10000];
double    outSlowJ3[10000];
double    J3[10000];
double    JE3[10000];


int
see_bars_index_forword(int start_index, int n)    // bar指针前移n个.
{
    int rtn;
    if(n >= MAX_BARS_LEN) {
        return -1;
    }
    rtn = start_index + n;
    if(rtn >= MAX_BARS_LEN) {
        rtn = rtn - MAX_BARS_LEN;
    }
    return rtn;
}

int
see_bars_index_back(int start_index, int n)   //bar指针后移n个。
{
    int rtn;
    if(n >= MAX_BARS_LEN) {
        return -1;
    }
    rtn = start_index -n;
    if(rtn < 0) {
        rtn = rtn + MAX_BARS_LEN;
    }
    return rtn;
}

int
see_bars_load(see_bar_t bars[], int start_index, int n)   // 从start_index开始装 n 个 bar的数据，装完后，需要将 g_bar_cur_index 改成 start_index + n -1;
{
    int rtn = 0;
    int i;
    for(i = start_index; i < start_index+n; i++) {
        bars[i].o = i;
        bars[i].c = i;
        bars[i].h = i;
        bars[i].l = i;
    }
    return rtn;
}
int
see_bars_calc_bar_1s(see_bar_t * bar)
{
    int rtn = 0;
    bar->o = 100;
    bar->c = 100;
    bar->h = 100;
    bar->l = 100;
    return rtn;
}

int
see_date_comp(char * pca_first, char * pca_last)
{

    int i_rtn;
    char ca_first[9];
    char ca_last[9];
    if(strlen(pca_first) < 8) {
        see_errlog(1000,"see_date_comp: input error!",RPT_TO_LOG,0,0);
    }
    if(strlen(pca_last) < 8) {
        see_errlog(1000,"see_date_comp: input error!",RPT_TO_LOG,0,0);
    }
    memset(ca_first,'\0',9);
    memset(ca_last,'\0',9);
    memcpy(ca_first,pca_first,8);
    memcpy(ca_last,pca_last,8);
    i_rtn = strcmp(ca_first,ca_last);
    return i_rtn;
}

int
see_time_comp(char * f, char * l)    // 比较时间，输出秒 格式：06:33:26
{
    char f_h[3] = "\0\0\0";
    char f_m[3] = "\0\0\0";
    char f_s[3] = "\0\0\0";

    char l_h[3] = "\0\0\0";
    char l_m[3] = "\0\0\0";
    char l_s[3] = "\0\0\0";

    int fh,fm,fs,lh,lm,ls;

    time_t f_sec;
    time_t l_sec;

    struct tm f_time_fields;
    struct tm l_time_fields;

    memcpy(f_h,f,2);
    memcpy(f_m,f+3,2);
    memcpy(f_s,f+6,2);

    memcpy(l_h,l,2);
    memcpy(l_m,l+3,2);
    memcpy(l_s,l+6,2);

    fh = atoi(f_h);
    fm = atoi(f_m);
    fs = atoi(f_s);

    lh = atoi(l_h);
    lm = atoi(l_m);
    ls = atoi(l_s);

    if(fh == lh && fm == lm) {
        sprintf(ca_errmsg,"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk, %s,%s,%d",f,l,ls-fs);
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);
        return ls-fs;
    }

    f_time_fields.tm_mday = 0;
    f_time_fields.tm_mon  = 0;
    f_time_fields.tm_year = 0;
    f_time_fields.tm_hour = fh;
    f_time_fields.tm_min  = fm;
    f_time_fields.tm_sec  = fs;

    l_time_fields.tm_mday = 0;
    l_time_fields.tm_mon  = 0;
    l_time_fields.tm_year = 0;
    l_time_fields.tm_hour = lh;
    l_time_fields.tm_min  = lm;
    l_time_fields.tm_sec  = ls;

    f_sec = mktime(&f_time_fields);
    l_sec = mktime(&l_time_fields);

    sprintf(ca_errmsg,"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk, %s,%s,%d",f,l,(int)(l_sec-f_sec));
    see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);
    return l_sec-f_sec;
}

int
see_bar_calc_1s(see_bar_t * p_bar,char * buf)
{
    return SEE_OK;
}

int see_bar_calc_5s(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_10s(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_15s(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_30s(see_bar_t * p_bar,char * buf)
{
    return SEE_OK;

}

int see_bar_calc_1f(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_3f(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_5f(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_10f(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_15f(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_30f(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_1h(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_2h(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_3h(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_4h(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_d(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_w(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_m(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_s(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

int see_bar_calc_y(see_bar_t * p_bar,char * buf)
{

    return SEE_OK;
}

see_bar_t *
see_create_bar(char * p_future_id,char c_period)
{
    see_bar_t * kkk;
    kkk = malloc(sizeof(see_bar_t));              // 为每个future 分配2个bars 的内存 0表示前一个bar,1表示当前bar
    if(kkk == NULL) {
        see_errlog(1000,"see_create_bar error!\n",RPT_TO_LOG,0,0);
    }
    memset(kkk->TradingDay,'\0',9);
    memset(kkk->ca_btime,'\0',9);
    memset(kkk->ActionDay,'\0',9);
    kkk->o = -1;
    kkk->c = -1;
    kkk->h = -1;
    kkk->l = -1;
    kkk->v = -1;

    return kkk;
}

int
see_calc_bar(see_fut_block_t * p_block, char * buf, int period)
{
    int wr = 0;

    return wr;
}

int
see_calc_k_bar(see_fut_block_t * p_block, char * buf, int period)
{
    int    num = 0;

    switch(period) {
    case  BAR_TICK :
        break;
    case  BAR_1S :
    case  BAR_2S :
        break;
    case  BAR_3S :
        break;
    case  BAR_5S :
        break;
    case  BAR_10S :
        break;
    case  BAR_15S :
        break;
    case  BAR_30S :
        break;
    case  BAR_1F :
        break;
    case  BAR_2F :
        break;
    case  BAR_3F :
        break;
    case  BAR_5F :
        break;
    case  BAR_10F :
        break;
    case  BAR_15F :
        break;
    case  BAR_30F :
        break;
    case  BAR_1H :
        break;
    case  BAR_2H :
        break;
    case  BAR_3H :
        break;
    case  BAR_4H :
        break;
    case  BAR_5H :
        break;
    case  BAR_1D :
    case  BAR_1W :
    case  BAR_1M :
    case  BAR_1J :
    case  BAR_1Y :
        break;
    default :
        break;
    }
    return num;
}

/*
* i_sgm_idx：用于回传，返回当前的tick是在哪个交易时间段内
* 收到一个tick，就需要调用一次is_mkt_open，更新 block里的 i_sgm_idx c_oc_flag
*/
int is_mkt_open(see_fut_block_t *p_block, char *buf)
{
    int j = 0;
    int b;
    int e;
    struct CThostFtdcDepthMarketDataField * tick;
    tick = (struct CThostFtdcDepthMarketDataField *)buf;

    j = 0;
    while(j < SEE_SGM_NUM) {
        if(p_block->pt_hour->pt_segments[j] != NULL) {
            b = memcmp(tick->UpdateTime, p_block->pt_hour->pt_segments[j]->ca_b,8);
            e = memcmp(tick->UpdateTime, p_block->pt_hour->pt_segments[j]->ca_e,8);
            if(b >=0 && e<0 && p_block->pt_hour->pt_segments[j]->c_oc_flag == 'o') {
                p_block->i_sgm_idx = j;
                p_block->c_oc_flag = 'o';
                return SEE_MKT_OPEN;
            }
            j++;
        } else {
            p_block->i_sgm_idx = 0;
            p_block->c_oc_flag = 'c';
            return SEE_MKT_CLOSE;
        }
    }
    p_block->i_sgm_idx = 0;
    p_block->c_oc_flag = 'c';
    return SEE_MKT_CLOSE;
}

int is_weekend(char * pc_day)    //很耗时！！！！
{
    struct tm * p_time;
    struct tm cur_time;
    time_t   rawtime;
    char ca_y[5] = "\0\0\0\0\0";
    char ca_m[3] = "\0\0\0";
    char ca_d[3] = "\0\0\0";

    memcpy(ca_y,pc_day,4);
    memcpy(ca_m,pc_day+4,2);
    memcpy(ca_d,pc_day+6,2);

    cur_time.tm_mday = atoi(ca_d);
    cur_time.tm_mon  = atoi(ca_m)-1;
    cur_time.tm_year = atoi(ca_y)-1900;
    cur_time.tm_hour = 0;
    cur_time.tm_min  = 0;
    cur_time.tm_sec  = 0;
    rawtime = mktime(&cur_time);

    p_time =localtime(&rawtime);
    if(p_time->tm_wday == 6 || p_time->tm_wday == 0) {
        return 1;
    } else {
        return 0;
    }
}
int is_holiday(char * pc_day)
{
    return 0;
}

int is_notrade(see_fut_block_t * p_block,char * time0)    //交易时间段判断
{
    /*
    */
    return 1;  //不在交易时间段内
}

/*
  see_handle_bars()
  p_block 从t_conf结构中取得 相应期货的 p_block

  在主程序中(see_recivev.c, mds/src/ctpget.cpp) ，同时处理多个期货品种.

  如果要在 see_handle_bars 的 see_calc_bar_block() 或者 see_save_bar()中
  处理 send to python 再 send to web页面的话，需要有一个参数，来判断前端订阅的是哪个期货品种。
  或者全部都送到 python rose，然后由rose来区分，到底送到哪个前端。

  最好的方案是， see_handle_bars() 能根据 参数 来选择 发送哪个品种到 python rose，同时，
  python rose 也能够根据前端页面的选择来 进行相应的期货品种的发送。
  这两者都具备筛选的能力。

*/
int
see_handle_bars(see_fut_block_t *p_block, char *buf)
{
    int     i_rtn;
    int     period;
    //int     uiui;
    //int     mimi;
    //char    ca_UpdateTime[9];
    //char    ca_TradingDay[9];
    //struct CThostFtdcDepthMarketDataField * tick;
    //tick = (struct CThostFtdcDepthMarketDataField *)buf;

    i_rtn = is_mkt_open(p_block,buf);      // 修改 block->c_oc_flag 以及 block->i_sgm_i_idx
    if(i_rtn == SEE_MKT_CLOSE) {
        return 0;
    }

    /* -----------------------  异常处理 ------------------------- /
    if( memcmp(ca_UpdateTime,"22:59",5) ==0 && memcmp(tick->UpdateTime,"23:29",5) ==0  ) {return 0;} //异常处理
    if( memcmp(tick->TradingDay,ca_TradingDay,8) ==0 )
    {
        uiui = see_time_to_int(tick->UpdateTime);
        mimi = see_time_to_int(ca_UpdateTime);
        if ( uiui < mimi ) { return 0; }
    }  // 异常处理：下一个K的时间比前一个K的时间还早，那就直接返回。
    memcpy(ca_TradingDay,tick->TradingDay,8);
    memcpy(ca_UpdateTime,tick->UpdateTime,8);
    / -----------------------  异常处理 ------------------------- */

    for(period=0; period<=30; period++) {
        see_calc_bar_block(p_block, buf, period);                   // 计算K柱 .
        see_save_bar(p_block, buf, period);                         // 保存文件.
    }

    return 0;
}

/*
rtn = 0; 表示为 第0秒的第0个tick,所以，这个tick的volume应该算到前一个K柱里
rtn = 1; 表示为 已经不是第0秒的第0个tick，所以这个tick的volume应该算到当前的K柱里
*/
int
see_first_tick(see_fut_block_t     *p_block,
               char            *buf,
               see_bar_t       *p_bar0,  //暂时没有用到
               see_bar_t       *p_bar1,
               int             period)
{
    int  rtn = 0;
    char f_h[3] = "\0\0\0";
    char f_m[3] = "\0\0\0";
    char f_s[3] = "\0\0\0";

    int mo;
//    int fh;
    int fm;
    int fs;
    char * f;
    struct CThostFtdcDepthMarketDataField * tick;
    tick = (struct CThostFtdcDepthMarketDataField *)buf;

    int  i_sgm_idx = p_block->i_sgm_idx;

//    memcpy(p_bar0->TradingDay,f,8);
    memcpy(p_bar1->TradingDay,tick->TradingDay,8);

//    memcpy(p_bar0->ActionDay,f,8);
    memcpy(p_bar1->ActionDay,tick->ActionDay,8);

    f = tick->UpdateTime;
    memcpy(f_h,f,2);
    memcpy(f_m,f+3,2);
    memcpy(f_s,f+6,2);

//    fh = atoi(f_h);
    fm = atoi(f_m);
    fs = atoi(f_s);

    switch(period) {
    case  BAR_TICK :
        break;
    case  BAR_1S :
        NEW_BAR1;
        if(tick->UpdateMillisec == 0) {
            rtn = 0;
        } else {
            rtn = 1;
        }
        break;
    case  BAR_2S :
        NEW_BAR1;
        mo = fs%2;
        fs = fs - mo;
        if(mo == 0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_s,'\0',3);
            sprintf(f_s,"%02d",fs);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_3S :
        NEW_BAR1;
        mo = fs%3;
        fs = fs - mo;
        if(mo == 0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_s,'\0',3);
            sprintf(f_s,"%02d",fs);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_5S :
        NEW_BAR1;
        mo = fs%5;
        fs = fs - mo;
        if(mo == 0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_s,'\0',3);
            sprintf(f_s,"%02d",fs);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_10S :
        NEW_BAR1;
        mo = fs%10;
        fs = fs - mo;
        if(mo == 0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_s,'\0',3);
            sprintf(f_s,"%02d",fs);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_15S :
        NEW_BAR1;
        mo = fs%15;
        fs = fs - mo;
        if(mo == 0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_s,'\0',3);
            sprintf(f_s,"%02d",fs);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_30S :
        NEW_BAR1;
        mo = fs%30;
        fs = fs - mo;
        if(mo == 0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_s,'\0',3);
            sprintf(f_s,"%02d",fs);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_1F :
        NEW_BAR1;
        if(memcmp(tick->UpdateTime+6,"00",2) == 0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_s,'0',3);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;

    case  BAR_2F :
        NEW_BAR1;
        mo = fm%2;
        fm = fm - mo;
        if(mo==0 && memcmp(tick->UpdateTime+6,"00",2)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_m,'\0',3);
            memset(f_s,'0',3);
            sprintf(f_m,"%02d",fm);
            memcpy(p_bar1->ca_btime+3,f_m,2);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_3F :
        NEW_BAR1;
        mo = fm%3;
        fm = fm - mo;
        if(mo==0 && memcmp(tick->UpdateTime+6,"00",2)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_m,'\0',3);
            memset(f_s,'0',3);
            sprintf(f_m,"%02d",fm);
            memcpy(p_bar1->ca_btime+3,f_m,2);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;
    case  BAR_5F :
        NEW_BAR1;
        mo = fm%5;
        fm = fm - mo;
        if(mo==0 && memcmp(tick->UpdateTime+6,"00",2)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_m,'\0',3);
            memset(f_s,'0',3);
            sprintf(f_m,"%02d",fm);
            memcpy(p_bar1->ca_btime+3,f_m,2);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;

    case  BAR_10F :
        NEW_BAR1;
        mo = fm%10;
        fm = fm - mo;
        if(mo==0 && memcmp(tick->UpdateTime+6,"00",2)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        } else {
            memset(f_m,'\0',3);
            memset(f_s,'0',3);
            sprintf(f_m,"%02d",fm);
            memcpy(p_bar1->ca_btime+3,f_m,2);
            memcpy(p_bar1->ca_btime+6,f_s,2);
            rtn = 1;
        }
        break;

    case  BAR_15F :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;

    case  BAR_20F :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_20F_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_20F_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;

    case  BAR_30F :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;

    case  BAR_1H :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1H_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1H_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;
    case  BAR_2H :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_2H_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_2H_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;

    case  BAR_3H :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_3H_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_3H_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;

    case  BAR_4H :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_4H_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_4H_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;

    case  BAR_5H :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_5H_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_5H_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;
    case  BAR_1D :
        NEW_BAR1;
        memcpy(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1D_start,8);
        memcpy(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1D_end,8);
        if(memcmp(tick->UpdateTime,p_bar1->ca_btime,8)==0) {
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
        }
        break;
    case  BAR_1W :
        NEW_BAR1;
        break;
    case  BAR_1M :
        NEW_BAR1;
        break;
    case  BAR_1J :
        NEW_BAR1;
        break;
    case  BAR_1Y :
        NEW_BAR1;
        break;
    default :
        break;
    }
    p_bar1->vsum = tick->Volume;
    return rtn;
}

int
see_calc_bar_block(see_fut_block_t  * p_block,
                   char         * buf,
                   int          period)
{
    int             i_kbar_num;
    see_bar_t       *p_bar0;
    see_bar_t       *p_bar1;

    struct CThostFtdcDepthMarketDataField * tick;

    if(period == BAR_TICK) {
        return 0;
    }

    tick = (struct CThostFtdcDepthMarketDataField *)buf;

    p_bar0 =  &p_block->bar_block[period].bar0;
    p_bar1 =  &p_block->bar_block[period].bar1;

    if(p_block->c_oc_flag == 'o') {    // 在交易时间段内
        if(p_bar1->o == SEE_NULL) {    // 程序开启后的第一个tick
            see_first_tick(p_block,buf,p_bar0,p_bar1,period);
            memcpy((char *)p_bar0,p_bar1,sizeof(see_bar_t));
            return 0;
        }

        i_kbar_num = is_same_k_bar(p_block,p_bar1,buf,period);
        if(i_kbar_num == 0) {   //同一个K
            UPDATE_BAR1;
        } else { // 下一个K
            memcpy((char *)p_bar0,p_bar1,sizeof(see_bar_t));
            if(see_first_tick(p_block,buf,p_bar0,p_bar1,period) == 0) {    // 新K柱，tick->UpdateTime的值可能不是 起始的时间
                p_bar0->v    = tick->Volume - p_bar0->vsum;
                p_bar0->vsum = tick->Volume;
            } else {
                p_bar1->v    = tick->Volume - p_bar0->vsum;
            }   // 根据 see_first_tick 返回 tick的 UpdateMillisec 是 0 还是 500，来处理 Volume

            //see_save_bin("../../dat/hloc.bin",(char *)p_bar0,sizeof(see_bar_t));
            //memset(ca_ohlc_file,'\0',512);
            //memset(ca_errmsg,'\0',512);
            //sprintf(ca_ohlc_file,"%s-%s-%d%c",p_block->InstrumentID,p_bar0->TradingDay,p_block->bar_block[period].i_bar_type,
            //        p_block->bar_block[period].c_bar_type);
            //sprintf(ca_ohlc_file,"%s-%s-%d",p_block->InstrumentID,p_bar0->TradingDay,period);
            //sprintf(ca_errmsg,"%s:%10.2f:%10.2f:%10.2f:%10.2f\n",p_bar0->ca_btime,p_bar0->o,p_bar0->h,p_bar0->l,p_bar0->c);
            //see_save_line(ca_ohlc_file,ca_errmsg);
            // see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0);
            /*
            hh[i_index] = p_bar0->h;
            ll[i_index] = p_bar0->l;
            oo[i_index] = p_bar0->o;
            cc[i_index] = p_bar0->c;
            */
        }
    }
    return 0;
}

int is_same_k_bar(see_fut_block_t     * p_block,
                  see_bar_t       * p_bar1,
                  char            * buf,
                  int             period)
{
    int  i_rtn = 0;
    int  i_sgm_idx;

    //int  i_bar_type;
    //int  c_bar_type;

    char f_h[3] = "\0\0\0";
    char f_m[3] = "\0\0\0";
    char f_s[3] = "\0\0\0";

    char b_h[3] = "\0\0\0";
    char b_m[3] = "\0\0\0";
    char b_s[3] = "\0\0\0";

    int fh,fm,fs;
    int bh,bm,bs;

    char * f;
    char * b;
    struct CThostFtdcDepthMarketDataField * tick;
    tick = (struct CThostFtdcDepthMarketDataField *)buf;

    if(p_bar1->o == SEE_NULL) {
        return -1;
    }

    i_sgm_idx  = p_block->i_sgm_idx;       // 从p_block中取 i_sgm_idx值
    //i_bar_type = p_block->bar_block[period].i_bar_type;
    //c_bar_type = p_block->bar_block[period].c_bar_type;


    b = p_bar1->ca_btime;
    memcpy(b_h,b,2);
    memcpy(b_m,b+3,2);
    memcpy(b_s,b+6,2);
    bh = atoi(b_h);
    bm = atoi(b_m);
    bs = atoi(b_s);
    f = tick->UpdateTime;
    memcpy(f_h,f,2);
    memcpy(f_m,f+3,2);
    memcpy(f_s,f+6,2);
    fh = atoi(f_h);
    fm = atoi(f_m);
    fs = atoi(f_s);

    /*
    switch( c_bar_type ) {
        case  BAR_SECOND :
            fs = fs - ( fs%i_bar_type );
            i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_MINUTE :
            if ( i_bar_type == 15 ) {
                if( memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_start,8) ==0 ||
                    memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_end,8) ==0 ) {
                    i_rtn = 0;
                } else {
                    i_rtn = 1;
                }
            } else if ( i_bar_type == 30 ) {
                if( memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_start,8) ==0 ||
                    memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_end,8) ==0 ) {
                    i_rtn = 0;
                } else {
                    i_rtn = 1;
                }
            } else {
                fm = fm - ( fm%i_bar_type );
                i_rtn = (fh-bh)*60+fm-bm;
            }
            break;
        case  BAR_HOUR :
        case  BAR_DAY :
        case  BAR_WEEK :
        case  BAR_MONTH :
        case  BAR_SEASON :
        case  BAR_YEAR :
            break;
    }
    */

    switch(period) {
    case  BAR_TICK :
        break;
    case  BAR_1S :
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_2S :
        fs = fs - fs%2;
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_3S :
        fs = fs - fs%3;
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_5S :
        fs = fs - fs%5;
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_10S :
        fs = fs - fs%10;
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_15S :
        fs = fs - fs%15;
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_20S :
        fs = fs - fs%20;
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_30S :
        fs = fs - fs%30;
        i_rtn = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_1F :
        i_rtn = (fh-bh)*60+fm-bm;
        break;
    case  BAR_2F :
        fm = fm - fm%2;
        i_rtn = (fh-bh)*60+fm-bm;
        break;
    case  BAR_3F :
        fm = fm - fm%3;
        i_rtn = (fh-bh)*60+fm-bm;
        break;
    case  BAR_5F :
        fm = fm - fm%5;
        i_rtn = (fh-bh)*60+fm-bm;
        break;
    case  BAR_10F :
        fm = fm - fm%10;
        i_rtn = (fh-bh)*60+fm-bm;
        break;
    case  BAR_15F :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_20F :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_20F_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_20F_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_30F :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_1H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1H_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_2H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_2H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_2H_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_3H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_3H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_3H_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_4H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_4H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_4H_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_5H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_5H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_5H_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_1D :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1D_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1D_end,8) ==0) {
            i_rtn = 0;
        } else {
            i_rtn = 1;
        }
        break;
    case  BAR_1W :
        break;
    case  BAR_1M :
        break;
    case  BAR_1J :
        break;
    case  BAR_1Y :
        break;
    default :
        break;
    }
    if(i_rtn ==0) {
        p_block->bar_block[period].c_save = 'n';
    } else {
        p_block->bar_block[period].c_save = 's';
    }
    return i_rtn;
}

int see_save_bar(see_fut_block_t *p_block, char *buf, int period)
{
    see_bar_t       *p_bar0;
    char            ca_year[5] = "\0\0\0";
    char            ca_month[7] = "\0\0\0";
    char            ca_filename[512];
    char            ca_tickname[512];
    char            ca_msg[1024];
    struct CThostFtdcDepthMarketDataField * tick;


    memset(ca_msg,'\0',1024);
    memset(ca_filename,'\0',512);

    if(period == BAR_TICK) {
        tick = (struct CThostFtdcDepthMarketDataField *)buf;
        memset(ca_filename,'\0',512);
        sprintf(ca_filename,"%s/tick/%s-%s-tick",   p_block->ca_home,
                tick->InstrumentID,
                tick->TradingDay);
        memset(ca_tickname,'\0',512);
        sprintf(ca_tickname,"%s/tick/%s-%s-bin",    p_block->ca_home,
                tick->InstrumentID,
                tick->TradingDay);
        double dd;
        int    ii;
        char ca_Volume[100];
        char ca_PreClosePrice[100];
        char ca_OpenPrice[100];
        char ca_HighestPrice[100];
        char ca_LowestPrice[100];
        char ca_ClosePrice[100];
        char ca_AveragePrice[100];
        char ca_LastPrice[100];
        char ca_BidPrice1[100];
        char ca_BidVolume1[100];
        char ca_AskPrice1[100];
        char ca_AskVolume1[100];
        char ca_UpdateMillisec[100];

        char ca_errtmp[1024];

        ii = tick->Volume;
        if(ii < 10000000 && ii > -10000000) {
            memset(ca_Volume,'\0',100);
            sprintf(ca_Volume,"%d",ii);
        } else {
            sprintf(ca_Volume,"%s",(char *)"NULL");
        }

        dd = tick->PreClosePrice;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_PreClosePrice,'\0',100);
            sprintf(ca_PreClosePrice,"%10.2f",dd);
        } else {
            sprintf(ca_PreClosePrice,"%s",(char *)"NULL");
        }

        dd = tick->OpenPrice;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_OpenPrice,'\0',100);
            sprintf(ca_OpenPrice,"%10.2f",dd);
        } else {
            sprintf(ca_OpenPrice,"%s",(char *)"NULL");
        }

        dd = tick->HighestPrice;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_HighestPrice,'\0',100);
            sprintf(ca_HighestPrice,"%10.2f",dd);
        } else {
            sprintf(ca_HighestPrice,"%s",(char *)"NULL");
        }

        dd = tick->LowestPrice;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_LowestPrice,'\0',100);
            sprintf(ca_LowestPrice,"%10.2f",dd);
        } else {
            sprintf(ca_LowestPrice,"%s",(char *)"NULL");
        }

        dd = tick->ClosePrice;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_ClosePrice,'\0',100);
            sprintf(ca_ClosePrice,"%10.2f",dd);
        } else {
            sprintf(ca_ClosePrice,"%s",(char *)"NULL");
        }

        dd = tick->AveragePrice;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_AveragePrice,'\0',100);
            sprintf(ca_AveragePrice,"%10.2f",dd);
        } else {
            sprintf(ca_AveragePrice,"%s",(char *)"NULL");
        }

        dd = tick->LastPrice;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_LastPrice,'\0',100);
            sprintf(ca_LastPrice,"%10.2f",dd);
        } else {
            sprintf(ca_LastPrice,"%s",(char *)"NULL");
        }

        dd = tick->BidPrice1;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_BidPrice1,'\0',100);
            sprintf(ca_BidPrice1,"%10.2f",dd);
        } else {
            sprintf(ca_BidPrice1,"%s",(char *)"NULL");
        }

        ii = tick->BidVolume1;
        if(ii < 10000000 && ii > -10000000) {
            memset(ca_BidVolume1,'\0',100);
            sprintf(ca_BidVolume1,"%d",ii);
        } else {
            sprintf(ca_BidVolume1,"%s",(char *)"NULL");
        }

        dd = tick->AskPrice1;
        if(dd < 10000000000 && dd > -10000000000) {
            memset(ca_AskPrice1,'\0',100);
            sprintf(ca_AskPrice1,"%10.2f",dd);
        } else {
            sprintf(ca_AskPrice1,"%s",(char *)"NULL");
        }

        ii = tick->AskVolume1;
        if(ii < 10000000 && ii > -10000000) {
            memset(ca_AskVolume1,'\0',100);
            sprintf(ca_AskVolume1,"%d",ii);
        } else {
            sprintf(ca_AskVolume1,"%s",(char *)"NULL");
        }



        ii = tick->UpdateMillisec;
        if(ii < 10000000 && ii > -10000000) {
            memset(ca_UpdateMillisec,'\0',100);
            sprintf(ca_UpdateMillisec,"%d",ii);
        } else {
            sprintf(ca_UpdateMillisec,"%s",(char *)"NULL");
        }

        memset(ca_errtmp,'\0',1024);
        sprintf(ca_errtmp,"%s %s %s %s %s ",tick->InstrumentID,
                tick->TradingDay,
                tick->ActionDay,
                tick->UpdateTime,
                ca_UpdateMillisec);

        sprintf(ca_msg,"%s H:%s L:%s LastP:%s B1:%s BV1:%s A1:%s AV1:%s V:%s\n",
                ca_errtmp,
                ca_HighestPrice,ca_LowestPrice,ca_LastPrice,
                ca_BidPrice1,ca_BidVolume1,ca_AskPrice1,ca_AskVolume1,
                ca_Volume);
        see_save_line(ca_filename,ca_msg);
        see_save_bin(ca_tickname,(char *)buf,sizeof(struct CThostFtdcDepthMarketDataField));
        return 0;
    } /* tick data saving */

    p_bar0 =  &p_block->bar_block[period].bar0;
    memcpy(ca_year,p_bar0->TradingDay,4);
    memcpy(ca_month,p_bar0->TradingDay,6);

    if(p_block->bar_block[period].c_save == 's') {
        memset(ca_filename,'\0',512);
        if(period <=7) {
            sprintf(ca_filename,"%s/%s-%s-%d%c",    p_block->bar_block[period].ca_home,
                    p_block->InstrumentID,
                    p_block->bar_block[period].bar0.TradingDay,
                    p_block->bar_block[period].i_bar_type,
                    p_block->bar_block[period].c_bar_type);
        } else if(period <=15) {
            sprintf(ca_filename,"%s/%s-%s-%d%c",    p_block->bar_block[period].ca_home,
                    p_block->InstrumentID,
                    ca_month,
                    p_block->bar_block[period].i_bar_type,
                    p_block->bar_block[period].c_bar_type);
        } else {
            sprintf(ca_filename,"%s/%s-%s-%d%c",    p_block->bar_block[period].ca_home,
                    p_block->InstrumentID,
                    ca_year,
                    p_block->bar_block[period].i_bar_type,
                    p_block->bar_block[period].c_bar_type);
        }
        sprintf(ca_msg,"%s %s %s %s %10.2f %10.2f %10.2f %10.2f %d",
                p_block->InstrumentID,
                p_block->bar_block[period].bar0.TradingDay,
                p_block->bar_block[period].bar0.ActionDay,
                p_bar0->ca_btime,p_bar0->o,p_bar0->h,p_bar0->l,p_bar0->c,p_bar0->v);

        see_save_line(ca_filename,ca_msg);

        char ca_sss[1024];
        memset(ca_sss,'\0',1024);
        /*
        sprintf(ca_sss,"{\"topic\":\"%s\",\"data\":\"%s\"}",p_block->InstrumentID,
                ca_msg);
        */
        sprintf(ca_sss,"{\"topic\":\"%s:%d%c\",\"data\":\"%s\"}",p_block->InstrumentID,
                p_block->bar_block[period].i_bar_type,
                p_block->bar_block[period].c_bar_type,ca_msg);
        see_send_bar(p_block,ca_sss);
    }
    return 0;
}
/*
 see_send_bar() 向web python 传送bar的信息。
*/
int see_send_bar(see_fut_block_t *p_block,char *pc_msg)
{
    int i_size;
    int i_rtn;
    i_size = strlen(pc_msg);
    if(i_size <=0) {
        return -1;
    }
    i_rtn = see_zmq_pub_send(p_block->v_sock,pc_msg);
    if(i_rtn != i_size) {
        see_errlog(1000,"see_send_bar: send error !!",RPT_TO_LOG,0,0);
    }
    //usleep(50000);
    //usleep(1000);
    return 0;
}

/*
 *  if c_save == 's' , send bar1->o h l c v,  to hh[] oo[] ll[] cc[] vv[]  marked : this is a new K !!
 *  if c_save == 'n' , send bar1->o h l c v,  to hh[] oo[] ll[] cc[] vv[]  marked : this is a updating K !!
 *  send to another process for KDJ? for strategy ?  or calculate KDJ locally ?
*/


int see_save_bar_last(see_fut_block_t *p_block, int period, int i_another_day)
{
    see_bar_t       *p_bar0;
    see_bar_t       *p_bar1;
    char            ca_year[5] = "\0\0\0";
    char            ca_month[7] = "\0\0\0";
    char            ca_filename[512];
    char            ca_msg[1024];

    if(period == BAR_TICK) {
        return 0;
    }

    p_bar0 =  &p_block->bar_block[period].bar0;
    p_bar1 =  &p_block->bar_block[period].bar1;

    memcpy((char *)p_bar0,p_bar1,sizeof(see_bar_t));
    /*
    if( see_first_tick(p_block,buf,p_bar0,p_bar1,period) == 0 ) {  // 新K柱，tick->UpdateTime的值可能不是 起始的时间
        p_bar0->v    = tick->Volume - p_bar0->vsum;
        p_bar0->vsum = tick->Volume;
    }else{
        p_bar1->v    = tick->Volume - p_bar0->vsum;
    }
    */

    memset(ca_msg,'\0',1024);
    memset(ca_filename,'\0',512);


    p_bar0 =  &p_block->bar_block[period].bar0;
    memcpy(ca_year,p_bar0->TradingDay,4);
    memcpy(ca_month,p_bar0->TradingDay,6);

    memset(ca_filename,'\0',512);
    if(period <=7) {
        sprintf(ca_filename,"%s/%d%c/%s-%s-%d%c",    p_block->ca_home,
                p_block->bar_block[period].i_bar_type,
                p_block->bar_block[period].c_bar_type,
                p_block->InstrumentID,
                p_block->bar_block[period].bar0.TradingDay,
                p_block->bar_block[period].i_bar_type,
                p_block->bar_block[period].c_bar_type);
    } else if(period <=15) {
        sprintf(ca_filename,"%s/%d%c/%s-%s-%d%c",    p_block->ca_home,
                p_block->bar_block[period].i_bar_type,
                p_block->bar_block[period].c_bar_type,
                p_block->InstrumentID,
                ca_month,
                p_block->bar_block[period].i_bar_type,
                p_block->bar_block[period].c_bar_type);
    } else {
        sprintf(ca_filename,"%s/%d%c/%s-%s-%d%c",    p_block->ca_home,
                p_block->bar_block[period].i_bar_type,
                p_block->bar_block[period].c_bar_type,
                p_block->InstrumentID,
                ca_year,
                p_block->bar_block[period].i_bar_type,
                p_block->bar_block[period].c_bar_type);
    }
    sprintf(ca_msg,"%s %s %s %s %10.2f %10.2f %10.2f %10.2f %d\n",
            p_block->InstrumentID,
            p_block->bar_block[period].bar0.TradingDay,
            p_block->bar_block[period].bar0.ActionDay,
            p_bar0->ca_btime,p_bar0->o,p_bar0->h,p_bar0->l,p_bar0->c,p_bar0->v);
    //see_errlog(1000,ca_filename,RPT_TO_LOG,0,0 );
    see_save_line(ca_filename,ca_msg);
    if(i_another_day==1) {
        p_bar0->o = SEE_NULL;
    }
    return 0;
}

void *see_pthread_dat(void *data)
{
    volatile int            i,j,k;
    int                     i_num;
    char                    ca_files[200][512];
    char                    ca_state[512];
    char                    ca_filename[512];
    see_config_t           *p_conf;
    struct timespec         outtime;
    time_t                  now;
    struct tm              *timenow;
    p_conf = (see_config_t *)data;

    int t =0;
    int t0 =0;
    int t1 = 3600* 2 + 60*32;
    int t2 = 3600*10 + 60*17;
    int t3 = 3600*11 + 60*32;
    int t4 = 3600*15 + 60* 2;
    int t5 = 3600*24 + 60* 0;

    while(1) {
        pthread_mutex_lock(&p_conf->mutex_bar);

        memset(&outtime, 0, sizeof(outtime));
        clock_gettime(CLOCK_REALTIME, &outtime);

        printf("--------------------------%d,%d\n",(int)outtime.tv_sec,(int)outtime.tv_nsec);

        time(&now);
        timenow = localtime(&now);

        t = timenow->tm_hour*3600 + timenow->tm_min*60 + timenow->tm_sec;

        printf("-----------------%d,%d,%d,--------t:%d\n",timenow->tm_hour,timenow->tm_min,timenow->tm_sec,t);

        if(t<t1) {
            t0 = t1-t;
        }
        if(t1<=t && t<t2) {
            t0 = t2-t;
        }
        if(t2<=t && t<t3) {
            t0 = t3-t;
        }
        if(t3<=t && t<t4) {
            t0 = t4-t;
        }
        if(t4<=t && t<t5) {
            t0 = t5-t+t1;
        }

        outtime.tv_sec+=t0;
        outtime.tv_nsec=0;
        printf("--------------------------%d,%d\n",(int)outtime.tv_sec,(int)outtime.tv_nsec);
        see_errlog(1000,(char *)"enter into see_pthread_dat() sleeping !!!!!",RPT_TO_LOG,0,0);
        pthread_cond_timedwait(&p_conf->cond_bar, &p_conf->mutex_bar, &outtime);
        see_errlog(1000,(char *)"enter into see_pthread_dat() working !!!!!",RPT_TO_LOG,0,0);
        see_zdb_open(p_conf);

        /*
        volatile see_node *node;
        for ( i=0;i<p_conf->i_future_num;i++ ){
            memset(ca_state,'\0',512);
            memset(ca_filename,'\0',512);
            node = p_conf->pt_stt_blks[i]->list;
            while( node != NULL ){
                // p_conf->pt_fut_blks[i].bar_block[node->period].ca_table;
                printf(p_conf->pt_fut_blks[i]->bar_block[node->period].ca_table);
                printf("\n");
                //memcpy(ca_filename,"%s/%s",p_conf->pt_fut_blks[i].bar_block[node->period].ca_home

                see_trave_dir(p_conf->pt_fut_blks[i]->bar_block[node->period].ca_home,&i_num, ca_files);
                see_zdb_create_table( p_conf, p_conf->pt_fut_blks[i]->bar_block[node->period].ca_table );
                for( j=0;j<i_num;j++ ){
                    see_zdb_insert_file( p_conf, ca_files[j], p_conf->pt_fut_blks[i]->bar_block[node->period].ca_table );
                }
                node = node->next;
            }
        }
        */

        for(i=0; i<p_conf->i_future_num; i++) {
            memset(ca_state,'\0',512);
            memset(ca_filename,'\0',512);
            int len2 = strlen(p_conf->pt_fut_blks[i]->InstrumentID);
            for(j=0; j<31; j++) {
                //printf( p_conf->pt_fut_blks[i]->bar_block[j].ca_home );
                //printf( "\n\n\n");
                int len1 = strlen(p_conf->pt_fut_blks[i]->bar_block[j].ca_home);
                see_trave_dir(p_conf->pt_fut_blks[i]->bar_block[j].ca_home,&i_num, ca_files);
                see_zdb_create_table(p_conf, p_conf->pt_fut_blks[i]->bar_block[j].ca_table);
                /*
                for( k=0;k<i_num;k++ ){
                    printf( ca_files[k] );
                    printf( "----------\n");
                }*/
                int nn = 0;
                for(k=0; k<i_num; k++) {
                    /*
                    printf( ca_files[k] );
                    printf( "\n");
                    printf( &ca_files[k][len1+1] );
                    printf( "\n");
                    */
                    if(memcmp((char*)&ca_files[k][len1+1], (char*)(p_conf->pt_fut_blks[i]->InstrumentID), len2)==0) {
                        see_zdb_insert_file(p_conf, ca_files[k], p_conf->pt_fut_blks[i]->bar_block[j].ca_table);
                        nn++;
                    }
                    if(nn >=2) {
                        break;
                    }
                }
            }
        }

        see_zdb_close(p_conf);
        pthread_mutex_unlock(&p_conf->mutex_bar);
    }


    return NULL;
}
void *see_pthread_bar(void *data)
{
    see_config_t           *p_conf;
    struct timespec         outtime;
    time_t                  now;
    struct tm              *timenow;

    p_conf = (see_config_t *)data;

    while(1) {
        pthread_mutex_lock(&p_conf->mutex_bar);

        memset(&outtime, 0, sizeof(outtime));
        clock_gettime(CLOCK_REALTIME, &outtime);

        time(&now);
        timenow = localtime(&now);
        printf("recent time is tm_sec : %d \n", timenow->tm_sec);
        printf("recent time is tm_min : %d \n", timenow->tm_min);
        printf("recent time is tm_hour : %d \n", timenow->tm_hour);

        int b1,b2,b3,b4,b5,b6,b7;
        int e1,e2,e3,e4,e5,e6,e7;
        int t;

        t = timenow->tm_hour*3600 + timenow->tm_min*60 + timenow->tm_sec;

        b1 = 2*3600 + 30*60;
        e1 = 10*3600 + 15*60;

        b2 = 10*3600 + 15*60;
        e2 = 11*3600 + 30*60;

        b3 = 11*3600 + 30*60;
        e3 = 15*3600 + 0*60;

        b4 = 15*3600 + 0*60;
        e4 = 23*3600 + 0*60;

        b5 = 23*3600 + 0*60;
        e5 = 23*3600 + 30*60;

        b6 = 23*3600 + 30*60; // 24*3600
        e6 = 1*3600 + 0*60;   // 0*3600 ----> 1*3600 !

        b7 = 1*3600 + 0*60;
        e7 = 2*3600 + 30*60;


        if(b1<t && t<e1) {
            outtime.tv_sec = e1;
        }

        if(b2<t && t<e2) {
            outtime.tv_sec = e1;
        }

        if(b3<t && t<e3) {
            outtime.tv_sec = e1;
        }

        if(b4<t && t<e4) {
            outtime.tv_sec = e1;
        }

        if(b4<t && t<e4) {
            outtime.tv_sec = e1;
        }

        if(b5<t && t<e5) {
            outtime.tv_sec = e1;
        }

        if(b6<t && t<e6) {
            outtime.tv_sec = e1;
        }

        if(b7<t && t<e7) {
            outtime.tv_sec = e1;
        }

        pthread_cond_timedwait(&p_conf->cond_bar, &p_conf->mutex_bar, &outtime);



        pthread_mutex_unlock(&p_conf->mutex_bar);
    }
    return NULL;
}
