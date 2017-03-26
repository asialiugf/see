/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
 */

#include <see_com_common.h>


int 
see_daemon( int nochdir,int noclose )
{
    int rtn = 0 ;
    int fd ;
    switch (fork()) {
        case -1:
            return (-1);
        case 0:
            break;
        default:
            exit(0);
    }

    if (setsid() == -1)
        return (-1);
    if (nochdir == 0) {
        if(chdir("/") != 0) {
            perror("chdir");
            return (-1);
        }
    }

    if (setpgrp() == -1){
        return -1;
    }

    signal(SIGHUP, SIG_IGN);

    switch (fork()) {
        case -1: 
            return (-1);
        case 0:
            break;
        default:
            exit(0);
    }   

    if (noclose == 0 && (fd = open("/dev/null", O_RDWR, 0)) != -1) {
        if(dup2(fd, STDIN_FILENO) < 0) {
            perror("dup2 stdin");
            return (-1);
        }
        if(dup2(fd, STDOUT_FILENO) < 0) {
            perror("dup2 stdout");
            return (-1);
        }
        if(dup2(fd, STDERR_FILENO) < 0) {
            perror("dup2 stderr");
            return (-1);
        }

        if (fd > STDERR_FILENO) {
            if(close(fd) < 0) {
                perror("close");
               return (-1);
            }
       }
    }
    return (rtn);
}
