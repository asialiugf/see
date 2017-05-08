#include <see_com_common.h>

extern  double hh[10000];
extern  double ll[10000];
extern  double cc[10000];
extern  double oo[10000];

/*
 *  periods defined
 *  pp[31] 数组 定义每个period的秒数，比如 3F 是 180秒
 */

/*                         0  1 2 3 4  5  6  7  8  9   10  11  12  13  14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30   */
/*                         1S 2 3 5 10 15 20 30 1F 2F  3F  5F  10F 15F 20 30 1H 2H 3H 4H 5H 6H 8H 10 12 1D 1W 1M 1J 1Y TICK */
static const int pp[31] = {1, 2,3,5,10,15,20,30,60,120,180,300,600,900,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

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

    int rc;
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
    rc = strcmp(ca_first,ca_last);
    return rc;
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

/*
* i_sgm_idx：用于回传，返回当前的tick是在哪个交易时间段内
* 收到一个tick，就需要调用一次is_mkt_open，更新 block里的 i_sgm_idx c_oc_flag
*/
int is_mkt_open(see_fut_block_t *p_block, struct CThostFtdcDepthMarketDataField *tick)
{
    int j = 0;
    int b;
    int e;

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
see_handle_bars(see_fut_block_t *p_block, struct CThostFtdcDepthMarketDataField *tick)
{
    int     rc;
    int     period;

    rc = is_mkt_open(p_block,tick);      // 修改 block->c_oc_flag 以及 block->i_sgm_i_idx
    if(rc == SEE_MKT_CLOSE) {
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

    if(gp_conf->i_save_tick_only != 1) {
        for(period=0; period<=30; period++) {
            see_calc_bar_block(p_block, tick, period);                   // 计算K柱 .
            see_save_bar(p_block, tick, period);                         // 保存文件.
        }
    } else {
        see_save_bar(p_block, tick, BAR_TICK);
    }
    /*
    if(gp_conf->send_on) {
        see_send_to_sttrun();
    }
    if(gp_conf->stt_on) {
        see_sttrun() ;
    }
    */
    return 0;
}

/*
rtn = 0; 表示为 第0秒的第0个tick,所以，这个tick的volume应该算到前一个K柱里
rtn = 1; 表示为 已经不是第0秒的第0个tick，所以这个tick的volume应该算到当前的K柱里
*/
int
see_first_tick(see_fut_block_t                                  *p_block,
               struct CThostFtdcDepthMarketDataField            *tick,
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
    /*
        case  BAR_1S :
            NEW_BAR1;
            if(tick->UpdateMillisec == 0) {
                rtn = 0;
            } else {
                rtn = 1;
            }
            break;
    */
    case  BAR_1S :
    case  BAR_2S :
    case  BAR_3S :
    case  BAR_5S :
    case  BAR_10S :
    case  BAR_15S :
    case  BAR_20S :
    case  BAR_30S :
        NEW_BAR1;
        mo = fs%(pp[period]);
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
    /*
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
    */
    /*
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
    */

    case  BAR_1F :
    case  BAR_2F :
    case  BAR_3F :
    case  BAR_5F :
    case  BAR_10F :
        NEW_BAR1;
        mo = fm%(pp[period]/60);
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
    /*
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
    */

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
see_calc_bar_block(see_fut_block_t                                  *p_block,
                   struct CThostFtdcDepthMarketDataField            *tick,
                   int                                               period)
{
    int             i_kbar_num;
    see_bar_t       *p_bar0;
    see_bar_t       *p_bar1;

    if(period == BAR_TICK) {
        return 0;
    }

    p_bar0 =  &p_block->bar_block[period].bar0;
    p_bar1 =  &p_block->bar_block[period].bar1;

    if(p_block->c_oc_flag == 'o') {    // 在交易时间段内
        if(p_bar1->o == SEE_NULL) {    // 程序开启后的第一个tick
            see_first_tick(p_block,tick,p_bar0,p_bar1,period);
            memcpy((char *)p_bar0,p_bar1,sizeof(see_bar_t));
            return 0;
        }

        /*
            在 is_same_k_bar() 中， 会对 c_save 进行赋值，'s'表示tick已经不是同一个K柱了，要save。
            'n'表示 当前收到的tick仍然是同一个K柱。
            i_kbar_num 是is_same_k_bar()的返回值 ，==0 表示 是同一个K柱。
            i_kbar_num == 2,表是前面要存在两个K柱要 save，一般情况 i_kbar_num应该是1，如果比1大，
            表示，中间隔了比较久没有收到tick了。
        */
        i_kbar_num = is_same_k_bar(p_block,p_bar1,tick,period);
        if(i_kbar_num == 0) {   //同一个K
            UPDATE_BAR1;
        } else { // 下一个K
            /*
                例如：
                假设现在正在计算的是5F的K柱
                假如第N个K柱，收到 tick的时间是 09:29:59 000,这个tick要计算到第N个K柱中。这时不能确定
                第N个K柱是否结束。
                当新一个tick来到，时间恰好是09:31:02 500, 也就是说中间有好几秒没有tick，这种情况下，
                可以确定第N个K柱结束。于是，将p_bar1的内容copy到 p_bar0，即p_bar0是第N个K柱的结束状态。

            */
            memcpy((char *)p_bar0,p_bar1,sizeof(see_bar_t));
            if(see_first_tick(p_block,tick,p_bar0,p_bar1,period) == 0) {    // 新K柱，tick->UpdateTime的值可能不是 起始的时间
                p_bar0->v    = tick->Volume - p_bar0->vsum;
                p_bar0->vsum = tick->Volume;
            } else {
                p_bar1->v    = tick->Volume - p_bar0->vsum;
            }   // 根据 see_first_tick 返回 tick的 UpdateMillisec 是 0 还是 500，来处理 Volume

        }
    }
    return 0;
}

int is_same_k_bar(see_fut_block_t     * p_block,
                  see_bar_t       * p_bar1,
                  struct CThostFtdcDepthMarketDataField            *tick,
                  int             period)
{
    int  rc = 0;
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

    switch(period) {
    case  BAR_TICK :
        break;
    case  BAR_1S :
    case  BAR_2S :
    case  BAR_3S :
    case  BAR_5S :
    case  BAR_10S :
    case  BAR_20S :
    case  BAR_15S :
    case  BAR_30S :
        fs = fs - fs%(pp[period]);
        rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
        break;
    case  BAR_1F :
    case  BAR_2F :
    case  BAR_3F :
    case  BAR_5F :
    case  BAR_10F :
        fm = fm - fm%(pp[period]/60);
        rc = (fh-bh)*60+fm-bm;
        break;
    /*
        case  BAR_1S :
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_2S :
            fs = fs - fs%(pp[period]);
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_3S :
            fs = fs - fs%3;
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_5S :
            fs = fs - fs%5;
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_10S :
            fs = fs - fs%10;
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_15S :
            fs = fs - fs%15;
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_20S :
            fs = fs - fs%20;
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
        case  BAR_30S :
            fs = fs - fs%30;
            rc = (fh-bh)*3600+(fm-bm)*60+fs-bs;
            break;
    */
    /*
        case  BAR_1F :
            rc = (fh-bh)*60+fm-bm;
            break;
        case  BAR_2F :
            fm = fm - fm%2;
            rc = (fh-bh)*60+fm-bm;
            break;
        case  BAR_3F :
            fm = fm - fm%3;
            rc = (fh-bh)*60+fm-bm;
            break;
        case  BAR_5F :
            fm = fm - fm%5;
            rc = (fh-bh)*60+fm-bm;
            break;
        case  BAR_10F :
            fm = fm - fm%10;
            rc = (fh-bh)*60+fm-bm;
            break;
    */
    case  BAR_15F :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_15F_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_20F :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_20F_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_20F_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_30F :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_30F_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_1H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1H_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_2H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_2H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_2H_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_3H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_3H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_3H_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_4H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_4H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_4H_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_5H :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_5H_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_5H_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
        }
        break;
    case  BAR_1D :
        if(memcmp(p_bar1->ca_btime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1D_start,8) ==0 ||
           memcmp(p_bar1->ca_etime,p_block->pt_hour->pt_segments[i_sgm_idx]->ca_1D_end,8) ==0) {
            rc = 0;
        } else {
            rc = 1;
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
    if(rc ==0) {
        p_block->bar_block[period].c_save = 'n';
    } else {
        p_block->bar_block[period].c_save = 's';
    }
    return rc;
}

int see_save_bar(see_fut_block_t *p_block,
                 struct CThostFtdcDepthMarketDataField *tick, int period)
{
    see_bar_t       *p_bar0;
    see_tick_t      new_tick;
    char            ca_year[5] = "\0\0\0";
    char            ca_month[7] = "\0\0\0";
    char            ca_filename[512];
    char            ca_tickname[512];
    char            ca_msg[1024];

    memset(ca_msg,'\0',1024);
    memset(ca_filename,'\0',512);

    if(period == BAR_TICK) {
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


        /*
         * 记录收到tick的时间
        */
        see_memzero(&new_tick,sizeof(see_tick_t));
        memcpy(&new_tick,tick,sizeof(struct CThostFtdcDepthMarketDataField));
        struct timeval tv;
        gettimeofday(&tv,NULL);
        new_tick.rcv_msec = tv.tv_usec/1000 ;
        struct tm *t;
        time_t tt;
        time(&tt);
        t=localtime(&tt);
        sprintf(new_tick.rcv_date,"%4d%02d%02d",t->tm_year+1900,t->tm_mon+1,t->tm_mday);
        sprintf(new_tick.rcv_time,"%02d:%02d:%02d",t->tm_hour,t->tm_min,t->tm_sec);
        new_tick.rcv_week = t->tm_wday;


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
        sprintf(ca_errtmp,"%s %s %s %s %s - %s %s %d %d -",tick->InstrumentID,
                tick->TradingDay,
                tick->ActionDay,
                tick->UpdateTime,
                ca_UpdateMillisec,
                new_tick.rcv_date,
                new_tick.rcv_time,
                new_tick.rcv_msec,
                new_tick.rcv_week);

        sprintf(ca_msg,"%s H:%s L:%s LastP:%s B1:%s BV1:%s A1:%s AV1:%s V:%s\n",
                ca_errtmp,
                ca_HighestPrice,ca_LowestPrice,ca_LastPrice,
                ca_BidPrice1,ca_BidVolume1,ca_AskPrice1,ca_AskVolume1,
                ca_Volume);
        see_save_line(ca_filename,ca_msg);

        see_save_bin(ca_tickname,(char *)&new_tick,sizeof(see_tick_t));
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
        sprintf(ca_msg,"%s %s %s %s %10.2f %10.2f %10.2f %10.2f %d\n",
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

/*
    参数：see_fut_block_t *p_block
    输入特定的 future block。

    功能：
    把 p_block中的不同的period的 K柱的信息，传递到前端。
*/
/*
int see_send_bar1(see_fut_block_t *p_block)
{
    int i ;
    // 创建JSON Object
    cJSON *root = cJSON_CreateObject();
    // 加入节点（键值对），节点名称为value，节点值为123.4
    cJSON_AddNumberToObject(root,"value",123.4);
    // 打印JSON数据包
    char *out = cJSON_Print(root);
    printf("%s\n",out);
    // 释放内存
    cJSON_Delete(root);
    free(out);
    return 0;

    cJSON * root =  cJSON_CreateObject();
    cJSON * item =  cJSON_CreateObject();
    cJSON * next =  cJSON_CreateObject();

    cJSON_AddItemToObject(root, "topic", cJSON_CreateNumber(0));//根节点下添加
    cJSON_AddItemToObject(root, "operation", cJSON_CreateString("CALL"));
    cJSON_AddItemToObject(root, "service", cJSON_CreateString("telephone"));
    cJSON_AddItemToObject(root, "text", cJSON_CreateString("打电话给张三"));
    cJSON_AddItemToObject(root, "semantic", item);//root节点下添加semantic节点
    cJSON_AddItemToObject(item, "slots", next);//semantic节点下添加item节点
    cJSON_AddItemToObject(next, "name", cJSON_CreateString("张三"));//添加name节点

    printf("%s\n", cJSON_Print(root));

    for(i=0; i<=BAR_TICK; i++) {

    }
}
*/

int see_send_bar(see_fut_block_t *p_block,char *pc_msg)
{
    int i_size;
    int rc;
    i_size = strlen(pc_msg);
    if(i_size <=0) {
        return -1;
    }
    rc = see_zmq_pub_send(gp_conf->pub_ctxsock.sock,pc_msg);
    if(rc != i_size) {
        see_errlog(1000,"see_send_bar: send error !!",RPT_TO_LOG,0,0);
    }
    usleep(50000);
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


/*
 * 定时，将K线数据 从文件 写入到数据库里
 */
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
    int t1 = 3600* 2 + 60*32;  /* 2:32分 */
    int t2 = 3600*10 + 60*17;  /* 10:17分 */
    int t3 = 3600*11 + 60*32;  /* 11:32分 */
    int t4 = 3600*15 + 60* 2;  /* 15:02分 */
    int t5 = 3600*24 + 60* 0;  /* 24:00分 */

    while(1) {
        pthread_mutex_lock(&p_conf->mutex_bar);

        memset(&outtime, 0, sizeof(outtime));
        clock_gettime(CLOCK_REALTIME, &outtime);


        /* t 取得开启程序时的当前时间 */
        time(&now);
        timenow = localtime(&now);
        t = timenow->tm_hour*3600 + timenow->tm_min*60 + timenow->tm_sec;


        /* 设定定时执行线程的时间点 */
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
        /*
            如果下午3点(t4)以后开机，则要在2:32 进行数据库存储
        */
        if(t4<=t && t<t5) {
            t0 = t5-t+t1;
        }

        outtime.tv_sec+=t0;
        outtime.tv_nsec=0;
        printf("--------------------------%d,%d\n",(int)outtime.tv_sec,(int)outtime.tv_nsec);
        see_errlog(1000,(char *)"enter into see_pthread_dat() sleeping !!!!!",RPT_TO_LOG,0,0);

        /* pthread_cond_timedwait() 这个函数执行等待时，程序会打开锁
           一旦时间到，被唤醒，进入它下面的程序段，就会锁住，直到最后，
           调用  pthread_mutex_unlock() 解锁。
        */
        pthread_cond_timedwait(&p_conf->cond_bar, &p_conf->mutex_bar, &outtime);

        see_zdb_open(p_conf);

        for(i=0; i<p_conf->i_future_num; i++) {
            memset(ca_state,'\0',512);
            memset(ca_filename,'\0',512);
            int len2 = strlen(p_conf->pt_fut_blks[i]->InstrumentID);
            for(j=0; j<31; j++) {
                printf(p_conf->pt_fut_blks[i]->bar_block[j].ca_home);
                printf("\n\n\n");
                int len1 = strlen(p_conf->pt_fut_blks[i]->bar_block[j].ca_home);
                see_trave_dir(p_conf->pt_fut_blks[i]->bar_block[j].ca_home,&i_num, ca_files);
                see_zdb_create_table(p_conf, p_conf->pt_fut_blks[i]->bar_block[j].ca_table);

                for(k=0; k<i_num; k++) {
                    printf(ca_files[k]);
                    printf("----------\n");
                }
                int nn = 0;
                for(k=0; k<i_num; k++) {

                    printf(ca_files[k]);
                    printf("\n");
                    printf(&ca_files[k][len1+1]);
                    printf("\n");

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
