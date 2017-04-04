from __future__ import print_function
from nanomsg import Socket, PAIR, PUB
s2 = Socket(PAIR)
s2.connect('ipc:///tmp/wand1.ipc')
while(True):
    print(s2.recv())
s2.close()
