#include <see_com_common.h>

/*  stt_init() :
 *  K       :  bar array !
 *  pc_sttname :  strategy name ,defined in <etc/json/see_conf.json> such as stt01 stt02 ...
 *  j_root  :  t_conf.j_conf or p_conf->j_conf !!
 */
int stt_init(stt_kkall_t *K, char *pc_sttname, cJSON *j_root)
{
    int i = 0;
    int n;
    int p;
    cJSON *j_strategy ;
    cJSON *j_stt;
    cJSON *j_map;
    cJSON *j_ttt;
    cJSON *j_period;
    cJSON *j_ccc;

    for(i = 0; i<31; i++) {
        K->pt_ones[i] = NULL ;
    }

    j_strategy = cJSON_GetObjectItem(j_root, "strategy");
    if(!j_strategy) {
        see_err_log(0,0,"stt_init(): cJSON_GetObjectItem():  get strategy error!") ;
    }
    j_stt = cJSON_GetObjectItem(j_strategy, pc_sttname);
    if(j_stt) {
        j_ttt = cJSON_GetObjectItem(j_stt, "period");
        n = cJSON_GetArraySize(j_ttt);
        K->i_num = n;
        see_err_log(0,0," %s: period num: %d",j_ttt->string,n);
        for(i=0; i<n; i++) {
            j_period = cJSON_GetArrayItem(j_ttt,i);
            if(j_period) {
                j_map = cJSON_GetObjectItem(j_root,"period_map");
                j_ccc = cJSON_GetObjectItem(j_map,j_period->valuestring);
                p = j_ccc->valueint ;
                K->p[i] = p;
                K->pt_ones[p] = malloc(sizeof(stt_kkone_t));
                K->pt_ones[p]->i_cur = 0;
                see_err_log(0,0,"%s: %s %d \n",j_stt->string, j_period->valuestring,j_ccc->valueint);
            }
        }
    } else {
        see_err_log(0,0,"stt_init(): cJSON_GetObjectItem():  get %s error!",pc_sttname) ;
    }
    return 0;
}

int see_stt_load()
{
    return 0;
}


typedef struct {
    char        ca_future       [31];
    char        ca_sttname      [31];
    char        ca_TradingDayB  [9] ;
    char        ca_ActionDayB   [9] ;
    char        ca_UpdateTimeB  [9] ;
    char        ca_TradingDayE  [9] ;
    char        ca_ActionDayE   [9] ;
    char        ca_UpdateTimeE  [9] ;
    int         n;

} stt_input_t;

/*
 *  初始化
 *  
 */
int stt_kkall_init(see_config_t *p_conf,char * pc_future, char *pc_sttname, stt_kkall_t *p_kkall)
{
    int i;
    int k;
    int idx;
    int period ;
    char                *pc_table;
    see_fut_block_t     *fb ;
    see_bar_block_t     *bb ;
    stt_kkone_t         *p_kkone;

    idx = see_get_future_index(p_conf->pc_futures, pc_future) ;
    p_kkall->idx = idx ;
    fb = p_conf->pt_fut_blks[idx] ;

    stt_init(p_kkall, pc_sttname, p_conf->j_conf);

    /* i_num 表示有多少个period要于用策略计算 */
    for(k=0; k<p_kkall->i_num; k++) {
        period = p_kkall->p[k];
        bb = &( fb->bar_block[period] );
        pc_table = bb->ca_table ;
        printf ( "pc_table:%s period:%d\n",pc_table,period);
        //table = p_conf->pt_fut_blks[idx]->bar_block[ p_kkall->p[k] ].ca_table

        p_kkone = (stt_kkone_t *)malloc(sizeof(stt_kkone_t)) ;
        if(p_kkone == NULL) {
            return -1 ;
        }
        for(i=0; i<10000; i++) {
            p_kkone->oo[i] = SEE_NULL ;
            p_kkone->hh[i] = SEE_NULL ;
            p_kkone->ll[i] = SEE_NULL ;
            p_kkone->cc[i] = SEE_NULL ;
            p_kkone->vv[i] = SEE_NULL ;
            see_memzero(p_kkone->ca_TradingDays[i],9) ;
            memset(p_kkone->ca_ActionDays[i],'\0',9) ;
            memset(p_kkone->ca_UpdateTimes[i],'\0',9) ;
        }
        p_kkone->i_cur=0;
        printf( "befor stt_kkone_init !!\n");
        stt_kkone_init(p_conf, pc_table, 10000, p_kkone);
        printf( "after stt_kkone_init !!\n");
        p_kkall->pt_ones[period] = p_kkone ;
    }
    /* ? */
    return 0;
}

