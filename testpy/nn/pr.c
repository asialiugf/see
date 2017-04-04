#include <unistd.h>
#include <string.h>
#include <assert.h>
//#include <libc.h>
#include <nanomsg/nn.h>
#include <nanomsg/pair.h>
#include <stdio.h>

#define NODE0 "myserver"
#define NODE1 "myclient"

char ca_msg[] = "hello world!\n" ;

int mysend(int sock)
{
  printf ("SENDING \"%s\"\n", ca_msg );
  int sz_n = strlen (ca_msg) + 1;
  return nn_send (sock, ca_msg, sz_n, 0);
}

int myrecv(int sock)
{
  char *buf = NULL;
  int result = nn_recv (sock, &buf, NN_MSG, 0);
  if (result > 0)
  {
      printf ("RECEIVED \"%s\"\n", buf);
      nn_freemsg (buf);
  }
  return result;
}

int myserver (const char *url)
{
  int sock = nn_socket (AF_SP, NN_PAIR);
  assert (sock >= 0);
  assert (nn_bind (sock, url) >= 0);
  return 0 ;
}

int myclient (const char *url)
{
  int sock = nn_socket (AF_SP, NN_PAIR);
  assert (sock >= 0);
  assert (nn_connect (sock, url) >= 0);
  return sock ;
}

int main (const int argc, const char **argv)
{
    int sock ;
    sock = myclient( "ipc:///tmp/pp.ipc") ;
    while(1)
    {
        myrecv(sock) ;
    }
    return 0 ;
}
