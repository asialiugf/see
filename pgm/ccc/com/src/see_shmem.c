
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_config.h>
#include <see_core.h>
#include <sys/ipc.h>
#include <sys/shm.h>

see_int_t
see_shm_alloc(see_shm_t *shm)
{
    int  id;

    id = shmget(IPC_PRIVATE, shm->size, (SHM_R|SHM_W|IPC_CREAT));

    if (id == -1) {
        see_log_error(SEE_LOG_ALERT, shm->log, see_errno,
                      "shmget(%uz) failed", shm->size);
        return SEE_ERROR;
    }

    see_log_debug1(SEE_LOG_DEBUG_CORE, shm->log, 0, "shmget id: %d", id);

    shm->addr = shmat(id, NULL, 0);

    if (shm->addr == (void *) -1) {
        see_log_error(SEE_LOG_ALERT, shm->log, see_errno, "shmat() failed");
    }

    if (shmctl(id, IPC_RMID, NULL) == -1) {
        see_log_error(SEE_LOG_ALERT, shm->log, see_errno,
                      "shmctl(IPC_RMID) failed");
    }

    return (shm->addr == (void *) -1) ? SEE_ERROR : SEE_OK;
}


void
see_shm_free(see_shm_t *shm)
{
    if (shmdt(shm->addr) == -1) {
        see_log_error(SEE_LOG_ALERT, shm->log, see_errno,
                      "shmdt(%p) failed", shm->addr);
    }
}
