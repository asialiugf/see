
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_SETPROCTITLE_H_INCLUDED_
#define _SEE_SETPROCTITLE_H_INCLUDED_


#if (SEE_HAVE_SETPROCTITLE)

/* FreeBSD, NetBSD, OpenBSD */

#define see_init_setproctitle(log) SEE_OK
#define see_setproctitle(title)    setproctitle("%s", title)


#else /* !SEE_HAVE_SETPROCTITLE */

#if !defined SEE_SETPROCTITLE_USES_ENV

#if (SEE_SOLARIS)

#define SEE_SETPROCTITLE_USES_ENV  1
#define SEE_SETPROCTITLE_PAD       ' '

see_int_t see_init_setproctitle(see_log_t *log);
void see_setproctitle(char *title);

#elif (SEE_LINUX) || (SEE_DARWIN)

#define SEE_SETPROCTITLE_USES_ENV  1
#define SEE_SETPROCTITLE_PAD       '\0'

see_int_t see_init_setproctitle(see_log_t *log);
void see_setproctitle(char *title);

#else

#define see_init_setproctitle(log) SEE_OK
#define see_setproctitle(title)

#endif /* OSes */

#endif /* SEE_SETPROCTITLE_USES_ENV */

#endif /* SEE_HAVE_SETPROCTITLE */


#endif /* _SEE_SETPROCTITLE_H_INCLUDED_ */
