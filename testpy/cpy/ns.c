#include <assert.h>
#include <unistd.h>
#include <string.h>
#include <nanomsg/nn.h>
#include <stdio.h>
#include <nanomsg/pipeline.h>
//#include <nanomsg/pubsub.h>

int see_pubsub_server (const char *url)
{
  int sock = nn_socket (AF_SP, NN_PUSH);
  assert (sock >= 0);
  assert (nn_connect (sock, url)>=0) ;
  return sock ;
}

int see_pubsub_client (const char *url, const char *name)
{
    int sock = nn_socket (AF_SP, NN_PULL) ;
    if ( sock <=0 )
    {
        printf("client sock error!\n") ;
    }
    nn_bind (sock, url) ;
    return sock ;
}

int main (const int argc, const char **argv)
{
    int i_sock ;
    int bytes ;
    printf( "test 11\n") ;
    i_sock = see_pubsub_server( "ipc:///tmp/xxx.ipc" ) ;
    printf( "test 22!\n") ;
    while(1)
    { 
        bytes = nn_send (i_sock, (char *)"test ok!!!!",11,NN_DONTWAIT);
        if ( bytes <=0 ) 
        {
            printf("send error!\n") ;
        }
        sleep(1) ;
	printf( "test ok!\n") ;
    }
    return 0;
}
