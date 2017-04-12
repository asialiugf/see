
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_SETPROCTITLE_H_INCLUDED_
#define _SEE_SETPROCTITLE_H_INCLUDED_

void setproctitle_init(int argc, char **argv, char **envp);
void setproctitle(const char *fmt, ...);

#endif /* _SEE_SETPROCTITLE_H_INCLUDED_ */
