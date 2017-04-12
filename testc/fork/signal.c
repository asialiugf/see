#include <signal.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define SIG10 1000
#define see_signal_helper(n)     SIG##n
#define see_signal_value(n)      see_signal_helper(n)

#define see_value_helper(n)      #n
#define see_value(n)             see_value_helper(n)

int main(int argc,char **argv)
{

    printf( "\n%d\n", see_signal_helper(10) );
    printf( "\n%s\n", see_value(100) );

    double y;
    sigset_t intmask;
    int i,repeat_factor;
    if(argc!=2) {
        fprintf(stderr,"Usage：%s repeat_factor\n\a",argv[0]);
        exit(1);
    }
    if((repeat_factor=atoi(argv[1]))<1)repeat_factor=10;
    sigemptyset(&intmask);
    sigaddset(&intmask,SIGINT);
    while(1) {
        sigprocmask(SIG_BLOCK,&intmask,NULL);
        fprintf(stderr,"SIGINT signal blocked\n");
        for(i=0; i<repeat_factor; i++) y=sin((double)i);
        fprintf(stderr,"Blocked calculation is finished\n");

        sigprocmask(SIG_UNBLOCK,&intmask,NULL);
        fprintf(stderr,"SIGINT signal unblocked\n");
        for(i=0; i<repeat_factor; i++) y=sin((double)i);
        fprintf(stderr,"Unblocked calculation is finished\n");
        break;
    }
    exit(0);
}
