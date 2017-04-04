#include <assert.h>
#include <unistd.h>
#include <string.h>
#include <nanomsg/nn.h>
#include <stdio.h>
#include <nanomsg/pipeline.h>

int see_pubsub_server (const char *url)
{
  int sock = nn_socket (AF_SP, NN_PUSH);
  assert (sock >= 0);
  assert (nn_connect (sock, url)>=0) ;
  return sock ;
}

int see_pubsub_client (const char *url)
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
    i_sock = see_pubsub_client( "ipc:///tmp/xxx.ipc" ) ;
    printf( "test 22!\n") ;

  while (1)
    {
      char *buf = NULL;
      nn_recv (i_sock, &buf, NN_MSG, 0);
      assert (bytes >= 0);
      printf ("NODE0: RECEIVED \"%s\"\n", buf);
      nn_freemsg (buf);
    }

    return 0;
}
