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

extern string NoteRisk = "Trade Lot Risk %: 0.50 - 6.00";
extern double Risk = 2.00; //2.00
extern string NoteScale = "Test Lot Scaling: 0.00 - 1.00";
extern double TestLotScale = 1.00;
extern string NoteSpread = "Max Spreads: 2.00 - 4.00";
extern double MaxSpread = 4.0;
extern string NoteFri = "Trade after Friday Cut Hour";
extern bool   TradeLateFri = true;
extern int    FridayCutHour = 15;
extern string NoteDec = "Trade on December Cut Date(15)";
int           DecCutDate = 15;
extern bool   TradeLateDec = false;
extern string NoteEA = "Magic No.& Comments, pls change it";
extern int    MagicNo = 668866;
string CommentTxt = "M-EA(M5_Power)";
extern bool   FXOpenECN = false;

extern bool   EnableBuy  = true;
extern bool   EnableSell = true;


//------------用于资金管理-------------
double gTradeLots = 0.1;
double gTestLots  = 0.1;
double gCurSpread;
double gHistoryOrderProfit = 0;
double gMinLots = 0;
double gMaxLots = 0;
double gLotStep = 0;
//-------------------------------------


double gPipSize = 0;
int    gSlippage = 3;
bool   gFlagUseSound = true;
string gSoundFileName = "alert.wav";
color  gColorOpenBuy   = Green;
color  gColorCloseBuy  = Black;
color  gColorOpenSell  = Red;
color  gColorCloseSell = White;

double gBuyStopLossPips;
double gSellStopLossPips;
double gBuyTakeProfitPips = 0;
double gSellTakeProfitPips = 0;
double gStopLossPips = 20;
double gTrailingStop = 10;

void init()
{
	//Check for user input outside range
	//----------------------------Input Val------Min---Max-Digits
	Risk          = getInRangeValue(Risk,          0.50, 100.00, 2);
	TestLotScale  = getInRangeValue(TestLotScale,  0.00, 1.00, 2);
	MaxSpread     = getInRangeValue(MaxSpread,     2.0,  4.0,  1);
	FridayCutHour = getInRangeValue(FridayCutHour, 0,    23,   0);

	gBuyStopLossPips = gStopLossPips;
	gSellStopLossPips = gStopLossPips;

	gPipSize = getPipSize(Symbol());
	if (MagicNo <= 0)
	{
		MagicNo = 668866;
	}
	
	//----  Y-Distance -----
	int yLine1 = 20,
	    yLine2 = 40;

	//----X-Distance ----
	int xCol1 = 10;

	// ----Display Line 1----
	DisplayText("Title1", yLine1 - 5, xCol1, "MEA for M5 Power ", 13, "Verdana", Red);
}

void deinit()
{
	ObjectDelete("Tilte1");
}

bool gFlagMACDBuyReady;
bool gFlagEMABuyReady;
int  gMACDBuyReadyBars = 0;
double gOrderOpenBuyLots = 0;
double gOrderOpenSellLots = 0;
int start()
{
	//Check for user type
	if (IsTesting() == false && IsDemo() == false )
	{
		Alert("It's Not Demo Account, it's not for testing either, so I quit!");
		return (-1);
	}

	if (Bars < 100)
	{
		Print("bars less than 100");
		return (0);
	}
	double Lots = Gen_Lots();
	if(Lots == 0)
	{
		Print("Lots is ZERO!!!");
		return (0);
	}

	if (OrdersNumber(BUY_ORDERS) == 0) //no buy order
	{
		if (CheckBuyCondition() == true)
		{
			Print("Do OpenBuy---------------------------");
			OpenBuy(Lots);  
			gFlagMACDBuyReady = false;
			gFlagEMABuyReady = false;
			gMACDBuyReadyBars = 0;
			gOrderOpenBuyLots = Lots;
			//Sleep(1000);
			return (0);
		}
	}

	if (OrdersNumber(SELL_ORDERS) == 0) //no sell order
	{
		if (CheckSellCondition() == true)
		{
			//OpenSell();
		}
	}

	if (OrdersNumber(BUY_ORDERS) == 1) //close buy order
	{
		ModifyBuyOrder();
	}

	if (OrdersNumber(SELL_ORDERS) == 1) //close sell order
	{
		//do close sell
	}

	return (0);
}

