#define SEE_CONFIGURE ""

#ifndef SEE_COMPILER
#define SEE_COMPILER  "gcc 4.8.5 20150623 (Red Hat 4.8.5-4) (GCC) "
#endif


#ifndef SEE_HAVE_GCC_ATOMIC
#define SEE_HAVE_GCC_ATOMIC  1
#endif


#ifndef SEE_HAVE_C99_VARIADIC_MACROS
#define SEE_HAVE_C99_VARIADIC_MACROS  1
#endif


#ifndef SEE_HAVE_GCC_VARIADIC_MACROS
#define SEE_HAVE_GCC_VARIADIC_MACROS  1
#endif


#ifndef SEE_HAVE_GCC_BSWAP64
#define SEE_HAVE_GCC_BSWAP64  1
#endif


#ifndef SEE_HAVE_EPOLL
#define SEE_HAVE_EPOLL  1
#endif


#ifndef SEE_HAVE_CLEAR_EVENT
#define SEE_HAVE_CLEAR_EVENT  1
#endif


#ifndef SEE_HAVE_EPOLLRDHUP
#define SEE_HAVE_EPOLLRDHUP  1
#endif


#ifndef SEE_HAVE_O_PATH
#define SEE_HAVE_O_PATH  1
#endif


#ifndef SEE_HAVE_SENDFILE
#define SEE_HAVE_SENDFILE  1
#endif


#ifndef SEE_HAVE_SENDFILE64
#define SEE_HAVE_SENDFILE64  1
#endif


#ifndef SEE_HAVE_PR_SET_DUMPABLE
#define SEE_HAVE_PR_SET_DUMPABLE  1
#endif


#ifndef SEE_HAVE_SCHED_SETAFFINITY
#define SEE_HAVE_SCHED_SETAFFINITY  1
#endif


#ifndef SEE_HAVE_GNU_CRYPT_R
#define SEE_HAVE_GNU_CRYPT_R  1
#endif


#ifndef SEE_HAVE_NONALIGNED
#define SEE_HAVE_NONALIGNED  1
#endif


#ifndef SEE_CPU_CACHE_LINE
#define SEE_CPU_CACHE_LINE  64
#endif


#define SEE_KQUEUE_UDATA_T  (void *)


#ifndef SEE_HAVE_POSIX_FADVISE
#define SEE_HAVE_POSIX_FADVISE  1
#endif


#ifndef SEE_HAVE_O_DIRECT
#define SEE_HAVE_O_DIRECT  1
#endif


#ifndef SEE_HAVE_ALIGNED_DIRECTIO
#define SEE_HAVE_ALIGNED_DIRECTIO  1
#endif


#ifndef SEE_HAVE_STATFS
#define SEE_HAVE_STATFS  1
#endif


#ifndef SEE_HAVE_STATVFS
#define SEE_HAVE_STATVFS  1
#endif


#ifndef SEE_HAVE_DLOPEN
#define SEE_HAVE_DLOPEN  1
#endif


#ifndef SEE_HAVE_SCHED_YIELD
#define SEE_HAVE_SCHED_YIELD  1
#endif


#ifndef SEE_HAVE_REUSEPORT
#define SEE_HAVE_REUSEPORT  1
#endif


#ifndef SEE_HAVE_TRANSPARENT_PROXY
#define SEE_HAVE_TRANSPARENT_PROXY  1
#endif


#ifndef SEE_HAVE_IP_PKTINFO
#define SEE_HAVE_IP_PKTINFO  1
#endif


#ifndef SEE_HAVE_IPV6_RECVPKTINFO
#define SEE_HAVE_IPV6_RECVPKTINFO  1
#endif


#ifndef SEE_HAVE_DEFERRED_ACCEPT
#define SEE_HAVE_DEFERRED_ACCEPT  1
#endif


#ifndef SEE_HAVE_KEEPALIVE_TUNABLE
#define SEE_HAVE_KEEPALIVE_TUNABLE  1
#endif


#ifndef SEE_HAVE_TCP_FASTOPEN
#define SEE_HAVE_TCP_FASTOPEN  1
#endif


#ifndef SEE_HAVE_TCP_INFO
#define SEE_HAVE_TCP_INFO  1
#endif


#ifndef SEE_HAVE_ACCEPT4
#define SEE_HAVE_ACCEPT4  1
#endif


