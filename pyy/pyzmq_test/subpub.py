#coding=utf-8  
  
import sys  
import zmq  
import datetime
import random
  
port = "5556"  
if len(sys.argv) > 1:  
    port =  sys.argv[1]  
    int(port)  
      
if len(sys.argv) > 2:  
    port1 =  sys.argv[2]  
    int(port1)  
  
# Socket to talk to server  
context = zmq.Context()  
socket = context.socket(zmq.SUB)  
  
print "Collecting updates from weather server..."  
socket.connect ("tcp://localhost:%s" % port)  
  
if len(sys.argv) > 2:  
    socket.connect ("tcp://localhost:%s" % port1)  
  
# 本地过滤  
topicfilter = "500"  
socket.setsockopt(zmq.SUBSCRIBE, topicfilter)  




pub_server_name = 'pub-server01'
context_pub = zmq.Context()
socket_pub = context_pub.socket(zmq.PUB)
socket_pub.bind('tcp://*:%s'%port)



  
# Process 5 updates  
total_value = 0  
begin = datetime.datetime.now()
for update_nbr in range (5):  


    messagedata = random.randrange(1,215)-80
    topic=500
    print 'topic:%s messagedata:%s'%(topic,messagedata)
    socket_pub.send('%d %d %s'%(topic,messagedata,pub_server_name))
    print("send ok!")



    string = socket.recv()  
    topic, messagedata,pub_server_name = string.split()  
    total_value += int(messagedata)  
    print topic, messagedata,pub_server_name  
    end = datetime.datetime.now()
    k = end - begin
    print(end)
  
print "Average messagedata value for topic '%s' was %dF" % (topicfilter, total_value / update_nbr)  



