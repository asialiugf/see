#ifndef _SEE_STRATEGY_H_INCLUDED_
#define _SEE_STRATEGY_H_INCLUDED_

#include <see_com_common.h>

typedef struct {
    char        TradingDays  [10000][9] ;
    char        ActionDays   [10000][9] ;
    char        UpdateTimes  [10000][9] ;
    double      oo[10000] ;             // open
    double      cc[10000] ;             // close
    double      hh[10000] ;             // high
    double      ll[10000] ;             // low
    int         vv[10000] ;             // volume
    int         cur ;                 /* current point !!!! */
} stt_bar_t ;

/*
 *
 */
typedef struct {
    stt_bar_t   *B[31] ;
    int          p[31] ;
} stt_bars_t;

int see_update_kkall( see_config_t *p_conf, int i_idx );
int see_stt_blocks_init ( see_config_t *p_conf );
int see_stt_blk_init ( see_config_t *p_conf, see_stt_block_t *p_stt_blk, int i_idx );
int see_kkone_init ( see_config_t *p_conf, char *pc_table, int num, see_kkone_t *p_kkone );
int see_trave_dir(char* path, int *p_count, char pc_files[][512]) ;
int stt_init(stt_bars_t *K, char *pc_name, cJSON *j_root);

#endif