#ifndef SEE_HAVE_EVENTFD
#define SEE_HAVE_EVENTFD  1
#endif


#ifndef SEE_HAVE_SYS_EVENTFD_H
#define SEE_HAVE_SYS_EVENTFD_H  1
#endif


#ifndef SEE_HAVE_UNIX_DOMAIN
#define SEE_HAVE_UNIX_DOMAIN  1
#endif


#ifndef SEE_PTR_SIZE
#define SEE_PTR_SIZE  8
#endif


#ifndef SEE_SIG_ATOMIC_T_SIZE
#define SEE_SIG_ATOMIC_T_SIZE  4
#endif


#ifndef SEE_HAVE_LITTLE_ENDIAN
#define SEE_HAVE_LITTLE_ENDIAN  1
#endif


#ifndef SEE_MAX_SIZE_T_VALUE
#define SEE_MAX_SIZE_T_VALUE  9223372036854775807LL
#endif


#ifndef SEE_SIZE_T_LEN
#define SEE_SIZE_T_LEN  (sizeof("-9223372036854775808") - 1)
#endif


#ifndef SEE_MAX_OFF_T_VALUE
#define SEE_MAX_OFF_T_VALUE  9223372036854775807LL
#endif


#ifndef SEE_OFF_T_LEN
#define SEE_OFF_T_LEN  (sizeof("-9223372036854775808") - 1)
#endif


#ifndef SEE_TIME_T_SIZE
#define SEE_TIME_T_SIZE  8
#endif


#ifndef SEE_TIME_T_LEN
#define SEE_TIME_T_LEN  (sizeof("-9223372036854775808") - 1)
#endif


#ifndef SEE_MAX_TIME_T_VALUE
#define SEE_MAX_TIME_T_VALUE  9223372036854775807LL
#endif


#ifndef SEE_HAVE_PREAD
#define SEE_HAVE_PREAD  1
#endif


#ifndef SEE_HAVE_PWRITE
#define SEE_HAVE_PWRITE  1
#endif


#ifndef SEE_HAVE_PWRITEV
#define SEE_HAVE_PWRITEV  1
#endif


#ifndef SEE_SYS_NERR
#define SEE_SYS_NERR  135
#endif


#ifndef SEE_HAVE_LOCALTIME_R
#define SEE_HAVE_LOCALTIME_R  1
#endif


#ifndef SEE_HAVE_POSIX_MEMALIGN
#define SEE_HAVE_POSIX_MEMALIGN  1
#endif


#ifndef SEE_HAVE_MEMALIGN
#define SEE_HAVE_MEMALIGN  1
#endif


#ifndef SEE_HAVE_MAP_ANON
#define SEE_HAVE_MAP_ANON  1
#endif


#ifndef SEE_HAVE_MAP_DEVZERO
#define SEE_HAVE_MAP_DEVZERO  1
#endif


#ifndef SEE_HAVE_SYSVSHM
#define SEE_HAVE_SYSVSHM  1
#endif


#ifndef SEE_HAVE_POSIX_SEM
#define SEE_HAVE_POSIX_SEM  1
#endif


#ifndef SEE_HAVE_MSGHDR_MSG_CONTROL
#define SEE_HAVE_MSGHDR_MSG_CONTROL  1
#endif


#ifndef SEE_HAVE_FIONBIO
#define SEE_HAVE_FIONBIO  1
#endif


#ifndef SEE_HAVE_GMTOFF
#define SEE_HAVE_GMTOFF  1
#endif


#ifndef SEE_HAVE_D_TYPE
#define SEE_HAVE_D_TYPE  1
#endif


#ifndef SEE_HAVE_SC_NPROCESSORS_ONLN
#define SEE_HAVE_SC_NPROCESSORS_ONLN  1
#endif


#ifndef SEE_HAVE_OPENAT
#define SEE_HAVE_OPENAT  1
#endif


#ifndef SEE_HAVE_GETADDRINFO
#define SEE_HAVE_GETADDRINFO  1
#endif


#ifndef SEE_HTTP_CACHE
#define SEE_HTTP_CACHE  1
#endif


#ifndef SEE_HTTP_GZIP
#define SEE_HTTP_GZIP  1
#endif


