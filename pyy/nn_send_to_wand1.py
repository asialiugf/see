from __future__ import print_function
import ctypes
import time
from ctypes import *
#ll = ctypes.cdll.LoadLibrary
#lib = ll("./libnanomsg.so")
 
from nanomsg import Socket, PAIR, PUB

import time
import ctypes
s1 = Socket(PAIR)
s1.bind('ipc:///tmp/wand1.ipc')
while(True):
    s1.send("topic:sub,future:TA703")
    time.sleep(1)
    s1.send("topic:sub,future:TA705")
    time.sleep(1)
s1.close()
