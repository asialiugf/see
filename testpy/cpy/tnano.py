#from __future__ import print_function
import ctypes
from ctypes import *
ll = ctypes.cdll.LoadLibrary
lib = ll("./libnanomsg.so")

from nanomsg import Socket, PAIR, PUB

import time
import ctypes
start = time.clock()
s1 = Socket(PAIR)
s2 = Socket(PAIR)
s1.bind('inproc://bob')
s2.connect('ipc:///tmp/pp.ipc')
#    s1.send(i)
while(True):
    print(s2.recv())
s1.close()
s2.close()






IntArray5 = c_int * 1000000
ia = IntArray5(5, 1, 7, 33, 99)
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]
ic = ia[0:1000000]





end = time.clock()
x = end - start
print x
print (x)