#ifndef SEE_HTTP_SSI
#define SEE_HTTP_SSI  1
#endif


#ifndef SEE_CRYPT
#define SEE_CRYPT  1
#endif


#ifndef SEE_HTTP_X_FORWARDED_FOR
#define SEE_HTTP_X_FORWARDED_FOR  1
#endif


#ifndef SEE_HTTP_X_FORWARDED_FOR
#define SEE_HTTP_X_FORWARDED_FOR  1
#endif


#ifndef SEE_HTTP_UPSTREAM_ZONE
#define SEE_HTTP_UPSTREAM_ZONE  1
#endif


#ifndef SEE_PCRE
#define SEE_PCRE  1
#endif


#ifndef SEE_HAVE_PCRE_JIT
#define SEE_HAVE_PCRE_JIT  1
#endif


#ifndef SEE_ZLIB
#define SEE_ZLIB  1
#endif


#ifndef SEE_PREFIX
#define SEE_PREFIX  "/usr/local/nginx/"
#endif


#ifndef SEE_CONF_PREFIX
#define SEE_CONF_PREFIX  "conf/"
#endif


#ifndef SEE_SBIN_PATH
#define SEE_SBIN_PATH  "sbin/nginx"
#endif


#ifndef SEE_CONF_PATH
#define SEE_CONF_PATH  "conf/nginx.conf"
#endif


#ifndef SEE_PID_PATH
#define SEE_PID_PATH  "logs/nginx.pid"
#endif


#ifndef SEE_LOCK_PATH
#define SEE_LOCK_PATH  "logs/nginx.lock"
#endif


#ifndef SEE_ERROR_LOG_PATH
#define SEE_ERROR_LOG_PATH  "logs/error.log"
#endif


#ifndef SEE_HTTP_LOG_PATH
#define SEE_HTTP_LOG_PATH  "logs/access.log"
#endif


#ifndef SEE_HTTP_CLIENT_TEMP_PATH
#define SEE_HTTP_CLIENT_TEMP_PATH  "client_body_temp"
#endif


#ifndef SEE_HTTP_PROXY_TEMP_PATH
#define SEE_HTTP_PROXY_TEMP_PATH  "proxy_temp"
#endif


#ifndef SEE_HTTP_FASTCGI_TEMP_PATH
#define SEE_HTTP_FASTCGI_TEMP_PATH  "fastcgi_temp"
#endif


#ifndef SEE_HTTP_UWSGI_TEMP_PATH
#define SEE_HTTP_UWSGI_TEMP_PATH  "uwsgi_temp"
#endif


#ifndef SEE_HTTP_SCGI_TEMP_PATH
#define SEE_HTTP_SCGI_TEMP_PATH  "scgi_temp"
#endif


#ifndef SEE_SUPPRESS_WARN
#define SEE_SUPPRESS_WARN  1
#endif


#ifndef SEE_SMP
#define SEE_SMP  1
#endif


#ifndef SEE_USER
#define SEE_USER  "nobody"
#endif


#ifndef SEE_GROUP
#define SEE_GROUP  "nobody"
#endif


#ifndef SEE_HAVE_UNISTD_H
#define SEE_HAVE_UNISTD_H  1
#endif


#ifndef SEE_HAVE_INTTYPES_H
#define SEE_HAVE_INTTYPES_H  1
#endif


#ifndef SEE_HAVE_LIMITS_H
#define SEE_HAVE_LIMITS_H  1
#endif


#ifndef SEE_HAVE_SYS_PARAM_H
#define SEE_HAVE_SYS_PARAM_H  1
#endif


#ifndef SEE_HAVE_SYS_MOUNT_H
#define SEE_HAVE_SYS_MOUNT_H  1
#endif


#ifndef SEE_HAVE_SYS_STATVFS_H
#define SEE_HAVE_SYS_STATVFS_H  1
#endif


#ifndef SEE_HAVE_CRYPT_H
#define SEE_HAVE_CRYPT_H  1
#endif


#ifndef SEE_LINUX
#define SEE_LINUX  1
#endif


#ifndef SEE_HAVE_SYS_PRCTL_H
#define SEE_HAVE_SYS_PRCTL_H  1
#endif


#ifndef SEE_HAVE_SYS_VFS_H
#define SEE_HAVE_SYS_VFS_H  1
#endif
