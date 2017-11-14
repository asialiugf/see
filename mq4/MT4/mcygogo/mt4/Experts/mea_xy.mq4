#property copyright "mea"
#property link "mcygogo@126.com"
#include <stderror.mqh>
#include <stdlib.mqh>

#import "kernel32.dll"
void GetLocalTime(int& TimeArray[]);
void GetSystemTime(int& TimeArray[]);
int  GetTimeZoneInformation(int& TZInfoArray[]);
#import

#define BUY_ORDERS 1
#define SELL_ORDERS 2

#define GoingUp 1
#define GoingDown 2

#define Hammer 1
#define Shooting_Star 2
#define Invented_Hammer 3

double gPipSize = 0;
int    gSlippage = 3;
int    MagicNo = 668866;
string CommentTxt = "M-EA()";
color  gColorOpenBuy   = Green;
color  gColorCloseBuy  = Black;
color  gColorOpenSell  = Red;
color  gColorCloseSell = White;
double gBuyStopLossPips;
double gSellStopLossPips;
double gBuyTakeProfitPips = 0;
double gSellTakeProfitPips = 0;
double gStopLossPips = 15;

void init()
{
	if (IsTesting() == false && IsDemo() == false )
	{
		Alert("It's Not Demo Account, it's not for testing either, so I quit!");
		return ;
	}	

	gPipSize = getPipSize(Symbol());

	gBuyStopLossPips = gStopLossPips;
}

void deinit()
{
}

int start()

{
	
	if (OrdersNumber(BUY_ORDERS) < 1 && CheckDirection() == GoingUp)
	{
		if (CheckOpenBuyCondition() == true)
		{
			Print("Do OpenBuy");
			OpenBuy(0.01);
			return (0);
		}
	}
	if (OrdersNumber(BUY_ORDERS) == 1)
	{
		if (CheckCloseBuyCondition() == true)
		{
			Print("Do CloseBuy");
			CloseBuy();
			return (0);
		}
	}


	if (CheckDirection() == GoingDown)
	{
		
	}
	

	return (0);
}

int CheckDirection()
{
	//D1周期下通过均线角度确定方向
	int CurMAShift = 0;
	int PreMAShift = 1;
	int ShiftDif = PreMAShift - CurMAShift;
	double SMA_5_D1_Cur = iMA(Symbol(), PERIOD_D1, 5, 0, MODE_SMA, PRICE_CLOSE, CurMAShift);
	double SMA_5_D1_Pre = iMA(Symbol(), PERIOD_D1, 5, 0, MODE_SMA, PRICE_CLOSE, PreMAShift);

	double dFactor = 3.14159/180.0;
	double mFactor = 1000.0;
	if (StringSubstr(Symbol(), 3, 3) == "JPY")
	{
		mFactor = 10.0;
	}
	
	double MA_Angle = (SMA_5_D1_Cur - SMA_5_D1_Pre)/ShiftDif;
	MA_Angle = mFactor * MathArctan(MA_Angle)/dFactor;
	Print("MA_Angle: "+MA_Angle);
	if (MA_Angle > 40 && iLow(Symbol(), PERIOD_D1, 0) > SMA_5_D1_Cur)	//0号K线最低价在5SMA均线之上
	{
		//DrawLine("VLine", 0, Bid, White);
		Print("MA_Angle > 40, UP ");
		return (1);
	}

	//if(MA_Angle < -40)
	//{
	//	DrawLine("VLine", 0, Bid, Red);
	//	Print("MA_Angle < -40, Down");
	//	return (2);
	//}
}

//type: 1: buy
//      2: sell
int OrdersNumber(int type)
{
	int numBuy  = 0;
	int numSell = 0;
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNo) // Checking magic number to make sure this order opened by EA
			{
				if (OrderType() == OP_BUY)
				{
					numBuy++;
				}
				if (OrderType() == OP_SELL)
				{
					numSell++;
				}
			}
		}
	}
	
	switch(type)
	{
		case 1:
			return (numBuy);
			break;
		case 2:
			return (numSell);
			break;
		default:
			Print("OrdersNumber input error");
			break;
	}
}

int CloseBuy()
{
	//OrderSelect did in OrdersNumber()
	OrderClose(OrderTicket(), OrderLots(), Bid, gSlippage, gColorCloseBuy);
}


