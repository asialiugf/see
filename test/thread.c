#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <memory.h>


int count = 0;
//#define 30 30

pthread_cond_t cond ;
pthread_mutex_t mutex ;
struct prodcons {
 pthread_mutex_t lock;
 pthread_cond_t condd[30];
 int ref;
};

struct prodcons buffer;
int init(struct prodcons *b)
{
    int i = 0;
    pthread_mutex_init(&b->lock, NULL);
    for (i = 0; i < 30; i++) {
        pthread_cond_init(&b->condd[i], NULL);
    }
    b->ref = 0;
}

void put(struct prodcons *b, int data, int sig)
{
 while(1) {
    pthread_mutex_lock(&b->lock);
    b->ref |= (1 << sig);
    pthread_cond_wait(&b->condd[sig], &b->lock);
    b->ref &= ~(1 << sig);
    count++;
    printf("signal: %d data: %d count:%d\n", sig, data, count);

        struct timeval now;
        struct timespec outtime;
        printf("*****\n");
        gettimeofday(&now, NULL);
        printf("%d----->%d\n", now.tv_sec, now.tv_usec);

        memset(&outtime, 0, sizeof(outtime));
        clock_gettime(CLOCK_REALTIME, &outtime);
        printf("%d----->%d\n", outtime.tv_sec, outtime.tv_nsec);

        outtime.tv_sec = now.tv_sec + 3 ;
        outtime.tv_nsec = now.tv_usec * 1000;

        printf("new !!!%d----->%d\n", outtime.tv_sec, outtime.tv_nsec);

        time_t nw;
        struct tm   *timenow;

        time(&nw);
        timenow = localtime(&nw);
        printf("recent time is : %s \n", asctime(timenow));
        printf("recent time is tm_sec : %d \n", timenow->tm_sec);
        printf("recent time is tm_min : %d \n", timenow->tm_min);
        printf("recent time is tm_hour : %d \n", timenow->tm_hour);
        printf("recent time is tm_mday : %d \n", timenow->tm_mday);
        printf("recent time is tm_mon : %d \n", timenow->tm_mon);
        printf("recent time is tm_year : %d \n", timenow->tm_year);
        printf("recent time is tm_wday : %d \n", timenow->tm_wday);
        printf("recent time is tm_yday : %d \n", timenow->tm_yday);
        printf("recent time is tm_isdst : %d \n", timenow->tm_isdst);

        pthread_cond_timedwait(&cond, &mutex, &outtime);    
        printf("new 222222 !!!%d----->%d\n", outtime.tv_sec, outtime.tv_nsec);

    pthread_mutex_unlock(&b->lock);

     int tmp;
     while( !(tmp = (b->ref & (1 << ((sig + 1) % 30)))) )
         printf("while-tmp:%d\n", tmp);
         pthread_cond_signal(&b->condd[(sig + 1) % 30]);
    }
}

void producer_put(int x)
{
    printf("starting pthread:%d\n", x);
    put(&buffer, x, x);
    return;
}

void *producer(void *data)
{
 int d = *(int *)data;
producer_put(d);
 return NULL;
}

int main(void)
{
    int i;
    int resource[30];
    pthread_t p[30];
    void *retval;
    init(&buffer);
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond, NULL);

    for (i = 0; i < 30; i++) {
        resource[i] = i;
        pthread_create(&p[i], NULL, producer, &resource[i]);
    }

    printf("Starting %d pthreads...n Pthreads would print numbers one by one~nn", 30);
    while(buffer.ref != ((1 << 30) - 1));
    printf("Sending signal[0] to trigger a start\n");
    sleep(1);
    pthread_cond_signal(&buffer.condd[0]);

    //    pthread_join(p[0], &retval);

    //for (i = 0; i < 30; i++) {
    //    printf ( "teeeeeetttttttttttttttt\n" ) ;
    //    pthread_join(p[i], &retval);
    //}
    while(1)
    {
        count++ ;
        sleep(1) ;
    }
 return 0;
}

