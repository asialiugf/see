import ctypes
from ctypes import *
ll = ctypes.cdll.LoadLibrary
lib = ll("./libpycall.so")
IntArray5 = c_int * 1000000
ia = IntArray5(191, 1, 7, 33, 99)
ib = IntArray5(227, 1, 7, 33, 99)
c = lib.foo(ia, ib)
print "ia[0]: " , ia[0]
print "ib[2]: " , ib[2] 

import time  
#import spam  
import ctypes  
start = time.clock()  
for i in range(999999): 
    ia[i] = ia[i-1]
t1 = (time.clock()-start)
print "cost time:",t1 

start = time.clock()
lib.moveint(ia)
lib.moveint(ia)
lib.moveint(ia)
lib.moveint(ia)
lib.moveint(ia)
t1 = (time.clock()-start)
print "cost time:",t1
print ia[0]

start = time.clock()  
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
t1 = (time.clock()-start)
print "ic = ia cost time:",t1 

import tushare as ts
start = time.clock()
mm = ts.get_hist_data('600848', ktype='5')
df = ts.get_tick_data('600848',date='2011-01-04')
print df 
t1 = (time.clock()-start)
print "tusare get_hist_data:",t1
