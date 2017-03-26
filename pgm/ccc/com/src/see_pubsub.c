//#include <assert.h>
//#include <string.h>
//#include <time.h>
//#include <stdio.h>
//#include <nanomsg/nn.h>
//#include <nanomsg/pubsub.h>

#include <see_com_common.h>

#define SERVER "server"
#define CLIENT "client"

char *date ()
{
  time_t raw = time (&raw);
  struct tm *info = localtime (&raw);
  char *text = asctime (info);
  text[strlen(text)-1] = '\0'; // remove '\n'
  return text;
}

int see_pipeline_server (const char *url)
{
  int sock = nn_socket (AF_SP, NN_PUSH);
  nn_connect (sock, url) ;
  return sock ;
}

int see_pipeline_client (const char *url)
{
    int sock = nn_socket (AF_SP, NN_PULL) ;
    nn_bind (sock, url) ;
    return sock ;
}

int see_pair_server(const char *url)
{
    int sock = nn_socket (AF_SP, NN_PAIR);
    assert (sock >= 0);
    if( nn_bind (sock, url) < 0 ){
        printf("see_pair_server error, url:%s errno:%d\n",url,errno ) ;
        exit (-1);
    }
    //assert (nn_bind (sock, url) >= 0);
    return sock ;
}

int see_pair_client(const char *url)
{
    int sock = nn_socket (AF_SP, NN_PAIR);
    assert (sock >= 0);
    assert (nn_connect (sock, url) >= 0);
    return 0;
}