//close order, or modify stoploss
int gEMA_GotOutPips = 20;
int ModifyBuyOrder()
{
	double EMA_20 = iMA(Symbol(), 5, 20, 0, MODE_EMA, PRICE_CLOSE, 0);

	if ((EMA_20 > Bid) && (EMA_20 - Bid > gEMA_GotOutPips * gPipSize))
	{
		Print("EMA_20: "+EMA_20+" Bid: "+Bid );
		bool flagCloseBuy = OrderClose(OrderTicket(), OrderLots(), Bid, gSlippage, gColorCloseBuy);
		if (flagCloseBuy && gFlagUseSound)
		{
			PlaySound(gSoundFileName);
		}
		return (0);
	}
	if (OrderLots() == gOrderOpenBuyLots) //平一半仓条件
	{
		if ((Bid > OrderOpenPrice()) && (Bid - OrderOpenPrice() >= OrderOpenPrice() - OrderStopLoss() ))
		{
			//modify the sl
			bool modify_buy = OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice(), OrderTakeProfit(), 0, Red);
			if (modify_buy == false)
			{
				Print("Modify the SL  of  Buy order to OpenPrice error "+GetLastError());
			}
					
			Print("Now I can close a half of buy order, Modify the sl to open point");
			bool flagCloseHalfBuy = OrderClose(OrderTicket(), OrderLots()/2, Bid, gSlippage, gColorCloseBuy);
			if (flagCloseHalfBuy && gFlagUseSound)
			{
				//BarMark("BH", 0, Bid, "Verdana", 18, White);
				PlaySound(gSoundFileName);
			}

			return (0);
		}
	}

	//均线移动止损
	// (NormalizeDouble(OrderStopLoss(),Digits)!=NormalizeDouble(BaseTemp,Digits))
	if (OrderLots() == gOrderOpenBuyLots / 2 )
	{
		if ((EMA_20 > OrderStopLoss() ) && (EMA_20 - OrderStopLoss() > gTrailingStop * gPipSize))
		{
			if (NormalizeDouble(OrderStopLoss(),Digits)==NormalizeDouble(EMA_20 - gTrailingStop*gPipSize,Digits))
			{
				return (0);
			}
			bool EMA_20_sl = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(EMA_20 - gTrailingStop*gPipSize, Digits),OrderTakeProfit(), 0, Red );
			if (!EMA_20_sl)
			{
				Print("Modify the SL of buy order according EMA error "+GetLastError());
			}
			return (0);
		}
	}
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


int gEMA_GotInPips = 10;
bool CheckBuyCondition()
{
	if (EnableBuy == false)
	{
		return (false);
	}
	//check time 
	if (TimeForTrade() == false)
	{	
		return (false);
	}
	
	bool FlagBuyOpen = false;
	if (gFlagMACDBuyReady == false)  
	{
		double MACD_1_Main = iMACD(Symbol(), 5, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1);
		double MACD_2_Main = iMACD(Symbol(), 5, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 2);
		if (MACD_1_Main > 0 && MACD_2_Main < 0) // MACD  go up cross the line 0;
		{
			gFlagMACDBuyReady = true;
			//check ema的时候要确认和该k线的距离
			gMACDBuyReadyBars = Bars;
			Print("MACD Buy Ready , Bars", gMACDBuyReadyBars);
			//BarMark("MACD Buy Ready", 0, Bid, "Verdana", 8, White);
			DrawLine("VLine", 0, Bid, White);
		}

		if (gFlagMACDBuyReady == false)
		{
			return (false);
		}
	}
	if((gMACDBuyReadyBars > 0) && (Bars - gMACDBuyReadyBars > 5))
	{
		gFlagEMABuyReady = false;
		gFlagMACDBuyReady = false;
		gMACDBuyReadyBars = 0;
		Print("MACD ready, but EMA not ready in 5 Bars");
		//BarMark("MACD ready, but EMA not ready in 5 Bars", 0, Bid, "Verdana", 8, White);
		return (0);
	}

	double EMA_20 = iMA(Symbol(), 5, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
	if (gFlagMACDBuyReady == true && gFlagEMABuyReady == false) 
	{

		if (Ask - EMA_20 >= gEMA_GotInPips * gPipSize) //如果
		//if (Ask > EMA_20) 
		{
			gFlagEMABuyReady = true;
			FlagBuyOpen = true;
			Print("EMA Buy ready, Bars: "+ Bars+" Ask: "+ Ask + " EMA: "+EMA_20+ " price "+getOrderPrice(1, EMA_20));
		}
	}

	return (FlagBuyOpen);
}

bool CheckSellCondition()
{
	if (TimeForTrade() == false)
	{	
		return (false);
	}
}

double gPricePip = 10;
//BuyOrSell: 1: buy 2: sell
double getOrderPrice(int BuyOrSell, double ema) //就算买卖的价位:
{
	double price;

	//Print("gPricePip: "+ gPricePip + " gPipSize: "+gPipSize);
	switch(BuyOrSell)
	{
		case 1:
			price = ema + gPricePip * gPipSize;
			break;
		case 2:
			price = ema - gPricePip * gPipSize;
			break;
		default:
			Print("input BuyOrSell error");
			price = ema;
	}
	return (price);
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
			dStopLoss = NormalizeDouble(OrderOpenPrice() - gBuyStopLossPips * gPipSize, Digits);
		}
		if (gBuyTakeProfitPips > 0)
		{
			dTakeProfit = NormalizeDouble(OrderOpenPrice() + gBuyTakeProfitPips * gPipSize, Digits);
		}
		OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
	}


	if (order > -1 && gFlagUseSound)
	{
		PlaySound(gSoundFileName);
	}
}

