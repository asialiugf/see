
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_BUF_H_INCLUDED_
#define _SEE_BUF_H_INCLUDED_


#include <see_com_common.h>


typedef void *            see_buf_tag_t;

typedef struct see_buf_s  see_buf_t;

struct see_buf_s {
    u_char          *pos;
    u_char          *last;
    off_t            file_pos;
    off_t            file_last;

    u_char          *start;         /* start of buffer */
    u_char          *end;           /* end of buffer */
    see_buf_tag_t    tag;
    see_file_t      *file;
    see_buf_t       *shadow;


    /* the buf's content could be changed */
    unsigned         temporary:1;

    /*
     * the buf's content is in a memory cache or in a read only memory
     * and must not be changed
     */
    unsigned         memory:1;

    /* the buf's content is mmap()ed and must not be changed */
    unsigned         mmap:1;

    unsigned         recycled:1;
    unsigned         in_file:1;
    unsigned         flush:1;
    unsigned         sync:1;
    unsigned         last_buf:1;
    unsigned         last_in_chain:1;

    unsigned         last_shadow:1;
    unsigned         temp_file:1;

    /* STUB */ int   num;
};


struct see_chain_s {
    see_buf_t    *buf;
    see_chain_t  *next;
};


typedef struct {
    see_int_t    num;
    size_t       size;
} see_bufs_t;


typedef struct see_output_chain_ctx_s  see_output_chain_ctx_t;

typedef see_int_t (*see_output_chain_filter_pt)(void *ctx, see_chain_t *in);

#if (SEE_HAVE_FILE_AIO)
typedef void (*see_output_chain_aio_pt)(see_output_chain_ctx_t *ctx,
    see_file_t *file);
#endif

struct see_output_chain_ctx_s {
    see_buf_t                   *buf;
    see_chain_t                 *in;
    see_chain_t                 *free;
    see_chain_t                 *busy;

    unsigned                     sendfile:1;
    unsigned                     directio:1;
#if (SEE_HAVE_ALIGNED_DIRECTIO)
    unsigned                     unaligned:1;
#endif
    unsigned                     need_in_memory:1;
    unsigned                     need_in_temp:1;
#if (SEE_HAVE_FILE_AIO || SEE_THREADS)
    unsigned                     aio:1;
#endif

#if (SEE_HAVE_FILE_AIO)
    see_output_chain_aio_pt      aio_handler;
#if (SEE_HAVE_AIO_SENDFILE)
    ssize_t                    (*aio_preload)(see_buf_t *file);
#endif
#endif

#if (SEE_THREADS)
    see_int_t                  (*thread_handler)(see_thread_task_t *task,
                                                 see_file_t *file);
    see_thread_task_t           *thread_task;
#endif

    off_t                        alignment;

    see_pool_t                  *pool;
    see_int_t                    allocated;
    see_bufs_t                   bufs;
    see_buf_tag_t                tag;

    see_output_chain_filter_pt   output_filter;
    void                        *filter_ctx;
};


typedef struct {
    see_chain_t                 *out;
    see_chain_t                **last;
    see_connection_t            *connection;
    see_pool_t                  *pool;
    off_t                        limit;
} see_chain_writer_ctx_t;


#define SEE_CHAIN_ERROR     (see_chain_t *) SEE_ERROR


#define see_buf_in_memory(b)        (b->temporary || b->memory || b->mmap)
#define see_buf_in_memory_only(b)   (see_buf_in_memory(b) && !b->in_file)

#define see_buf_special(b)                                                   \
    ((b->flush || b->last_buf || b->sync)                                    \
     && !see_buf_in_memory(b) && !b->in_file)

#define see_buf_sync_only(b)                                                 \
    (b->sync                                                                 \
     && !see_buf_in_memory(b) && !b->in_file && !b->flush && !b->last_buf)

#define see_buf_size(b)                                                      \
    (see_buf_in_memory(b) ? (off_t) (b->last - b->pos):                      \
                            (b->file_last - b->file_pos))

see_buf_t *see_create_temp_buf(see_pool_t *pool, size_t size);
see_chain_t *see_create_chain_of_bufs(see_pool_t *pool, see_bufs_t *bufs);


#define see_alloc_buf(pool)  see_palloc(pool, sizeof(see_buf_t))
#define see_calloc_buf(pool) see_pcalloc(pool, sizeof(see_buf_t))

see_chain_t *see_alloc_chain_link(see_pool_t *pool);
#define see_free_chain(pool, cl)                                             \
    cl->next = pool->chain;                                                  \
    pool->chain = cl



see_int_t see_output_chain(see_output_chain_ctx_t *ctx, see_chain_t *in);
see_int_t see_chain_writer(void *ctx, see_chain_t *in);

see_int_t see_chain_add_copy(see_pool_t *pool, see_chain_t **chain,
    see_chain_t *in);
see_chain_t *see_chain_get_free_buf(see_pool_t *p, see_chain_t **free);
void see_chain_update_chains(see_pool_t *p, see_chain_t **free,
    see_chain_t **busy, see_chain_t **out, see_buf_tag_t tag);

off_t see_chain_coalesce_file(see_chain_t **in, off_t limit);

see_chain_t *see_chain_update_sent(see_chain_t *in, off_t sent);

#endif /* _SEE_BUF_H_INCLUDED_ */
