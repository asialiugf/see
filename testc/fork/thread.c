#include <pthread.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define P_NUMBER 255//并发线程数量
#define COUNT 5 //每线程打印字符串数
#define TEST_LOG "logFile.log"
FILE *logFile=NULL;

char *s="hello linux\0";

print_hello_linux()//线程执行的函数
{
    int i=0;
    for(i=0;i<COUNT;i++)
    {
        printf("[%d]%s\n",i,s);//想控制台输出
        /*当你频繁读写文件的时候，Linux内核为了提高读写性能与速度，会将文件在内存中进行缓存，这部分内存就是Cache Memory(缓存内存)。可能导致测试结果不准，所以在此注释*/
        //fprintf(logFile,"[%d]%s\n",i,s);//向日志文件输出
    }
    pthread_exit(0);//线程结束
}

int main()
{
    int i=0;
    pthread_t pid[P_NUMBER];//线程数组
    logFile=fopen(TEST_LOG,"a+");//打开日志文件
    
    for(i=0;i<P_NUMBER;i++)
        pthread_create(&pid[i],NULL,(void *)print_hello_linux,NULL);//创建线程
        
    for(i=0;i<P_NUMBER;i++)
        pthread_join(pid[i],NULL);//回收线程
        
    printf("Okay\n");
    return 0;
}
