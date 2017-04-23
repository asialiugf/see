#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

#include <iostream>

using namespace std;

/*
 *子进程退出的时候，会发送SIGCHLD信号，默认的POSIX不响应，
 *所以，用该函数处理SIGCHLD信号便可，同时使用signal设置处理信号量的规则(或跳转到的函数)
 */
void sig_handle(int num)
{
    int status;
    pid_t pid;

    while((pid = waitpid(-1,&status,WNOHANG)) > 0) {
        if(WIFEXITED(status)) {
            printf("child process revoked. pid[%6d], exit code[%d]\n",pid,WEXITSTATUS(status));
        } else
            printf("child process revoked.but ...\n");
    }
}

/*  循环创建多进程，采用非阻塞方式回收进程  */
int main()
{
    int p_num=5;

    signal(SIGCHLD, sig_handle);

    /* 使用循环创建多个进程 */
    for(int i=0; i < p_num; i++) {
        pid_t ret = 0;
        if((ret = fork()) < 0) {
            fprintf(stderr,"fork fail. ErrNo[%d],ErrMsg[%s]\n",errno,strerror(errno));
        } else if(0 == ret) {
            printf("child process [%d], pid[%6d] ppid[%6d]\n",i,getpid(),getppid());

            for(int j = 0; j<5; j++) {
                pid_t ret = 0;
                if((ret = fork()) < 0) {
                    fprintf(stderr,"fork fail. ErrNo[%d],ErrMsg[%s]\n",errno,strerror(errno));
                } else if(0 == ret) {
                    printf ( "kkkkkkkkkkkkkk\n" );
                    sleep(10);
                    exit(0);
                }

            }

            sleep(10);
            exit(0);
        }
    }

    printf("main pid[%6d] ppid[%6d]\n",getpid(),getppid());

    /* 不再显式，阻塞方式回收进程，子进程退出的时候，会发送SIGCHLD信号，通过signal()注册处理信号的方法 */

    sleep(5);
    printf("sleep 1 over\n");
    sleep(5);
    printf("sleep 2 over\n");
    sleep(5);
    printf("sleep 3 over\n");
    sleep(5);
    printf("sleep 4 over\n");
    sleep(5);
    printf("all over\n");
}
/*
]# time ./a.out
child process [0], pid[ 19711] ppid[ 19710]
child process [1], pid[ 19712] ppid[ 19710]
child process [2], pid[ 19713] ppid[ 19710]
main pid[ 19710] ppid[ 15683]
child process [3], pid[ 19714] ppid[ 19710]
child process [4], pid[ 19715] ppid[ 19710]
child process revoked. pid[ 19711], exit code[0]
sleep 1 over
child process revoked. pid[ 19712], exit code[0]
sleep 2 over
child process revoked. pid[ 19713], exit code[0]
sleep 3 over
child process revoked. pid[ 19714], exit code[0]
sleep 4 over
child process revoked. pid[ 19715], exit code[0]
all over

real    0m4.009s
user    0m0.000s
sys     0m0.008s

1.问题:
    如果程序末尾只有一个sleep函数的话，信号处理完后就会结束主进程的sleep，于是主程序结束，程序最终仅回收了一个进程，故而达不到回收所有进程的目的
2.不是解决方法的方法:
    加了5个sleep于是，可以看到程序将五个进程都回收了
3.总结
    1)异步回收依靠的是信号，子进程结束会发信号SIGCHLD，系统默认不处理，我们可通过signal()自定义该信号的处理方法
    2)因为信号也就是中断，是不确定时间点产生的，所以没有阻塞等待的过程，等到信号发生了去处理就行，于是达到了不阻塞情况的进程回收
    3)信号的到达会唤醒将主进程从sleep状态唤醒，于是导致并不能回收所有进程
    4)由于3)的原因，需要进一步研究，今天不早了，还有事就先到这
    5)如果主进程是常驻进程该方法就没有问题了
4.附
    1)信号的可靠与不可靠只与信号值有关，与信号的发送及安装函数无关
    2)非实时信号都不支持排队，都是不可靠信号；实时信号都支持排队，都是可靠信号。
    3)
*/
