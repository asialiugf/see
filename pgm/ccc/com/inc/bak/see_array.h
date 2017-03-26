
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_ARRAY_H_INCLUDED_
#define _SEE_ARRAY_H_INCLUDED_


#include <see_com_common.h>

typedef struct {
    void        *elts;
    see_uint_t   nelts;
    size_t       size;
    see_uint_t   nalloc;
    see_pool_t  *pool;
} see_array_t;


see_array_t *see_array_create(see_pool_t *p, see_uint_t n, size_t size);
void see_array_destroy(see_array_t *a);
void *see_array_push(see_array_t *a);
void *see_array_push_n(see_array_t *a, see_uint_t n);


static see_inline see_int_t
see_array_init(see_array_t *array, see_pool_t *pool, see_uint_t n, size_t size)
{
    /*
     * set "array->nelts" before "array->elts", otherwise MSVC thinks
     * that "array->nelts" may be used without having been initialized
     */

    array->nelts = 0;
    array->size = size;
    array->nalloc = n;
    array->pool = pool;

    array->elts = see_palloc(pool, n * size);
    if (array->elts == NULL) {
        return SEE_ERROR;
    }

    return SEE_OK;
}


#endif /* _SEE_ARRAY_H_INCLUDED_ */
