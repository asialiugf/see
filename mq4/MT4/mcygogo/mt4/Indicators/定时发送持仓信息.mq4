//+------------------------------------------------------------------+
//|                                                OrderSendMail.mq4 |
//|                       Copyright ?2011, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2011, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
//#property strict
#property indicator_chart_window
//--- input parameters
//input int IntervalMinutes=1;
extern int IntervalMinutes=1;
int start(){
MT4_Timer_runfun(IntervalMinutes*60);
return(0);
}


void MT4_Timer_runfun(int _interval){
   //static int s=0;
   static datetime lasttime=0;
   static int exec_cnt=0; //ִ�еĴ����������3��. exec_cnt=2��ʾ�Ѿ���tick������һ�Ρ�
   datetime deltaT,tmcur;
   int EN_MAX=_interval;
   static int EN_cur=0;
   tmcur=TimeCurrent();
   deltaT=tmcur-lasttime;lasttime=tmcur;
   EN_cur+=deltaT; 
   if ( (exec_cnt<=2 && (1)) ||((exec_cnt>2))&&(EN_cur>=EN_MAX) ){EN_cur=0; trySendMail();}
   if (exec_cnt<3) exec_cnt++;
}

void trySendMail(){
  string y=collect_onHoldOrder(); 
  SendMail("order_on_hold",y);
  Print("try send email");
}

string GetOrderType(int type)
{
   string type_str = "";
   switch(type)
   {
      case 0:
         type_str = "BUY";     
         break;
      case 1:
         type_str = "SELL";
         break;
      case 2:
         type_str = "BULYLIMIT";
         break;
      case 3:
         type_str = "BUYSTOP";
         break;
      case 4:
         type_str = "SELLLIMIT";
         break;
      case 5:
         type_str = "SELLSTOP";
         break;
   }
   return (type_str);
}

string collect_onHoldOrder()
{
   int i=OrdersTotal();
   string tmp="";
   //tmp=StringConcatenate(tmp,"\n","OrderClosePrice,OrderCloseTime,OrderComment,OrderCommission,OrderExpiration,OrderLots,OrderMagicNumber, OrderOpenPrice, OrderOpenTime, OrderProfit, OrderStopLoss, OrderSwap, OrderSymbol, OrderTakeProfit, OrderTicket, OrderType,AccountServer,AccountCompany,AccountNumber,AccountName,AccountCurrency,AccountLeverage,AccountBalance,AccountEquity,AccountMargin,AccountFreeMargin");
   //�����ţ�����Ʒ�֣��������ͣ����ּۣ��ּۣ�ӯ��
   tmp = StringConcatenate(tmp, "\n", "������, ", "����, ", "����Ʒ��, ", "��������, ", "���ּ� ,", "�ּ�  ,", "ӯ��  ,");
   for (;i>=0;i--) 
   {
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES ))
      {
            tmp = StringConcatenate(tmp,
            "\n",  OrderTicket(),
            ", ",  OrderLots(),
            ", ",  OrderSymbol(),
            ", ",  GetOrderType(OrderType()),
            //", ",  OrderType(),
            ", ",  OrderOpenPrice(),
            ", ",  MarketInfo(OrderSymbol(),MODE_BID),
            ", ",  OrderProfit());
/*
            tmp=StringConcatenate(tmp,
            "������: ", OrderTicket(),
            ", ", "����Ʒ�֣�", OrderSymbol(), 
            ", ", "�������ͣ� ",OrderType(),
            ", ", "ƽ�ּۣ�", OrderClosePrice(),
            ", ", "ƽ��ʱ�䣺",OrderCloseTime(),
            ", ", "�������� ",OrderLots(),
            ", ", "�����ۣ�", OrderOpenPrice(),
            ", ", "�µ�ʱ�䣺 ", OrderOpenTime(),
            ", ", "����: ", OrderProfit(),
            ", ", "ֹ��", OrderStopLoss(),
            ", ", "ֹӯ��", OrderTakeProfit(),
            ", ", "�˻���", AccountBalance(),
            ", ", "�˻���ֵ��", AccountEquity(),
            ", ", "�˻���֤��:", AccountMargin());  
*/      
      }
   }
   return(tmp);
}

//+------------------------------------------------------------------+

