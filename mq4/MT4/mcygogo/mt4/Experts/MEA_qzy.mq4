//+------------------------------------------------------------------+
//|                                                      MEA_qzy.mq4 |
//|                                                          Michael |
//|                                                       1055655869 |
//+------------------------------------------------------------------+
#property copyright "mea"
#property link      "qq1055655869"
#property version   "1.00"
#property strict
#include <stderror.mqh>
#include <stdlib.mqh>

//--- input parameters
input int    gPipsDiff = 100;  
input int    gSlippage = 3;
input int    gTotalOrders = 50;
input double gDefaultLots = 0.01;
input double gRisk = 2.00;
//input double gSL_1  = 0.55;
input double gFOProfit = 0.0;
input double gFO_SL_S = 0.0;
input double gFO_SL_P = 0.0;
input double gSO_SL_S = 0.0;
input double gSO_SL_P = 0.0;
input double gSL_345 = 0.6;
input double gSL_678 = 0.65;
input double gSL_9 = 0.7;
//input double gSL_10 = 0.75;
input double gUnlockProfit = 0.0;
input int    gMagicNo = 668866;
input bool   gTestBuy = true;
input bool   gTestSell = true;
input bool   gJustOneTime = false;

#define BUY_ORDERS       1
#define BUYLIMIT_ORDERS  2
#define BUYSTOP_ORDERS   3
#define SELL_ORDERS      4
#define SELLLIMIT_ORDERS 5
#define SELLSTOP_ORDERS  6
#define TOTAL_ORDERS     7

double gPriceDiff = 0.0;
double gLine0Price = Bid;
double gLastBuyPrice = 0.0;
double gLastSellPrice = 0.0;
string CommentTxt = "M-EA()";
color  gColorOpenBuy   = Green;
color  gColorOpenBuyStop = Pink;
color  gColorCloseBuyStop = Pink;
color  gColorCloseBuy  = Black;
color  gColorOpenSell  = Red;
color  gColorOpenSellStop  = Pink;
color  gColorCloseSellStop = Pink;
color  gColorCloseSell = White;
bool   gOpenOrderStarted = false;
int gLockedBuyOrderTicket = -1;
int gLockedSellOrderTicket = -1;

int OnInit()
{
	gLine0Price = Bid;
	DrawLine("HLine", 0, gLine0Price, White);

	DrawLine("VLine", 0, gLine0Price, White);
	gPriceDiff = gPipsDiff*Point;

	gLastBuyPrice = gLine0Price;
	gLastSellPrice = gLine0Price;

	
	return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
}

int gInLockMode = 0;
int gInLockBuyMode = 0;
int gInLockSellMode = 0;
int gSellStopDone = 0;
int gBuyStopDone = 0;
int gSellStopTicket = -1;
int gBuyStopTicket = -1;
void OnTick()
{
	if (CheckStop() == true)
	{
		return;
	}

	ResetLine0();
	

	//Check SellStop order  
	if (gSellStopTicket > -1 && CheckSellStopDone() && gInLockMode == 0)
	{
		gInLockBuyMode = 1;
		gInLockMode = 1;
		SetLockedOrdersTicket();
	}
	//Check BuyStop order
	if (gBuyStopTicket > -1 && CheckBuyStopDone() && gInLockMode == 0)
	{
		gInLockSellMode = 1;
		gInLockMode = 1;
		SetLockedOrdersTicket();
	}

	if (gInLockMode == 1)
	{
		UnlockOrders();
	}
	
	if (ModifyOrders() == true)
	{
		//return ;
	}


	//add orders
	AddOrders();
	
}

void UnlockOrders()
{
	bool UnlockOK = false;
	if (CheckOrdersProfit() == true)
	{
		UnlockOK = CloseAllOrders();
	}
	if (UnlockOK == true)
	{
		Print("Unlock success, Now Reset the EA!");
		gInLockMode = 0;

		ResetLine0();
	}
}