string getLocalTime(int& nYear,int& nMonth,int& nDay,int& nHour,int& nMin,int& nSec,int& nMilliSec)
{
       int TimeArray[4];
       GetLocalTime(TimeArray);
       nYear=TimeArray[0]&0x0000FFFF;  
       nMonth=TimeArray[0]>>16;
       nDay=TimeArray[1]>>16;
       nHour=TimeArray[2]&0x0000FFFF;
       nMin=TimeArray[2]>>16;
       nSec=TimeArray[3]&0x0000FFFF;
       nMilliSec=TimeArray[3]>>16;
       return(StringConcatenate(nYear,"/",nMonth,"/",nDay," ",nHour,":",nMin,":",nSec,".",nMilliSec));
}

int getLocalHour()
{
	int nYear, nMonth, nDay, nHour, nMin, nSec, nMilliSec;
	getLocalTime(nYear, nMonth, nDay, nHour, nMin, nSec, nMilliSec);
	return (nHour);
}

bool TimeForTrade()
{
	int hour = getLocalHour();
	if (!((hour >= 13 && hour <= 24)))
	{
		Comment("Time for trade has not come else!");
		return (false);
	}
	return (true);
}

bool CheckOpenBuyCondition()
{
	//Check Time
	if (!TimeForTrade())
	{
		return (false);
	}
	
	//M15,M30,H1的k1是锤子形
	//K1收盘价小于9SMA
	//5SMA在k0的值设置为A，2A-A的范围可以买入，否则不买 ?
	bool Condition_M15 = false;
	Condition_M15 = doCheckBuyCondition(PERIOD_M15);
	if (Condition_M15 == true)
	{
		Print("Condition in M15 is OK");
		return (true);
	}

	bool Condition_M30 = false;
	Condition_M30 = doCheckBuyCondition(PERIOD_M30);
	if (Condition_M30 == true)
	{
		Print("Condition in M30 is OK");
		return (true);
	}
	
	bool Condition_H1 = false;
	Condition_H1 = doCheckBuyCondition(PERIOD_H1);
	if (Condition_H1 == true)
	{
		Print("Condition in H1 is OK");
		return (true);
	}
	
	return (false);
}

int getMA_Angle(int TimeFrame, int MAPeriod, int CurMAShift, int PreMAShift)
{

	int ShiftDif = PreMAShift - CurMAShift;
	double SMA_5_D1_Cur = iMA(Symbol(), TimeFrame, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, CurMAShift);
	double SMA_5_D1_Pre = iMA(Symbol(), TimeFrame, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, PreMAShift);

	double dFactor = 3.14159/180.0;
	double mFactor;

	switch (TimeFrame)
	{
		case PERIOD_H1:
			mFactor = 1000.0;
			break;
	}
	
	if (StringSubstr(Symbol(), 3, 3) == "JPY")
	{
		mFactor = 10.0;
	}
	
	double MA_Angle = (SMA_5_D1_Cur - SMA_5_D1_Pre)/ShiftDif;
	MA_Angle = mFactor * MathArctan(MA_Angle)/dFactor;
	Print("MA_Angle: "+MA_Angle);

	return (MA_Angle);
}


