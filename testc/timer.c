#include <sys/time.h>  
#include <sys/select.h>  
#include <time.h>  
#include <stdio.h>  
  
/*seconds: the seconds; mseconds: the micro seconds*/  
void setTimer(int seconds, int mseconds)  
{  
        struct timeval temp;  
  
        temp.tv_sec = seconds;  
        temp.tv_usec = mseconds;  
  
        select(0, NULL, NULL, NULL, &temp);  
        printf("timer\n");  
  
        return ;  
}  
  
int main()  
{  
    int i;  


    struct timeval tv;
    gettimeofday(&tv,NULL);
    printf("second:%ld\n",tv.tv_sec);  //秒
    printf("millisecond:%ld\n",tv.tv_sec*1000 + tv.tv_usec/1000);  //毫秒
    printf("microsecond:%ld\n",tv.tv_sec*1000000 + tv.tv_usec);  //微秒


    struct tm *t;
    time_t tt;
    time(&tt);
    t=localtime(&tt);
    printf("%4d年%02d月%02d日 %02d:%02d:%02d\n",
        t->tm_year+1900,t->tm_mon+1,t->tm_mday,t->tm_hour,t->tm_min,t->tm_sec);
    int x = 12-t->tm_hour;
    int y = 48-t->tm_min ;
    int z = 0-t->tm_sec ;
    int a = x*3600+y*60+z ;
    printf( "second::: x:%d y:%d z:%d a: %d\n",x,y,z,a) ;
    setTimer(a, 0); 

    time(&tt);
    t=localtime(&tt);
    printf("%4d年%02d月%02d日 %02d:%02d:%02d\n",
        t->tm_year+1900,t->tm_mon+1,t->tm_mday,t->tm_hour,t->tm_min,t->tm_sec);
 
     //   for(i = 0 ; i < 10; i++)  
    //            setTimer(a, 0); 
  
        return 0;  
}  
