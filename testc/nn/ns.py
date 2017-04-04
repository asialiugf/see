from __future__ import print_function
from nanomsg import Socket, PAIR, PUB
import time
s1 = Socket(PAIR)
s1.bind('ipc:///tmp/wand1.ipc')
while(True):
    kkk = "hello world!"
    print( kkk )
    s1.send(kkk)
    time.sleep(1)
s1.close()
