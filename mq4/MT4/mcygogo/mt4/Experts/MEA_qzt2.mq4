//+------------------------------------------------------------------+
//|                                                     MEA_qzt2.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "qq1055655869"
#property version   "1.00"
#property strict

#include "../Include/MEA_Common.mqh"
#include "../Include/MEA_List.mqh"

input int    gPipsDiff = 100;
input double gBaseLots = 0.01;
input int    gSlippage = 3;
input int    gMagicNo = 668866;
input bool   gTestBuy = true;
input bool   gTestSell = true;
input bool   gJustOneTime = false;

bool gOpenOrderStarted = false;
string gCommentTxt = "M-EA()";
color  gColorOpenBuy   = Green;
color  gColorOpenBuyStop = Pink;
color  gColorCloseBuyStop = Pink;
color  gColorCloseBuy  = Black;
color  gColorOpenSell  = Red;
color  gColorOpenSellStop  = Pink;
color  gColorCloseSellStop = Pink;
color  gColorCloseSell = White;

void OnTick()
{

	if (CheckStop() == true)
	{
		return;
	}
	UpdateOrderList();

	AddOrders();	


	MoveBuyLimitOrder();
}


int BuyStopA = 0;
int BuyStopB = 0;
int BuyLimit = 0;
void AddOrders()
{
	double CurSpread = MarketInfo(Symbol(), MODE_SPREAD)*Point;
	if (gOpenOrderStarted == false)
	{
		OpenBuy(gBaseLots);
		DrawSign("Dot", 0, Ask, Red, 108,"", 100);
	}
	else
	{
		//if (Ask - GetMaxBuyOpenPrice() > gPipsDiff*Point + CurSpread)
		/*
		if (GetBuyLimitNum() < 1)
		{
			OpenBuyLimit(gBaseLots, GetMaxBuyOpenPrice() + gPipsDiff*Point+CurSpread);
			OpenBuyLimit(gBaseLots, GetMaxBuyOpenPrice() + gPipsDiff*Point+CurSpread);

		}
		*/
		if (GetBuyStopNum() < 1)
		{
			double BuyStopOpenPrice = GetMaxBuyOpenPrice()+gPipsDiff*Point+CurSpread;
			BuyStopA = OpenBuyStop(gBaseLots, BuyStopOpenPrice);
			if (BuyStopA > 0)
			{
				//double tp = BuyStopOpenPrice;
				double tp = BuyStopOpenPrice + gPipsDiff*Point+CurSpread;
				Print("Modify A order tp: "+ tp);
				ModifyBuyStop(BuyStopA, 0.0, tp);
			}
			BuyStopB = OpenBuyStop(gBaseLots, BuyStopOpenPrice);			
		}

		if (GetBuyLimitNum() < 1)
		{
			double BuyLimitOpenPrice = GetMinBuyOpenPrice() - gPipsDiff*Point-CurSpread;
			BuyLimit = OpenBuyLimit(gBaseLots, BuyLimitOpenPrice);
			if (BuyLimit > 0)
			{
				double BuyLimitTP = BuyLimitOpenPrice + gPipsDiff*Point + CurSpread;
				Print("Modify BuyLimit order tp: "+BuyLimitTP);
				ModifyBuyLimit(BuyLimit, 0.0, BuyLimitTP);
			}
			
		}
	}
	
}


void MoveBuyLimitOrder()
{
	double CurSpread = MarketInfo(Symbol(), MODE_SPREAD)*Point;
	
	if (GetBuyLimitNum() == 1)
	{
		if (GetMinBuyOpenPrice() - GetBuyLimitOrderOpenPrice(BuyLimit) > gPipsDiff*Point + CurSpread + 10*Point)
		{
			OrderDelete(BuyLimit);
			
			double BuyLimitOpenPrice = GetMinBuyOpenPrice() - gPipsDiff*Point-CurSpread;
			BuyLimit = OpenBuyLimit(gBaseLots, BuyLimitOpenPrice);
			if (BuyLimit > 0)
			{
				double BuyLimitTP = BuyLimitOpenPrice + gPipsDiff*Point + CurSpread;
				Print("Modify BuyLimit order tp: "+BuyLimitTP);
				ModifyBuyLimit(BuyLimit, 0.0, BuyLimitTP);
			}
		}
	}
}

