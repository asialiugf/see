//+------------------------------------------------------------------+
//|                                                     MEA_List.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

#include "MEA_Common.mqh"

struct Order
{
	int Ticket;
	int OpenTime;
	double OpenPrice;
	ORDER_TYPE Type;
	double Lots;
	double StopLoss;
	double TakeProfit;
	int MagicNum;
	double Commission;
};

struct OrderList
{
	ORDER_TYPE ListType;
	int OrdersNum;
	Order OrdersArray[];
};

OrderList BuyOrderList;
OrderList SellOrderList;
OrderList BuyLimitOrderList;
OrderList SellLimitOrderList;
OrderList BuyStopOrderList;
OrderList SellStopOrderList;

int MagicNo;

Order Null_Order;


void UpdateOrderList()
{	
	int BuyNum = OrdersNumber(BUY_ORDER, MagicNo);
	int SellNum = OrdersNumber(SELL_ORDER, MagicNo);
	int BuyLimitNum = OrdersNumber(BUYLIMIT_ORDER, MagicNo);
	int SellLimitNum = OrdersNumber(SELLLIMIT_ORDER, MagicNo);
	int BuyStopNum = OrdersNumber(BUYSTOP_ORDER, MagicNo);
	int SellStopNum = OrdersNumber(SELLSTOP_ORDER, MagicNo);
	
	if (BuyNum > BuyOrderList.OrdersNum)
	{
		AddOrder(BuyOrderList);
	}
	else if (BuyNum < BuyOrderList.OrdersNum)
	{
		DeleteOrder(BuyOrderList);
	}

	if (SellNum > SellOrderList.OrdersNum)
	{
		AddOrder(SellOrderList);
	}
	else if (SellNum < SellOrderList.OrdersNum)
	{
		DeleteOrder(SellOrderList);
	}

	if (BuyLimitNum > BuyLimitOrderList.OrdersNum)
	{
		AddOrder(BuyLimitOrderList);
	}
	else if (BuyLimitNum < BuyLimitOrderList.OrdersNum)
	{
		DeleteOrder(BuyLimitOrderList);
	}

	if (SellLimitNum > SellLimitOrderList.OrdersNum)
	{
		AddOrder(SellLimitOrderList);
	}
	else if (SellLimitNum < SellLimitOrderList.OrdersNum)
	{
		DeleteOrder(SellLimitOrderList);
	}

	if (BuyStopNum > BuyStopOrderList.OrdersNum)
	{
		AddOrder(BuyStopOrderList);
	}
	else if (BuyStopNum < BuyStopOrderList.OrdersNum)
	{
		DeleteOrder(BuyStopOrderList);
	}

	if (SellStopNum > SellStopOrderList.OrdersNum)
	{
		AddOrder(SellStopOrderList);
	}
	else if (SellStopNum < SellStopOrderList.OrdersNum)
	{
		DeleteOrder(SellStopOrderList);
	}

/*	
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNo) // Checking magic number to make sure this order opened by EA
			{
				
			}
		}
	}
*/
}


int GetBuyLimitNum()
{
	return GetOrderNum(BuyLimitOrderList);
}

int GetBuyStopNum()
{
	return GetOrderNum(BuyStopOrderList);
}

int GetOrderNum(OrderList &List)
{
	//Print("OrdersNum: "+ List.OrdersNum);
	return List.OrdersNum;
}

Order GetLastOpenTimeOrder(OrderList &List)
{
	int TmpTime = 0;
	int Index = 0;
	for(int i = 0; i < List.OrdersNum; i++)
	{
		if (TmpTime < List.OrdersArray[i].OpenTime)
		{
			TmpTime = List.OrdersArray[i].OpenTime;
			Index = i;
		}
	}

	return List.OrdersArray[Index];
}

double GetMaxBuyOpenPrice()
{
	Order TmpOrder = GetMaxOpenPriceOrder(BuyOrderList);
	if (TmpOrder.Ticket < 0)
	{
		return -1;
	}
	return TmpOrder.OpenPrice;
}

Order GetMaxOpenPriceOrder(OrderList &List)
{
	if (List.OrdersNum == 0)
	{
		Print("No Order in the List, Type: "+ List.ListType);
		return Null_Order;
	}
	double TmpPrice = 0.0;
	int Index = 0;
	for(int i = 0; i < List.OrdersNum; i++)
	{
		if (TmpPrice < List.OrdersArray[i].OpenPrice)
		{
			TmpPrice = List.OrdersArray[i].OpenPrice;
			Index = i;
		}
	}	
	//Print("Index: "+ Index);
	return List.OrdersArray[Index];
}

