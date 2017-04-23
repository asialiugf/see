#coding:utf8
import time, random
from sdk import Operation

import ctypes
from ctypes import *
ll = ctypes.cdll.LoadLibrary
lib = ll("/usr/local/lib64/libnanomsg.so.1.0.0")

from nanomsg import Socket, PAIR, PUB
from tornado.log import app_log

import time
import ctypes
import json
import time

start = time.clock()
s2 = Socket(PAIR)
s2.connect('ipc:///tmp/pp.ipc')


def test1(op):
    for i in range(10):
        time.sleep(3)
        op.send('bbb', 'hello world')

def test2(op):
    stock_map = {
            'aapl': 100.0,
            'wbai': 20.0,
            'goog': 165.0,
            'baid': 144.0,
            'jd': 33.0,
            'intr': 39.0,
            'shne': 178.0,
            'msft': 43.90,
            'txn': 47.05,
        }
    stock_copy = stock_map.copy()
    while 1:
        message = s2.recv()
        #content = json.loads(message)
        #topic = content['topic']
        #print( topic )
        try:
            #print(message)
            #content = json.loads(message, encoding='utf-8') 
            #topic = content['topic']
            #future = content['future']
            mm = message.split(",")
            #print ( mm[0] )
            #print ( mm[1] )
            topic = mm[0].split(":")[1]
            future = mm[0].split(":")[1]
            #print ( future )
            #print( topic )
            #print( future )
            if topic == 'sub':
                #op.send('%s' %(future),'baidu,10.0,11.0,12.0,13.0' )
                #op.send('%s' % (future).encode(),message )
                cmd ={"future":"TA905","sttname":"stt03","actionday_s":"20160101","actionday_e":"20170908","updatetime_s":"03:05:09","updatetime_e":"09:09:09","number":10005}
                #op.send( "TA703",message )
                #time.sleep(1)
                #op.send( "TA705",message )
                #op.send( "TA709",message )
                #op.send( "waiter",cmd )
                op.send( "test01",cmd )
                op.send( "test02",cmd )
                print ( 'test!!!!!!!!!!!!!!!!!!!!!!!!!!!' )
                #kkk = "TA701"
                #op.send('TA701', '%s,%.3g,%.3g,%.3g,%.3g' % ('baidu',11,11,11,12))
                #op.send(kkk, '%s,%.3g,%.3g,%.3g,%.3g' % ('baidu',11,11,11,12))
            elif topic == 'kkk':
                op.send('stock','tencent,10.0,11.0,12.0,13.0')
            else:
                print ( 'into else!!!!!!!!!!' )
                op.send('stock1', '%s,%.3g,%.3g,%.3g,%.3g' % ('baidu',11,11,11,12))
        except Exception as e:
            print ( 'json error!!' )
            print (e)
            app_log.exception(e)

        #r = random.randint(1,100) / 200.0
        #time.sleep(r+1)
        stock = random.choice(stock_map.keys())
        steps = random.randint(-100, 100) / 100.0
        org_price = stock_map[stock]
        latest_price = stock_copy[stock] + steps
        stock_copy[stock] = latest_price
        counts = latest_price - org_price
        rge = counts / org_price * 100.0
        #print stock, steps, org_price, latest_price, counts, rge
        #op.send('stock', '%s,%.3g,%.3g,%.3g,%.3g' % (stock, latest_price, counts, rge, steps))



if __name__ == "__main__":
    op = Operation('localhost:9021')
    # test1(op)
    test2(op)
