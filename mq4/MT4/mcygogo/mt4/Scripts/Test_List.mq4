//+------------------------------------------------------------------+
//|                                                    Test_List.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+


#include "../Include/MEA_List.mqh"
#include "../Include/MEA_Common.mqh"


void OnStart()
{
//---
	OrderList BuyOrderList;
	OrderListInit(BuyOrderList, BUY_ORDER);
	for (int i = 0; i < 10; i++)
	{
		Order TmpOrder;
		TmpOrder.Type = BUY_ORDER;
		TmpOrder.Ticket = i;
		OrderListPush(TmpOrder, BuyOrderList);
	}

	OrderListPrintAll(BuyOrderList);
}
//+------------------------------------------------------------------+
