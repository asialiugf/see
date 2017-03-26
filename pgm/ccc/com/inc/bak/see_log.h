
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_LOG_H_INCLUDED_
#define _SEE_LOG_H_INCLUDED_


#include <see_com_common.h>
#include <see_core.h>


#define SEE_LOG_STDERR            0
#define SEE_LOG_EMERG             1
#define SEE_LOG_ALERT             2
#define SEE_LOG_CRIT              3
#define SEE_LOG_ERR               4
#define SEE_LOG_WARN              5
#define SEE_LOG_NOTICE            6
#define SEE_LOG_INFO              7
#define SEE_LOG_DEBUG             8

#define SEE_LOG_DEBUG_CORE        0x010
#define SEE_LOG_DEBUG_ALLOC       0x020
#define SEE_LOG_DEBUG_MUTEX       0x040
#define SEE_LOG_DEBUG_EVENT       0x080
#define SEE_LOG_DEBUG_HTTP        0x100
#define SEE_LOG_DEBUG_MAIL        0x200
#define SEE_LOG_DEBUG_STREAM      0x400

/*
 * do not forget to update debug_levels[] in src/core/see_log.c
 * after the adding a new debug level
 */

#define SEE_LOG_DEBUG_FIRST       SEE_LOG_DEBUG_CORE
#define SEE_LOG_DEBUG_LAST        SEE_LOG_DEBUG_STREAM
#define SEE_LOG_DEBUG_CONNECTION  0x80000000
#define SEE_LOG_DEBUG_ALL         0x7ffffff0


typedef u_char *(*see_log_handler_pt) (see_log_t *log, u_char *buf, size_t len);
typedef void (*see_log_writer_pt) (see_log_t *log, see_uint_t level,
    u_char *buf, size_t len);


struct see_log_s {
    see_uint_t           log_level;
    see_open_file_t     *file;

    see_atomic_uint_t    connection;

    time_t               disk_full_time;

    see_log_handler_pt   handler;
    void                *data;

    see_log_writer_pt    writer;
    void                *wdata;

    /*
     * we declare "action" as "char *" because the actions are usually
     * the static strings and in the "u_char *" case we have to override
     * their types all the time
     */

    char                *action;

    see_log_t           *next;
};


#define SEE_MAX_ERROR_STR   2048


/*********************************/

#if (SEE_HAVE_C99_VARIADIC_MACROS)

#define SEE_HAVE_VARIADIC_MACROS  1

#define see_log_error(level, log, ...)                                        \
    if ((log)->log_level >= level) see_log_error_core(level, log, __VA_ARGS__)

void see_log_error_core(see_uint_t level, see_log_t *log, see_err_t err,
    const char *fmt, ...);

#define see_log_debug(level, log, ...)                                        \
    if ((log)->log_level & level)                                             \
        see_log_error_core(SEE_LOG_DEBUG, log, __VA_ARGS__)

/*********************************/

#elif (SEE_HAVE_GCC_VARIADIC_MACROS)

#define SEE_HAVE_VARIADIC_MACROS  1

#define see_log_error(level, log, args...)                                    \
    if ((log)->log_level >= level) see_log_error_core(level, log, args)

void see_log_error_core(see_uint_t level, see_log_t *log, see_err_t err,
    const char *fmt, ...);

#define see_log_debug(level, log, args...)                                    \
    if ((log)->log_level & level)                                             \
        see_log_error_core(SEE_LOG_DEBUG, log, args)

/*********************************/

#else /* no variadic macros */

#define SEE_HAVE_VARIADIC_MACROS  0

void see_cdecl see_log_error(see_uint_t level, see_log_t *log, see_err_t err,
    const char *fmt, ...);
void see_log_error_core(see_uint_t level, see_log_t *log, see_err_t err,
    const char *fmt, va_list args);
void see_cdecl see_log_debug_core(see_log_t *log, see_err_t err,
    const char *fmt, ...);


#endif /* variadic macros */


/*********************************/

#if (SEE_DEBUG)

#if (SEE_HAVE_VARIADIC_MACROS)

#define see_log_debug0(level, log, err, fmt)                                  \
        see_log_debug(level, log, err, fmt)

#define see_log_debug1(level, log, err, fmt, arg1)                            \
        see_log_debug(level, log, err, fmt, arg1)

#define see_log_debug2(level, log, err, fmt, arg1, arg2)                      \
        see_log_debug(level, log, err, fmt, arg1, arg2)

#define see_log_debug3(level, log, err, fmt, arg1, arg2, arg3)                \
        see_log_debug(level, log, err, fmt, arg1, arg2, arg3)

