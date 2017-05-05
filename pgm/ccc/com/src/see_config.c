#include <see_com_common.h>

//see_config_t         gt_conf;
see_config_t        *gp_conf;

void test_reset_hwm();

//int see_config_init(see_config_t *p_conf)
int see_config_init()
{
    int     i_rtn ;
    int     i ;
    int     u ;
    see_config_t * p_conf;
    cJSON   *j_root ;
    cJSON   *j_item ;
    cJSON   *j_temp ;
    cJSON   *j_period ;
    char    ca_conf_json[] = "../../etc/json/see_conf.json" ;
    
    gt_shm.size = sizeof(see_config_t);
    see_shm_alloc(&gt_shm);
    gp_conf = (see_config_t *)gt_shm.addr;
    p_conf = gp_conf;

    p_conf-> i_future_num = 0;
    memset(p_conf->ca_nn_pair_url,'\0',512);
    memset(p_conf->ca_nn_pubsub_url,'\0',512);
    memset(p_conf->ca_db_url,'\0',512);
    for(i=0; i<FUTURE_NUMBER; i++) {
        memset(p_conf->ca_futures[i],'\0',FUTRUE_ID_LEN) ;
        p_conf->pc_futures[i] = NULL;
        p_conf->pt_stt_blks[i] = NULL;
        p_conf->pt_fut_blks[i] = NULL;
    }

    /*
    pthread_mutex_init(&p_conf->mutex_dat, NULL);
    pthread_mutex_init(&p_conf->mutex_bar, NULL);
    pthread_cond_init(&p_conf->cond_dat, NULL);
    pthread_cond_init(&p_conf->cond_bar, NULL);
    */

    /* p_conf->t_hours init !!!!!!!!!!!  */
    see_trading_hours_init(&p_conf->t_hours[0]) ;

    sprintf(p_conf->ca_home, "%s", (char *)getenv("HOME"));

    /* deal futures from conf.json */
    i_rtn = see_file_to_json((char *)ca_conf_json, &j_root);
    if(i_rtn!=0) {
        exit(1) ;
    }
   
    j_item = cJSON_GetObjectItem(j_root, "nanomsg");
    if(j_item == NULL) {
        printf(" see_config_init() get nanomsg error !!  \n ");
    }
    j_temp = cJSON_GetObjectItem(j_item, "pair_url");
    memcpy(p_conf->ca_nn_pair_url, j_temp->valuestring, strlen(j_temp->valuestring));
    //p_conf->i_pair_sock = see_pair_server(p_conf->ca_nn_pair_url) ;

    /* topy : to python rose */
    j_temp = cJSON_GetObjectItem(j_item, "topy_url");
    memcpy(p_conf->ca_nn_topy_url, j_temp->valuestring, strlen(j_temp->valuestring));
    //p_conf->i_topy_sock = see_pair_server(p_conf->ca_nn_topy_url) ;

    /* zmq_pub : to python rose */
    see_memzero(p_conf->ca_zmq_pub_url,512);
    see_memzero(p_conf->ca_zmq_sub_url,512);
    j_temp = cJSON_GetObjectItem(j_item, "zmq_pub_url");
    memcpy(p_conf->ca_zmq_pub_url, j_temp->valuestring, strlen(j_temp->valuestring));
    j_temp = cJSON_GetObjectItem(j_item, "zmq_sub_url");
    memcpy(p_conf->ca_zmq_sub_url, j_temp->valuestring, strlen(j_temp->valuestring));


    //void *vv = see_zmq_sub_init(p_conf->ca_zmq_sub_url);
    //char mybuf[256];
    //see_zmq_sub_recv(vv,mybuf,256,0);

    //p_conf->v_pub_sock = see_zmq_pub_init(p_conf->ca_zmq_pub_url);
    //p_conf->v_sub_sock = see_zmq_sub_init(p_conf->ca_zmq_sub_url);

    //see_zmq_sub_recv(p_conf->v_sub_sock,mybuf,256,0);


    /* 这里其实是 pipeline sock !! */
    j_temp = cJSON_GetObjectItem(j_item, "pubsub_url");
    memcpy(p_conf->ca_nn_pubsub_url, j_temp->valuestring, strlen(j_temp->valuestring));
    p_conf->i_pubsub_sock = see_pipeline_server(p_conf->ca_nn_pubsub_url) ;

    j_item = cJSON_GetObjectItem(j_root, "database");
    if(j_item == NULL) {
        printf(" see_config_init() get database error !!  \n ");
    }
    j_item = cJSON_GetObjectItem(j_item, "mariadb");
    j_temp = cJSON_GetObjectItem(j_item, "url");
    memcpy(p_conf->ca_db_url, j_temp->valuestring, strlen(j_temp->valuestring));


    j_item = cJSON_GetObjectItem(j_root, "futures");
    if(j_item == NULL) {
        printf(" see_config_init() get futures error !!  \n ");
    }
    p_conf->i_future_num = cJSON_GetArraySize(j_item);

    printf( "config:::::p_conf->i_future_num: %d\n",p_conf->i_future_num );
    if(p_conf->i_future_num <=0) {
        exit(-1) ;
    }
    if(p_conf->i_future_num > FUTURE_NUMBER) {
        printf(" see_config_init() futures number is overload !!  \n ");
        exit(-1) ;
    }

    /* p_conf->ca_futures[u][] init !       */
    /* p_conf->pc_futures[u] init !         */
    /* p_conf->pt_stt_blks[u]->list init !! */

    for(u=0; u<p_conf->i_future_num; u++) {
        j_temp = cJSON_GetArrayItem(j_item,u);
        if(j_temp) {
            printf("%s\n",j_temp->string);
            memcpy(p_conf->ca_futures[u], j_temp->string, strlen(j_temp->string));
            p_conf->pc_futures[u] = &(p_conf->ca_futures[u][0]) ;

            p_conf->pt_fut_blks[u] = (see_fut_block_t *)malloc(sizeof(see_fut_block_t)) ;
            if(p_conf->pt_fut_blks[u] == NULL) {
                see_errlog(1000,"malloc(sizeof(see_fut_block_t) error !\n",RPT_TO_LOG,0,0) ;
            }
            see_block_init(p_conf->pt_fut_blks[u], p_conf->pc_futures[u], &p_conf->t_hours[0]) ;


            /*
                下面这句，是为每个 future block 的 v_pub_sock赋值。v_pub_sock是指 zmq
                前面 see_zmq_pub_init() 会产生 v_pub_sock值。
                目前，所有的future block  的 v_pub_sock 的值是一样的。
                在 see_bars.c 的 see_send_bar() 会 使用到 v_pub_sock !
            */
            //p_conf->pt_fut_blks[u]->v_pub_sock = p_conf->v_pub_sock ; // for zmq pub
            p_conf->pt_fut_blks[u]->v_sub_sock = p_conf->v_sub_sock ; // for zmq pub


            /*
             *  每个future block 分配一块内存区 share memory !!
             */
            p_conf->pt_fut_blks[u]->shm.size = sizeof(see_fut_mem_t);
            see_shm_alloc(&(p_conf->pt_fut_blks[u]->shm));


            p_conf->pt_stt_blks[u] = (stt_kkall_t *)malloc(sizeof(stt_kkall_t)) ;
            if(p_conf->pt_stt_blks[u] == NULL) {
                see_errlog(1000,"malloc(sizeof(stt_kkall_t) error !\n",RPT_TO_LOG,0,0) ;
            }
            for(i=0; i<31; i++) {
                p_conf->pt_stt_blks[u]->pt_ones[i] = NULL ;
                p_conf->pt_stt_blks[u]->list = NULL ;
            }
            /*
            see_stt_blk_init( p_conf->pt_stt_blks[u], p_conf->pc_futures[u] ) ;
            */

            j_period = cJSON_GetObjectItem(j_temp, "period");
            if(j_period) {
                /*
                char *s = cJSON_Print(j_period) ;
                printf( "%s\n",s );
                free( s );
                */
                int num ;
                cJSON *j_kkk;
                cJSON *j_map;
                cJSON *j_ttt;

                num = cJSON_GetArraySize(j_period);
                if(num>0) {
                    see_node * temp ;
                    see_node * node ;
                    see_node * n_this = malloc(sizeof(see_node));
                    temp = n_this ;
                    p_conf->pt_stt_blks[u]->list = n_this ;
                    for(i=0; i<num; i++) {
                        j_kkk = cJSON_GetArrayItem(j_period,i);
                        if(j_kkk) {
                            j_map = cJSON_GetObjectItem(j_root,"period_map");
                            j_ttt = cJSON_GetObjectItem(j_map,j_kkk->valuestring);
                            node = malloc(sizeof(see_node));
                            temp = n_this ;
                            n_this->period = j_ttt->valueint ;
                            n_this->next = node ;
                            n_this = node ;
                        }
                    }
                    if(p_conf->pt_stt_blks[u]->list != n_this) {
                        temp->next = NULL ;
                    } else {
                        p_conf->pt_stt_blks[u]->list = NULL ;
                    }
                    free(n_this) ;
                }
            } /* end of if( j_period ) */
        } /* end of if(j_temp) */
    } /* end of for */

    p_conf->j_conf = j_root ;
    // cJSON_Delete(j_root);

    /* p_conf->pt_stt_blks[u]->list init !!
     * pt_stt_blks[1] : TA705 { 1f : ->pt_ones[8],
     *                          5f : ->pt_ones[11],
     *                          30f: ->pt_ones[15], }
     * pt_stt_blks[2] : v1705 { 1f : ->pt_ones[8],
     *                          5f : ->pt_ones[11],
     *                          30f: ->pt_ones[15], }
     * pt_stt_blks[u] : v1705 { 1f : ->pt_ones[node->period] }
    */

    /*
    for( u=0; u<p_conf->i_future_num; u++ )
    {
        see_node *node;
        stt_kkone_t *p_kkone ;
        node = p_conf->pt_stt_blks[u]->list ;
        while( node != NULL ){
            p_kkone = (stt_kkone_t *)malloc(sizeof(stt_kkone_t)) ;
            if( p_kkone == NULL ){
                return -1 ;
            }
            for(i=0;i<10000;i++){
                p_kkone->oo[i] = SEE_NULL ;
                p_kkone->hh[i] = SEE_NULL ;
                p_kkone->ll[i] = SEE_NULL ;
                p_kkone->cc[i] = SEE_NULL ;
                p_kkone->vv[i] = SEE_NULL ;
                memset( p_kkone->ca_TradingDays[i],'\0',9 ) ;
                memset( p_kkone->ca_ActionDays[i],'\0',9 ) ;
                memset( p_kkone->ca_UpdateTimes[i],'\0',9 ) ;
            }
            p_conf->pt_stt_blks[u]->pt_ones[node->period] = p_kkone;
            node = node->next ;
        }
        see_stt_blk_init( p_conf,p_conf->pt_stt_blks[u],u );
    }
    */

    /* p_conf->p_conf->pt_fut_blks init !!!!!!!!!!!  */
    /* p_conf->p_conf->pt_stt_blks init !!!!!!!!!!!  */

    return 0 ;
}
