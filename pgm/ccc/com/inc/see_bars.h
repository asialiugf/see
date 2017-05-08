/*
 *   Copyright (C) asialine
 *   Copyright (C) seeme,Inc.
 */

#ifndef _SEE_BARS_H_INCLUDED_
#define _SEE_BARS_H_INCLUDED_

#include <see_com_common.h>
#include <ThostFtdcUserApiStruct.h>

#define  SEE_HOUR_TYPE_NUM 20
#define  SEE_SGM_NUM       50
#define  MAX_BARS_LEN      1000000

/*
 * 定义工作一天需要保存的长度
 * 注意：下面是按照一天交易时间不超过12小时来计算的
 *       如果超过，下面的这些值需要修改。
*/
#define  BAR_1S_LEN   43200
#define  BAR_2S_LEN   21600
#define  BAR_3S_LEN   14400
#define  BAR_5S_LEN   8640
#define  BAR_10S_LEN  4320
#define  BAR_15S_LEN  2880
#define  BAR_20S_LEN  2160
#define  BAR_30S_LEN  1440
#define  BAR_1F_LEN   720
#define  BAR_2F_LEN   360
#define  BAR_3F_LEN   240
#define  BAR_5F_LEN   144
#define  BAR_10F_LEN  73
#define  BAR_15F_LEN  49
#define  BAR_20F_LEN  37
#define  BAR_30F_LEN  23
#define  BAR_1H_LEN   13
#define  BAR_2H_LEN   7
#define  BAR_3H_LEN   5
#define  BAR_4H_LEN   4
#define  BAR_5H_LEN   4
#define  BAR_6H_LEN   4
#define  BAR_8H_LEN   3
#define  BAR_10H_LEN  3
#define  BAR_12H_LEN  3
#define  BAR_1D_LEN   2
#define  BAR_1W_LEN   2
#define  BAR_1M_LEN   2
#define  BAR_1J_LEN   2
#define  BAR_1Y_LEN   2
#define  BAR_TICK_LEN 0

typedef struct {
    struct CThostFtdcDepthMarketDataField   rcv_tick;
    TThostFtdcDateType                      rcv_date;
    TThostFtdcTimeType                      rcv_time;
    TThostFtdcMillisecType                  rcv_msec;
    int                                     rcv_week;
} see_tick_t;

typedef struct {
    double  o ;             // open
    double  c ;             // close
    double  h ;             // high
    double  l ;             // low
    int     v ;             // volume
    char                UpdateTime[9];
} see_kbar_t;

typedef struct {
    char               InstrumentID[31];
    char               TradingDay[9];
    char               ActionDay[9];
    see_kbar_t         kbars_1S[BAR_1S_LEN];
    see_kbar_t         kbars_2S[BAR_2S_LEN];
    see_kbar_t         kbars_3S[BAR_3S_LEN];
    see_kbar_t         kbars_5S[BAR_5S_LEN];
    see_kbar_t         kbars_10S[BAR_10S_LEN];
    see_kbar_t         kbars_15S[BAR_15S_LEN];
    see_kbar_t         kbars_20S[BAR_20S_LEN];
    see_kbar_t         kbars_30S[BAR_30S_LEN];
    see_kbar_t         kbars_1F[BAR_1F_LEN];
    see_kbar_t         kbars_2F[BAR_2F_LEN];
    see_kbar_t         kbars_3F[BAR_3F_LEN];
    see_kbar_t         kbars_5F[BAR_5F_LEN];
    see_kbar_t         kbars_10F[BAR_10F_LEN];
    see_kbar_t         kbars_15F[BAR_15F_LEN];
    see_kbar_t         kbars_20F[BAR_20F_LEN];
    see_kbar_t         kbars_30F[BAR_30F_LEN];
    see_kbar_t         kbars_1H[BAR_1H_LEN];
    see_kbar_t         kbars_2H[BAR_2H_LEN];
    see_kbar_t         kbars_3H[BAR_3H_LEN];
    see_kbar_t         kbars_4H[BAR_4H_LEN];
    see_kbar_t         kbars_5H[BAR_5H_LEN];
    see_kbar_t         kbars_6H[BAR_6H_LEN];
    see_kbar_t         kbars_8H[BAR_8H_LEN];
    see_kbar_t         kbars_10H[BAR_10H_LEN];
    see_kbar_t         kbars_12H[BAR_12H_LEN];
    see_kbar_t         kbars_1D[BAR_1D_LEN];
    see_kbar_t         kbars_1W[BAR_1W_LEN];
    see_kbar_t         kbars_1M[BAR_1M_LEN];
    see_kbar_t         kbars_1J[BAR_1J_LEN];
    see_kbar_t         kbars_1Y[BAR_1Y_LEN];
    int                cur_1s;
    int                cur_1S;
    int                cur_2S;
    int                cur_3S;
    int                cur_5S;
    int                cur_10S;
    int                cur_15S;
    int                cur_20S;
    int                cur_30S;
    int                cur_1F;
    int                cur_2F;
    int                cur_3F;
    int                cur_5F;
    int                cur_10F;
    int                cur_15F;
    int                cur_20F;
    int                cur_30F;
    int                cur_1H;
    int                cur_2H;
    int                cur_3H;
    int                cur_4H;
    int                cur_5H;
    int                cur_6H;
    int                cur_8H;
    int                cur_10H;
    int                cur_12H;
    int                cur_1D;
    int                cur_1W;
    int                cur_1M;
    int                cur_1J;
    int                cur_1Y;
} see_fut_mem_t;


