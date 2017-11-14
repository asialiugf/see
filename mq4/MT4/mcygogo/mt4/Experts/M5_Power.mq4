//M5_Power

#property copyright "mea"
#property link "mcygogo@126.com"
#include <stderror.mqh>
#include <stdlib.mqh>

extern string NoteRisk = "Trade Lot Risk %: 0.50 - 6.00";
extern double Risk = 2.00; //2.00
extern string NoteScale = "Test Lot Scaling: 0.00 - 1.00";
extern double TestLotScale = 0.00;
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
double gStopLossPips = 15;
double gTrailingStop = 15;

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


bool glFlagMACDBuyReady = false;
bool glFlagEMABuyReady  = false; 
bool glFlagMACDSellReady = false;
bool glFlagEMASellReady  = false; 
bool gMACDReadyBars = 0;
int gEMA_GoOutPip = 10;
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

	//Check trading time
	bool   lFlagUseHourTrade = true;
	int    nFromHourTrade = 0;
	int    nToHourTrade = 23;
	if (lFlagUseHourTrade)
	{
		//if (!(Hour() >= nFromHourTrade&& Hour()<= nToHourTrade))
		//{
		//	Comment("Time for trade has not come else!");
		//	return (0);
		//}

		//15~18 20~24
		if (!((Hour()>= 15 && Hour()<=18) || (Hour() >= 20 && Hour() <= 24) || (Hour() > 0 && Hour() < 5)))
		{
			Comment("Time for trade has not come else!");
			return (0);
		}
	}

	if (Bars < 100)
	{
		Print("bars less than 100");
		return (0);
	}


	bool lFlagBuyOpen = false, lFlagSellOpen = false; 
	double EMA_20 = 0.0;
	//if (OrderNumbers() == 0) //means that EA have not open any order, so EA can try to open one
	if (OrderNumbers() < 2)
	{
	//1: check MACD
		if (glFlagMACDBuyReady == false && glFlagMACDSellReady == false)  
		{
			double MACD_1_Main = iMACD(Symbol(), 5, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1); //why close is not right?
			double MACD_2_Main = iMACD(Symbol(), 5, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 2);
			//Print("MACD_0_Main: "+DoubleToStr(MACD_0_Main, 8) +"  MACD_0_Main"+DoubleToStr(MACD_0_Main, 8));
			
			if (MACD_1_Main > 0 && MACD_2_Main < 0) // MACD  go up cross the line 0;
			{
				glFlagMACDBuyReady = true;
				//check ema的时候要确认和该k线的距离
				gMACDReadyBars = Bars;
				Print("MACD Buy Ready , Bars", gMACDReadyBars);
				BarMark("MACD Buy Ready", 0, Bid, "Verdana", 8, White);
			}
			if (MACD_1_Main < 0 && MACD_2_Main > 0) //MACD go down cross the line 0
			{
				glFlagMACDSellReady = true;
				//check ema的时候要确认和该k线的距离
				gMACDReadyBars = Bars;
				Print("MACD Sell Ready , Bars", gMACDReadyBars);
				BarMark("MACD Sell Ready", 0, Bid, "Verdana", 8, White);

			}

			//MACD买卖条件都不成立
			if (!(glFlagMACDBuyReady == true || glFlagMACDSellReady == true))
			{
				//Print("MACD not ready just return!");
				return (0);
			}
		}
	// 2: check MA
		//check MA之前应该检查一下Bars是否已经超过MACD进入点5，
		//如果超过5个，就不需要继续检查EMA，而是直接重新Check MACD
		if((gMACDReadyBars > 0) && (Bars - gMACDReadyBars > 5))
		{
			glFlagEMABuyReady = false;
			glFlagMACDBuyReady = false;
			gMACDReadyBars = 0;
			Print("MACD ready, but EMA not ready in 5 Bars");
			BarMark("MACD ready, but EMA not ready in 5 Bars", 0, Bid, "Verdana", 8, White);

			return (0);
		}
		//在5个bars以内，继续check EMA
		EMA_20 = iMA(Symbol(), 5, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
		if (glFlagMACDBuyReady == true && glFlagEMABuyReady == false) 
		{

			//if (Ask - EMA_20 >= 10 * gPipSize) 
			if (Ask > EMA_20) 
			{
				glFlagEMABuyReady = true;
				lFlagBuyOpen = true;
				Print("EMA Buy ready, Bars: "+ Bars+" Ask: "+ Ask + " EMA: "+EMA_20+ " price "+getOrderPrice(1, EMA_20));
			}
		}
		if (glFlagMACDSellReady == true && glFlagEMASellReady == false)
		{
			//if (EMA_20 - Bid < 10 * gPipSize)
			if (EMA_20 < Bid)
			{
				glFlagEMASellReady = true;
				lFlagSellOpen = true;
				Print("EMA Sell ready, Bars: "+ Bars+" Bid: "+ Bid + " EMA: "+EMA_20+ " price "+getOrderPrice(2, EMA_20));
			}
		}

		//如果EMA条件不成立，退出下次再check
		if (!(lFlagBuyOpen == true || lFlagSellOpen == true))
		{
			return (0);
		}
		
	//3: Open Orders
		//开单后将入场条件重置
		double Lots = Gen_Lots();
		if(Lots == 0)
		{
			Print("Lots is ZERO!!!");
			return (0);
		}
		if (lFlagBuyOpen == true)
		{
			Print("Do OpenBuy---------------------------");
			OpenBuy(Lots);  //要在EMA20的向上10点出做多，但是只能用挂单
			glFlagMACDBuyReady = false;
			glFlagEMABuyReady = false;
			gMACDReadyBars = 0;
			gOrderOpenBuyLots = Lots;
			//Sleep(1000);
			return (0);
		}
		if (lFlagSellOpen == true)
		{
			OpenSell(Lots);
			glFlagMACDSellReady = false;
			glFlagEMASellReady = false;
			gMACDReadyBars = 0;
			gOrderOpenSellLots = Lots;
			//Sleep(1000);
			return (0);
		}
	}

	bool lFlagBuyCloseA = false, lFlagSellCloseA = false;
	bool lFlagBuyCloseB = false, lFlagSellCloseB = false;
	//if (OrderNumbers() == 1) //close order ,
	//if (OrderNumbers() >= 1)
	while(OrderNumbers() > 0)
	{
	//出场条件判断
	//1:如果汇价穿过EMA20有15个点就平调所有仓
	//2:如果汇价和入场价之间的差值是止损价和入场价的差值，就平调一半仓
		//有可能入场之后，价格就相反方向走，在触及止损之前，就穿过EMA20 X个点。
		EMA_20 = iMA(Symbol(), 5, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
		if (OrderType() == OP_BUY)
		{
			if ((EMA_20 > Bid) && (EMA_20 - Bid > gEMA_GoOutPip * gPipSize))
			{
				Print("EMA_20: "+EMA_20+" Bid: "+Bid );
				bool flagCloseBuy = OrderClose(OrderTicket(), OrderLots(), Bid, gSlippage, gColorCloseBuy);
				if (flagCloseBuy && gFlagUseSound)
				{
					PlaySound(gSoundFileName);
				}
				//return (0);
				continue;
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
						BarMark("BH", 0, Bid, "Verdana", 18, White);
						PlaySound(gSoundFileName);
					}


					//return (0);
					continue;
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
						//return (0);
						continue;
					}
					bool EMA_20_sl = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(EMA_20 - gTrailingStop*gPipSize, Digits),OrderTakeProfit(), 0, Red );
					if (!EMA_20_sl)
					{
						Print("Modify the SL of buy order according EMA error "+GetLastError());
					}
					//return (0);
					continue;
				}
			}
			
		}

		if (OrderType() == OP_SELL)
		{
			if ((Ask > EMA_20)&& (Ask - EMA_20 > gEMA_GoOutPip * gPipSize))
			{
				Print("EMA_20: "+EMA_20+ " Ask: "+Ask);
				bool flagCloseSell = OrderClose(OrderTicket(), OrderLots(), Ask, gSlippage, gColorCloseSell);
				if (flagCloseSell && gFlagUseSound)
				{
					PlaySound(gSoundFileName);
				}
				//return (0);
				continue;
			}

			if (OrderLots() == gOrderOpenSellLots) //平一半仓条件
			{
				if ((Ask < OrderOpenPrice()) && (OrderOpenPrice() - Ask) >= OrderStopLoss() - OrderOpenPrice())
				{
					bool modify_sell = OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice(), OrderTakeProfit(), 0, Red);
					if (modify_sell == false)
					{
						Print("Modify the SL  of  sell order to OpenPrice error "+GetLastError());
					}
					
					Print("Now I can close a half of Sell order");
					bool flagCloseHalfSell = OrderClose(OrderTicket(), OrderLots()/2, Ask, gSlippage, gColorCloseSell);
					if (flagCloseHalfSell && gFlagUseSound)
					{
						BarMark("SH", 0, Ask, "Verdana", 18, White);
						PlaySound(gSoundFileName);
					}


					//return (0);
					continue;
				}
			}

			if (OrderLots() == gOrderOpenSellLots / 2)
			{
				if ((OrderStopLoss() > EMA_20 ) && (OrderStopLoss() - EMA_20 > gTrailingStop * gPipSize))
				{
					if (NormalizeDouble(OrderStopLoss(),Digits)==NormalizeDouble(EMA_20 + gTrailingStop*gPipSize,Digits))
					{
						//return (0);
						continue;
					}
					bool EMA_20_sl_sell = OrderModify(OrderTicket(), OrderOpenPrice(), EMA_20 + gTrailingStop*gPipSize, OrderTakeProfit(), 0, Red );
					if (!EMA_20_sl_sell)
					{
						Print("Modify the SL of Sell order according EMA error "+GetLastError());
					}
					//return (0);
					continue;
				}
			}
		}

	}
		
	return (0);
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

//Updated Values by this func: 
//                   MinLots, MaxLots, LotStep, CurSpread, mmTradeLots, mmTestLots, HistoryOrderProfit, mmMessage, mmMessageColor
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
		//lots = gTradeLots;
		lots = gTestLots;
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
int OrderNumbers()
{
	int num = 0;
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNo) // Checking magic number to make sure this order opened by EA
			{
				num++;
			}
		}
	}
	return (num);
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