/*
int see_stt_blocks_init(see_config_t *p_conf)
{
    int u;
    int i;
    for(u=0; u<p_conf->i_future_num; u++) {
        see_node *node;
        stt_kkone_t *p_kkone ;
        node = p_conf->pt_stt_blks[u]->list ;
        while(node != NULL) {
            p_kkone = (stt_kkone_t *)malloc(sizeof(stt_kkone_t)) ;
            if(p_kkone == NULL) {
                return -1 ;
            }
            for(i=0; i<10000; i++) {
                p_kkone->oo[i] = SEE_NULL ;
                p_kkone->hh[i] = SEE_NULL ;
                p_kkone->ll[i] = SEE_NULL ;
                p_kkone->cc[i] = SEE_NULL ;
                p_kkone->vv[i] = SEE_NULL ;
                memset(p_kkone->ca_TradingDays[i],'\0',9) ;
                memset(p_kkone->ca_ActionDays[i],'\0',9) ;
                memset(p_kkone->ca_UpdateTimes[i],'\0',9) ;
            }
            p_kkone->i_cur=0;
            p_conf->pt_stt_blks[u]->pt_ones[node->period] = p_kkone;
            node = node->next ;
        }
        see_stt_blk_init(p_conf,p_conf->pt_stt_blks[u],u);
    }
    return 0;
}
*/


/*
int see_stt_blk_init(see_config_t *p_conf, stt_kkall_t *p_stt_blk, int i_idx)
{
    see_node *node;
    node = p_stt_blk->list ;
    while(node != NULL) {
        stt_kkone_init(p_conf,
                       p_conf->pt_fut_blks[i_idx]->bar_block[node->period].ca_table,
                       10000, p_stt_blk->pt_ones[node->period]);
        node = node->next ;
    }
    return 0 ;
}
*/

int stt_kkone_init(see_config_t *p_conf, char *pc_table, int num, stt_kkone_t *p_kkone)
{
    see_zdb_open(p_conf);
    see_zdb_get_data(p_conf,
                     pc_table,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     num,
                     p_kkone);

    see_zdb_get_data(   p_conf,
                        pc_table,
                        "20161108",
                        "20161110",
                        "09:00:01",
                        "14:30:45",
                        num,
                        p_kkone );

    see_zdb_close(p_conf);
    return 0 ;
}

int see_update_kkall(see_config_t *p_conf, int i_idx)
{
    see_node            *node;
    stt_kkone_t         *kkone ;
    see_fut_block_t     *p_fut_blk ;
    stt_kkall_t     *p_stt_blk ;
    see_bar_t           *p_bar0 ;
    see_bar_t           *p_bar1 ;

    p_fut_blk =     p_conf->pt_fut_blks[i_idx] ;
    p_stt_blk =     p_conf->pt_stt_blks[i_idx] ;
    node =          p_stt_blk->list ;

    while(node != NULL) {
        kkone   =   p_stt_blk->pt_ones[node->period] ;
        p_bar0  =  &p_fut_blk->bar_block[node->period].bar0 ;
        p_bar1  =  &p_fut_blk->bar_block[node->period].bar1 ;

        if(p_fut_blk->bar_block[node->period].c_save == 's') {
            memcpy(kkone->ca_TradingDays   [kkone->i_cur], p_bar0->TradingDay, 8) ;
            memcpy(kkone->ca_ActionDays    [kkone->i_cur], p_bar0->ActionDay,  8) ;
            memcpy(kkone->ca_UpdateTimes   [kkone->i_cur], p_bar0->ca_btime,   8) ;
            kkone->oo[kkone->i_cur] = p_bar0->o ;
            kkone->hh[kkone->i_cur] = p_bar0->h ;
            kkone->ll[kkone->i_cur] = p_bar0->l ;
            kkone->cc[kkone->i_cur] = p_bar0->c ;
            kkone->vv[kkone->i_cur] = p_bar0->v ;
            kkone->i_cur++ ;
            memcpy(kkone->ca_TradingDays   [kkone->i_cur], p_bar1->TradingDay, 8) ;
            memcpy(kkone->ca_ActionDays    [kkone->i_cur], p_bar1->ActionDay,  8) ;
            memcpy(kkone->ca_UpdateTimes   [kkone->i_cur], p_bar1->ca_btime,   8) ;
            kkone->oo[kkone->i_cur] = p_bar1->o ;
            kkone->hh[kkone->i_cur] = p_bar1->h ;
            kkone->ll[kkone->i_cur] = p_bar1->l ;
            kkone->cc[kkone->i_cur] = p_bar1->c ;
            kkone->vv[kkone->i_cur] = p_bar1->v ;
        } else {
            memcpy(kkone->ca_TradingDays   [kkone->i_cur], p_bar1->TradingDay, 8) ;
            memcpy(kkone->ca_ActionDays    [kkone->i_cur], p_bar1->ActionDay,  8) ;
            memcpy(kkone->ca_UpdateTimes   [kkone->i_cur], p_bar1->ca_btime,   8) ;
            kkone->oo[kkone->i_cur] = p_bar1->o ;
            kkone->hh[kkone->i_cur] = p_bar1->h ;
            kkone->ll[kkone->i_cur] = p_bar1->l ;
            kkone->cc[kkone->i_cur] = p_bar1->c ;
            kkone->vv[kkone->i_cur] = p_bar1->v ;
        }
        node = node->next ;
    }
    return 0;
}

