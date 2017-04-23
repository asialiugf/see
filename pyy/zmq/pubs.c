/*
    Copyright (c) 2007-2016 Contributors as noted in the AUTHORS file

    This file is part of libzmq, the ZeroMQ core engine in C++.

    libzmq is free software; you can redistribute it and/or modify it under
    the terms of the GNU Lesser General Public License (LGPL) as published
    by the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    As a special exception, the Contributors give you permission to link
    this library with independent modules to produce an executable,
    regardless of the license terms of these independent modules, and to
    copy and distribute the resulting executable under terms of your choice,
    provided that you also meet, for each linked independent module, the
    terms and conditions of the license of that module. An independent
    module is a module which is not derived from or based on this library.
    If you modify this library, you must extend this exception to your
    version of the library.

    libzmq is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
    License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "zmq.h"
#include <string.h> 
#include <unistd.h>
#include <assert.h>
#include <time.h>
//#include "linux/delay.h"
#define SETTLE_TIME 300

// with hwm 11024: send 9999 msg, receive 9999, send 1100, receive 1100
void test_reset_hwm ()
{
    int first_count = 10;
    int hwm = 11024;


    void *ctx = zmq_ctx_new ();
    assert (ctx);
    int rc;

    // Set up bind socket
    void *pub_socket = zmq_socket (ctx, ZMQ_PUB);
    assert (pub_socket);
    rc = zmq_setsockopt (pub_socket, ZMQ_SNDHWM, &hwm, sizeof (hwm));
    assert (rc == 0);
    //rc = zmq_bind (pub_socket, "tcp://127.0.0.1:9021");
    rc = zmq_connect (pub_socket, "tcp://localhost:9021");
    if( rc < 0 ){
        printf ("zmq_bind: %s\n", zmq_strerror (errno));
    }
    assert (rc == 0);


    sleep(2);

/*


    void *ctx = zmq_ctx_new ();
    assert (ctx);
    int rc;

    // Set up bind socket
    void *pub_socket = zmq_socket (ctx, ZMQ_PUB);
    assert (pub_socket);
    rc = zmq_setsockopt (pub_socket, ZMQ_SNDHWM, &hwm, sizeof (hwm));
    assert (rc == 0);
    //rc = zmq_bind (pub_socket, "tcp://127.0.0.1:1234");
    rc = zmq_bind (pub_socket, "tcp://localhost:1234");
    //rc = zmq_connect (pub_socket, "tcp://localhost:9021");
    printf ("zmq_bind: %s\n", zmq_strerror (errno));
    printf( "%d\n",rc ) ;
    assert (rc == 0);

    // Set up connect socket
*/
    // Send messages
    int send_count = 0;
    char ca_ttt[] = "{\"topic\": \"TA703\", \"data\": \"topic:sub,future:TA705\"}";
    //char ca_ttt[] = "{topic:sub,future:TA705}";
    int len = strlen(ca_ttt);
        printf( "%d ssss! %s \n",len,ca_ttt) ;
    while (send_count < first_count) {
        char ca_kkk[256] ;
        sprintf(ca_kkk,"number:   %d", send_count);
        len = strlen(ca_kkk);
        //rc = zmq_send (pub_socket, "TA703", 5, ZMQ_SNDMORE);
        rc = zmq_send (pub_socket, "TA703", 5, ZMQ_DONTWAIT);
        rc = zmq_send (pub_socket, ca_kkk, len, ZMQ_DONTWAIT);
        sleep(1);
        //rc = zmq_send (pub_socket, "TA705", 5, ZMQ_SNDMORE);
        rc = zmq_send (pub_socket, "TA705", 5, ZMQ_DONTWAIT);
        rc = zmq_send (pub_socket, ca_kkk, len, ZMQ_DONTWAIT);
        printf("%s\n",ca_kkk) ;
        sleep(1);
        ++send_count;
    }
    assert (first_count == send_count);

    usleep (SETTLE_TIME);

    // Now receive all sent messages
    rc = zmq_close (pub_socket);
    assert (rc == 0);

    rc = zmq_ctx_term (ctx);
    assert (rc == 0);
}

int main (void)
{
    // hwm should apply to the messages that have already been received
    test_reset_hwm ();

    return 0;
}
