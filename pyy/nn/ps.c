#include <unistd.h>
#include <string.h>
#include <assert.h>
//#include <libc.h>
#include <nanomsg/nn.h>
#include <nanomsg/pair.h>
#include <stdio.h>

#define NODE0 "myserver"
#define NODE1 "myclient"

char ca_msg[] = "hello world!" ;
char ca_tmp[1024] ;

int mysend(int sock, int i)
{
    printf("SENDING %s : %d \n", ca_msg, i);
    memset(ca_tmp, '\0', 1024) ;
    //sprintf(ca_tmp,"\"topic\":\"sub\"");
    //sprintf(ca_tmp,"{\"topic\":\"sub\",\"future\":\"TA701\"}");
    sprintf(ca_tmp, "topic:sub,future:TA703");
    int sz_n = strlen(ca_tmp);
    nn_send(sock, ca_tmp, sz_n, NN_DONTWAIT);
    usleep(100000);
    sprintf(ca_tmp, "topic:sub,future:TA705");
    nn_send(sock, ca_tmp, sz_n, NN_DONTWAIT);
    usleep(100000);
    return 1;
}

int myrecv(int sock)
{
    char *buf = NULL;
    int result = nn_recv(sock, &buf, NN_MSG, 0);
    if(result > 0) {
        printf("RECEIVED \"%s\"\n", buf);
        nn_freemsg(buf);
    }
    return result;
}

int myserver(const char *url)
{
    int sock = nn_socket(AF_SP, NN_PAIR);
    assert(sock >= 0);
    assert(nn_bind(sock, url) >= 0);
    return sock ;
}

int myclient(const char *url)
{
    int sock = nn_socket(AF_SP, NN_PAIR);
    assert(sock >= 0);
    assert(nn_connect(sock, url) >= 0);
    return 0;
}

int main(const int argc, const char **argv)
{
    int sock ;
    int i ;
    sock = myserver("ipc:///tmp/pp.ipc") ;
    i = 0 ;
    while(1) {
        //usleep(1000000) ;
        mysend(sock, i) ;
        i++ ;
    }
    return 0 ;
}
