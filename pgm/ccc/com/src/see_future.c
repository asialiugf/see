/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
 */

#include <see_com_common.h>
static char FUTURE_TABLE[512]= {"../../etc/tbl/see_future_table"} ;
static char FUTURE_TIME[512]= {"../../etc/tbl/see_future_time"} ;
static char TRADE_TIME[512]=  {"../../etc/tbl/see_trade_time"} ;
static char FUTURE_DAYS[512]= {"../../etc/tbl/see_future_days"} ;
// static char kkk[SEE_SGM_NUM][20] ;

int
see_futures_init(PC_FUTURES ppfuture_add,CA_FUTURES ppfuture_id)
{
    int i = 0 ;
    int len =0 ;
    char ca_file[512] ;
    char ca_line[1024] ;
    FILE *pf ;

    memset(ca_file,'\0',512);
    strcat(ca_file,FUTURE_TABLE) ;

    pf = fopen(ca_file,"r");
    if(pf == NULL) {
        see_errlog(1000,"see_future.c see_futures_init(): open future table error!!",RPT_TO_LOG,0,0) ;
        see_errlog(1000,ca_file,RPT_TO_LOG,0,0) ;
        return -1 ;
    }

    i = 0 ;
    memset(ca_line,'\0',1024) ;
    while(fgets(ca_line,1024, pf) != NULL && i <= FUTURE_NUMBER) {
        len = strlen(ca_line)-1 ;
        //    sprintf(ca_tmp,"kkkkkkkkkkkkkkkkk%s,:%d\n",ca_line,len) ;
        //    see_errlog(1000,ca_tmp,RPT_TO_LOG,0,0) ;

        memset(ppfuture_id[i],'\0',8) ;
        if(len >=6) {
            memcpy(ppfuture_id[i],ca_line,6) ;
        } else if(len >0 && len<6) {
            memcpy(ppfuture_id[i],ca_line,len) ;
        }
        ppfuture_add[i] = ppfuture_id[i] ;
        i++ ;
        memset(ca_line,'\0',100) ;
    }
    while(i < FUTURE_NUMBER) {
        memset(ppfuture_id[i],'\0',8) ;
        // ppfuture_add[i] = ppfuture_id[i] ;
        ppfuture_add[i] = NULL ;
        i++ ;
    }

    fclose(pf);
    return 0 ;
}

int see_get_future_index(PC_FUTURES pc_futures, char * pc_future)
{
    int i = 0 ;               // 取得某个期货合约 所在数组 ppfutures的下标
    while(pc_futures[i] != NULL && i < FUTURE_NUMBER) {
        if(strcmp(pc_futures[i],pc_future) == 0) {
            return i;
        }
        i ++ ;
    }
    return -1 ;
}