/*
int see_update_kkone( see_config_t *p_conf, int period )
{

}

int see_update_kkone ( stt_kkone_t  *p_kkone, see_stt_data_t *p_stt_data )
{
    int         i_len ;
    if ( p_stt_data->c_save == 'n' ) {
        p_kkone->oo[10000] = p_stt_data->o ;
        p_kkone->hh[10000] = p_stt_data->h ;
        p_kkone->ll[10000] = p_stt_data->l ;
        p_kkone->cc[10000] = p_stt_data->c ;
        p_kkone->vv[10000] = p_stt_data->v ;
    } else {
        i_len = sizeof(double)*9999 ;
        memcpy( (char *)&(p_kkone->oo[0]), (char *)&(p_kkone->oo[1]), i_len ) ;
        memcpy( (char *)&(p_kkone->hh[0]), (char *)&(p_kkone->hh[1]), i_len ) ;
        memcpy( (char *)&(p_kkone->ll[0]), (char *)&(p_kkone->ll[1]), i_len ) ;
        memcpy( (char *)&(p_kkone->cc[0]), (char *)&(p_kkone->cc[1]), i_len ) ;
        i_len = sizeof(int)*9999 ;
        memcpy( (char *)&(p_kkone->vv[0]), (char *)&(p_kkone->vv[1]), i_len ) ;
        p_kkone->oo[10000] = p_stt_data->o ;
        p_kkone->hh[10000] = p_stt_data->h ;
        p_kkone->ll[10000] = p_stt_data->l ;
        p_kkone->cc[10000] = p_stt_data->c ;
        p_kkone->vv[10000] = p_stt_data->v ;
    }
}
*/

static int i_count ;
static char ca_files[200][512] ;

static int trave_dir(char* path)
{
    DIR             *d;
    struct stat     sb;
    int             n,i_len;
    struct dirent   **namelist;
    char            ca_path[512] ;

    if(!(d = opendir(path))) {
        printf("error opendir %s!!!/n",path);
        return -1;
    }

    memset(ca_path,'\0',512);

    n = scandir(path,&namelist,0,alphasort);
    while(n--) {
        if(strncmp(namelist[n]->d_name, ".", 1) == 0) {
            free(namelist[n]) ;
            continue;
        }

        sprintf(ca_path,"%s/%s",path,namelist[n]->d_name) ;

        if(stat(ca_path, &sb) >= 0 && S_ISDIR(sb.st_mode)) {
            trave_dir(ca_path);
        } else {
            i_len = strlen(ca_path) ;
            if(strncmp("bin", &ca_path[i_len-3],3) != 0) {
                memset(ca_files[i_count],'\0',512);
                sprintf(ca_files[i_count],"%s",ca_path) ;
                i_count++ ;
                if(i_count >=200) {
                    return -1;
                } ;
            }
        }
        free(namelist[n]) ;
    }
    closedir(d);
    return 0;
}

int see_trave_dir(char* path, int *p_count, char pc_files[][512])
{
    int i;
    i_count = 0;
    trave_dir(path) ;
    *p_count = i_count ;
    for(i=0; i<i_count; i++) {
        memset(pc_files[i],'\0',512);
        memcpy(pc_files[i],ca_files[i],512);
    }
    i_count = 0;
    return 0;
}

/*
 *
*/

/****************************
typedef struct {
    double *oo;
    double *hh;
    double *ll;
    double *cc;
    double *vv;
    int cur;
} see_ohlcv_one_t;

typedef struct {
    see_ohlcv_one_t [31] ;
} see_ohlcv_all_t;
****************************/

/*
 * ca_timeB: "20120101-00:00:00"  如果 ca_timeB 为 NULL, 则从数据库时取最近 10000个数据
 * ca_timeE: "20170202-21:30:59"  如果 ca_timeE 为 NULL，表示算到当前，
 *          而且 会实时计算当前ctpget所得到的数据.
 * ohlcv:   输出的 ohlcv数组。
 * pp[]:    pp[0] 必须是数值，表示pp数组的长度，pp[1] pp[2] ... pp[n] 记录的是周期。
 *          具体的周期值，请查看 ../inc/see_bars.h 中的定义。 例如： BAR_1S = 0 , 这里的
 *          pp[] = { 4,0,5,7,9 } 表示 有4个周期会用到，这四个周期分别是：BAR_1S BAR_15S
 *          BAR_30S BAR_2F。 第一个4，代表有4个周期会用到， 0,5,7,9分别代表不同的周期。
 */
/****************************
int see_stt_prepare_data(char *ca_timeB, char *ca_timeE, void *ohlcv, int pp[])
{
    return 0;
}
int see_stt_free_data()
{
    return 0;
}
****************************/

/*
 *  see_stt_process() 供 waiter.x 收到前端请求后，fork一个子进程来调用。
 *  在调用之前，waiter.x需要将请求进行处理，放在一个全局的  stt_request_t
 *  see_stt_process() 从这个全局的 stt_request_t 取数据进行处理.
 *  see_stt_deal() 也从 stt_request_t中取数据，其中，这里面必须包含 策略函数名。
 */
/****************************
int see_stt_process()
{
    see_stt_prepare_data()
    see_stt_deal()
    see_stt_send()

    while(1) {
        wait_zmq_from_ctpget()
        see_stt_deal()
        see_stt_send()
    }
}
****************************/
