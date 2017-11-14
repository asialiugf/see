设计思路：
A: 开单lots大小分3种情况，mmTradeLots，mmTestLots，0
   1：当历史盈利是0，或者是负，就开mmTestLots，如果历史数据是盈利，就开mmTradeLots；
   2：当交易日是周五下午，和12月份后半月的时候，将限制开单数，可以根据客户需求修改
   3：点差过大时，将停止开单
   4：当保证金太少时，将停止开单
   5：mmTradeLots和mmTestLots，将根据实际平台动态改变