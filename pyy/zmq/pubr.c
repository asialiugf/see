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
void test_reset_hwm()
{
    //int first_count = 1;
    //int second_count = 1100;
    int hwm = 11024;

    void *ctx = zmq_ctx_new();
    assert(ctx);
    int rc;

    // Set up connect socket
    void *sub_socket = zmq_socket(ctx, ZMQ_SUB);
    assert(sub_socket);
    rc = zmq_setsockopt(sub_socket, ZMQ_RCVHWM, &hwm, sizeof(hwm));
    assert(rc == 0);
    //rc = zmq_connect (sub_socket, "tcp://localhost:1234");
    rc = zmq_connect(sub_socket, "tcp://localhost:9022");
    assert(rc == 0);
    rc = zmq_setsockopt(sub_socket, ZMQ_SUBSCRIBE, 0, 0);
    assert(rc == 0);

    sleep(1);
    // Now receive all sent messages
    char buff[256] ;
    //int ret=0 ;
    //int recv_count = 0;
    while(1) {
        memset(buff,'\0',256);
        //ret = zmq_recv (sub_socket, &buff, 256, ZMQ_DONTWAIT) ;
        /*
        ret = zmq_recv(sub_socket, &buff, 256, 0) ;
        if(ret < 0) {
            printf("error in zmq_connect: %s\n", zmq_strerror(errno));
            sleep(1);
            continue;
        }
        */

        int more;
        size_t more_size = sizeof(more);
        do {
            rc = zmq_recv(sub_socket, &buff,256,0);
            rc = zmq_getsockopt(sub_socket, ZMQ_RCVMORE, &more, &more_size);
            printf("%s\n", buff);
        } while(more);
        //sleep(1);
    }
    usleep(SETTLE_TIME);

    // Clean up
    rc = zmq_close(sub_socket);
    assert(rc == 0);

    rc = zmq_ctx_term(ctx);
    assert(rc == 0);
}

int main(void)
{
    // hwm should apply to the messages that have already been received
    test_reset_hwm();

    return 0;
}