/*
   注意：
    下面的定义，与数组下标是严格一致的。
    block->bar_block[0]  = block->bar_block[BAR_1S]
    block->bar_block[13]  = block->bar_block[BAR_15F]
    各种函数的 period 也用的是下面的定义。

*/
#define  BAR_1S       0
#define  BAR_2S       1
#define  BAR_3S       2
#define  BAR_5S       3
#define  BAR_10S      4
#define  BAR_15S      5
#define  BAR_20S      6
#define  BAR_30S      7
#define  BAR_1F       8
#define  BAR_2F       9
#define  BAR_3F       10
#define  BAR_5F       11
#define  BAR_10F      12
#define  BAR_15F      13
#define  BAR_20F      14
#define  BAR_30F      15
#define  BAR_1H       16
#define  BAR_2H       17
#define  BAR_3H       18
#define  BAR_4H       19
#define  BAR_5H       20
#define  BAR_6H       21
#define  BAR_8H       22
#define  BAR_10H      23
#define  BAR_12H      24
#define  BAR_1D       25
#define  BAR_1W       26
#define  BAR_1M       27
#define  BAR_1J       28
#define  BAR_1Y       29
#define  BAR_TICK     30

/* periods defined */
/*                0  1 2 3 4  5  6  7  8  9   10  11  12  13  14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30   */
/*                1S 2 3 5 10 15 20 30 1F 2F  3F  5F  10F 15F 20 30 1H 2H 3H 4H 5H 6H 8H 10 12 1D 1W 1M 1J 1Y TICK */
//const static int pp[31] =  {1, 2,3,5,10,15,20,30,60,120,180,300,600,900,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

#define  BAR_SECOND        's'
#define  BAR_MINUTE        'f'
#define  BAR_HOUR          'h'
#define  BAR_DAY           'd'
#define  BAR_WEEK          'w'
#define  BAR_MONTH         'm'
#define  BAR_SEASON        'j'
#define  BAR_YEAR          'y'
#define  BAR_TICKC         't'

#define  BAR_SAVE_YES     ‘'y'
#define  BAR_SAVE_NO       'n'

#define SEG_0       0
#define SEG_1       1
#define SEG_2       2
#define SEG_3       3
#define SEG_4       4
#define SEG_5       5
#define SEG_6       6
#define SEG_7       7
#define SEG_8       8
#define SEG_9       9

#define NO_SEG_0       -1
#define NO_SEG_1       -1
#define NO_SEG_2       -2
#define NO_SEG_3       -3
#define NO_SEG_4       -4
#define NO_SEG_5       -5
#define NO_SEG_6       -6
#define NO_SEG_7       -7
#define NO_SEG_8       -8
#define NO_SEG_9       -9

#define SAME_SEG_0       0
#define SAME_SEG_1       1
#define SAME_SEG_2       2
#define SAME_SEG_3       3
#define SAME_SEG_4       4
#define SAME_SEG_5       5
#define SAME_SEG_6       6
#define SAME_SEG_7       7
#define SAME_SEG_8       8
#define SAME_SEG_9       9

