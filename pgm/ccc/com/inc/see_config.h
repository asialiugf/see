/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
 */

#ifndef _SEE_CONFIG_H_INCLUDED_
#define _SEE_CONFIG_H_INCLUDED_

#include <see_com_common.h>

typedef struct {
    int                 i_log_level ;
    char                c_test;                 /* 开机参数："t"：测试环境  "p"：生产环境  */
    char                ca_futures              [FUTURE_NUMBER][FUTRUE_ID_LEN] ;
    char               *pc_futures              [FUTURE_NUMBER] ;
    int                 i_future_num ;
    int                 i_idx ;                 // future 数组下标

    char                ca_nn_pair_url          [512] ;
    int                 i_pair_sock;
    char                ca_nn_topy_url          [512] ;
    int                 i_topy_sock;
    char                ca_zmq_pubsub_url       [512] ;
    void               *v_sock;

    char                ca_nn_pubsub_url        [512] ;
    int                 i_pubsub_sock;
    char                ca_db_url               [512] ;
    char                ca_home                 [512] ;
    stt_kkall_t    *pt_stt_blks             [FUTURE_NUMBER] ;
    see_fut_block_t    *pt_fut_blks             [FUTURE_NUMBER] ;
    see_hours_t         t_hours                 [SEE_HOUR_TYPE_NUM] ;

    cJSON              *j_conf ;

    pthread_t           p_dat;
    pthread_t           p_bar;

    pthread_cond_t      cond_dat ;
    pthread_cond_t      cond_bar ;
    pthread_mutex_t     mutex_dat ;
    pthread_mutex_t     mutex_bar ;

    see_pthread_bar_arg_t  t_bar_arg ; 
    see_pthread_dat_arg_t  t_dat_arg ; 

    URL_T                   z_url ;
    ConnectionPool_T        z_pool ;
    Connection_T            z_con ;
    PreparedStatement_T     z_statement ;

} see_config_t ;

int see_config_init( see_config_t *p_conf );
int see_get_index( see_config_t *p_conf, char *pc_future );

extern see_config_t         gt_conf;
extern see_config_t        *gp_conf;

#endif
