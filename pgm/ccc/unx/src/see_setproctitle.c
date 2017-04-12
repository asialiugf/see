
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>


#if (SEE_SETPROCTITLE_USES_ENV)

/*
 * To change the process title in Linux and Solaris we have to set argv[1]
 * to NULL and to copy the title to the same place where the argv[0] points to.
 * However, argv[0] may be too small to hold a new title.  Fortunately, Linux
 * and Solaris store argv[] and environ[] one after another.  So we should
 * ensure that is the continuous memory and then we allocate the new memory
 * for environ[] and copy it.  After this we could use the memory starting
 * from argv[0] for our process title.
 *
 * The Solaris's standard /bin/ps does not show the changed process title.
 * You have to use "/usr/ucb/ps -w" instead.  Besides, the UCB ps does not
 * show a new title if its length less than the origin command line length.
 * To avoid it we append to a new title the origin command line in the
 * parenthesis.
 */

extern char **environ;

static char *see_os_argv_last;

see_int_t
see_init_setproctitle(see_log_t *log)
{
    u_char      *p;
    size_t       size;
    see_uint_t   i;

    size = 0;

    for (i = 0; environ[i]; i++) {
        size += see_strlen(environ[i]) + 1;
    }

    p = see_alloc(size, log);
    if (p == NULL) {
        return SEE_ERROR;
    }

    see_os_argv_last = see_os_argv[0];

    for (i = 0; see_os_argv[i]; i++) {
        if (see_os_argv_last == see_os_argv[i]) {
            see_os_argv_last = see_os_argv[i] + see_strlen(see_os_argv[i]) + 1;
        }
    }

    for (i = 0; environ[i]; i++) {
        if (see_os_argv_last == environ[i]) {

            size = see_strlen(environ[i]) + 1;
            see_os_argv_last = environ[i] + size;

            see_cpystrn(p, (u_char *) environ[i], size);
            environ[i] = (char *) p;
            p += size;
        }
    }

    see_os_argv_last--;

    return SEE_OK;
}


void
see_setproctitle(char *title)
{
    u_char     *p;

#if (SEE_SOLARIS)

    see_int_t   i;
    size_t      size;

#endif

    see_os_argv[1] = NULL;

    p = see_cpystrn((u_char *) see_os_argv[0], (u_char *) "nginx: ",
                    see_os_argv_last - see_os_argv[0]);

    p = see_cpystrn(p, (u_char *) title, see_os_argv_last - (char *) p);

#if (SEE_SOLARIS)

    size = 0;

    for (i = 0; i < see_argc; i++) {
        size += see_strlen(see_argv[i]) + 1;
    }

    if (size > (size_t) ((char *) p - see_os_argv[0])) {

        /*
         * see_setproctitle() is too rare operation so we use
         * the non-optimized copies
         */

        p = see_cpystrn(p, (u_char *) " (", see_os_argv_last - (char *) p);

        for (i = 0; i < see_argc; i++) {
            p = see_cpystrn(p, (u_char *) see_argv[i],
                            see_os_argv_last - (char *) p);
            p = see_cpystrn(p, (u_char *) " ", see_os_argv_last - (char *) p);
        }

        if (*(p - 1) == ' ') {
            *(p - 1) = ')';
        }
    }

#endif

    if (see_os_argv_last - (char *) p) {
        see_memset(p, SEE_SETPROCTITLE_PAD, see_os_argv_last - (char *) p);
    }

    see_log_debug1(SEE_LOG_DEBUG_CORE, see_cycle->log, 0,
                   "setproctitle: \"%s\"", see_os_argv[0]);
}

#endif /* SEE_SETPROCTITLE_USES_ENV */
