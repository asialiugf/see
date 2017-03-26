/*
 *  * Copyright (C) AsiaLine
 *   * Copyright (C) kkk, Inc.
 *   */

#ifndef _SEE_FUTURE_H_INCLUDED_
#define _SEE_FUTURE_H_INCLUDED_

#include <see_com_common.h>

#define FUTRUE_ID_LEN  31 
//#define FUTURE_NUMBER  200

#define FUTURE_BLOCK   pp_f_block[i]

//typedef char * PC_FUTURES[FUTURE_NUMBER] ;                      // 合约 名称字串 地址数组    存放合约名称地址的地方
//typedef char  CA_FUTURES [FUTURE_NUMBER][FUTRUE_ID_LEN] ;        // 合约 名称字串数组 真正存放 合约名称的地方

int see_futures_init        ( PC_FUTURES ppfuture_add,CA_FUTURES ppfuture_id) ;
int see_get_future_index    ( PC_FUTURES ppfuture_add, char * pc_future ) ;
int see_block_init          ( see_fut_block_t * p_block, char * pc_future, see_hours_t t_hours[] ) ;
int see_time_to_int         (char *f ) ;
int string_split            (char *s, char _cmd[SEE_SGM_NUM][20]) ;
int string_split1           ( char *s, char ** _cmd, char c_seperater ) ;
int see_trading_hours_init  ( see_hours_t t_hours[] ) ;

#endif /* _SEE_FUTURE_H_INCLUDED_ */