bool CloseAllOrders()
{
	int OrdersNum = OrdersTotal();
	//for (int i = 0; i < OrdersNum; i++)
	while(OrdersTotal()>0)
	{
		Print("In CloseAllOrders: OrdersTotal: "+DoubleToStr(OrdersTotal()));
		if (OrderSelect(OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				bool CloseOK = false;
				if (OrderType() == OP_BUY)
				{
					CloseOK = OrderClose(OrderTicket(), OrderLots(), Bid, gSlippage, gColorCloseBuy);
					if (CloseOK == false)
					{
						Print("in CloseAllOrders, Close Buy Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
						return false;
					}
				}
				if (OrderType() == OP_SELL)
				{
					CloseOK = OrderClose(OrderTicket(), OrderLots(), Ask, gSlippage, gColorCloseSell);
					if (CloseOK == false)
					{
						Print("in CloseAllOrders, Close Sell Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
						return false;
					}					
				}
			}
		}
	}	
	return true;

}

bool CheckOrdersProfit()
{
	double ProfitSum = 0;
	//Print("OrdersTotal: "+ DoubleToStr(OrdersTotal()));
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				ProfitSum = ProfitSum + OrderProfit();

				//Print("OrderTicket: " +DoubleToStr(OrderTicket())+
				//	  "ProfitSum: "+DoubleToStr(ProfitSum)+
				//      " OrderProfit: "+DoubleToStr(OrderProfit()));
			}
		}
	}
	if (ProfitSum >= gUnlockProfit)
	{
		return true;
	}

	return false;
}


bool SetLockedOrdersTicket()
{
	int LockedBuyOrderNum = 0;
	int LockedSellOrderNum = 0;
	for (int i = 0; i < OrdersTotal(); i++)
	{
		//Print("In CloseAllOrders: OrdersTotal: "+DoubleToStr(OrdersTotal()));
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				//bool CloseOK = false;
				if (OrderType() == OP_BUY)
				{
					LockedBuyOrderNum++;
					if (LockedBuyOrderNum > 1)
					{
						Print("In Lock Mode, But Locked Buy Order Number > 0, It's not right, ticket:"+ DoubleToStr(OrderTicket()));
						return false;
					}
					gLockedBuyOrderTicket = OrderTicket();

				}
				if (OrderType() == OP_SELL)
				{
					LockedSellOrderNum++;
					if (LockedSellOrderNum > 1)
					{
						Print("In Lock Mode, But Locked Sell Order Number > 0, It's not right, ticket:"+ DoubleToStr(OrderTicket()));
						return false;
					}
					gLockedSellOrderTicket = OrderTicket();
				}
			}
		}
	}	
	
	return true;
}

int gFirstBuyOrder = 0;
int gFirstSellOrder = 0;
int gSellStopStatus = 0; // When open the SellStop order set it to 1
int gBuyStopStatus = 0;  // When open the BuyStop roder  set it to 1
bool gSecBuyOrderPass = false;
bool gSecSellOrderPass = false;
void AddOrders()
{

	double lots = GetLots();
	if (Ask - gLastBuyPrice  > gPriceDiff)
	{
		//Add Buy Order
		if (gTestBuy == true)
		{
			OpenBuy(lots);
			gLastBuyPrice = Ask;
			if (gFirstBuyOrder == 0 && gInLockMode != 1)
			{
				gFirstBuyOrder = 1; //should be reset in ResetLine0()
				gSellStopTicket = OpenSellStop(lots, gLine0Price);
			}
			else if (gFirstBuyOrder > 0 && gSellStopStatus == 1 && gSellStopTicket != -1 && gInLockMode != 1) // close the SellStop
			{
				DeleteSellStop();
			}
		}
		return ;
	}
	if (gLastSellPrice - Bid > gPriceDiff)
	{
		//Add Sell Order
		if (gTestSell == true)
		{
			OpenSell(lots);
			gLastSellPrice = Bid;
			if (gFirstSellOrder == 0 && gInLockMode != 1)
			{
				gFirstSellOrder = 1;
				gBuyStopTicket = OpenBuyStop(lots, gLine0Price);
			}
			else if (gFirstSellOrder > 0 && gBuyStopStatus == 1 && gBuyStopTicket != -1 && gInLockMode != 1)
			{
				DeleteBuyStop();
			}
		}
		return ;
	}
}

//bool CheckReset()
//{
//	if ()
//	return (false);
//}

bool CheckStop()
{	
	if (gJustOneTime == false)
	{
		return false;
	}
	else
	{
		if (OrdersNumber(TOTAL_ORDERS) == 0 && gOpenOrderStarted == true)
		{
			return true;
		}
		return false;
	}
}