double GetMinBuyOpenPrice()
{
	Order TmpOrder = GetMinOpenPriceOrder(BuyOrderList);
	if (TmpOrder.Ticket < 0)
	{
		return -1;
	}
	return TmpOrder.OpenPrice;
}

Order GetMinOpenPriceOrder(OrderList &List)
{
	if (List.OrdersNum == 0)
	{
		Print("No Order in the List, Type: "+ List.ListType);
		return Null_Order;
	}
	double TmpPrice = List.OrdersArray[0].OpenPrice;
	int Index = 0;
	for(int i = 0; i < List.OrdersNum; i++)
	{
		if (TmpPrice > List.OrdersArray[i].OpenPrice)
		{
			TmpPrice = List.OrdersArray[i].OpenPrice;
			Index = i;
		}
	}	
	//Print("Index: "+ Index);
	return List.OrdersArray[Index];
}

void AddOrder(OrderList &List)
{
	RegenList(List);

}

void DeleteOrder(OrderList &List)
{	
	RegenList(List);
}

void RegenList(OrderList &List)
{
	Order TmpOrder;
	ResetOrderList(List);
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNo)
			{
				if (OrderType() == ConvertType(List.ListType))
				{
					TmpOrder.Type = List.ListType;
					TmpOrder.Ticket = OrderTicket();
					TmpOrder.OpenTime = OrderOpenTime();
					TmpOrder.OpenPrice = OrderOpenPrice();
					OrderListPush(TmpOrder, List);
				}
			}
		}
	}	
}

void ResetOrderList(OrderList &List)
{

	List.OrdersNum = 0;
	ArrayResize(List.OrdersArray, 0);

}

int ConvertType(ORDER_TYPE Type)
{
	switch(Type)
	{
		case BUY_ORDER:
			return OP_BUY;
			break;
		case BUYLIMIT_ORDER:
			return OP_BUYLIMIT;
			break;
		case BUYSTOP_ORDER:
			return OP_BUYSTOP;
			break;
		case SELL_ORDER:
			return OP_SELL;
			break;
		case SELLLIMIT_ORDER:
			return OP_SELLLIMIT;
			break;
		case SELLSTOP_ORDER:
			return OP_SELLSTOP;
			break;
		default:
			Print("OrdersNumber input error :" + DoubleToStr(Type));
			return (0);
			break;
	}
}

void OrderListInit(int _MagicNo = 888888)
{
	MagicNo = _MagicNo;
	Null_Order.Ticket = -1;
	
	BuyOrderList.ListType = BUY_ORDER;
	BuyOrderList.OrdersNum = 0;

	SellOrderList.ListType = SELL_ORDER;
	SellOrderList.OrdersNum = 0;

	BuyLimitOrderList.ListType = BUYLIMIT_ORDER;
	BuyLimitOrderList.OrdersNum = 0;

	SellLimitOrderList.ListType = SELLLIMIT_ORDER;
	SellLimitOrderList.OrdersNum = 0;

	BuyStopOrderList.ListType = BUYSTOP_ORDER;
	BuyStopOrderList.OrdersNum = 0;

	SellStopOrderList.ListType = SELLSTOP_ORDER;
	SellStopOrderList.OrdersNum = 0;
	
}

void OrderListDeinit()
{
	//BuyOrderList.ListType = 0;
	BuyOrderList.OrdersNum = 0;

	//SellOrderList.ListType = 0;
	SellOrderList.OrdersNum = 0;

	BuyLimitOrderList.OrdersNum = 0;
	SellLimitOrderList.OrdersNum = 0;

	BuyStopOrderList.OrdersNum = 0;
	SellStopOrderList.OrdersNum = 0;
	
}

void OrderListPush(Order &_Order, OrderList &List)
{
	ArrayResize(List.OrdersArray, List.OrdersNum+1);
	List.OrdersNum = List.OrdersNum+1;
	List.OrdersArray[List.OrdersNum-1] = _Order;

}

void OrderListPrintAll(OrderList &List)
{
	for (int i= 0; i < List.OrdersNum; i++)
	{
		Print("Type: "+ DoubleToStr(List.OrdersArray[i].Type)+ 
		      "Ticket: "+DoubleToStr(List.OrdersArray[i].Ticket));
	}
}
