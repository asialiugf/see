#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

#define P_NUMBER 255 //并发进程数量
#define COUNT 5 //每次进程打印字符串数
#define TEST_LOGFILE "logFile.log"
FILE *logFile=NULL;

char *s="hello linux\0";

int main()
{
    int i=0,j=0;
    logFile=fopen(TEST_LOGFILE,"a+");//打开日志文件
    for(i=0;i<P_NUMBER;i++)
    {
        if(fork()==0)//创建子进程，if(fork()==0){}这段代码是子进程运行区间
        {
            for(j=0;j<COUNT;j++)
            {
                printf("[%d]%s\n",j,s);//向控制台输出
                /*当你频繁读写文件的时候，Linux内核为了提高读写性能与速度，会将文件在内存中进行缓存，这部分内存就是Cache Memory(缓存内存)。可能导致测试结果不准，所以在此注释*/
                //fprintf(logFile,"[%d]%s\n",j,s);//向日志文件输出，
            }
            exit(0);//子进程结束
        }
    }
    
    for(i=0;i<P_NUMBER;i++)//回收子进程
    {
        wait(0);
    }
    
    printf("Okay\n");
    return 0;
}
