
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>


/*
 * The strerror() messages are copied because:
 *
 * 1) strerror() and strerror_r() functions are not Async-Signal-Safe,
 *    therefore, they cannot be used in signal handlers;
 *
 * 2) a direct sys_errlist[] array may be used instead of these functions,
 *    but Linux linker warns about its usage:
 *
 * warning: `sys_errlist' is deprecated; use `strerror' or `strerror_r' instead
 * warning: `sys_nerr' is deprecated; use `strerror' or `strerror_r' instead
 *
 *    causing false bug reports.
 */


static see_str_t  *see_sys_errlist;
static see_str_t   see_unknown_error = see_string("Unknown error");


u_char *
see_strerror(see_err_t err, u_char *errstr, size_t size)
{
    see_str_t  *msg;

    msg = ((see_uint_t) err < SEE_SYS_NERR) ? &see_sys_errlist[err]:
                                              &see_unknown_error;
    size = see_min(size, msg->len);

    return see_cpymem(errstr, msg->data, size);
}


see_int_t
see_strerror_init(void)
{
    char       *msg;
    u_char     *p;
    size_t      len;
    see_err_t   err;

    /*
     * see_strerror() is not ready to work at this stage, therefore,
     * malloc() is used and possible errors are logged using strerror().
     */

    len = SEE_SYS_NERR * sizeof(see_str_t);

    see_sys_errlist = malloc(len);
    if (see_sys_errlist == NULL) {
        goto failed;
    }

    for (err = 0; err < SEE_SYS_NERR; err++) {
        msg = strerror(err);
        len = see_strlen(msg);

        p = malloc(len);
        if (p == NULL) {
            goto failed;
        }

        see_memcpy(p, msg, len);
        see_sys_errlist[err].len = len;
        see_sys_errlist[err].data = p;
    }

    return SEE_OK;

failed:

    err = errno;
    see_log_stderr(0, "malloc(%uz) failed (%d: %s)", len, err, strerror(err));

    return SEE_ERROR;
}
