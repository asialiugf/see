#include <see_master.h>
int see_master_cycle()
{
    int rc=0;
    int pid;
    pid = getpid();
    //setproctitle_init(argc, argv, environ);
    setproctitle("%s %s", "future.x :", "master");
    while(1) {
        sleep(100);
    }
    return rc;
}
