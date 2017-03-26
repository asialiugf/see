#ifndef _SEE_STRATEGY_H_INCLUDED_
#define _SEE_STRATEGY_H_INCLUDED_

#include <see_com_common.h>

int see_update_kkall( see_config_t *p_conf, int i_idx );
int see_stt_blocks_init ( see_config_t *p_conf );
int see_stt_blk_init ( see_config_t *p_conf, see_stt_block_t *p_stt_blk, int i_idx );
int see_kkone_init ( see_config_t *p_conf, char *pc_table, int num, see_kkone_t *p_kkone );
int see_trave_dir(char* path, int *p_count, char pc_files[][512]) ;

#endif
