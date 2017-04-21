#include <see_com_common.h>

int hwm = 11024;
char ca_msg[1024];

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

void * see_zmq_sub_init(char * pc_url, char *topic)
{
    int rc;
    int hwm = 11024;
    void *ctx = zmq_ctx_new();

    //printf("%s\n",pc_url);
    // Set up connect socket
    void *sub_socket = zmq_socket(ctx, ZMQ_SUB);
    assert(sub_socket);
    rc = zmq_setsockopt(sub_socket, ZMQ_RCVHWM, &hwm, sizeof(hwm));
    assert(rc == 0);
    rc = zmq_connect(sub_socket, pc_url);
    //rc = zmq_connect(sub_socket, "tcp://localhost:9022");
    assert(rc == 0);
    rc = zmq_setsockopt(sub_socket, ZMQ_SUBSCRIBE, topic, strlen(topic));
    assert(rc == 0);

    sleep(1);
    return sub_socket;
}

int see_zmq_pub_send(void * sock, char * pc_msg)
{
    int rc = 0;
    int len = 0;
    len = strlen(pc_msg);

    /*
        这里需要调用两次zmq_send()，第一次采用 ZMQ_SNDMORE
        这样是为了让rose-dewdrop 能够根据订阅的  "TA705" 来处理.
        注：
            这里的 "TA705" 需要修改，根据需要来输入。
    */
    rc = zmq_send(sock, "TA705", 5, ZMQ_SNDMORE);
    rc = zmq_send(sock, pc_msg, len, ZMQ_DONTWAIT);
    if(rc!=len) {
        memset(ca_msg,'\0',1024) ;
        sprintf(ca_msg,"%s -- errno : %d  rc: %d ", pc_msg,errno,rc) ;
        see_errlog(1000,ca_msg,RPT_TO_LOG,0,0);
        see_errlog(1000," zmq_send error !!",RPT_TO_LOG,0,0);
        printf("%d ----------------\n",rc);
    }
    return len;
}

int see_zmq_sub_recv(void *sub_socket, void *buf, size_t len, int flags)
{
    int     rc=0;
    int     more;
    int     idx     = 0;
    int     l       = (int)len;
    char    *bf     = (char *)buf;
    void    *b;
    size_t  more_size = sizeof(more);

    printf( "in see_zmq_sub_recv !!!!!!!!!!!!!!!!!!!!-----------------\n");
    b = malloc(len);
    see_memzero(buf,len);
    do {
        see_memzero(b,l);

        for(;;) {
            rc = zmq_recv(sub_socket, b,len,0);
            if(rc<=0) {
                if(errno == EINTR) {
                    continue;
                } else {
                    see_err_log(0,0,"see_zmq_sub_recv(): zmq_recv error!! errno: %d  %s",see_errno,zmq_strerror(errno));
                    sleep(1);
                }
            } else {
                break;
            }
        }

        if(rc>0 && idx<l) {
            if(idx+rc >=l) {
                rc = l-idx ;
            }
            memcpy(bf+idx,b,rc);
            memset(bf+l-1,'\0',1);
            idx = idx+rc;
        }
        rc = zmq_getsockopt(sub_socket, ZMQ_RCVMORE, &more, &more_size);
        if(rc!=0) {
            see_errlog(1000," zmq_getsockopt error !!",RPT_TO_LOG,0,0);
            return -1;
        }
    } while(more);
    printf("see_zmq: %s\n",(char*)buf);
    free(b);
    printf( "out!! see_zmq_sub_recv !!!!!!!!!!!!!!!!!!!!-----------------\n");
    return 0;
}