void ResetLine0()
{
	//Print("In ResetLine0: OrdersNumber:"+DoubleToStr(OrdersNumber(TOTAL_ORDERS))+
	//	  " gOpenOrderStarted: "+DoubleToStr(gOpenOrderStarted));
	if (OrdersNumber(TOTAL_ORDERS) == 0 && gOpenOrderStarted == true) //No Orders , so reset 
	{

		Print("Do ResetLine0 ");
		gLastBuyPrice = Bid; //or Ask ??
		gLastSellPrice = Bid;
		gLine0Price = Bid; //or Ask ???
		DrawLine("HLine", 0, Bid, White);
		DrawLine("VLine", 0, Bid, White);

		gOpenOrderStarted = false;

		gFirstBuyOrder = 0;
		gSellStopStatus = 0;
		gSellStopDone = 0;
		gSellStopTicket = -1;
		gSecBuyOrderPass = false;

		gFirstSellOrder = 0;
		gBuyStopStatus = 0;
		gBuyStopDone = 0;
		gBuyStopTicket = -1;
		gSecSellOrderPass = false;
		
	}
}



bool ModifyOrders()
{
	//double RetracementPips = 0.0;
	double ProfitPips = 0.0;
	int BuyOrdersNum = 0;
	double SLBase = 0.0;
	double CurSpread = MarketInfo(Symbol(), MODE_SPREAD);
	double StopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
	//Only Buy Orders
	//if (gInLockMode != 1 && OrdersNumber(TOTAL_ORDERS) > 0 && OrdersNumber(SELLSTOP_ORDERS) == 0 && OrdersNumber(SELL_ORDERS) == 0)
	if (gInLockMode != 1 && OrdersNumber(TOTAL_ORDERS) > 0 && OrdersNumber(SELL_ORDERS) == 0)
	{
		BuyOrdersNum = OrdersNumber(BUY_ORDERS);
		//RetracementPips = Bid - gLine0Price;
		ProfitPips = Bid - (gLine0Price+gPriceDiff);
		SLBase = BuyOrdersNum*gPriceDiff;
		
		//Print("BuyOrderNum: "+DoubleToStr(BuyOrdersNum)+
		//	  "ProfitPips:"+DoubleToStr(ProfitPips)+
		//	  "Point: "+DoubleToStr(Point)+
		//      " CurSpread:"+DoubleToStr(CurSpread*Point)+
		//      " StopLevel:"+DoubleToStr(StopLevel*Point));		
		if (BuyOrdersNum == 1)
		{
			if (gFO_SL_S > 0)
			{
				if ( (Bid - gLine0Price) >= gFO_SL_S*Point )
				{
					if (doModifyBuyOrder(gLine0Price + gFO_SL_P*Point))
					{
						DeleteSellStop();
						return true;
					}
				}
			}
			else
			{
				if (ProfitPips >= (CurSpread + StopLevel + gFOProfit)*Point)
				{
					if (doModifyBuyOrder(gLine0Price + (gPipsDiff + CurSpread + gFOProfit)*Point))
					{
						//after set SL for first buy order delete the sellstop
						DeleteSellStop();
						return true;
					}
				}
			}
		}
		if (BuyOrdersNum == 2)
		{
			if (gSO_SL_S > 0)
			{
				//Plan A:
				//if ((Bid - gLine0Price) >= gSO_SL_S*Point )
				//{
				//	if (doModifyBuyOrder(gLine0Price + gSO_SL_P*Point))
				//	{
				//		return true;
				//	}
				//}

				//Plan B:
				if ((Bid - gLine0Price) >= gSO_SL_S*Point)
				{
					gSecBuyOrderPass = true;
				}
				if (gSecBuyOrderPass == true && ((Bid-gLine0Price) < gSO_SL_S*Point))
				{
					CloseAllOrders();
				}
			}
			else
			{
				if (doModifyBuyOrder(gLine0Price + (gPipsDiff + CurSpread*2)*Point))
				{
					return true;
				}
			}
		}
		//if (BuyOrdersNum == 3)  
		//{
		//	if (ProfitPips >= BuyOrdersNum*gPriceDiff*gSL_23)
		//	{
		//		if (doModifyBuyOrder(SLBase*gSL_23 + gLine0Price + gPriceDiff - StopLevel*Point))
		//		{
		//			return true;
		//		}			
		//	}
		//}
		if (BuyOrdersNum > 2 && BuyOrdersNum <= 5)
		{
			//if (RetracementPips <= ProfitPips * gSL_456)
			if (ProfitPips >= BuyOrdersNum*gPriceDiff*gSL_345)
			{
				if (doModifyBuyOrder(SLBase*gSL_345 + gLine0Price + gPriceDiff - StopLevel*Point))
				{
					return true;
				}			
			}
		}
		if (BuyOrdersNum > 5 && BuyOrdersNum <= 8)
		{
			if (ProfitPips >= BuyOrdersNum*gPriceDiff*gSL_678)
			{
				if (doModifyBuyOrder(SLBase*gSL_678 + gLine0Price + gPriceDiff - StopLevel*Point))
				{
					return true;
				}			
			}
		}
		if (BuyOrdersNum >= 9) 
		{
			if (ProfitPips >= BuyOrdersNum*gPriceDiff*gSL_9)
			{
				if (doModifyBuyOrder(SLBase*gSL_9 + gLine0Price + gPriceDiff - StopLevel*Point))
				{
					return true;
				}			
			}
		}
		
	}


	//Only Sell Orders
	int SellOrdersNum = 0;
	if (gInLockMode != 1 && OrdersNumber(TOTAL_ORDERS) > 0 && OrdersNumber(BUY_ORDERS) == 0)
	{
		SellOrdersNum = OrdersNumber(SELL_ORDERS);
		ProfitPips = gLine0Price - Ask - gPriceDiff;
		SLBase = SellOrdersNum*gPriceDiff;

		//Print("SellOrderNum: "+DoubleToStr(SellOrdersNum)+
		//	  "ProfitPips:"+DoubleToStr(ProfitPips)+
		//	  "Point: "+DoubleToStr(Point)+
		//      " CurSpread:"+DoubleToStr(CurSpread*Point)+
		//      " StopLevel:"+DoubleToStr(StopLevel*Point));		
		if (SellOrdersNum == 1)
		{
			if (gFO_SL_S > 0)
			{
				if ( (gLine0Price - Ask) >= gFO_SL_S*Point )
				{
					if (doModifySellOrder(gLine0Price - gFO_SL_P*Point))
					{
						DeleteBuyStop();
						return true;
					}
				}
			}
			else
			{
				if (ProfitPips >= (CurSpread + StopLevel + gFOProfit)*Point)
				{
					if (doModifySellOrder(gLine0Price - (gPipsDiff + CurSpread + gFOProfit)*Point))
					{
						//after set SL for first sell order delete the sellstop
						DeleteBuyStop();
						return true;
					}
				}
			}
		}
		if (SellOrdersNum == 2)
		{
			if (gSO_SL_S > 0)
			{
				//Plan A:
				//if ( (gLine0Price - Ask) >= gSO_SL_S*Point )
				//{
				//	if (doModifySellOrder(gLine0Price - gSO_SL_P*Point))
				//	{
				//		return true;
				//	}
				//}

				//Plan B:
				if ((gLine0Price - Ask) >= gSO_SL_S*Point)
				{
					gSecSellOrderPass = true;
				}
				if (gSecSellOrderPass == true && ((gLine0Price - Ask)<gSO_SL_S*Point))
				{
					CloseAllOrders();
				}

			}
			else
			{		
				if (doModifySellOrder(gLine0Price - (gPipsDiff + CurSpread*2)*Point))
				{
					return true;
				}
			}
		}
		//if (SellOrdersNum == 3)
		//{
		//	if (ProfitPips >= gPriceDiff*gSL_23)
		//	{
		//		if (doModifySellOrder(gLine0Price - gPriceDiff - SLBase*gSL_23 + StopLevel*Point))
		//		{
		//			return true;
		//		}
		//	}
		//}
		if (SellOrdersNum > 2 && SellOrdersNum <= 5)
		{
			if (ProfitPips >= gPriceDiff*gSL_345)
			{
				if (doModifySellOrder(gLine0Price - gPriceDiff - SLBase*gSL_345 + StopLevel*Point))
				{
					return true;
				}
			}
		}
		if (SellOrdersNum > 5 && SellOrdersNum <= 8)
		{
			if (ProfitPips >= gPriceDiff*gSL_678)
			{
				if (doModifySellOrder(gLine0Price - gPriceDiff - SLBase*gSL_678 + StopLevel*Point))
				{
					return true;
				}
			}
		}
		if (SellOrdersNum >= 9)
		{
			if (ProfitPips >= gPriceDiff*gSL_9)
			{
				if (doModifySellOrder(gLine0Price - gPriceDiff - SLBase*gSL_9 + StopLevel*Point))
				{
					return true;
				}
			}
		}
	}

	//In Lock mode
	if (gInLockMode == 1)
	{
		//Print("In Lock Mode, Locked Buy Ticket: "+DoubleToStr(gLockedBuyOrderTicket)+
		//      ", Locked Sell Ticket: "+DoubleToStr(gLockedSellOrderTicket));

		if (OrdersNumber(TOTAL_ORDERS) > 2)
		{
			ModifyExtrOrders();
		}
	}
	
	return false;	
}

