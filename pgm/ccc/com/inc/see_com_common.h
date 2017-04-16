
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_COM_COMMON_H_INCLUDED_
#define _SEE_COM_COMMON_H_INCLUDED_

#include <see_com_auto.h>
#include <see_com_third.h>

#if (SEE_FREEBSD)
#include <see_freebsd_config.h>

#elif (SEE_LINUX)
#include <see_com_linux.h>

#elif (SEE_SOLARIS)
#include <see_solaris_config.h>

#elif (SEE_DARWIN)
#include <see_darwin_config.h>

#elif (SEE_WIN32)
#include <see_win32_config.h>

#else /* POSIX */
#include <see_posix_config.h>
#endif

#define  SEE_OK          0
#define  SEE_ERROR      -1
#define  SEE_AGAIN      -2
#define  SEE_BUSY       -3
#define  SEE_DONE       -4
#define  SEE_DECLINED   -5
#define  SEE_ABORT      -6

#define  FUTURE_NUMBER  200
#define  FUTRUE_ID_LEN  31

typedef char         *PC_FUTURES    [FUTURE_NUMBER] ;                      // 合约 名称字串 地址数组    存放合约名称地址的地方
typedef char          CA_FUTURES    [FUTURE_NUMBER][FUTRUE_ID_LEN] ;        // 合约 名称字串数组 真正存放 合约名称的地方
//typedef see_fut_block_t  *PT_BLOCKS     [FUTURE_NUMBER] ;

#include <see_shmem.h>
#include <see_cjson.h>
#include <see_errlog.h>
#include <see_signal.h>
#include <see_daemon.h>
#include <see_pubsub.h>
#include <see_zmq.h>
#include <see_bars.h>
#include <see_future.h>
#include <see_iofile.h>
#include <see_config.h>
#include <see_zdbfun.h>
#include <see_strategy.h>
//#include <../../unx/inc/see_setproctitle.h>
#include <see_setproctitle.h>
#include <see_process.h>

// extern see_hours_t t_hours[SEE_HOUR_TYPE_NUM] ;


#define SEE_NULL    -2147483648
#define SEE_OK      0 
#define LF          (u_char) '\n'
#define CR          (u_char) '\r'
#define CRLF        "\r\n"


#define see_abs(value)       (((value) >= 0) ? (value) : - (value))
#define see_max(val1, val2)  ((val1 < val2) ? (val2) : (val1))
#define see_min(val1, val2)  ((val1 > val2) ? (val2) : (val1))

void see_cpuinfo(void);

#if (SEE_HAVE_OPENAT)
#define SEE_DISABLE_SYMLINKS_OFF        0
#define SEE_DISABLE_SYMLINKS_ON         1
#define SEE_DISABLE_SYMLINKS_NOTOWNER   2
#endif


#define see_tolower(c)              (u_char) ((c >= 'A' && c <= 'Z') ? (c | 0x20) : c)
#define see_toupper(c)              (u_char) ((c >= 'a' && c <= 'z') ? (c & ~0x20) : c)

#define see_strlen(s)               strlen((const char *) s)
#define see_strcmp(s1, s2)          strcmp((const char *) s1, (const char *) s2)
#define see_strncmp(s1, s2, n)      strncmp((const char *) s1, (const char *) s2, n)

#define see_memzero(buf, n)         (void) memset(buf, 0, n)
#define see_memset(buf, c, n)       (void) memset(buf, c, n)
#define see_memcmp(s1, s2, n)       memcmp((const char *) s1, (const char *) s2, n)


typedef     pid_t               see_pid_t;
typedef     int                 see_err_t;
#define     see_errno           errno

#endif /* _SEE_COM_COMMON_H_INCLUDED_ */