bool doCheckCloseBuy(int TimeFrame)
{
	bool MA_OK = false;
	double MA_5 = iMA(Symbol(), TimeFrame, 5, 0, MODE_SMA, PRICE_CLOSE, 1);
	double MA_8 = iMA(Symbol(), TimeFrame, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
	double K1_Close = iClose(Symbol(), TimeFrame, 1);
	if ((MA_5 > MA_8) && (K1_Close > MA_5) )
	{
		MA_OK = true;
	}

	bool K_OK = Check_K(Symbol(), TimeFrame, Invented_Hammer);

	if ((K_OK && MA_OK) || ((Bid < MA_8) && (MA_5>MA_8)))
	{
		return (true);
	}
	else
	{
		return (false);
	}
}
bool CheckCloseBuyCondition()
{
	//M15,M30,H1下，5均线大于8均线，出现翻转信号(锤子)出
	if (doCheckCloseBuy(PERIOD_M15)== true)
	{
		Print("Close Buy Ok in M15");
		return (true);
	}

	if (doCheckCloseBuy(PERIOD_M30)== true)
	{
		Print("Close Buy Ok in M30");
		return (true);
	}


	if (doCheckCloseBuy(PERIOD_H1)== true)
	{
		Print("Close Buy Ok in H1");
		return (true);
	}
	return (false);
}


bool Check_K(string Sym, int TimeFrame, int type)
{
	bool K_Ready = false;
	double open1, close1, low1, high1;
	double BodyLen1, UpWick1, DownWick1, BodyHigh1, BodyLow1;
	double CandleLen1;
	//open1  = NormalizeDouble(iOpen(Sym, TimeFrame, 1), Digits);
	open1  = iOpen(Sym, TimeFrame, 1);
	close1 = iClose(Sym, TimeFrame, 1);
	high1  = iHigh(Sym, TimeFrame, 1);
	low1   = iLow(Sym, TimeFrame, 1);
	
	if (open1 > close1)
	{
		BodyHigh1 = open1;
		BodyLow1  = close1;
	}
	else
	{
		BodyHigh1 = close1;
		BodyLow1  = open1;
	}

	CandleLen1 = high1 - low1;
	BodyLen1   = BodyHigh1 - BodyLow1;
	UpWick1    = high1 - BodyHigh1;
	DownWick1  = BodyLow1 - low1;
	switch (type)
	{
		case Hammer:
		{
			if ((DownWick1 > (BodyLen1 * 2) )&& (DownWick1 > UpWick1) )
			{
				//DrawLine("VLine", 0, Bid, Red);
				K_Ready = true;
			}
			break;
		}
		case Invented_Hammer:
		{
			if ((UpWick1 > (BodyLen1 * 2)) && (UpWick1 > DownWick1))
			{
				K_Ready = true;
			}
			break;
		}
	}

	

	return (K_Ready);
}

bool doCheckBuyCondition(int TimeFrame)
{
	//k1是锤子形
	bool K_Ready = Check_K(Symbol(), TimeFrame, Hammer);

	//k1收盘价小于9SMA
	bool SMA_9_Ready = false;
	double SMA_9 = iMA(Symbol(), TimeFrame, 9, 0, MODE_SMA, PRICE_CLOSE, 1);
	double K1_Close = iClose(Symbol(), TimeFrame, 1);
	if (K1_Close < SMA_9)
	{
		SMA_9_Ready = true;
	}


	//5SMA在K0的值设置为A，2A-A的范围内可以买入
	//ToDo

	if (K_Ready && SMA_9_Ready)
	{
		return (true);
	}
}



void OpenBuy(double BuyLots)
{
	if (BuyLots == 0)
	{
		Print("BuyLot is 0+++++++++++");
		return (0);
	}

	double dStopLoss = 0, dTakeProfit = 0;
	Print("Do OrderSend============");
	int order = OrderSend(Symbol(), OP_BUY, BuyLots, Ask, gSlippage, 0, 0, CommentTxt, MagicNo, 0, gColorOpenBuy);
	if (order > -1)
	{
		OrderSelect(order, SELECT_BY_TICKET);
		if (gBuyStopLossPips > 0)
		{
			//dStopLoss = NormalizeDouble(OrderOpenPrice() - gBuyStopLossPips * gPipSize, Digits);
			dStopLoss = GetStopLoss();
		}
		if (gBuyTakeProfitPips > 0)
		{
			dTakeProfit = NormalizeDouble(OrderOpenPrice() + gBuyTakeProfitPips * gPipSize, Digits);
		}
		OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
	}


	//if (order > -1 && gFlagUseSound)
	//{
	//	PlaySound(gSoundFileName);
	//}
}

double GetStopLoss()
{
	//D1周期下的5SMA 以下15个点止损
	double SMA_5_D1 = iMA(Symbol(), PERIOD_D1, 5, 0, MODE_SMA, PRICE_CLOSE, 1);
	double StopLoss = NormalizeDouble(SMA_5_D1 - gBuyStopLossPips * gPipSize, Digits);

	return (StopLoss);
}

double getPipSize(string eSymbol)
{
	double iPipSize;
	int iDigits;

	iDigits = MarketInfo(eSymbol, MODE_DIGITS);
	iPipSize = 0.0001; // For most EUR/USD Currency pairs

	//Special Case here
	if (iDigits == 2 || iDigits == 3)
	{
		iPipSize = 0.01;
	}

	return (iPipSize);
}


void DrawLine(string eType, int eBarPos, double ePrice, color eColor)
{
   if (eType == "HLine")
   {
      string eHLineBarString = eType+Time[eBarPos];
      ObjectCreate(eHLineBarString, OBJ_HLINE, 0, Time[eBarPos], ePrice);
      ObjectSet(eHLineBarString, OBJPROP_COLOR, eColor);
      //ObjectSet(eHLineBarString, OBJPROP_BACK, false);
   }
   if (eType == "VLine")
   {
      string eVLineBarString = eType+Time[eBarPos];
      ObjectCreate(eVLineBarString, OBJ_VLINE, 0, Time[eBarPos], ePrice);
      ObjectSet(eVLineBarString, OBJPROP_COLOR, eColor);
      //ObjectSet(eVLineBarString, OBJPROP_BACK, false);
   }
}