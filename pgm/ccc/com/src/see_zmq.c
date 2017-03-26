#include <see_com_common.h>

int hwm = 11024;

void * see_zmq_pub_init(char * pc_url)
{
    int rc=0;
    void *ctx = zmq_ctx_new();
    void *pub_socket = zmq_socket(ctx, ZMQ_PUB);
    rc = zmq_setsockopt(pub_socket, ZMQ_SNDHWM, &hwm, sizeof(hwm));
    if(rc!=0) {
        see_errlog(1000," zmq_setsockopt error !!",RPT_TO_LOG,0,0);
    }
    assert(rc == 0);
    rc = zmq_connect(pub_socket, pc_url);
    if(rc!=0) {
        see_errlog(1000," zmq_connect error !!",RPT_TO_LOG,0,0);
    }
    assert(rc == 0);
    sleep(2);
    return pub_socket ;
}

int see_zmq_pub_send(void * sock, char * pc_msg)
{
    int rc = 0;
    int len = 0;
    len = strlen(pc_msg);
    printf("%s  --  %d\n",pc_msg,len);
    rc = zmq_send(sock, pc_msg, len, ZMQ_DONTWAIT);
    if(rc!=len) {
        see_errlog(1000," zmq_send error !!",RPT_TO_LOG,0,0);
        printf("%d ----------------\n",rc);
    }
    return len;
}
