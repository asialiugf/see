
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */

#ifndef _SEE_COM_THIRD_H_INCLUDED_
#define _SEE_COM_THIRD_H_INCLUDED_

/*
 *  ctp include files
 */
//#include <ThostFtdcMdApi.h>
//#include <ThostFtdcTraderApi.h>
#include <ThostFtdcUserApiDataType.h>
#include <ThostFtdcUserApiStruct.h>

/*
 *  see include files
 */
//#include <errlog.h>
#include <see_talib.h>

/*
 *  libzdb include files
 *  http://www.tildeslash.com/libzdb/
 *  database connection pool 
 */ 
#include <zdb/zdb.h>                      /* libzdb database connection pool */

/*
 *  nanomsg include files
 *  http://nanomsg.org/
 */
#include <nanomsg/nn.h>               /* message queue nanomsg */
#include <nanomsg/pubsub.h>           /* message queue nanomsg */
#include <nanomsg/pipeline.h>           /* message queue nanomsg */
#include <nanomsg/reqrep.h>           /* message queue nanomsg */
#include <nanomsg/survey.h>           /* message queue nanomsg */
#include <nanomsg/pair.h>           /* message queue nanomsg */

/*
 * https://github.com/DaveGamble/cJSON
 */
#include <cjson/cJSON.h>

/*
 * http://zeromq.org/
 * for python:
 * # pip install zmq
 * Requirement already satisfied: zmq in /usr/lib/python2.7/site-packages
 * Requirement already satisfied: pyzmq in /usr/lib64/python2.7/site-packages (from zmq)
 */
#include <zmq.h>

//#include <see_setproctitle.h>

#define _FILE_OFFSET_BITS  64

#endif /* _SEE_COM_THIRD_H_INCLUDED_ */