int see_block_init(see_fut_block_t * p_block, char * pc_future, see_hours_t t_hours[])
{
    int             i = 0 ;
    char            ca_hours_type[3] ;
    char            ca_future[FUTRUE_ID_LEN] ;
    char            ca_line[1024] ;
    FILE            *pf_trade_time ;
    FILE            *pf_future_time ;
    FILE            *pf_future_days ;
    see_bar_block_t     bar_block ;

    //memset(bar_block.ca_table, '\0', 128) ;
    //memset(bar_block.ca_home, '\0', 512) ;
    see_memzero(bar_block.ca_table,128) ;
    see_memzero(bar_block.ca_home, 512) ;

    bar_block.bar0.o = SEE_NULL;
    bar_block.bar1.o = SEE_NULL;
    bar_block.bar0.c = SEE_NULL;
    bar_block.bar1.c = SEE_NULL;
    bar_block.bar0.h = SEE_NULL;
    bar_block.bar1.h = SEE_NULL;
    bar_block.bar0.l = SEE_NULL;
    bar_block.bar1.l = SEE_NULL;
    bar_block.bar0.v = 0 ;
    bar_block.bar1.v = 0 ;
    bar_block.c_save = 0 ;


    memcpy(p_block->InstrumentID,pc_future,FUTRUE_ID_LEN) ;
    for(i=0; i<=30; i++) {
        memcpy((char *)&p_block->bar_block[i],&bar_block,sizeof(see_bar_block_t)) ;
    }

    for(i=0; i<8; i++) {
        p_block->bar_block[i].c_bar_type  = BAR_SECOND ;
    }
    for(i=8; i<16; i++) {
        p_block->bar_block[i].c_bar_type  = BAR_MINUTE ;
    }
    for(i=16; i<25; i++) {
        p_block->bar_block[i].c_bar_type  = BAR_HOUR ;
    }
    p_block->bar_block[25].c_bar_type = BAR_DAY ;
    p_block->bar_block[26].c_bar_type = BAR_WEEK ;
    p_block->bar_block[27].c_bar_type = BAR_MONTH ;
    p_block->bar_block[28].c_bar_type = BAR_SEASON ;
    p_block->bar_block[29].c_bar_type = BAR_YEAR ;
    p_block->bar_block[30].c_bar_type = BAR_TICKC ;

    p_block->bar_block[0].i_bar_type = 1 ;
    p_block->bar_block[1].i_bar_type = 2 ;
    p_block->bar_block[2].i_bar_type = 3 ;
    p_block->bar_block[3].i_bar_type = 5 ;
    p_block->bar_block[4].i_bar_type = 10 ;
    p_block->bar_block[5].i_bar_type = 15 ;
    p_block->bar_block[6].i_bar_type = 20 ;
    p_block->bar_block[7].i_bar_type = 30 ;

    p_block->bar_block[8].i_bar_type = 1 ;
    p_block->bar_block[9].i_bar_type = 2 ;
    p_block->bar_block[10].i_bar_type = 3 ;
    p_block->bar_block[11].i_bar_type = 5 ;
    p_block->bar_block[12].i_bar_type = 10 ;
    p_block->bar_block[13].i_bar_type = 15 ;
    p_block->bar_block[14].i_bar_type = 20 ;
    p_block->bar_block[15].i_bar_type = 30 ;

    for(i=16; i<22; i++) {
        p_block->bar_block[i].i_bar_type = i-15 ;
    }
    p_block->bar_block[22].i_bar_type = 8 ;
    p_block->bar_block[23].i_bar_type = 10 ;
    p_block->bar_block[24].i_bar_type = 12 ;

    for(i=25; i<=30; i++) {
        p_block->bar_block[i].i_bar_type = 1 ;
    }

    memset(ca_future,'\0',FUTRUE_ID_LEN);
    memcpy(ca_future,pc_future,2);
    if(!((ca_future[1] <= 'z' && ca_future[1] >= 'a') || (ca_future[1] <= 'Z' && ca_future[1] >= 'A'))) {
        ca_future[1] = '\0' ;
    }

    memset(p_block->ca_home, '\0', 512) ;
    sprintf(p_block->ca_home, "%s/see/dat/rcv_dat/%s", (char *)getenv("HOME"), ca_future) ;


    sprintf(p_block->bar_block[30].ca_table,"%s_tick", pc_future);
    sprintf(p_block->bar_block[30].ca_home,"%s/tick", p_block->ca_home);

    for(i=0; i<30; i++) {
        sprintf(p_block->bar_block[i].ca_table,"%s_%d%c", pc_future,
                p_block->bar_block[i].i_bar_type,
                p_block->bar_block[i].c_bar_type);
        sprintf(p_block->bar_block[i].ca_home,"%s/%d%c", p_block->ca_home,
                p_block->bar_block[i].i_bar_type,
                p_block->bar_block[i].c_bar_type);
    }

    // see_errlog(1000,p_block->ca_home,RPT_TO_LOG,0,0 ) ;


    /*  ------  初始化 这个期货合约的 每天的交易时间段 ------ */


    /*
        struct tm * p_time ;
        time_t   rawtime ;
    */
    /*
        time ( &rawtime );
        p_time = localtime ( &rawtime );
        if(  p->tm_wday == 6 || p_time->tm_wday == 0 ) {

        }
    */

    pf_future_days = fopen(FUTURE_DAYS,"r");
    if(pf_future_days == NULL) {
        see_errlog(1000,"see_future.c see_futures_init(): open future table error!!",RPT_TO_LOG,0,0) ;
        see_errlog(1000,FUTURE_DAYS,RPT_TO_LOG,0,0) ;
        return -1 ;
    }

    pf_trade_time = fopen(TRADE_TIME,"r");
    if(pf_trade_time == NULL) {
        see_errlog(1000,"see_future.c see_futures_init(): open future table error!!",RPT_TO_LOG,0,0) ;
        see_errlog(1000,TRADE_TIME,RPT_TO_LOG,0,0) ;
        return -1 ;
    }

    pf_future_time = fopen(FUTURE_TIME,"r");
    if(pf_future_time == NULL) {
        see_errlog(1000,"see_future.c see_futures_init(): open future table error!!",RPT_TO_LOG,0,0) ;
        see_errlog(1000,FUTURE_TIME,RPT_TO_LOG,0,0) ;
        return -1 ;
    }

    memset(ca_line,'\0',1024) ;
    while(fgets(ca_line,1024, pf_future_time) != NULL) {
        see_errlog(1000,ca_line,RPT_TO_LOG,0,0) ;
        if(ca_future[0] == ca_line[0]) {
            see_errlog(1000,pc_future,RPT_TO_LOG,0,0) ;
            if(ca_future[1] == ca_line[1]) {
                i = 2 ;
                while(ca_line[i] > '9' || ca_line[i] < '0') {
                    i++;
                }
                memset(ca_hours_type,'\0',3) ;
                memcpy(ca_hours_type,ca_line+i,1) ;
                p_block->i_hour_type = atoi(ca_hours_type) ;
                p_block->pt_hour = &t_hours[p_block->i_hour_type] ;

                break ;
            } else if(!((ca_future[1] <= 'z' && ca_future[1] >= 'a') || (ca_future[1] <= 'Z' && ca_future[1] >= 'A'))) {
                if(!((ca_line[1] <= 'z' && ca_line[1] >= 'a') || (ca_line[1] <= 'Z' && ca_line[1] >= 'A'))) {
                    i = 2 ;
                    while(ca_line[i] > '9' || ca_line[i] < '0') {
                        i++;
                    }
                    memset(ca_hours_type,'\0',3) ;
                    memcpy(ca_hours_type,ca_line+i,1) ;
                    p_block->i_hour_type = atoi(ca_hours_type) ;
                    p_block->pt_hour = &t_hours[p_block->i_hour_type] ;
                    break ;
                }
            }
        }
    }

    fclose(pf_future_days);
    fclose(pf_trade_time);
    fclose(pf_future_time);
    /*  ------  初始化 这个期货合约的 每天的交易时间段 ------ */

    see_err_log(0,0,"<OUT> see_block_init!");
    return SEE_OK ;
}


