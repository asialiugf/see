
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SEE_QUEUE_H_INCLUDED_
#define _SEE_QUEUE_H_INCLUDED_

#include <see_com_common.h>

typedef struct see_queue_s  see_queue_t;

struct see_queue_s {
    see_queue_t  *prev;
    see_queue_t  *next;
};


#define see_queue_init(q)                                                     \
    (q)->prev = q;                                                            \
    (q)->next = q


#define see_queue_empty(h)                                                    \
    (h == (h)->prev)


#define see_queue_insert_head(h, x)                                           \
    (x)->next = (h)->next;                                                    \
    (x)->next->prev = x;                                                      \
    (x)->prev = h;                                                            \
    (h)->next = x


#define see_queue_insert_after   see_queue_insert_head


#define see_queue_insert_tail(h, x)                                           \
    (x)->prev = (h)->prev;                                                    \
    (x)->prev->next = x;                                                      \
    (x)->next = h;                                                            \
    (h)->prev = x


#define see_queue_head(h)                                                     \
    (h)->next


#define see_queue_last(h)                                                     \
    (h)->prev


#define see_queue_sentinel(h)                                                 \
    (h)


#define see_queue_next(q)                                                     \
    (q)->next


#define see_queue_prev(q)                                                     \
    (q)->prev


#if (SEE_DEBUG)

#define see_queue_remove(x)                                                   \
    (x)->next->prev = (x)->prev;                                              \
    (x)->prev->next = (x)->next;                                              \
    (x)->prev = NULL;                                                         \
    (x)->next = NULL

#else

#define see_queue_remove(x)                                                   \
    (x)->next->prev = (x)->prev;                                              \
    (x)->prev->next = (x)->next

#endif


#define see_queue_split(h, q, n)                                              \
    (n)->prev = (h)->prev;                                                    \
    (n)->prev->next = n;                                                      \
    (n)->next = q;                                                            \
    (h)->prev = (q)->prev;                                                    \
    (h)->prev->next = h;                                                      \
    (q)->prev = n;


#define see_queue_add(h, n)                                                   \
    (h)->prev->next = (n)->next;                                              \
    (n)->next->prev = (h)->prev;                                              \
    (h)->prev = (n)->prev;                                                    \
    (h)->prev->next = h;


#define see_queue_data(q, type, link)                                         \
    (type *) ((u_char *) q - offsetof(type, link))


see_queue_t *see_queue_middle(see_queue_t *queue);
void see_queue_sort(see_queue_t *queue,
    see_int_t (*cmp)(const see_queue_t *, const see_queue_t *));


#endif /* _SEE_QUEUE_H_INCLUDED_ */