bool ModifyExtrOrders()
{
	if (CheckOrdersProfit() == true)
	{
	}
	else
	{
	}
	return true;
}

double GetBalancePoint()
{
/*
	double ProfitSum = 0;
	Print("OrdersTotal: "+ DoubleToStr(OrdersTotal()));
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				ProfitSum = ProfitSum + OrderProfit();

				//Print("OrderTicket: " +DoubleToStr(OrderTicket())+
				//	  "ProfitSum: "+DoubleToStr(ProfitSum)+
				//      " OrderProfit: "+DoubleToStr(OrderProfit()));
			}
		}
	}
	if (ProfitSum >= 0)
	{
		return true;
	}

	return false;
*/
	return (0.0);
}

bool doModifyBuyOrder(double sl)
{
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				if (OrderType() == OP_BUY)
				{
					//bool CloseOK = OrderClose(OrderTicket(), OrderLots(), Bid, gSlippage, gColorCloseBuy);
					//if (CloseOK == false)
					//{
					//	Print("Close Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
					//}
					if (NormalizeDouble(OrderStopLoss(),Digits)== NormalizeDouble(sl, Digits))
					{
						//Print("Do NOT need modify the SL , just go on");
						continue;
					}
					bool ModifyOK = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(sl, Digits), 0, 0, Red);
					if (ModifyOK == false)
					{
						Print("OrderModify Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
						//return false;  //???
						continue;
					}

				}

			}
		}
	}

	return true;
}