#define SAME_NO_SEG_0       -1
#define SAME_NO_SEG_1       -1
#define SAME_NO_SEG_2       -2
#define SAME_NO_SEG_3       -3
#define SAME_NO_SEG_4       -4
#define SAME_NO_SEG_5       -5
#define SAME_NO_SEG_6       -6
#define SAME_NO_SEG_7       -7
#define SAME_NO_SEG_8       -8
#define SAME_NO_SEG_9       -9

#define SEE_MKT_OPEN       10000        /*  market openning */
#define SEE_MKT_CLOSE      10001        /*  market closed   */
#define SEE_SAME_SEG          10002
#define SEE_DIFF_SEG          10003
#define SEE_SAME_NO_SEG       10004
#define SEE_DIFF_NO_SEG       10005
#define SEE_SAME_KBAR         10006
#define SEE_DIFF_KBAR         10007

#define SEE_START_TICK        10008   // 开机后第一个交易时间段内的tick 

/*
 * 定义内存块
*/




typedef struct  {
    char c_oc_flag ;    /* 'o':open   ;c':close */
    char ca_b[9] ;      /* ca_begin             */
    char ca_e[9] ;      /* ca_end               */

    char ca_15F_start[9] ;
    char ca_20F_start[9] ;
    char ca_30F_start[9] ;
    char ca_1H_start[9] ;
    char ca_2H_start[9] ;
    char ca_3H_start[9] ;
    char ca_4H_start[9] ;
    char ca_5H_start[9] ;
    char ca_1D_start[9] ;

    char ca_15F_end[9] ;
    char ca_20F_end[9] ;
    char ca_30F_end[9] ;
    char ca_1H_end[9] ;
    char ca_2H_end[9] ;
    char ca_3H_end[9] ;
    char ca_4H_end[9] ;
    char ca_5H_end[9] ;
    char ca_1D_end[9] ;
} see_segment_t ;   // 用于记录时间段，目前每个交易时间段为15分钟


typedef struct {
    char ca_begin[9];
    char ca_end[9];
} see_begin_end_t;

typedef struct {
    int             i_hour_type;  /* 不同的交易时间类型 */
    int             period;
    see_begin_end_t * pt_BEs[SEE_SGM_NUM];
} see_BE_t;

typedef struct  {
    int             i_hour_type;  /* 不同的交易时间类型 */
    see_segment_t  *pt_segments[SEE_SGM_NUM] ;
} see_hours_t ;     // 交易时间，用于记录一天的所有的交易时间段  每个期货品种有一个 see_fut_block_t，这个结构中会包含

typedef struct {
//    char    InstrumentID[31];
    char    TradingDay[9];
    char    ActionDay[9];
    char    ca_btime[9];   //begin time
    char    ca_etime[9];  //end time
    double  o ;             // open
    double  c ;             // close
    double  h ;             // high
    double  l ;             // low
    int     v ;             // volume
    int     vsum ;         // keep volume sum
} see_bar_t ;

typedef struct {
    see_bar_t           bar0 ;
    see_bar_t           bar1 ;
    char                c_save ;                    /* 's' 表示 save  'n' 表示 不需要save */
    int                 i_bar_type ;                // 1 2 3 5 10 15   这个值可以用来计算 新来的tick是不是在同一个K
    char                c_bar_type ;                // S F H D W M J Y  BAR_SECOND BAR_MINUTE ...
    char                ca_table[128];                 /* database table name */
    char                ca_home[512];              /* for txt ohlc saving */
    char                ca_file[512];
} see_bar_block_t ;                                 // 每个period有一个bar_block

typedef struct  {
    int                 i_sock;                         // 用于记录 send to python rose 的sock!!
    void   *            v_pub_sock;                         // 用于记录 zmq pub v_sock !!
    void   *            v_sub_sock;                         // 用于记录 zmq pub v_sock !!
    char                InstrumentID[31];
    char                ca_home[512];                   // 用于记录"/home/rabbit/see/dat/rcv_dat/au" 需要初始化
    int                 i_hour_type ;                   // 每个品种的交易时间类型不一样，有的到23:00结束，有的到 01:00
    char                c_oc_flag ;                     //  'o' 'c' 用于记录 收到的tick是不是在交易时间段内 每收到一个记一次
    int                 i_sgm_idx ;                     // 用于记录收到tick时，是在哪个交易时间段内 每收到一个记一次
    see_hours_t         *pt_hour ;                      // 每个品种的交易时间类型 不一样
    see_bar_block_t     bar_block[31] ;                 // 1s 2s 3s ... 1f 2f 3f 5f ... 1h 5h ... 1y tick
    see_shm_t           shm ;                    /* 用于记录sharememory, 每个future有一个shmem */
} see_fut_block_t ;                                         // 每个future 有一个 block !

