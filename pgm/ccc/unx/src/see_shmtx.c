
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>


#if (SEE_HAVE_ATOMIC_OPS)


static void see_shmtx_wakeup(see_shmtx_t *mtx);


see_int_t
see_shmtx_create(see_shmtx_t *mtx, see_shmtx_sh_t *addr, u_char *name)
{
    mtx->lock = &addr->lock;

    if (mtx->spin == (see_uint_t) -1) {
        return SEE_OK;
    }

    mtx->spin = 2048;

#if (SEE_HAVE_POSIX_SEM)

    mtx->wait = &addr->wait;

    if (sem_init(&mtx->sem, 1, 0) == -1) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_errno,
                      "sem_init() failed");
    } else {
        mtx->semaphore = 1;
    }

#endif

    return SEE_OK;
}


void
see_shmtx_destroy(see_shmtx_t *mtx)
{
#if (SEE_HAVE_POSIX_SEM)

    if (mtx->semaphore) {
        if (sem_destroy(&mtx->sem) == -1) {
            see_log_error(SEE_LOG_ALERT, see_cycle->log, see_errno,
                          "sem_destroy() failed");
        }
    }

#endif
}


see_uint_t
see_shmtx_trylock(see_shmtx_t *mtx)
{
    return (*mtx->lock == 0 && see_atomic_cmp_set(mtx->lock, 0, see_pid));
}


void
see_shmtx_lock(see_shmtx_t *mtx)
{
    see_uint_t         i, n;

    see_log_debug0(SEE_LOG_DEBUG_CORE, see_cycle->log, 0, "shmtx lock");

    for ( ;; ) {

        if (*mtx->lock == 0 && see_atomic_cmp_set(mtx->lock, 0, see_pid)) {
            return;
        }

        if (see_ncpu > 1) {

            for (n = 1; n < mtx->spin; n <<= 1) {

                for (i = 0; i < n; i++) {
                    see_cpu_pause();
                }

                if (*mtx->lock == 0
                    && see_atomic_cmp_set(mtx->lock, 0, see_pid))
                {
                    return;
                }
            }
        }

#if (SEE_HAVE_POSIX_SEM)

        if (mtx->semaphore) {
            (void) see_atomic_fetch_add(mtx->wait, 1);

            if (*mtx->lock == 0 && see_atomic_cmp_set(mtx->lock, 0, see_pid)) {
                (void) see_atomic_fetch_add(mtx->wait, -1);
                return;
            }

            see_log_debug1(SEE_LOG_DEBUG_CORE, see_cycle->log, 0,
                           "shmtx wait %uA", *mtx->wait);

            while (sem_wait(&mtx->sem) == -1) {
                see_err_t  err;

                err = see_errno;

                if (err != SEE_EINTR) {
                    see_log_error(SEE_LOG_ALERT, see_cycle->log, err,
                                  "sem_wait() failed while waiting on shmtx");
                    break;
                }
            }

            see_log_debug0(SEE_LOG_DEBUG_CORE, see_cycle->log, 0,
                           "shmtx awoke");

            continue;
        }

#endif

        see_sched_yield();
    }
}


void
see_shmtx_unlock(see_shmtx_t *mtx)
{
    if (mtx->spin != (see_uint_t) -1) {
        see_log_debug0(SEE_LOG_DEBUG_CORE, see_cycle->log, 0, "shmtx unlock");
    }

    if (see_atomic_cmp_set(mtx->lock, see_pid, 0)) {
        see_shmtx_wakeup(mtx);
    }
}


see_uint_t
see_shmtx_force_unlock(see_shmtx_t *mtx, see_pid_t pid)
{
    see_log_debug0(SEE_LOG_DEBUG_CORE, see_cycle->log, 0,
                   "shmtx forced unlock");

    if (see_atomic_cmp_set(mtx->lock, pid, 0)) {
        see_shmtx_wakeup(mtx);
        return 1;
    }

    return 0;
}


static void
see_shmtx_wakeup(see_shmtx_t *mtx)
{
#if (SEE_HAVE_POSIX_SEM)
    see_atomic_uint_t  wait;

    if (!mtx->semaphore) {
        return;
    }

    for ( ;; ) {

        wait = *mtx->wait;

        if ((see_atomic_int_t) wait <= 0) {
            return;
        }

        if (see_atomic_cmp_set(mtx->wait, wait, wait - 1)) {
            break;
        }
    }

    see_log_debug1(SEE_LOG_DEBUG_CORE, see_cycle->log, 0,
                   "shmtx wake %uA", wait);

    if (sem_post(&mtx->sem) == -1) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_errno,
                      "sem_post() failed while wake shmtx");
    }

#endif
}


#else


see_int_t
see_shmtx_create(see_shmtx_t *mtx, see_shmtx_sh_t *addr, u_char *name)
{
    if (mtx->name) {

        if (see_strcmp(name, mtx->name) == 0) {
            mtx->name = name;
            return SEE_OK;
        }

        see_shmtx_destroy(mtx);
    }

    mtx->fd = see_open_file(name, SEE_FILE_RDWR, SEE_FILE_CREATE_OR_OPEN,
                            SEE_FILE_DEFAULT_ACCESS);

    if (mtx->fd == SEE_INVALID_FILE) {
        see_log_error(SEE_LOG_EMERG, see_cycle->log, see_errno,
                      see_open_file_n " \"%s\" failed", name);
        return SEE_ERROR;
    }

    if (see_delete_file(name) == SEE_FILE_ERROR) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_errno,
                      see_delete_file_n " \"%s\" failed", name);
    }

    mtx->name = name;

    return SEE_OK;
}


void
see_shmtx_destroy(see_shmtx_t *mtx)
{
    if (see_close_file(mtx->fd) == SEE_FILE_ERROR) {
        see_log_error(SEE_LOG_ALERT, see_cycle->log, see_errno,
                      see_close_file_n " \"%s\" failed", mtx->name);
    }
}


see_uint_t
see_shmtx_trylock(see_shmtx_t *mtx)
{
    see_err_t  err;

    err = see_trylock_fd(mtx->fd);

    if (err == 0) {
        return 1;
    }

    if (err == SEE_EAGAIN) {
        return 0;
    }

#if __osf__ /* Tru64 UNIX */

    if (err == SEE_EACCES) {
        return 0;
    }

#endif

    see_log_abort(err, see_trylock_fd_n " %s failed", mtx->name);

    return 0;
}


void
see_shmtx_lock(see_shmtx_t *mtx)
{
    see_err_t  err;

    err = see_lock_fd(mtx->fd);

    if (err == 0) {
        return;
    }

    see_log_abort(err, see_lock_fd_n " %s failed", mtx->name);
}


void
see_shmtx_unlock(see_shmtx_t *mtx)
{
    see_err_t  err;

    err = see_unlock_fd(mtx->fd);

    if (err == 0) {
        return;
    }

    see_log_abort(err, see_unlock_fd_n " %s failed", mtx->name);
}


see_uint_t
see_shmtx_force_unlock(see_shmtx_t *mtx, see_pid_t pid)
{
    return 0;
}

#endif
