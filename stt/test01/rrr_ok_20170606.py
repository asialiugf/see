# -*- coding: utf-8 -*-

from gmsdk.api import StrategyBase
import time
import datetime
import arrow
import tquant as tt
import pandas as pd


"""
http://www.myquant.cn/docs/api/python/#tick_2

class Tick(object):

    def __init__(self):
        self.exchange = ''          ## 交易所代码
        self.sec_id = ''            ## 证券ID
        self.utc_time = 0.0         ## 行情时间戳
        self.strtime = ''           ## 可视化时间
        self.last_price = 0.0       ## 最新价
        self.open = 0.0             ## 开盘价
        self.high = 0.0             ## 最高价
        self.low = 0.0              ## 最低价

        self.cum_volume = 0.0       ## 成交总量/最新成交量,累计值
        self.cum_amount = 0.0       ## 成交总金额/最新成交额,累计值
        self.cum_position = 0.0L    ## 合约持仓量(期),累计值
        self.last_volume = 0        ## 瞬时成交量(中金所提供)
        self.last_amount = 0.0      ## 瞬时成交额

        self.upper_limit = 0.0      ## 涨停价
        self.lower_limit = 0.0      ## 跌停价
        self.settle_price = 0.0     ## 今日结算价
        self.trade_type = 0         ## 1:'双开', 2: '双平', 3: '多开', 4:'空开', 5: '空平', 6:'多平', 7:'多换', 8:'空换'
        self.pre_close = 0.0        ## 昨收价

        self.bids = []  ## [(price, volume), (price, volume), ...] ## 1-5档买价,量
        self.asks = []  ## [(price, volume), (price, volume), ...] ## 1-5档卖价,量
"""

"""
class Bar(object):

    def __init__(self):
        self.exchange = ''       ## 交易所代码
        self.sec_id = ''         ## 证券ID

        self.bar_type = 0        ## bar类型，以秒为单位，比如1分钟bar, bar_type=60
        self.strtime = ''        ## Bar开始时间
        self.utc_time = 0.0      ## Bar开始时间
        self.strendtime = ''     ## Bar结束时间
        self.utc_endtime = 0.0   ## Bar结束时间
        self.open = 0.0          ## 开盘价
        self.high = 0.0          ## 最高价
        self.low = 0.0           ## 最低价
        self.close = 0.0         ## 收盘价
        self.volume = 0.0        ## 成交量
        self.amount = 0.0        ## 成交额
        self.pre_close           ## 前收盘价
        self.position;           ## 持仓量
        self.adj_factor          ## 复权因子
        self.flag                ## 除权出息标记
"""

"""
class Dailybar(object):

    def __init__(self):
        self.exchange = ''          ## 交易所代码
        self.sec_id = ''            ## 证券ID

        self.bar_type = 0           ## bar类型
        self.strtime = ''           ## 可视化时间
        self.utc_time = 0.0         ## 行情时间戳

        self.open = 0.0             ## 开盘价
        self.high = 0.0             ## 最高价
        self.low = 0.0              ## 最低价
        self.close = 0.0            ## 收盘价
        self.volume = 0.0           ## 成交量
        self.amount = 0.0           ## 成交额

        self.position = 0.0L        ## 仓位
        self.settle_price = 0.0     ## 结算价
        self.upper_limit = 0.0      ## 涨停价
        self.lower_limit = 0.0      ## 跌停价
        self.pre_close              ## 前收盘价
        self.adj_factor             ## 复权因子
        self.flag                   ## 除权出息，停牌等标记
"""