bool doModifySellOrder(double sl)
{
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				if (OrderType() == OP_SELL)
				{
					if (NormalizeDouble(OrderStopLoss(),Digits)== NormalizeDouble(sl, Digits))
					{
						Print("Do NOT need modify the SL , just go on");
						continue;
					}
					bool ModifyOK = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(sl, Digits), 0, 0, Red);
					if (ModifyOK == false)
					{
						Print("OrderModify Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
						//return false;  //???
						continue;
					}

				}

			}
		}
	}

	return true;
}


void CloseAllBuy()
{
	//int OrdersNum = OrdersTotal();
	//for (int i = 0; i < OrdersNum; i++)
	while(OrdersTotal() > 0)
	{
		if (OrderSelect(OrdersTotal()-1, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				if (OrderType() == OP_BUY)
				{
					bool CloseOK = OrderClose(OrderTicket(), OrderLots(), Bid, gSlippage, gColorCloseBuy);
					if (CloseOK == false)
					{
						Print("Close Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
					}
				}

			}
		}
	}


	ResetLine0();
}
bool CheckBuyStopDone()
{
	if (gBuyStopTicket == -1)
	{
		return false;
	}
	//for (int i = 0; i < OrdersTotal(); i++)
	//{
		//if (OrderSelect(gSellStopTicket, SELECT_BY_POS, MODE_TRADES))
		if (OrderSelect(gBuyStopTicket, SELECT_BY_TICKET, MODE_TRADES))
		{
			if (OrderTicket() == gBuyStopTicket && OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				if (OrderType() == OP_BUY)//SELLSTOP -> SELL
				{
						gBuyStopDone = 1;
						//Print("BuyStop Order is Done !!!");
						return true;
				}

			}
		}
	//}

	return false;

}

void DeleteBuyStop()
{
	if (gBuyStopTicket == -1)
	{
		return;
	}
	
	if (OrderSelect(gBuyStopTicket, SELECT_BY_TICKET, MODE_TRADES))
	{
		if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo)
		{
			//bool CloseBuyStopOk = OrderClose(gBuyStopTicket, OrderLots(), Bid, gSlippage, gColorCloseSellStop);
			bool DeleteBuyStopOK = OrderDelete(gBuyStopTicket, gColorCloseBuyStop);
			if ( DeleteBuyStopOK == true )
			{
				gBuyStopTicket = -1;
			}
			else
			{
				Print("Delete BuyStop Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
			}
		}
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
	int ticket = OrderSend(Symbol(), OP_BUYSTOP, BuyLots, Price, gSlippage, 0, 0, CommentTxt, gMagicNo, 0, gColorOpenBuyStop);
	if (ticket > -1)
	{
		Print("Open BuyStop Order Success");
		if (gBuyStopStatus == 0)
		{
			gBuyStopStatus = 1; // reset in ResetLine0
		}
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
	int order = OrderSend(Symbol(), OP_BUY, BuyLots, Ask, gSlippage, 0, 0, CommentTxt, gMagicNo, 0, gColorOpenBuy);
	if (order > -1)
	{
		Print("Open Buy Order Success");
		//OrderSelect(order, SELECT_BY_TICKET);
		//if (gBuyStopLossPips > 0)
		//{
		//	dStopLoss = NormalizeDouble(OrderOpenPrice() - gBuyStopLossPips * gPipSize, Digits);
		//}
		//if (gBuyTakeProfitPips > 0)
		//{
		//	dTakeProfit = NormalizeDouble(OrderOpenPrice() + gBuyTakeProfitPips * gPipSize, Digits);
		//}
		//OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
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

bool CheckSellStopDone()
{
	if (gSellStopTicket == -1)
	{
		return false;
	}
	//for (int i = 0; i < OrdersTotal(); i++)
	//{
		//if (OrderSelect(gSellStopTicket, SELECT_BY_POS, MODE_TRADES))
		if (OrderSelect(gSellStopTicket, SELECT_BY_TICKET, MODE_TRADES))
		{
			if (OrderTicket() == gSellStopTicket && OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				if (OrderType() == OP_SELL)//SELLSTOP -> SELL
				{
						gSellStopDone = 1;
						//Print("SellStop Order is Done !!!");
						return true;
				}

			}
		}
	//}

	return false;
	
}


void DeleteSellStop()
{
	if (gSellStopTicket == -1)
	{
		return;
	}
	
	if (OrderSelect(gSellStopTicket, SELECT_BY_TICKET, MODE_TRADES))
	{
		if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo)
		{
			//bool CloseSellStopOk = OrderClose(gSellStopTicket, OrderLots(), Bid, gSlippage, gColorCloseSellStop);
			bool DeleteSellStopOK = OrderDelete(gSellStopTicket, gColorCloseSellStop);
			if ( DeleteSellStopOK == true )
			{
				gSellStopTicket = -1;
			}
			else
			{
				Print("Delete SellStop Order: "+DoubleToString(OrderTicket())+" Error: "+ DoubleToString(GetLastError()));
			}
		}
	}
}


int OpenSellStop(double SellLots, double Price)
{		
	if (SellLots == 0)
	{
		Print("SellLots is 0+++++++++++");
		return -1;		
	}
	if (gSellStopTicket != -1)
	{
		Print("Aready have one SellStop Order");
		return -1;
	}

	Print("Do SellStop OrderSend============");
	int ticket = OrderSend(Symbol(), OP_SELLSTOP, SellLots, Price, gSlippage, 0, 0, CommentTxt, gMagicNo, 0, gColorOpenSellStop);
	if (ticket > -1)
	{
		Print("Open SellStop Order Success");
		if (gSellStopStatus == 0)
		{
			gSellStopStatus = 1; // reset in ResetLine0
		}
		return (ticket);
	}
	else
	{
		Print("Open SellStop Order Error: "+ DoubleToString(GetLastError()));
		return -1;
	}
}


void OpenSell(double SellLots)
{
	if (SellLots == 0)
	{
		return ;
	}

	double dStopLoss = 0, dTakeProfit = 0;
	Print("Do Sell OrderSend============");
	int order = OrderSend(Symbol(), OP_SELL, SellLots, Bid, gSlippage, 0, 0, CommentTxt, gMagicNo, 0, gColorOpenSell);
	if (order > -1)
	{
		Print("Open Sell Order Success");
		//OrderSelect(order, SELECT_BY_TICKET);
		//if (gSellStopLossPips > 0)
		//{
		//	dStopLoss = NormalizeDouble(OrderOpenPrice() + gSellStopLossPips * gPipSize, Digits);
		//}
		//if (gSellTakeProfitPips > 0)
		//{
		//	dTakeProfit = NormalizeDouble(OrderOpenPrice() - gSellTakeProfitPips * gPipSize, Digits);
		//}
		//OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);

		if (gOpenOrderStarted == false)
		{
			gOpenOrderStarted = true;
		}
	}
	else
	{
		Print("Open Sell Order Error: "+ DoubleToString(GetLastError()));
	}

}

int OrdersNumber(int type)
{
	int numBuy  = 0;
	int numBuyLimit = 0;
	int numBuyStop = 0;
	int numSell = 0;
	int numSellLimit = 0;
	int numSellStop = 0;
	int numTotal = 0;
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == gMagicNo) // Checking magic number to make sure this order opened by EA
			{
				switch(OrderType())
				{
					case OP_BUY:
						numBuy++;
						break;
					case OP_BUYLIMIT:
						numBuyLimit++;
						break;
					case OP_BUYSTOP:
						numBuyStop++;
						break;
					case OP_SELL:
						numSell++;
						break;
					case OP_SELLLIMIT:
						numSellLimit++;
						break;
					case OP_SELLSTOP:
						numSellStop++;
						break;
					default:
						Print("OrdersNumber input error: "+ DoubleToStr(OrderType()));
				}
				
				numTotal++;
			}
		}
	}

	switch(type)
	{
		case BUY_ORDERS:
			return (numBuy);
			break;
		case BUYLIMIT_ORDERS:
			return (numBuyLimit);
			break;
		case BUYSTOP_ORDERS:
			return (numBuyStop);
			break;
		case SELL_ORDERS:
			return (numSell);
			break;
		case SELLLIMIT_ORDERS:
			return (numSellLimit);
			break;
		case SELLSTOP_ORDERS:
			return (numSellStop);
			break;
		case TOTAL_ORDERS:
			return (numTotal);
			break;
		default:
			Print("OrdersNumber input error :" + DoubleToStr(type));
			return (0);
			break;
	}
}

double GetLots()
{
	double lots;
	double RiskEquity;

	double MinLots = MarketInfo(Symbol(), MODE_MINLOT);
	double MaxLots = MarketInfo(Symbol(), MODE_MAXLOT);
	double LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
	double CurSpread = MarketInfo(Symbol(), MODE_SPREAD);

	//if (FXOpenECN && (StringFind(AccountServer(), "FXOpen-ECN", 0) >= 0 ))
	//{
	//	MinLots = 0.1;
	//}

	RiskEquity = AccountFreeMargin() * (gRisk / 100);

	lots = gDefaultLots;
	
	return (lots);
}

void DrawLine(string eType, int eBarPos, double ePrice, color eColor)
{
   if (eType == "HLine")
   {
      string eHLineBarString = eType+DoubleToString(Time[eBarPos]);
      ObjectCreate(eHLineBarString, OBJ_HLINE, 0, Time[eBarPos], ePrice);
      ObjectSet(eHLineBarString, OBJPROP_COLOR, eColor);
      //ObjectSet(eHLineBarString, OBJPROP_BACK, false);
   }
   if (eType == "VLine")
   {
      string eVLineBarString = eType+DoubleToString(Time[eBarPos]);
      ObjectCreate(eVLineBarString, OBJ_VLINE, 0, Time[eBarPos], ePrice);
      ObjectSet(eVLineBarString, OBJPROP_COLOR, eColor);
      //ObjectSet(eVLineBarString, OBJPROP_BACK, false);
   }
}
