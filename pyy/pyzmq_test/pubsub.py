import sys
import zmq 
import random
import time
import datetime

port = '5556'  
pub_server_name = 'pub-server01'  
  
#context = zmq.Context()  
#socket = context.socket(zmq.PUB)  
#socket.bind('tcp://*:%s'%port)  


topicfilter = "500"
context_sub = zmq.Context()
socket_sub = context_sub.socket(zmq.SUB)
socket_sub.connect ("tcp://localhost:%s" % port)
socket_sub.setsockopt(zmq.SUBSCRIBE, topicfilter)

    
while True:  
    topic=500
    messagedata = random.randrange(1,215)+80
    begin = datetime.datetime.now()
    for kk in range(10000):
        #socket.send('%d %d %s'%(topic,messagedata,pub_server_name))  
        print 'topic:%s messagedata:%s'%(topic,messagedata)  
        string = socket_sub.recv()
        print (string)
    end = datetime.datetime.now()
    tt = end - begin
    print(tt)
    if ( topic == 500 ):
        break
    #time.sleep(1)  

