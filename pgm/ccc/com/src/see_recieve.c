#include <see_com_common.h>

const char ca_pubsub_url[] = "ipc:///tmp/heaven.ipc" ;
const char ca_mysql_url[]  = "mysql://127.0.0.1/test?user=root&password=root" ;

//static char             ca_futures          [FUTURE_NUMBER][FUTRUE_ID_LEN] ;
//static char            *pc_futures          [FUTURE_NUMBER] ;

//static see_stt_block_t *pt_stt_blocks       [FUTURE_NUMBER] ;      /* each future has a strategy block !             */
//static see_fut_block_t     *pt_fut_blks       [FUTURE_NUMBER] ;      /* each future has a block !                      */
//static see_hours_t      t_hours             [SEE_HOUR_TYPE_NUM] ;  /* same lines with ../../etc/tbl/see_trade_time   */
static int              i_idx ;

see_config_t            t_conf ;
see_config_t            *p_conf ;

char ca_errtmp[512] ;

int
main(int iArgCnt, char *pcaArgVec[])
{
    int u ;
    int i ;
    int     i_rtn =0 ;
    int     sock ;
    char    ca_UpdateTime[9];
    char    ca_TradingDay[9];
    char    *buf = NULL;
    struct CThostFtdcDepthMarketDataField * tick ;

    see_signal_init() ;                 // 需要详细考虑
    signal(SIGHUP, SIG_IGN);
    signal(SIGPIPE, SIG_IGN);
    see_daemon(1,0) ;

    p_conf = &t_conf ;
    see_config_init(p_conf);
    see_stt_blocks_init(p_conf);

    for(u=0; u<p_conf->i_future_num; u++) {
        see_node *node;
        see_kkone_t *p_kkone ;
        node = p_conf->pt_stt_blks[u]->list ;
        while(node != NULL) {
            p_kkone = p_conf->pt_stt_blks[u]->pt_kkall[node->period] ;

            printf("\n------------- %d %d ------------------\n",p_kkone->i_cur, node->period) ;
            for(i=p_kkone->i_cur; i<10000; i++) {
                printf(" %s ", p_conf->pt_fut_blks[u]->InstrumentID);
                printf(" %s ", p_kkone->ca_TradingDays[i]) ;
                printf(" %s ", p_kkone->ca_ActionDays[i]) ;
                printf(" %s ", p_kkone->ca_UpdateTimes[i]) ;
                printf(" %lf ", p_kkone->oo[i]) ;
                printf(" %lf ", p_kkone->hh[i]) ;
                printf(" %lf ", p_kkone->ll[i]) ;
                printf(" %lf ", p_kkone->cc[i]) ;
                printf(" %d ", p_kkone->vv[i]) ;
                printf("\n") ;
            }
            node = node->next ;
        }
    }

    /*
    see_node *node;
    node = t_conf.pt_stt_blks[0]->list ;
    while( node != NULL ){
        printf( "test ok!!!!!!!!!!!!: period:%d\n", node->period );
        node = node->next ;
    }

    printf( " i_future_num :%d\n",t_conf.i_future_num ) ;
    printf( " home: %s \n",t_conf.ca_home ) ;
    printf( " pair_url: %s \n",t_conf.ca_nn_pair_url ) ;
    printf( " pair_url: %s \n",t_conf.ca_nn_pubsub_url ) ;
    printf( " pair_url: %s \n",t_conf.ca_db_url ) ;

    i = 0 ;
    while ( t_conf.pc_futures[i] != NULL ) {
        printf( " future: %s \n",t_conf.pc_futures[i] ) ;
        i++ ;
    }

    */

    i_rtn = pthread_create(&t_conf.p_dat, NULL, see_pthread_dat, &t_conf);
    if(i_rtn == -1) {
        printf("create thread tcp recv_thread failed errno= %d/n", errno);
        return -1;
    }
    //pthread_create(&t_conf.p_bar, NULL, see_pthread_bar, &t_conf);
    //sleep(1) ;


    if(iArgCnt<=1) {
        printf("Arg error!\n");
        return -1;
        see_errlog(1000,"Arg error!\n",RPT_TO_LOG,0,0);
    }


    /* --------- strategy init --------------------------------------- */
    //see_stt01_init() ;
    //see_stt02_init() ;
    //see_stt03_init() ;
    //see_stt04_init() ;


    /*
      $rrr.x 0
      参数0 表示 从nanomsg取得tick bin数据进行处理。
      一般情况，是由ctpget.x发送 tick bin 数据过来。

      2017-03-24
      ctpget.x 已经具备处理bar的功能，并且可以写入文件到 dat/rcv_dat/..下
      所以目前可以不需要使用 rrr.x 0 来接收 ctpget.x 传来的数据。

    */
    if(memcmp(pcaArgVec[1],"0",1)==0) {
        printf("\n === Get tick data from nanomsg !!!\n") ;

        //  sock = see_pubsub_client( ca_pubsub_url, "iostest" ) ;
        sock = see_pair_client(t_conf.ca_nn_pubsub_url) ;

        while(1) {                                                        //  接收数据 并进行处理
            nn_recv(sock, &buf, NN_MSG, 0);                       // 如果没有数据，进程会等在这里，这时
            // 如果收到signal 后，会进入到自己写的信号处理程序
            // 然后程序会往下走，buf没有分配内存，所以会出报SIGSEG信号。
            // 如果在前面 忽略如SIGHUP信号，则不会进入到 信号处理程序

            tick = (struct CThostFtdcDepthMarketDataField *)buf ;

            i_idx = see_get_future_index(t_conf.pc_futures, tick->InstrumentID) ;     //i_idx 合约所在的数组下标
            if(i_idx == SEE_ERROR) {
                see_errlog(1000,(char *) "see_handle_bars() -> see_get_future_index()  error!!",RPT_TO_LOG,0,0) ;
                sprintf(ca_errmsg,"future %s is not in pc_futures: tick->InstrumentID: %s",tick->InstrumentID,tick->InstrumentID) ;
                see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                continue ;
            }

            sprintf(ca_errmsg," tick_data.BidVolume5 %d\n",tick->BidVolume5);
            see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
            printf(" tick_data.BidVolume5 %d\n",tick->BidVolume5);

            //see_handle_bars( t_conf.pt_fut_blks[i_idx], buf ) ;             // calc_bar_block & save_bar(save k value)
            //see_update_kk( pt_fut_blks[i_idx], pt_stt_blocks[i_idx] ) ;
            nn_freemsg(buf);

            //see_kvalue_send () ;                                      // dedicated process for strategy calculating !!

            //see_stt01() ;                                               // strategy 01, return int i_buysell !!
            //see_stt02() ;
            //see_stt03() ;
            //see_stt04() ;

            // send i_buysell to trader process here !!!!!!!

        } /* endof while(1) */
    }

    clock_t t_start, t_finish;
    double Total_time;


    struct timeval start, end;
    gettimeofday(&start, NULL);


    t_start = clock();

    /*
     $rrr.x 1
     参数1表示，直接从../dat/tst_dat/tick.bin中读取 tick bin进行处理，
     一般进行测试用！
    */

    if(memcmp(pcaArgVec[1],"1",1)==0) {

        printf("\n === Get tick data from ../dat/tst_dat/* !!!\n") ;

        int msg_len = sizeof(struct CThostFtdcDepthMarketDataField) ;

        int i_count ;

        static char ca_tick_file_list[] = "../../etc/tbl/tick_file_name.txt" ;
        static char ca_line[100] ;
        static char ca_tick_file[512] ;
        FILE *pf ;
        FILE *pf_tick_file ;
//    struct CThostFtdcDepthMarketDataField * t_data ;
        struct CThostFtdcDepthMarketDataField tick_data ;

        pf = fopen(ca_tick_file_list,"r");
        if(pf == NULL) {
            see_errlog(1000,(char *)"see_recieve.c open future list file  error!!",RPT_TO_LOG,0,0) ;
            see_errlog(1000,ca_tick_file_list,RPT_TO_LOG,0,0) ;
            return -1 ;
        }
        memset(ca_line,'\0',100) ;

        memset(ca_UpdateTime,'\0',9) ;
        memset(ca_TradingDay,'\0',9) ;

        i_count = 0 ;
        while(fgets(ca_line, 100, pf) != NULL) {
            int len = strlen(ca_line)-1 ;
            ca_line[len] = '\0' ;
            memset(ca_tick_file,'\0',512) ;
            strcat(ca_tick_file,(char *)"../../dat/tst_dat/") ;
            strcat(ca_tick_file,ca_line) ;

            pf_tick_file = fopen(ca_tick_file,"rb");
            if(pf_tick_file == NULL) {
                see_errlog(1000,(char *)"see_recieve.c open future tick file  error!!",RPT_TO_LOG,0,0) ;
                see_errlog(1000,ca_tick_file,RPT_TO_LOG,0,0) ;
                return -1 ;
            }

            while((i_rtn = fread(&tick_data,msg_len,1,pf_tick_file)) != 0) {
                buf = (char *) &tick_data ;
                tick_data.BidVolume5 = i_count ;
                //see_disp_tick(buf) ;

                i_idx = see_get_future_index(t_conf.pc_futures,tick_data.InstrumentID) ;   //i_idx 合约所在的数组下标
                if(i_idx == SEE_ERROR) {
                    see_errlog(1000,(char *) "see_handle_bars() -> see_get_future_index()  error!!",RPT_TO_LOG,0,0) ;
                    sprintf(ca_errmsg,"future %s is not in pc_futures: tick_data: %s",tick_data.InstrumentID,tick_data.InstrumentID) ;
                    see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
                    continue ;
                }

                see_handle_bars(t_conf.pt_fut_blks[i_idx], buf) ;               // calc_bar_block & save_bar(save k value)
                see_update_kkall(p_conf, i_idx) ;

            }
            fclose(pf_tick_file);
        }
        fclose(pf);

    }
    t_finish = clock();

    Total_time = (double)(t_finish-t_start) / CLOCKS_PER_SEC;

    gettimeofday(&end,NULL);
    memset(ca_errmsg,'\0',100);
    sprintf(ca_errmsg,"==== calc-time =========: sec:%lu usec:%lu \n",end.tv_sec-start.tv_sec,end.tv_usec-start.tv_usec) ;
    see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;

    sprintf(ca_errmsg,"==== calc-time =========: clock sec: %f\n",Total_time) ;
    see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;

    sleep(36000);
    return SEE_OK;
}