int split_string(char *s,char _cmd[SEE_SGM_NUM][20])
{
    char *p = s;
    int i = 0;
    int j = 0;

    while(*p == ' ' || *p == '-') {
        p++;
    }

    while(*p != '\n' && *p != '\0') {
        if(*p == ' ' || *p == '-') {
            _cmd[i][j]='\0';
            i++;
            j = 0;
            p++;
            /*处理多个空格的情况*/
            while(*p == ' ' || *p == '-') {
                p++;
            }
        } else {
            _cmd[i][j] = *p;
            p++;
            j++;
        }
    }
    _cmd[i][j]='\0';
    return i+1;
}
int see_time_to_int(char *f)
{
    char f_h[3] = "\0\0\0" ;
    char f_m[3] = "\0\0\0" ;
    char f_s[3] = "\0\0\0" ;

    int fh,fm,fs ;

    /*
        time_t f_sec;
        struct tm f_time_fields;
    */

    memcpy(f_h,f,2);
    memcpy(f_m,f+3,2);
    memcpy(f_s,f+6,2);

    fh = atoi(f_h);
    fm = atoi(f_m);
    fs = atoi(f_s);
    /*
        f_time_fields.tm_mday = 0;
        f_time_fields.tm_mon  = 0;
        f_time_fields.tm_year = 0;
        f_time_fields.tm_hour = fh;
        f_time_fields.tm_min  = fm;
        f_time_fields.tm_sec  = fs;
        f_sec = mktime(&f_time_fields);
    */
    return fh*3600+fm*60+fs ;
}

