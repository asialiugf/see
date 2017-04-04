from __future__ import print_function
from nanomsg import wrapper as nn_wrapper
from nanomsg import PAIR, AF_SP

import time
import ctypes
start = time.clock()
s1 = nn_wrapper.nn_socket(AF_SP, PAIR)
s2 = nn_wrapper.nn_socket(AF_SP, PAIR)
nn_wrapper.nn_bind(s1, 'inproc://bob')
nn_wrapper.nn_connect(s2, 'inproc://bob')
for i in range(0, 500000):
    nn_wrapper.nn_send(s1, b'hello nanomsg', 0)
    result, buffer = nn_wrapper.nn_recv(s2, 0)
    # print(bytes(buffer))
nn_wrapper.nn_term()
end = time.clock()
x = end - start
print (x)