typedef struct {
    char                InstrumentID[31];
    char                TradingDay[9];
    char                ActionDay[9];
    char                UpdateTime[9];
    double              o ;             // open
    double              c ;             // close
    double              h ;             // high
    double              l ;             // low
    int                 v ;             // volume
} see_bar_save_t ;

typedef struct {
    see_fut_block_t    *pt_fut_block ;
    pthread_cond_t     *cond ;
    pthread_mutex_t    *mutex ;
    int                 period ;
    int                 i_another_day ;
} see_pthread_bar_arg_t ;


typedef struct {
    see_fut_block_t    *pt_fut_block ;
    pthread_cond_t     *cond ;
    pthread_mutex_t    *mutex ;
    int                 period ;
    int                 i_another_day ;
} see_pthread_dat_arg_t ;


typedef struct {
    char                InstrumentID[31];
    char                TradingDay[9];
    char                ActionDay[9];
    char                UpdateTime[9];
    char                c_save ;                        /* 's' 表示 save  'n' 表示 不需要save */
    double              o ;                             // open
    double              c ;                             // close
    double              h ;                             // high
    double              l ;                             // low
    int                 v ;                             // volume
} see_stt_data_t ;                                      // 发送给计算策略的进程！！

typedef struct {
    char        ca_TradingDays  [10000][9] ;
    char        ca_ActionDays   [10000][9] ;
    char        ca_UpdateTimes  [10000][9] ;
    double      oo[10000] ;             // open
    double      cc[10000] ;             // close
    double      hh[10000] ;             // high
    double      ll[10000] ;             // low
    int         vv[10000] ;             // volume
    int         i_cur ;                 /* current point !!!! */
} stt_kkone_t ;


typedef struct node {
    int             period ;
    struct node    *next;
} see_node ;


typedef struct {
    char           ca_future[31];
    char           ca_sttname[31];
    char           ca_actionday_s[9];
    char           ca_actionday_e[9];
    char           ca_updatetime_s[9];
    char           ca_updatetime_e[9];
    int            num;
} stt_command_t;

/* need to be init !!为每个period分配一个 klist_t !! */
/* list for record of strategy period, 1f->5f->30f   */
/*
    需要处理的每个future，都会有一个stt_kkall_t。这里面维护一个 list。
    因为真正的策略，可能会用到不同周期的K柱数据，所以，首先给每个K柱数据块（stt_kkone_t）
    分配一个指针，共31个指针：stt_kkone_t         *pt_ones[31] ;
    在实际中，可能只需要 其中 1f 5f 30f 这三个同期。所以，在初始化时，
    只为这三个同期分配真正的内存块。

    具体是哪个周期，在配置文件中：
*/
typedef struct {
    stt_kkone_t         *pt_ones[31] ;
    int                  p[31];            // 有哪些周期用于计算
    int                  i_num ;           // 有多少个周期用于计算
    int                  idx ;             // 合约在 p_conf->pc_futures中的位置
    see_node            *list ;
} stt_kkall_t ;


#define MOVE_BAR       p_bar0->o = p_bar1->o ; \
                       p_bar0->c = p_bar1->c ; \
                       p_bar0->h = p_bar1->h ; \
                       p_bar0->l = p_bar1->l ; \
                       p_bar0->v = p_bar1->v ;

#define BAR1_TO_BAR0   memcpy(p_bar0->TradingDay,p_bar1->TradingDay,9) ; \
                       memcpy(p_bar0->ca_btime,p_bar1->ca_btime,9) ; \
                       memcpy(p_bar0->ActionDay,p_bar1->ActionDay,9) ; \
                       p_bar0->o = p_bar1->o ; \
                       p_bar0->c = p_bar1->c ; \
                       p_bar0->h = p_bar1->h ; \
                       p_bar0->l = p_bar1->l ; \
                       p_bar0->v = p_bar1->v ;

