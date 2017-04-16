/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
 */

#ifndef _SEE_ZDBFUN_H_INCLUDED_
#define _SEE_ZDBFUN_H_INCLUDED_

#include <see_com_common.h>


int see_zdb_open( see_config_t *p_conf );
int see_zdb_close( see_config_t *p_conf );
int see_zdb_insert_file( see_config_t *p_conf, char *pc_filename, char *pc_table );
int see_zdb_create_table( see_config_t *p_conf, char *pc_table );
int see_zdb_get_data(   see_config_t   *p_conf,
                        char           *pc_table,
                        char           *pc_actionday_s,
                        char           *pc_actionday_e,
                        char           *pc_updatetime_s,
                        char           *pc_updatetime_e,
                        int             num,
                        stt_kkone_t    *p_kkone );


#endif
