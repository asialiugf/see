#include <see_com_common.h>

int see_fork_sttproc()
{
    return 0;
}

int see_waiter()
{
    while(1) {
        see_zmq_sub();
        see_fork_sttproc();
    }
    return 0;
}
int see_stt()
{

}
