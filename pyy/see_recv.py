import ctypes
from ctypes import *
#ll = ctypes.cdll.LoadLibrary
#lib = ll("./libnanomsg.so")

from nanomsg import Socket, PAIR, PUB

import time
import ctypes
start = time.clock()
s1 = Socket(PAIR)
s2 = Socket(PAIR)
s1.bind('inproc://bob')
s2.connect('ipc:///tmp/heaven.ipc')
#    s1.send(i)
while(True):
#    print(s2.recv())
    s2.recv()
s1.close()
s2.close()