void OpenSell(double SellLots)
{
	if (SellLots == 0)
	{
		return (0);
	}


	double dStopLoss = 0, dTakeProfit = 0;
	int order = OrderSend(Symbol(), OP_SELL, SellLots, Bid, gSlippage, 0, 0, CommentTxt, MagicNo, 0, gColorOpenSell);

	if (order > -1)
	{
		OrderSelect(order, SELECT_BY_TICKET);
		if (gSellStopLossPips > 0)
		{
			dStopLoss = NormalizeDouble(OrderOpenPrice() + gSellStopLossPips * gPipSize, Digits);
		}
		if (gSellTakeProfitPips > 0)
		{
			dTakeProfit = NormalizeDouble(OrderOpenPrice() - gSellTakeProfitPips * gPipSize, Digits);
		}
		OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
	}


	if (order > -1 && gFlagUseSound)
	{
		PlaySound(gSoundFileName);
	}
}

double Gen_Lots() 
{
	// Update  EA Meter Display
	double lots;
	double RiskEquity;

	gMinLots = MarketInfo(Symbol(), MODE_MINLOT);
	gMaxLots = MarketInfo(Symbol(), MODE_MAXLOT);
	gLotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
	gCurSpread = getSpreadPips(Symbol());

	if (FXOpenECN && (StringFind(AccountServer(), "FXOpen-ECN", 0) >= 0 ))
	{
		gMinLots = 0.1;
	}

	RiskEquity = AccountFreeMargin() * (Risk / 100);
	gTradeLots = RiskEquity / (gStopLossPips * getPipValue(Symbol()));
	gTradeLots = getWorkingLots(gTradeLots);

	if (TestLotScale > 0)
	{
		gTestLots = gTradeLots * TestLotScale;
		gTestLots = getWorkingLots(gTestLots);
	}
	else
	{
		gTestLots = gMinLots;
	}
	
	// Set Default Smart message
	//mmMessage = "Margin level is healthy, M-EA is running in full mode";
	//mmMessageColor = LightGreen;

	// Warn for Low margin if EA can only open MinLots
	if (gTradeLots == gMinLots)
	{
		//mmMessage = "Free margin / risk% is too low, M-EA can open MinLot orders only";
		//mmMessageColor = Pink;
	}

	for (int ioht = OrdersHistoryTotal() - 1; ioht >= 0; ioht--)
	{
		OrderSelect(ioht, SELECT_BY_POS, MODE_HISTORY);
		if (OrderMagicNumber() == MagicNo)
		{
			gHistoryOrderProfit = OrderProfit();
			ioht = 0;
		}
	}

	if (gHistoryOrderProfit > 0)
	{
		lots = gTradeLots;
		//lots = gTestLots;
	}

	// if lose, use smallest lot to test the market before resume full lots
	if (gHistoryOrderProfit <= 0)
	{
		lots = gTestLots;
	}

	// !!!!!!!Special days - trade min lot / stop trading to avoid risk!!!!!!!!!
	if ((DayOfWeek() == 5) && (Hour() > FridayCutHour))
	{
		//mmMessage = "It's Fridy after " + DoubleToStr(FridayCutHour, 0) + ":00, ";
		//mmMessageColor = Silver;
		if (!TradeLateFri)
		{
			lots = 0;
			//mmMessage = mmMessage + "M-EA will not open new orders";
		}
		else
		{
			lots = gTestLots;
			//mmMessage = mmMessage + "M-EA will open new TestLot orders only";
		}
	}

	if ((Month() == 12) && (Day() > DecCutDate))
	{
		//mmMessage = "It's December after" + DoubleToStr(DecCutDate, 0) + "th, ";
		//mmMessageColor = Silver;
		if (!TradeLateDec)
		{
			lots = 0;
			//mmMessage = mmMessage + "M-EA will not open new orders";
		}
		else
		{
			lots = gTestLots;
			//mmMessage = mmMessage + "M-EA will open new TestLot orders only";
		}
	}

	// Stop Trading if spreads are too high
	if (gCurSpread > MaxSpread)
	{
		//mmMessage = "Spread is too high, M-EA will not open new orders";
		//mmMessageColor = Silver;
		lots = 0;
	}

	// Stop M-EA from trading if capital is danger low, less than 100
	if (AccountFreeMargin() < 110)
	{
		//mmMessage = "Free Margin is dangerously low, M-EA will not open new orders";
		//mmMessageColor = HotPink;
		lots = 0;
	}
	Print("+++++++++gTestLots:"+gTestLots+"  gTradeLots:"+gTradeLots+" lots "+lots+"+++++++++++");
	
	lots = lots * 2; //A, B
	return (lots);
}

