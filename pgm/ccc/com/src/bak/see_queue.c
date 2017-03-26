
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>


/*
 * find the middle queue element if the queue has odd number of elements
 * or the first element of the queue's second part otherwise
 */

see_queue_t *
see_queue_middle(see_queue_t *queue)
{
    see_queue_t  *middle, *next;

    middle = see_queue_head(queue);

    if (middle == see_queue_last(queue)) {
        return middle;
    }

    next = see_queue_head(queue);

    for ( ;; ) {
        middle = see_queue_next(middle);

        next = see_queue_next(next);

        if (next == see_queue_last(queue)) {
            return middle;
        }

        next = see_queue_next(next);

        if (next == see_queue_last(queue)) {
            return middle;
        }
    }
}


/* the stable insertion sort */

void
see_queue_sort(see_queue_t *queue,
    see_int_t (*cmp)(const see_queue_t *, const see_queue_t *))
{
    see_queue_t  *q, *prev, *next;

    q = see_queue_head(queue);

    if (q == see_queue_last(queue)) {
        return;
    }

    for (q = see_queue_next(q); q != see_queue_sentinel(queue); q = next) {

        prev = see_queue_prev(q);
        next = see_queue_next(q);

        see_queue_remove(q);

        do {
            if (cmp(prev, q) <= 0) {
                break;
            }

            prev = see_queue_prev(prev);

        } while (prev != see_queue_sentinel(queue));

        see_queue_insert_after(prev, q);
    }
}