int see_trading_hours_init(see_hours_t t_hours[])
{
    int             i ;
    int             k ;
    int             n ;
    int             x=0 ;
    FILE            *pf ;
    char            ca_segment[SEE_SGM_NUM][20] ;

    char            ca_30F_s[9] ;
    char            ca_1H_s[9] ;
    char            ca_2H_s[9] ;
    char            ca_3H_s[9] ;
    char            ca_4H_s[9] ;
    char            ca_5H_s[9] ;
    char            ca_1D_s[9] ;

    char            ca_30F_e[9] ;
    char            ca_1H_e[9] ;
    char            ca_2H_e[9] ;
    char            ca_3H_e[9] ;
    char            ca_4H_e[9] ;
    char            ca_5H_e[9] ;
    char            ca_1D_e[9] ;

    char            ca_line[1024] ;
    see_segment_t  *sgm ;

    pf = fopen(TRADE_TIME,"r");
    if(pf == NULL) {
        see_errlog(1000,"open trade time error!!",RPT_TO_LOG,0,0) ;
        return -1 ;
    }

    for(i=0 ; i<SEE_HOUR_TYPE_NUM; i++) {
        for(k=0 ; k<SEE_SGM_NUM; k++) {
            t_hours[i].pt_segments[k] = NULL ;
        }
    }

    while(fgets(ca_line,1024, pf) != NULL) {
        memset(ca_30F_s,'\0',9);
        memset(ca_1H_s,'\0',9);
        memset(ca_2H_s,'\0',9);
        memset(ca_3H_s,'\0',9);
        memset(ca_4H_s,'\0',9);
        memset(ca_5H_s,'\0',9);
        memset(ca_1D_s,'\0',9);

        memset(ca_30F_e,'\0',9);
        memset(ca_1H_e,'\0',9);
        memset(ca_2H_e,'\0',9);
        memset(ca_3H_e,'\0',9);
        memset(ca_4H_e,'\0',9);
        memset(ca_5H_e,'\0',9);
        memset(ca_1D_e,'\0',9);

        k = string_split(ca_line,ca_segment) ;
        if(k<=2) {
            continue;
        }
        n = atoi(ca_segment[0]) ;   /* n 表示交易时间的类型，有的是23点结束，有的是23:30结束 */
        if(x<n+1) {
            x=n+1;
        }
        t_hours[n].i_hour_type= n ;
        for(i=1 ; i<k; i++) {
            sgm = malloc(sizeof(see_segment_t)) ;
            t_hours[n].pt_segments[i-1] = sgm ;
            /* need to init sgm !!! */

            if(sgm == NULL) {
                see_errlog(1000,"create k bar error!\n",RPT_TO_LOG,0,0) ;
            }
            sgm->c_oc_flag = 'o' ;
            sgm->ca_b[8] = '\0' ;
            sgm->ca_e[8] = '\0' ;
            memcpy(sgm->ca_b,ca_segment[i],8) ;
            memcpy(sgm->ca_e,ca_segment[i]+9,8) ;

            if((i-1)%2  ==0) {
                memcpy(ca_30F_s,ca_segment[i],8);
            }
            if((i-1)%4  ==0) {
                memcpy(ca_1H_s, ca_segment[i],8);
            }
            if((i-1)%8  ==0) {
                memcpy(ca_2H_s, ca_segment[i],8);
            }
            if((i-1)%12 ==0) {
                memcpy(ca_3H_s, ca_segment[i],8);
            }
            if((i-1)%16 ==0) {
                memcpy(ca_4H_s, ca_segment[i],8);
            }
            if((i-1)%20 ==0) {
                memcpy(ca_5H_s, ca_segment[i],8);
            }
            if(i-1 ==0) {
                memcpy(ca_1D_s,ca_segment[i],8);
            }

            int w ;
            if((i-1)%2  ==1 || i+1==k) {
                if((i-1)%2  ==1) {
                    memcpy(ca_30F_e,ca_segment[i]+9,8);
                    for(w=i-2; w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_30F_end,ca_30F_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 30F end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_30F_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
                if(i+1==k) {
                    memcpy(ca_30F_e,ca_segment[i]+9,8);
                    for(w=i-1-((i-1)%2); w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_30F_end,ca_30F_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 30F end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_30F_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
            }


            if((i-1)%4  ==3 || i+1==k) {
                if((i-1)%4  ==3) {
                    memcpy(ca_1H_e, ca_segment[i]+9,8);
                    for(w=i-4; w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_1H_end,ca_1H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 1H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_1H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
                if(i+1==k) {
                    memcpy(ca_1H_e, ca_segment[i]+9,8);
                    for(w=i-1-((i-1)%4); w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_1H_end,ca_1H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 1H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_1H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
            }


            if((i-1)%8  ==7 || i+1==k) {
                if((i-1)%8  ==7) {
                    memcpy(ca_2H_e, ca_segment[i]+9,8);
                    for(w=i-8; w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_2H_end,ca_2H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 2H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_2H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
                if(i+1==k) {
                    memcpy(ca_2H_e, ca_segment[i]+9,8);
                    for(w=i-1-((i-1)%8); w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_2H_end,ca_2H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 2H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_2H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
            }

            if((i-1)%12 ==11 || i+1==k) {
                if((i-1)%12  ==11) {
                    memcpy(ca_3H_e, ca_segment[i]+9,8);
                    for(w=i-12; w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_3H_end,ca_3H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 3H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_3H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
                if(i+1==k) {
                    memcpy(ca_3H_e, ca_segment[i]+9,8);
                    for(w=i-1-((i-1)%12); w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_3H_end,ca_3H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 3H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_3H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
            }
            if((i-1)%16 ==15 || i+1==k) {
                if((i-1)%16  ==15) {
                    memcpy(ca_4H_e, ca_segment[i]+9,8);
                    for(w=i-16; w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_4H_end,ca_4H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 4H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_4H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
                if(i+1==k) {
                    memcpy(ca_4H_e, ca_segment[i]+9,8);
                    for(w=i-1-((i-1)%16); w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_4H_end,ca_4H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 4H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_4H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
            }
            if((i-1)%20 ==19 || i+1==k) {
                if((i-1)%20 ==19) {
                    memcpy(ca_5H_e, ca_segment[i]+9,8);
                    for(w=i-20; w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_5H_end,ca_5H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 5H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_5H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
                if(i+1==k) {
                    memcpy(ca_5H_e, ca_segment[i]+9,8);
                    for(w=i-1-((i-1)%20); w<=i-1; w++) {
                        memcpy(t_hours[n].pt_segments[w]->ca_5H_end,ca_5H_e,9);
                        sprintf(ca_errmsg,"lllllllllllllll  n:%d   i-1:%d  w:%d 5H end: %s ca_segment[i]:%s",n,i-1,
                                w,ca_5H_e,ca_segment[i]) ;
                        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    }
                }
            }
            if(i+1 ==k) {
                memcpy(ca_1D_e,ca_segment[i]+9,8);
                for(w=0; w<=i-1; w++) {
                    memcpy(t_hours[n].pt_segments[w]->ca_1D_end,ca_1D_e,9);
                }
            }

            memcpy(sgm->ca_15F_start,ca_segment[i],8) ;
            memcpy(sgm->ca_15F_end,  ca_segment[i]+9,8) ;

            /* need to be modify ! */
            memcpy(sgm->ca_15F_start,ca_segment[i],8) ;
            memcpy(sgm->ca_15F_end,  ca_segment[i]+9,8) ;

            memcpy(sgm->ca_30F_start,ca_30F_s,9) ;
            memcpy(sgm->ca_30F_end,  ca_30F_e,9) ;

            memcpy(sgm->ca_1H_start,ca_1H_s,9) ;
            memcpy(sgm->ca_1H_end,  ca_1H_e,9) ;

            memcpy(sgm->ca_2H_start,ca_2H_s,9) ;
            memcpy(sgm->ca_2H_end,  ca_2H_e,9) ;

            memcpy(sgm->ca_3H_start,ca_3H_s,9) ;
            memcpy(sgm->ca_3H_end,  ca_3H_e,9) ;

            memcpy(sgm->ca_4H_start,ca_4H_s,9) ;
            memcpy(sgm->ca_4H_end,  ca_4H_e,9) ;

            memcpy(sgm->ca_5H_start,ca_5H_s,9) ;
            memcpy(sgm->ca_5H_end,  ca_5H_e,9) ;

            memcpy(sgm->ca_1D_start,ca_1D_s,9) ;
            memcpy(sgm->ca_1D_end,  ca_1D_e,9) ;
            /*    */

            t_hours[n].pt_segments[i-1] = sgm ;
            sprintf(ca_errmsg,"-iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii n: %d, i-1: %d,%s,1D start: %s,  1D end : %s ",n, i-1,
                    ca_segment[i],
                    t_hours[n].pt_segments[i-1]->ca_1D_start,
                    t_hours[n].pt_segments[i-1]->ca_1D_end) ;
            see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
        }

        for(i=1 ; i<k; i++) {
        }

        t_hours[n].pt_segments[k-1] = NULL ;
        t_hours[x].pt_segments[0] = NULL;
        sprintf(ca_errmsg,"ummmmmmmmmmmmmmm n:%d  x:%d  k:%d",n,x,k) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }

    fclose(pf);
    return 0 ;
}

int string_split(char *s,char _cmd[SEE_SGM_NUM][20])
{
    char *p = s;
    int i = 0;
    int j = 0;
    /*将前面的空格去掉*/
    while(*p == ' ') {
        p++;
    }
    while(*p != '\n' && *p != '\0') {
        if(*p == ' ') {
            _cmd[i][j]='\0';
            i++;
            j = 0;
            p++;
            /*处理多个空格的情况*/
            while(*p == ' ' || *p == '-') {
                p++;
            }
        } else {
            _cmd[i][j] = *p;
            p++;
            j++;
        }
    }
    _cmd[i][j]='\0';
    return i+1;
}

int string_split1(char *s, char ** _cmd,char c_seperater)
{
    char *p = s;
    int i = 0;
    int j = 0;

    while(*p == c_seperater) {
        p++;
    }

    while(*p != '\n' && *p != '\0') {
        if(*p == c_seperater) {
            _cmd[i][j]='\0';
            i++;
            j = 0;
            p++;
            /*处理多个空格的情况*/
            while(*p == c_seperater) {
                p++;
            }
        } else {
            _cmd[i][j] = *p;
            p++;
            j++;
        }
    }
    _cmd[i][j]='\0';
    return i+1;
}
