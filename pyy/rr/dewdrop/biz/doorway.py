# coding: utf-8
from zmq.eventloop.zmqstream import ZMQStream

import tornado.websocket
import tornado.web
from tornado.log import app_log
from core import *
import time
import json














HEARTBEAT_CC = 60

MEMBERS = 0


class Messager(object):
    def __init__(self, callback):
        self.callback = callback
        self.topics = []
        self._sock = ctx.socket(zmq.SUB)
        self._sock.connect('inproc:///tmp/monster_{}'.format(pid))
        self._stream = ZMQStream(self._sock)
        self._stream.on_recv(self.recv)

    def destroy(self):
        self.callback = None
        self.topics = None
        self._stream.close()

    def subscribe(self, raw_topic):
        '''订阅
            订阅的主题支持多级主题,用冒号分隔,例如
            WEATHER:CHINA:HANGZHOU
            订阅父主题将会收到所有该类主题消息,比如订阅了WEATHER:CHINA,将收到所有中国城市的天气
            但由于zmq的订阅规则中并不支持多级主题,于是需要自己在内容中维护多级主题关系,将顶级主题送到zmq中

            topic = raw_topic.split(':') 
            这一句之后：topic = [u'TA705', u'5F']
        '''
        topic = raw_topic.split(':')
        if not topic:
            return

        # 滤重
        if [x for x in self.topics if x == topic]:
            return

        # str(topic[0]) : "TA705"
        self._sock.setsockopt(zmq.SUBSCRIBE, str(topic[0]))
        # 注意，这里的 self._sock  是指从 serv.py ，即本进程内部 收信息。
        # 调用 self._sock.setsockopt()，会进行过滤，没有订阅的消息，将不会收到。
        #TODO 目前的多级主题(topics)的内存结构为列表,消息送达之后需整体遍历列表以判断用户是否订阅该主题,可以考虑使用trie树来优化
        # 将 topic = [u'TA705', u'5F'] 整个存入到 self.topics中
        # 'self.topics:', [[u'TA703'], [u'TA705', u'5F']]
        self.topics.append(topic)
        print ("99999999999999999999999999999")
        print (self.topics)

    def unsubscribe(self, raw_topic):
        '''取消订阅
            比订阅操作更复杂的是退订的时候必须检查顶级主题下的所以子主题都已经退订,如果有一个子主题还在就不能
            完全从zmq当中退订该顶级主题
        '''
        topic = raw_topic.split(':')
        if not topic:
            return
        try:
            self.topics.remove(raw_topic.split(':'))
            for tt in self.topics:
                if tt[0] == topic[0]:
                    break
            else:
                self._sock.setsockopt(zmq.UNSUBSCRIBE, str(topic[0]))
        except:
            pass

    def recv(self, frame):
        _, data = frame
        '''
        # 只有订阅了，这里才能收到.
        # frame的格式：['TA705', '{"topic":"TA705"}']
        # data : {"topic":"TA705"}

        # 第一级过滤：调用  self._sock.setsockopt() 对【 str(topic[0]) 】即："TA705" 过滤.
        # 如果不是 TA705 开头，则 这里的 recv 不会接收到。
        # 第二级过滤，则是下面的 if topic == top[:len(topic)]:
        '''
        try:
            dd = json.loads(data)
            top = dd.get('topic')
            if not top:
                return
            top = top.split(':')
            for topic in self.topics:
                #print (" topic++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                #print ( topic )
                #print ( top[:len(topic)] )
                #print ( top )
                # 这里进行第二层，第三层过滤。
                if topic == top[:len(topic)]:
                #if topic == top:
                    #print (" topic------------------------ " )
                    #print ( topic )
                    #print ( top[:len(topic)] )
                    self.callback(json.dumps(dd))
        except:
            pass



@Application.register(path='/api/push/ws')
class PushWs(tornado.websocket.WebSocketHandler):

    def check_origin(self, origin):
        return True

    def open(self):
        # 每个新的websocket连接进来都会绑定一个基于zmqsocket的Messager对象订阅到本进程的消息发布中心HUB
        self.messager = Messager(self.push)
        # 时间戳,每次客户端发消息都会刷新此时间戳,服务器在发送的时候会判断当前时间减去上次请求的时间戳超过两个心跳周期会主动断开
        self.timestamp = time.time()
        Statistics.CONNECTIONS += 1
        app_log.info('online connections %d', Statistics.CONNECTIONS)

    def push(self, msg):
        if (time.time() - self.timestamp) > 2 * HEARTBEAT_CC:
            # 超过两个心跳周期没有任何数据则断开
            #self.close()
            self.write_message(msg)
            print( msg )
            pass
        else:
            self.write_message(msg)

    def on_message(self, message):
        app_log.debug(message)
        #从 websocket 收到订阅的信息。格式： {"action":"subs","stamp":"x","data":["TA703","TA705"]}
        self.timestamp = time.time() #any response will be regarded as a heartbeat
        try:
            content = json.loads(message)
            op = content['action']
            if op == 'sub':
                self.messager.subscribe(content['data'])
            elif op == 'subs':
                # topic 可以是 1F 5F 30F 等
                # topic 定义在 "data":[ "aaa","bbb","ccc"] 中
                for topic in content['data']:
                    self.messager.subscribe(topic)
            elif op == 'unsub':
                self.messager.unsubscribe(content['data'])
            elif op == 'unsubs':
                for topic in content['data']:
                    self.messager.unsubscribe(topic)
            elif op == 'clear':
                self.messager = None
                self.messager = Messager(self.send)
            elif op == 'pong':
                pass
        except Exception as e:
            app_log.exception(e)

    def on_close(self):
        if hasattr(self, 'messager'):
            self.messager.destroy()
        Statistics.CONNECTIONS -= 1
        app_log.info('online connections %d', Statistics.CONNECTIONS)

    def on_error(self):
        while(1):
            print( "eeeeeeeeeeeerrrrrorr!!!!" )
