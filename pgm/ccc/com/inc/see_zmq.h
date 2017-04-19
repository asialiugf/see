/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
 */

#ifndef _SEE_ZMQ_H_INCLUDED_
#define _SEE_ZMQ_H_INCLUDED_

#include <see_com_common.h>
void * see_zmq_pub_init( char * pc_url );
void * see_zmq_sub_init( char * pc_url, char *topic );
int see_zmq_pub_send( void * sock, char * pc_msg ) ;
int see_zmq_sub_recv(void *sock, void *buf, size_t len, int flags);

#endif