#define NEW_BAR1       memcpy(p_bar1->TradingDay,tick->TradingDay,9) ; \
                       memcpy(p_bar1->ca_btime,tick->UpdateTime,9) ; \
                       memcpy(p_bar1->ActionDay,tick->ActionDay,9) ; \
                       p_bar1->o = tick->LastPrice ; \
                       p_bar1->c = tick->LastPrice ; \
                       p_bar1->h = tick->LastPrice ; \
                       p_bar1->l = tick->LastPrice ; \
                       p_bar1->vsum = tick->Volume ; \
                       p_bar1->v = 0 ;

#define UPDATE_BAR1    p_bar1->c = tick->LastPrice ; \
                       if (  p_bar1->h < tick->LastPrice ) { p_bar1->h = tick->LastPrice ; } \
                       if (  p_bar1->l > tick->LastPrice ) { p_bar1->l = tick->LastPrice ; } \
                       p_bar1->v    = tick->Volume - p_bar0->vsum ; \
                       p_bar1->vsum = tick->Volume ;

#define FIRST_TICK     if (  p_bar0->h < 0 ) { \
                           memcpy(p_bar0->TradingDay,tick->TradingDay,9) ; \
                           memcpy(p_bar0->ca_btime,tick->UpdateTime,9) ; \
                           memcpy(p_bar0->ActionDay,tick->ActionDay,9) ; \
                           p_bar0->o = tick->LastPrice ; \
                           p_bar0->c = tick->LastPrice ; \
                           p_bar0->h = tick->LastPrice ; \
                           p_bar0->l = tick->LastPrice ; \
                           p_bar0->v = tick->Volume ; \
                           memcpy(p_bar1->TradingDay,tick->TradingDay,9) ; \
                           memcpy(p_bar1->ca_btime,tick->UpdateTime,9) ; \
                           memcpy(p_bar1->ActionDay,tick->ActionDay,9) ; \
                           p_bar1->o = tick->LastPrice ; \
                           p_bar1->c = tick->LastPrice ; \
                           p_bar1->h = tick->LastPrice ; \
                           p_bar1->l = tick->LastPrice ; \
                           p_bar1->v = tick->Volume ; \
                           break ; \
                       }

typedef see_fut_block_t  *PT_BLOCKS     [FUTURE_NUMBER] ;

int see_bars_index_next(int start_index) ;
int see_bars_index_back(int start_index, int n) ;
int see_bars_index_forword(int start_index, int n) ;

int see_bars_load(see_bar_t bars[], int start_index, int n) ;  //从start_index开始装n个bar,装完后，需要将g_bar_cur_index 改成 start_index + n - 1 ;
int see_bars_add(see_bar_t bars[], int start_index) ;    // 规定：g_bar_cur_index 所指的是最后一个K线bar，所以要add一个K线bar时，要将start_index的值设为g_bar_cur_index+1，并在add完成后， g_bar_cur_index 应该是 加1了。

int see_date_comp(char * pca_first, char * pca_last) ;
int see_time_comp(char * pca_first, char * pca_last) ;
see_bar_t * see_create_bar(char * p_future_id, char c_period) ;

int split_string(char *s,char _cmd[SEE_SGM_NUM][20]) ;
int see_time_to_int(char *f) ;
int see_handle_bars(see_fut_block_t *p_block, struct CThostFtdcDepthMarketDataField *tick) ;
int see_send_bar(see_fut_block_t *p_block,char *pc_msg) ;
int see_save_bar(see_fut_block_t * p_block, struct CThostFtdcDepthMarketDataField *tick, int period) ;
int see_save_bar_last(see_fut_block_t *p_block, int period, int i_another_day) ;
int is_weekend(char * pc_day) ;
int is_holiday(char * pc_day) ;
int is_notrade(see_fut_block_t * p_blick,char * time0) ;
int see_first_tick(see_fut_block_t                         *p_block,
                   struct CThostFtdcDepthMarketDataField   *tick,
                   see_bar_t                               *p_bar0,
                   see_bar_t                               *p_bar1,
                   int                                      period) ;
int see_calc_bar_block(see_fut_block_t *p_block, struct CThostFtdcDepthMarketDataField *tick, int period) ;
int is_mkt_open(see_fut_block_t *p_block, struct CThostFtdcDepthMarketDataField *tick) ;

int is_same_k_bar(see_fut_block_t                         *p_block,
                  see_bar_t                               *p_bar1,
                  struct CThostFtdcDepthMarketDataField   *tick,
                  int                                      period);

void *see_pthread_dat(void *) ;
void *see_pthread_bar(void *) ;

#endif