double getSpreadPips(string eSymbol)
{
	double iSpreadPips, iPipSize;
	double iTickSize, iTickValue;

	iTickSize = MarketInfo(eSymbol, MODE_TICKSIZE);
	iPipSize  = getPipSize(eSymbol);

	iSpreadPips = MarketInfo(eSymbol, MODE_SPREAD) * (iTickSize/iPipSize);

	return (iSpreadPips);
}

double getWorkingLots(double eLots)
{
	double iLots;

	if (eLots < gMinLots)
	{
		iLots = gMinLots;
	}
	else
	{
		iLots = gMinLots + NormalizeDouble((eLots - gMinLots) / gLotStep, 0) * gLotStep;
		if (iLots > gMaxLots)
		{
			iLots = gMaxLots;
		}
	}

	return (iLots);
}

double getPipValue(string eSymbol) //计算一个点是多少美元
{
	double iPipValue, iPipSize;
	double iTickSize, iTickValue;

	iTickValue = MarketInfo(eSymbol, MODE_TICKVALUE);
	iTickSize  = MarketInfo(eSymbol, MODE_TICKSIZE);
	iPipSize   = getPipSize(eSymbol);

	iPipValue = iTickValue * (iPipSize / iTickSize);

	return (iPipValue);
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

double getInRangeValue(double eVal, double eMin, double eMax, int eDigits)
{
	double iVal = eVal;
	if (iVal < eMin)
	{	
		iVal = eMin;
	}
	else if (iVal > eMax)
	{
		iVal = eMax;
	}

	NormalizeDouble(iVal, eDigits);

	return (iVal);
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
/*
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
*/
int TimeLag = -6; //must modify 
bool TimeForTrade()
{
	int hour = Hour()+TimeLag;
	if (!((hour>= 15 && hour<=18) || (hour >= 20 && hour <= 24) || (hour > 0 && hour < 5)))
	{
		Comment("Time for trade has not come else!");
		return (false);
	}
	return (true);
}

void DisplayText(string eName, int eYD, int eXD, string eText, int eSize, string eFont, color eColor)
{
	ObjectCreate(eName, OBJ_LABEL, 0, 0, 0);
	ObjectSet(eName, OBJPROP_CORNER, 0);
	ObjectSet(eName, OBJPROP_XDISTANCE, eXD);
	ObjectSet(eName, OBJPROP_YDISTANCE, eYD);
	ObjectSetText(eName, eText, eSize, eFont, eColor);
}

void BarMark(string eString, int eBarPos, double ePrice, string eFont, int eSize, color eColor)
{
	string TextBarString = eString + Time[eBarPos];
	ObjectCreate(TextBarString, OBJ_TEXT, 0, Time[eBarPos], ePrice);
	ObjectSetText(TextBarString, eString, eSize, eFont, eColor);
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