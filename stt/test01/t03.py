#!/usr/bin/env python
# -*- coding: utf-8 -*-
from gmsdk.api import StrategyBase
from gmsdk.util import bar_to_dict
import time

class MyStrategy(StrategyBase):
    def __init__(self, *args, **kwargs):
        super(MyStrategy, self).__init__(*args, **kwargs)
        self.oc = True

    def on_login(self):
        print('logged in')

    def on_error(self, err_code, msg):
        # print('get error: %s - %s' % (err_code, msg))
        pass

    def on_tick(self, tick):
        #print(tick_to_dict(tick))
        self.open_long(tick.exchange, tick.sec_id, tick.last_price, 100)
        print("OpenLong: exchange %s, sec_id %s, price %s" %
            (tick.exchange, tick.sec_id, tick.last_price))
        print(tick)
        print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())))

    def on_bar(self, bar):
        print(bar_to_dict(bar))
        if self.oc:
            self.open_long(bar.exchange, bar.sec_id, 0, 100)
        else:
            self.close_long(bar.exchange, bar.sec_id, 0, 100)
        self.oc = not self.oc

if __name__ == '__main__':
    ret = MyStrategy(
        username='13601380996',
        password='Test518918ok',
        strategy_id='strategy_2',
        #subscribe_symbols='SHFE.ru1709.bar.15',
        subscribe_symbols='SHFE.ru1709.tick',
        mode=3
    ).run()
    print(('exit code: ', ret))