#define see_log_debug4(level, log, err, fmt, arg1, arg2, arg3, arg4)          \
        see_log_debug(level, log, err, fmt, arg1, arg2, arg3, arg4)

#define see_log_debug5(level, log, err, fmt, arg1, arg2, arg3, arg4, arg5)    \
        see_log_debug(level, log, err, fmt, arg1, arg2, arg3, arg4, arg5)

#define see_log_debug6(level, log, err, fmt,                                  \
                       arg1, arg2, arg3, arg4, arg5, arg6)                    \
        see_log_debug(level, log, err, fmt,                                   \
                       arg1, arg2, arg3, arg4, arg5, arg6)

#define see_log_debug7(level, log, err, fmt,                                  \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7)              \
        see_log_debug(level, log, err, fmt,                                   \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7)

#define see_log_debug8(level, log, err, fmt,                                  \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)        \
        see_log_debug(level, log, err, fmt,                                   \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)


#else /* no variadic macros */

#define see_log_debug0(level, log, err, fmt)                                  \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt)

#define see_log_debug1(level, log, err, fmt, arg1)                            \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt, arg1)

#define see_log_debug2(level, log, err, fmt, arg1, arg2)                      \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt, arg1, arg2)

#define see_log_debug3(level, log, err, fmt, arg1, arg2, arg3)                \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt, arg1, arg2, arg3)

#define see_log_debug4(level, log, err, fmt, arg1, arg2, arg3, arg4)          \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt, arg1, arg2, arg3, arg4)

#define see_log_debug5(level, log, err, fmt, arg1, arg2, arg3, arg4, arg5)    \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt, arg1, arg2, arg3, arg4, arg5)

#define see_log_debug6(level, log, err, fmt,                                  \
                       arg1, arg2, arg3, arg4, arg5, arg6)                    \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt, arg1, arg2, arg3, arg4, arg5, arg6)

#define see_log_debug7(level, log, err, fmt,                                  \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7)              \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt,                                     \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7)

#define see_log_debug8(level, log, err, fmt,                                  \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)        \
    if ((log)->log_level & level)                                             \
        see_log_debug_core(log, err, fmt,                                     \
                       arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)

#endif

#else /* !SEE_DEBUG */

#define see_log_debug0(level, log, err, fmt)
#define see_log_debug1(level, log, err, fmt, arg1)
#define see_log_debug2(level, log, err, fmt, arg1, arg2)
#define see_log_debug3(level, log, err, fmt, arg1, arg2, arg3)
#define see_log_debug4(level, log, err, fmt, arg1, arg2, arg3, arg4)
#define see_log_debug5(level, log, err, fmt, arg1, arg2, arg3, arg4, arg5)
#define see_log_debug6(level, log, err, fmt, arg1, arg2, arg3, arg4, arg5, arg6)
#define see_log_debug7(level, log, err, fmt, arg1, arg2, arg3, arg4, arg5,    \
                       arg6, arg7)
#define see_log_debug8(level, log, err, fmt, arg1, arg2, arg3, arg4, arg5,    \
                       arg6, arg7, arg8)

#endif

/*********************************/

see_log_t *see_log_init(u_char *prefix);
void see_cdecl see_log_abort(see_err_t err, const char *fmt, ...);
void see_cdecl see_log_stderr(see_err_t err, const char *fmt, ...);
u_char *see_log_errno(u_char *buf, u_char *last, see_err_t err);
see_int_t see_log_open_default(see_cycle_t *cycle);
see_int_t see_log_redirect_stderr(see_cycle_t *cycle);
see_log_t *see_log_get_file_log(see_log_t *head);
char *see_log_set_log(see_conf_t *cf, see_log_t **head);


/*
 * see_write_stderr() cannot be implemented as macro, since
 * MSVC does not allow to use #ifdef inside macro parameters.
 *
 * see_write_fd() is used instead of see_write_console(), since
 * CharToOemBuff() inside see_write_console() cannot be used with
 * read only buffer as destination and CharToOemBuff() is not needed
 * for see_write_stderr() anyway.
 */
static see_inline void
see_write_stderr(char *text)
{
    (void) see_write_fd(see_stderr, text, see_strlen(text));
}


static see_inline void
see_write_stdout(char *text)
{
    (void) see_write_fd(see_stdout, text, see_strlen(text));
}


extern see_module_t  see_errlog_module;
extern see_uint_t    see_use_stderr;


#endif /* _SEE_LOG_H_INCLUDED_ */
