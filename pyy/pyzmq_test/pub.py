import zmq 
import random
import time
import datetime

port = '5556'  
pub_server_name = 'pub-server01'  
  
context = zmq.Context()  
socket = context.socket(zmq.PUB)  
socket.bind('tcp://*:%s'%port)  
    
count = 0
topic = 1
while True:  
    #topic = random.randrange(9999,10005)  
    messagedata = random.randrange(1,215)-80  
    topic+=1 
    print 'topic:%s messagedata:%s'%(topic,messagedata)  
    socket.send('%d %d %s'%(topic,messagedata,pub_server_name))  
    print(topic)
    end = datetime.datetime.now()
    print(end)
    if ( topic == 500 ):
        break
    #time.sleep(1)  

