
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_ERRNO_H_INCLUDED_
#define _SEE_ERRNO_H_INCLUDED_


#include <see_com_common.h>


typedef int               see_err_t;

#define SEE_EPERM         EPERM
#define SEE_ENOENT        ENOENT
#define SEE_ENOPATH       ENOENT
#define SEE_ESRCH         ESRCH
#define SEE_EINTR         EINTR
#define SEE_ECHILD        ECHILD
#define SEE_ENOMEM        ENOMEM
#define SEE_EACCES        EACCES
#define SEE_EBUSY         EBUSY
#define SEE_EEXIST        EEXIST
#define SEE_EEXIST_FILE   EEXIST
#define SEE_EXDEV         EXDEV
#define SEE_ENOTDIR       ENOTDIR
#define SEE_EISDIR        EISDIR
#define SEE_EINVAL        EINVAL
#define SEE_ENFILE        ENFILE
#define SEE_EMFILE        EMFILE
#define SEE_ENOSPC        ENOSPC
#define SEE_EPIPE         EPIPE
#define SEE_EINPROGRESS   EINPROGRESS
#define SEE_ENOPROTOOPT   ENOPROTOOPT
#define SEE_EOPNOTSUPP    EOPNOTSUPP
#define SEE_EADDRINUSE    EADDRINUSE
#define SEE_ECONNABORTED  ECONNABORTED
#define SEE_ECONNRESET    ECONNRESET
#define SEE_ENOTCONN      ENOTCONN
#define SEE_ETIMEDOUT     ETIMEDOUT
#define SEE_ECONNREFUSED  ECONNREFUSED
#define SEE_ENAMETOOLONG  ENAMETOOLONG
#define SEE_ENETDOWN      ENETDOWN
#define SEE_ENETUNREACH   ENETUNREACH
#define SEE_EHOSTDOWN     EHOSTDOWN
#define SEE_EHOSTUNREACH  EHOSTUNREACH
#define SEE_ENOSYS        ENOSYS
#define SEE_ECANCELED     ECANCELED
#define SEE_EILSEQ        EILSEQ
#define SEE_ENOMOREFILES  0
#define SEE_ELOOP         ELOOP
#define SEE_EBADF         EBADF

#if (SEE_HAVE_OPENAT)
#define SEE_EMLINK        EMLINK
#endif

#if (__hpux__)
#define SEE_EAGAIN        EWOULDBLOCK
#else
#define SEE_EAGAIN        EAGAIN
#endif


#define see_errno                  errno
#define see_socket_errno           errno
#define see_set_errno(err)         errno = err
#define see_set_socket_errno(err)  errno = err


u_char *see_strerror(see_err_t err, u_char *errstr, size_t size);
see_int_t see_strerror_init(void);


#endif /* _SEE_ERRNO_H_INCLUDED_ */
