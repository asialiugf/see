
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _NGX_SHMEM_H_INCLUDED_
#define _NGX_SHMEM_H_INCLUDED_


#include <see_com_common.h>


typedef struct {
    u_char      *addr;
    size_t       size;
} see_shm_t;


int see_shm_alloc(see_shm_t *shm);
void see_shm_free(see_shm_t *shm);


#endif /* _NGX_SHMEM_H_INCLUDED_ */