double GetBuyLimitOrderOpenPrice(int ticket)
{
	if (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES))
	{
		if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNo)
		{
			return OrderOpenPrice();
		}
	}
	return 0.0;
}
void ModifyBuyLimit(int Ticket, double StopLoss, double TakeProfit)
{
	double sl = NormalizeDouble(StopLoss, Digits);
	double tp = NormalizeDouble(TakeProfit, Digits);
	if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
	{
		if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo)
		{
			if (OrderType() == OP_BUYLIMIT)
			{
				if (sl > 0  && NormalizeDouble(OrderStopLoss(),Digits)== sl)
				{
					Print("Do NOT need modify the BuyStop SL ");
					return;
				}
				if (tp > 0 && NormalizeDouble(OrderTakeProfit(),Digits)== tp)
				{
					Print("Do NOT need modify the BuyStop TP ");
				    return;
				}
				bool ModifyOK = OrderModify(OrderTicket(), OrderOpenPrice(), sl, tp, 0, Red);
				if (ModifyOK == false)
				{
					Print("OrderModify BuyLimit Order: "+DoubleToString(OrderTicket())+
							" Error: "+ DoubleToString(GetLastError()));
					return;
				}

			}

		}
	}

}

void ModifyBuyStop(int Ticket, double StopLoss, double TakeProfit)
{
	double sl = NormalizeDouble(StopLoss, Digits);
	double tp = NormalizeDouble(TakeProfit, Digits);
	if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
	{
		if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo)
		{
			if (OrderType() == OP_BUYSTOP)
			{
				if (sl > 0  && NormalizeDouble(OrderStopLoss(),Digits)== sl)
				{
					Print("Do NOT need modify the BuyStop SL ");
					return;
				}
				if (tp > 0 && NormalizeDouble(OrderTakeProfit(),Digits)== tp)
				{
					Print("Do NOT need modify the BuyStop TP ");
				    return;
				}
				bool ModifyOK = OrderModify(OrderTicket(), OrderOpenPrice(), sl, tp, 0, Red);
				if (ModifyOK == false)
				{
					Print("OrderModify BuyStop Order: "+DoubleToString(OrderTicket())+
							" Error: "+ DoubleToString(GetLastError()));
					return;
				}

			}

		}
	}

}

int OpenBuyLimit(double BuyLots, double Price)
{		
	if (BuyLots == 0)
	{
		Print("BuyLot is 0+++++++++++");
		return -1;		
	}

	Print("Do BuyLimit OrderSend============");
	int ticket = OrderSend(Symbol(), OP_BUYLIMIT, BuyLots, Price, gSlippage, 0, 0, gCommentTxt, gMagicNo, 0, gColorOpenBuyStop);
	if (ticket > -1)
	{
		Print("Open BuyLimit Order Success");
		UpdateOrderList();

		return (ticket);
	}
	else
	{
		Print("Open BuyLimit Order Error: "+ DoubleToString(GetLastError()));
		return -1;
	}
}

int OpenBuyStop(double BuyLots, double Price)
{		
	if (BuyLots == 0)
	{
		Print("BuyLot is 0+++++++++++");
		return -1;		
	}

	Print("Do BuyStop OrderSend============");
	int ticket = OrderSend(Symbol(), OP_BUYSTOP, BuyLots, Price, gSlippage, 0, 0, gCommentTxt, gMagicNo, 0, gColorOpenBuyStop);
	if (ticket > -1)
	{
		Print("Open BuyStop Order Success");
		UpdateOrderList();
		return (ticket);
	}
	else
	{
		Print("Open BuyStop Order Error: "+ DoubleToString(GetLastError()));
		return -1;
	}
}

void OpenBuy(double BuyLots)
{
	
	if (BuyLots == 0)
	{
		Print("BuyLot is 0+++++++++++");
		return ;
	}

	//double dStopLoss = 0, dTakeProfit = 0;
	Print("Do Buy OrderSend============");
	int order = OrderSend(Symbol(), OP_BUY, BuyLots, Ask, 
				gSlippage, 0, 0, gCommentTxt, gMagicNo, 0, gColorOpenBuy);
	if (order > -1)
	{
		Print("Open Buy Order Success");
		UpdateOrderList();
		if (gOpenOrderStarted == false)
		{
			gOpenOrderStarted = true;
		}
	}
	else
	{
		Print("Open Buy Order Error: "+ DoubleToString(GetLastError()));
	}


}


bool CheckStop()
{	
	if (gJustOneTime == false)
	{
		return false;
	}
	else
	{
		if (OrdersNumber(TOTAL_ORDER, gMagicNo) == 0 && gOpenOrderStarted == true)
		{
			return true;
		}
		return false;
	}
}

int OnInit()
{
	OrderListInit(gMagicNo);
	return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   
}
