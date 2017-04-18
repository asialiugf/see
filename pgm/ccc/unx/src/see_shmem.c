
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <see_com_common.h>
#include <sys/ipc.h>
#include <sys/shm.h>

see_shm_t            gt_shm;

int see_shm_alloc(see_shm_t *shm)
{
    int  id;

    id = shmget(IPC_PRIVATE, shm->size, (SHM_R|SHM_W|IPC_CREAT));

    if (id == -1) {
        see_err_log(0,0,"see_shmem.c: shmget(%uz) failed, errno: %d",shm->size,see_errno) ;
        return SEE_ERROR;
    }

    shm->addr = shmat(id, NULL, 0);

    if (shm->addr == (void *) -1) {
        see_err_log(0,0,"see_shmem.c: shmat() failed!");
    }

    if (shmctl(id, IPC_RMID, NULL) == -1) {
        see_err_log(0,0,"see_shmem.c: shmctl(IPC_RMID) failed");
    }

    return (shm->addr == (void *) -1) ? SEE_ERROR : SEE_OK;
}

void see_shm_free(see_shm_t *shm)
{
    if (shmdt(shm->addr) == -1) {
        see_err_log(0,0,"shmdt(%p) failed errno: ", shm->addr,see_errno);
    }
}
