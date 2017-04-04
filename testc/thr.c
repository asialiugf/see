
#include<stdio.h>
#include <sys/time.h>
#include<unistd.h>
#include <pthread.h>
#include<errno.h>
 
static pthread_t thread;
static pthread_cond_t cond;
static pthread_mutex_t mutex;
static int flag = 1;
 
void * thr_fn(void * arg) 
{
    struct timeval now;
    struct timespec outtime;
    pthread_mutex_lock(&mutex);
    while (flag) {
        printf("*****\n");
        gettimeofday(&now, NULL);
        outtime.tv_sec = now.tv_sec + 5;
        outtime.tv_nsec = now.tv_usec * 1000;
        pthread_cond_timedwait(&cond, &mutex, &outtime);
    }
    pthread_mutex_unlock(&mutex);
    printf("cond thread exit\n");
}
 
int main(void) 
{
    pthread_mutex_init(&mutex,NULL);
    pthread_cond_init(&cond, NULL);
    if(0 != pthread_create(&thread, NULL, thr_fn, NULL)) {
        printf("error when create pthread,%d\n", errno);
        return 1;
    }
    char c ;
    while ((c =getchar()) != 'q');
    printf("Now terminate thethread!\n");

    pthread_mutex_lock(&mutex);
    flag = 0;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
    printf("Wait forthread to exit\n");
    pthread_join(thread, NULL);
    printf("Bye\n");
    return 0;
}