def disp_tick(tick):
    print("tick.exchange:",tick.exchange)
    print("tick.sec_id:",tick.sec_id)
    print("tick.utc_time:",tick.utc_time)
    print("tick.strtime:",tick.strtime)
    print("tick.last_price:",tick.last_price)
    print("tick.open:",tick.open)
    print("tick.high:",tick.high)
    print("tick.low:",tick.low)
    print("tick.cum_volume:",tick.cum_volume)
    print("tick.cum_amount:",tick.cum_amount)
    print("tick.cum_position:",tick.cum_position)
    print("tick.:",tick.last_volume)
    print("tick.last_volume:",tick.last_amount)
    print("tick.upper_limit:",tick.upper_limit)
    print("tick.lower_limit:",tick.lower_limit)
    print("tick.settle_price:",tick.settle_price)
    print("tick.trade_type:",tick.trade_type)
    print("tick.pre_close:",tick.pre_close)
    print("tick.bids:",tick.bids)
    print("tick.asks:",tick.asks)

def disp_bar(bar):
    print(" ")
    print("bar.exchange:", bar.exchange)        ## 交易所代码
    print("bar.sec_id:", bar.sec_id)            ## 证券ID
    print("bar.bar_type:", bar.bar_type)        ## bar类型，以秒为单位，比如1分钟bar, bar_type=60
    print("bar.strtime:", bar.strtime)          ## Bar开始时间
    print("bar.utc_time:", bar.utc_time)        ## Bar开始时间
    print("bar.strendtime:", bar.strendtime)    ## Bar结束时间
    print("bar.utc_endtime:", bar.utc_endtime)  ## Bar结束时间
    print("bar.open:", bar.open)                ## 开盘价
    print("bar.high:", bar.high)                ## 最高价
    print("bar.low:", bar.low)                  ## 最低价
    print("bar.close:", bar.close)              ## 收盘价
    print("bar.volume:", bar.volume)            ## 成交量
    print("bar.amount:", bar.amount)            ## 成交额
    print("bar.pre_close:", bar.pre_close)      ## 前收盘价
    print("bar.position:", bar.position)        ## 持仓量
    print("bar.adj_factor:", bar.adj_factor)    ## 复权因子
    print("bar.flag:", bar.flag)                ## 除权出息标记
    print(" ")


def to_local(utc):
  return arrow.get(utc).to('local')

class Mystrategy(StrategyBase):

    def __init__(self, *args, **kwargs):
        super(Mystrategy, self).__init__(*args, **kwargs)


    def on_login(self):
        print("login ok!")
        pass

    def on_error(self, code, msg):
        #print("error!",code,msg)

        pass

    def on_tick(self, tick):
        #print(tick)
        #print(time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())))
        #print('%s %s %s %s' % (to_local(time.time()), tick.strtime, tick.sec_id, tick.last_price))
        disp_tick(tick)

        pass

    def on_bar(self, bar):
        #disp_bar(bar)
        aa = tt.bar_topd([bar],'date')
        #xx = [pdata,aa]
        #pdata = pd.concat(xx)
        pdata.append(aa)
        xx = pd.concat(pdata)
        print(xx)
        print("len:",len(xx))

        print("----------------------------------------------------------")
        #print(pdata)

        #print(aa)
        print("  ")
        print("  ")
        pass

    def on_execrpt(self, res):
        pass

    def on_order_status(self, order):
        pass

    def on_order_new(self, res):
        pass

    def on_order_filled(self, res):
        pass

    def on_order_partiall_filled(self, res):
        pass

    def on_order_stop_executed(self, res):
        pass

    def on_order_canceled(self, res):
        pass

    def on_order_cancel_rejected(self, res):
        pass


if __name__ == '__main__':
    pdata = []
    myStrategy = Mystrategy(
        username='13601380996',
        password='it@iZ23psatkqsZ',
        strategy_id='7f46b97a-4932-11e7-b598-68f7283cd5ae',
        #subscribe_symbols='SHFE.ru1709.tick,SHFE.ru1709.bar.5',
        subscribe_symbols='SHFE.ru1709.bar.5',
        mode=4,
        td_addr='localhost:8001'
    )
    myStrategy.backtest_config(
        start_time='2017-05-01 09:05:00',
        end_time='2017-06-04 22:30:00',
        initial_cash=1000000,
        transaction_ratio=0.1,
        commission_ratio=0.0002,
        slippage_ratio=0.01,
        price_type=0)
    ret = myStrategy.run()
    print('exit code: ', ret)