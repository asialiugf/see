/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
*/


#ifndef _SEE_PUBSUB_H_INCLUDED_
#define _SEE_PUBSUB_H_INCLUDED_


#include <see_com_common.h>

char * see_date () ;
int see_pipeline_server (const char *url) ;
int see_pipeline_client (const char *url) ;
int see_pair_server(const char *url) ;
int see_pair_client(const char *url) ;

#endif /* _SEE_PUBSUB_H_INCLUDED_ */
