/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
 */

#ifndef _SEE_IOFILE_H_INCLUDED_
#define _SEE_IOFILE_H_INCLUDED_

#include <see_com_common.h>

int see_save_line  (char *pc_file_name, char *pc_line ) ;
int see_update_line(char *pc_file_name, char *pc_line ) ;
int see_save_bin(char * pca_file_name, char * pca_buf, int len );
int see_save_tick(char * pca_buf, int len );
int see_disp_tick(char *buf ) ;
#endif
