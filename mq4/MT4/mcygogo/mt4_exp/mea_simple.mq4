//Mea


#property copyright "mea"
#property link "mcygogo@126.com"
#include <stderror.mqh>
#include <stdlib.mqh>

string sNameExpert = "Mea";
int    nAccount = 0;
/*
extern string NoteRisk = "Trade Lot Risk %: 0.50 - 6.00";
extern double Risk = 2.00; //2.00
extern string NoteScale = "Test Lot Scaling: 0.00 - 1.00";
extern double TestLotScale = 0.00;
extern string NoteSpread = "Max Spreads: 2.00 - 4.00";
extern double MaxSpread = 4.0;
extern string NoteFri = "Trade after Friday Cut Hour";
extern bool   TradeLateFri = false;
extern int    FridayCutHour = 15;
extern string NoteDec = "Trade on December Cut Date(15)";
int           DecCutDate = 15;
extern bool   TradeLateDec = false;
extern string NoteBroker = "Broker Friendly Settings";
extern bool   PipStepping = false;
extern bool   FXOpenECN = false;
extern string NoteEA = "Magic No.& Comments, pls change it";
extern int    MagicNo = 338833;
extern string CommentTxt = "M-ea";
*/
// "Trade Lot Risk %: 0.50 - 100.00";
double Risk = 60.00; //2.00
// "Test Lot Scaling: 0.00 - 1.00";
double TestLotScale = 0.00;
//"Max Spreads: 2.00 - 4.00";
double MaxSpread = 4.0;
//"Trade after Friday Cut Hour";
bool   TradeLateFri = false;
int    FridayCutHour = 15;
//"Trade on December Cut Date(15)";
int    DecCutDate = 15;
bool   TradeLateDec = false;
//"Broker Friendly Settings";
bool   PipStepping = false;
bool   FXOpenECN = false;
//"Magic No.& Comments, pls change it";
int    MagicNo = 886688;
string CommentTxt = "M-EA(demo)";


double dBuyStopLossPips;
double dSellStopLossPips;
double dBuyTakeProfitPips;
double dSellTakeProfitPips;
double dBuyTrailingStopPips;
double dSellTrailingStopPips;
double dBuyTrailingReservePips;
double dSellTrailingReservePips;

double timeclose1 = 900; //60 = 1 miute
double timeclose2 = 3600; 

//Professional Settings - Do NOT modify
string NotePro = "Professional Settings";
double dlStopLossPips = 110; 
double dlTakeProfitPips = 50;
double dlTrailingStopPips = 22;
double dlTrailingReservePips = 5;
double dlStepPips = 0;
//------------------------------------//


//double dSmartLots = 0.1;
//double g_LastLots = 0.1;
double dStepPips = 0;

double mmTradeLots = 0.1;
double mmTestLots  = 0.1;
double CurSpread;
double HistoryOrderProfit = 0;

double MinLots = 0;
double MaxLots = 0;
double LotStep = 0;
double PipSize = 0;
int    nSlippage = 3;
bool   lFlagUseHourTrade = true;
int    nFromHourTrade = 0;
int    nToHourTrade = 23;
int    dTrailingStatus = -1;
bool   lFlagUseSound = true;
string sSoundFileName = "alert.wav";
color  colorOpenBuy   = Green;
color  colorCloseBuy  = Black;
color  colorOpenSell  = Red;
color  colorCloseSell = White;


string mmMessage = "Smart MM finds nothing wrong";
color  mmMessageColor = LightGreen;

void init()
{


	//Check for user input outside range
	//----------------------------Input Val------Min---Max-Digits
	Risk          = getInRangeValue(Risk,          0.50, 100.00, 2);
	TestLotScale  = getInRangeValue(TestLotScale,  0.00, 1.00, 2);
	MaxSpread     = getInRangeValue(MaxSpread,     2.0,  4.0,  1);
	FridayCutHour = getInRangeValue(FridayCutHour, 0,    23,   0);

	//These assignment values allow for future asymetric parameter setting (ie different value for Buy/Sell)
	dBuyStopLossPips = dlStopLossPips;
	dSellStopLossPips = dlStopLossPips;
	dBuyTakeProfitPips = dlTakeProfitPips;
	dSellTakeProfitPips = dlTakeProfitPips;
	dBuyTrailingStopPips = dlTrailingStopPips;
	dSellTrailingStopPips = dlTrailingStopPips;
	dBuyTrailingReservePips = dlTrailingReservePips;
	dSellTrailingReservePips = dlTrailingReservePips;

	if (PipStepping)
	{
		dlStepPips = 1;
	}

	PipSize = getPipSize(Symbol());

	 Gen_Lots();  //Just for OSD info

	//----  Y-Distance -----
	int yLine1 = 20,
	    yLine2 = 40,
	    yLine3 = 60,
	    yLine4 = 80,
	    yLine5 = 100,
	    yLine6 = 120,
	    yLine7 = 140,
	    yLine8 = 160,
	    yLine9 = 180,
	    yLine10 = 200,
	    yLine11 = 220,
	    yLine12 = 240;

	 //----X-Distance ----
	int xCol1 = 10,
		xCol2 = 200,
		xCol3 = 380;

	// On Screen Display Message texts
	string txtTradeLateFri,
		   txtTradeLateDec,
		   txtPipStepping,
		   txtFXOpenECN;
		   
	 // ----Display Line 1----
	DisplayText("Title1", yLine1 - 5, xCol1, "MEA Demo - Just For EURUSD ", 13, "Verdana", Red);

	 //----Display Line 2----
	//DisplayText("Title2", yLine2, xCol1, "mcygogo@126.com", 9, "Verdana", White);

	 //----Display Line3 ----
	//DisplayText("Line1a", yLine3, xCol1, "----------------------", 10, "Verdana", Goldenrod);
	//DisplayText("Linelb", yLine3, xCol2, "--EA Settings------------------", 10, "Verdana", Goldenrod);

	 //---Display Line4 ---
	//DisplayText("txtRisk", yLine4, xCol1, "Trade Lot Risk %:"+DoubleToStr(Risk, 2), 9, "Verdana", Gold);
	//DisplayText("txtScale", yLine4, xCol2, "Test Lot Scale:   "+ DoubleToStr(TestLotScale, 2), 9, "Verdana", Gold);
	//DisplayText("txtMaxSpread", yLine4, xCol3, "Max Spread:   "+ DoubleToStr(MaxSpread, 1), 9, "Verdana", Gold);

	 //----Display Line5 ---
	//DisplayText("TxtTradeLots", yLine5, xCol1, "Trade Lot Size:   " + DoubleToStr(mmTradeLots, 2), 9, "Verdana", Gold);
	//DisplayText("TxtTestLots", yLine5, xCol2, "Test Lot Size:     " + DoubleToStr(mmTestLots, 2),  9, "Verdana", Gold);
	//DisplayText("TxtCurSpread", yLine5, xCol3, "Now Spread:       " + DoubleToStr(CurSpread, 1),   9, "Verdana", Gold);

	 //---Display Line6---
	//DisplayText("TxtMaxLot", yLine6, xCol1, "Max Lots:     " + DoubleToStr(MaxLots, 2), 9, "Verdana", Silver);
	//DisplayText("TxtMinLot", yLine6, xCol2, "Min Lots:     " + DoubleToStr(MinLots, 2), 9, "Verdana", Silver);
	//DisplayText("TxtLotStep", yLine6, xCol3, "Lot Setp:     " + DoubleToStr(LotStep, 2), 9, "Verdana", Silver);

	 //---Display Line7---
	//DisplayText("TxtSL", yLine7, xCol1, "Stop Loss  "+ DoubleToStr(dlStopLossPips,0), 9, "Verdana", Silver);
	//DisplayText("TxtTP", yLine7, xCol2, "Take Profit: "+DoubleToStr(dlTakeProfitPips,0), 9, "Verdana", Silver);

	//----Display Line8---
	//DisplayText("TxtTS", yLine8, xCol1, "Trailing Stop: "+DoubleToStr(dlTrailingStopPips,0),9,"Verdana", Silver);
	//DisplayText("TxtTR", yLine8, xCol2, "Trailing Reserve"+DoubleToStr(dlTrailingReservePips,0),9,"Verdana", Silver);

	//---Display Line9---
	if (TradeLateFri)
	{
		txtTradeLateFri = "Trade after Friday"+DoubleToStr(FridayCutHour,0)+":00        TEST LOT ONLY";
	}
	else
	{
		txtTradeLateFri = "Trade after Friday"+DoubleToStr(FridayCutHour,0)+":00         NO";
	}
	//DisplayText("TxtFri", yLine9, xCol1, txtTradeLateFri, 9, "Verdana", Gold);
	if (PipStepping)
	{
		txtPipStepping = "YES";
	}
	else
	{
		txtPipStepping = "NO";
	}
	//DisplayText("TxtPipStepping", yLine9, xCol3, "Pip Stepping:  "+ txtPipStepping, 9, "Verdana", Gold);

	//----Display Line 10-------
	if (TradeLateDec)
	{
		txtTradeLateDec = "Trade after December "+DoubleToStr(DecCutDate,0)+"th:   TEST LOT ONLY";
	}
	else
	{
		txtTradeLateDec = "Trade after December "+DoubleToStr(DecCutDate,0)+"th:   NO";
	}
   	//DisplayText("TxtDec", yLine10, xCol1, txtTradeLateDec, 9, "Verdana", Gold);
   	if (FXOpenECN)
   	{
   		txtFXOpenECN = "YES";
   	}
   	else
   	{
   	    txtFXOpenECN = "NO";
   	}
   	//DisplayText("TxtFXOpenECN", yLine10, xCol3, "FXOpen ECN:  " + txtFXOpenECN, 9, "Verdana", Gold);
   	
  	//----- Display Line 11 -----
   	//DisplayText("Line2a", yLine11, xCol1, "---------------------------", 10, "Verdana", Goldenrod);
   	//DisplayText("Line2b", yLine11, xCol2, "---------------------------------------------", 10, "Verdana", Goldenrod);
   
   	//----- Display Line 12 -----
   	//DisplayText("TxtSmartMM", yLine12, xCol1, mmMessage, 9, "Verdana", mmMessageColor);

}

void deinit()
{
	ObjectDelete("Tilte1");
	//ObjectDelete("Title2");
    //ObjectDelete("Line1a");        ObjectDelete("Line1b");         
    //ObjectDelete("TxtRisk");       ObjectDelete("TxtScale");     ObjectDelete("TxtMaxSpread");
    //ObjectDelete("TxtTradeLots");  ObjectDelete("TxtTestLots");  ObjectDelete("TxtCurSpread");  
    //ObjectDelete("TxtMaxLot");     ObjectDelete("TxtMinLot");    ObjectDelete("TxtLotStep");
    //ObjectDelete("TxtSL");         ObjectDelete("TxtTP");        
    //ObjectDelete("TxtTS");         ObjectDelete("TxtTR");
    //ObjectDelete("TxtFri");        ObjectDelete("TxtPipStepping");
    //ObjectDelete("TxtDec");        ObjectDelete("TxtFXOpenECN");
    //ObjectDelete("Line2a");        ObjectDelete("Line2b");           
    //ObjectDelete("TxtSmartMM");	
}

int start()
{
	//Check for user type
	if (IsTesting() == false && IsDemo() == false )
	{
		Alert("It's Not Demo Account, it's not for testing either, so I quit!");
		return (-1);
	}

	double Lots = Gen_Lots(); //Must get History Profit in here, and Open Order need it, also get some lots info for OSD
	ObjectSetText("TxtTradeLots", "Trade Lot Size:  "+DoubleToStr(mmTradeLots,2), 9, "Verdana", Gold);
	ObjectSetText("TxtTestLots", "Test Lot Size:  "+DoubleToStr(mmTestLots,2), 9, "Verdana", Gold);
	ObjectSetText("TxtCurSpread", "Now Spread:  "+DoubleToStr(CurSpread,1), 9, "Verdana",Gold);
	ObjectSetText("TxtSmartMM", mmMessage, 9, "Verdana", mmMessageColor);

	if (lFlagUseHourTrade)
	{
		if (!(Hour() >= nFromHourTrade&& Hour()<= nToHourTrade))
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

	if (nAccount > 0 && nAccount != AccountNumber())
	{
		Comment("Trade on account:"+AccountNumber()+" FORBIDDEN!");
		return (0);
	}

	//indicators, get data
	//HideTestIndicators(true);
	/*
	double diMA1 = iMA(Symbol(), 15, 100, 0, MODE_EMA, PRICE_CLOSE, 0); //100
	double diMA2 = iMA(Symbol(), 15, 200, 0, MODE_EMA, PRICE_CLOSE, 0); //200
	double diMA3 = iMA(Symbol(), 15, 300, 0, MODE_EMA, PRICE_CLOSE, 0); //300
	double diMA4 = iMA(Symbol(), 15, 400, 0, MODE_EMA, PRICE_CLOSE, 0); //400
	double diMA5 = iMA(Symbol(), 15, 500, 0, MODE_EMA, PRICE_CLOSE, 0); //500
	double diWPR10 = iWPR(Symbol(), 60, 5, 0);
	double diMFI11 = iMFI(Symbol(), 30, 1, 0);
	double diClose12 = iClose(Symbol(), 1, 0);
	double diMA13 = iMA(Symbol(), 1, 700, 0, MODE_EMA, PRICE_CLOSE, 0); //700
	double diMA14 = iMA(Symbol(), 5, 700, 0, MODE_EMA, PRICE_CLOSE, 0); //700
	double diMA15 = iMA(Symbol(), 15, 700, 0, MODE_EMA, PRICE_CLOSE, 0); //700
	double diMA16 = iMA(Symbol(), 30, 700, 0, MODE_EMA, PRICE_CLOSE, 0); //700
	double diAC17 = iAC(Symbol(), 1, 0);
	*/

	double iMA1  = iMA(Symbol(), 240, 15, 0, MODE_EMA, PRICE_CLOSE, 1);
	double iMA1p = iMA(Symbol(), 240, 15, 0, MODE_EMA, PRICE_CLOSE, 2);
	double iMA2  = iMA(Symbol(), 240, 65, 0, MODE_EMA, PRICE_CLOSE, 1);
	double iMA2p = iMA(Symbol(), 240, 65, 0, MODE_EMA, PRICE_CLOSE, 2);
	bool lFlagBuyOpen = false, lFlagSellOpen = false, lFlagBuyClose = false, lFlagSellClose = false;


	// Open Order
	if (!ExistPositions())
	{
		if (HistoryOrderProfit >= 0) //HistoryOrderProfit was modified in Gen_Lots() before
		{
			/*
			lFlagBuyOpen = (diAC17<0) && (diMFI11<0.1) && (diWPR10<-99.99) &&
						   (diMA13 < diClose12) && (diMA14 < diClose12) && (diMA15 < diClose12) && (diMA16 < diClose12) &&
						   (diMA1 > diMA2) && (diMA2 > diMA3) && (diMA3 > diMA4) && (diMA4 > diMA5);
							
			lFlagSellOpen = (diAC17 > 0) && (diMFI11>99.9) && (diWPR10>-0.01) && 
							(diMA13 > diClose12) && (diMA14 > diClose12) && (diMA15 > diClose12) && (diMA16 > diClose12) &&
							(diMA1 < diMA2) && (diMA2 < diMA3) && (diMA3 < diMA4) && (diMA4<diMA5);
			  */
			lFlagBuyOpen  = (iMA1 > iMA2) && (iMA1p < iMA2p);
			lFlagSellOpen = (iMA1 < iMA2) && (iMA1p > iMA2p); 
		}
		if (HistoryOrderProfit < 0)
		{
			/*
			lFlagBuyOpen  = (diAC17 < 0) && (diWPR10 < -50) && (diMA1 < diMA2);
			lFlagSellOpen = (diAC17 > 0) && (diWPR10 > -50) && (diMA1 > diMA2);
			*/
			lFlagBuyOpen  = (iMA1 > iMA2) && (iMA1p < iMA2p);
			lFlagSellOpen = (iMA1 < iMA2) && (iMA1p > iMA2p); 
		}

		dTrailingStatus = -1;
		if (lFlagBuyOpen)
		{
			//double BuyLots = Gen_Lots();
			dTrailingStatus = 0; // Init - Trailing Not Started Yet
			dStepPips = 0;       // Init - Trailing Step Not Active until First Trailing Start
			OpenBuy(Lots);
			return (0);
		}

		if (lFlagSellOpen)
		{
			//double SellLots = Gen_Lots();
			dTrailingStatus = 0; // Trailing not started yet
			dStepPips = 0;       // Trailing step not active until First trailing start
			OpenSell(Lots);
			return (0);
		}
		
	}

	//Close Order
	if (ExistPositions()) //do OrderSelect in ExistPostion(), so can use the other Order stuff
	{
		if (dTrailingStatus < 1)
		{
			if ((OrderProfit() >= 0) && (CurTime() - OrderOpenTime() > timeclose2))
			{
				/*
				lFlagBuyClose  = (diAC17 > 0) && (diWPR10 > -50) && (diMA1 > diMA2);
				lFlagSellClose = (diAC17 < 0) && (diWPR10 < -50) && (diMA1 < diMA2);
				*/
				lFlagBuyClose  = (iMA1 < iMA2) && (iMA1p > iMA2p);
				lFlagSellClose = (iMA1 > iMA2) && (iMA1p < iMA2p); 
			}
			if ((OrderProfit() < 0) && (CurTime() - OrderOpenTime() > timeclose1))
			{
				/*
				lFlagBuyClose  = (diAC17 > 0) && (diWPR10 > -15) && (diMA1 > diMA2);
				lFlagSellClose = (diAC17 < 0) && (diWPR10 < -85) && (diMA1 < diMA2);
				*/
				lFlagBuyClose  = (iMA1 < iMA2) && (iMA1p > iMA2p);
				lFlagSellClose = (iMA1 > iMA2) && (iMA1p < iMA2p); 
			}
		}

		//Handle Indicator Controlled Order Close Below
		if (OrderType() == OP_BUY)
		{
			if (lFlagBuyClose)
			{
				bool flagCloseBuy = OrderClose(OrderTicket(), OrderLots(), Bid, nSlippage, colorCloseBuy);
				if (flagCloseBuy && lFlagUseSound)
				{
					PlaySound(sSoundFileName);
				}
				return (0);
			}
		}
		if (OrderType() == OP_SELL)
		{
			if (lFlagSellClose)
			{
				bool flagCloseSell = OrderClose(OrderTicket(), OrderLots(), Ask, nSlippage, colorCloseSell);
				if (flagCloseSell && lFlagUseSound)
				{
					PlaySound(sSoundFileName);
				}
				return (0);
			}
		}
	}

	//Modify Order
	
	if (dBuyTrailingStopPips > 0 || dSellTrailingStopPips > 0)
	{
		for (int i = 0; i < OrdersTotal(); i++)
		{
			if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
			{
				bool lMagic = true;

				if (MagicNo > 0 && OrderMagicNumber() != MagicNo)
				{
					lMagic = false;
				}

				if (OrderSymbol() == Symbol() && lMagic)
				{
					if (OrderType() == OP_BUY && dBuyTrailingStopPips > 0)
					{
						if (Bid - OrderOpenPrice() > dBuyTrailingStopPips * PipSize)
						{
							if (OrderStopLoss() < Bid - (dBuyTrailingStopPips + dStepPips) * PipSize)
							{
								if (dTrailingStatus == 0)
								{
									ModifyStopLoss(Bid-NormalizeDouble((dBuyTrailingStopPips-dBuyTrailingReservePips)*PipSize, 5));
									dTrailingStatus = 1;    //Trailing Triggered - Set Status Flag
									dStepPips = dlStepPips; //Trailing Triggered - Activate Stepping if User enabled it
								}
								else
								{
									ModifyStopLoss(Bid - NormalizeDouble(dBuyTrailingStopPips * PipSize, 5));
								}
							}
						}
					}
					if (OrderType() == OP_SELL)
					{
						if (OrderOpenPrice() - Ask > dSellTrailingStopPips * PipSize)
						{
							if (OrderStopLoss() > Ask + (dSellTrailingStopPips + dStepPips)*PipSize || OrderStopLoss() == 0)
							{
								if (dTrailingStatus == 0)
								{
									ModifyStopLoss(Ask+NormalizeDouble((dSellTrailingStopPips-dSellTrailingReservePips)*PipSize, 5));
									dTrailingStatus = 1;
									dStepPips = dlStepPips;
								}
								else
								{
									ModifyStopLoss(Ask+NormalizeDouble(dSellTrailingStopPips * PipSize, 5));
								}
							}
						}
					}
				}
			}
		}
	}
	return (0);
}

void ModifyStopLoss(double ldStopLoss)
{
	bool lFlagModify = OrderModify(OrderTicket(), NormalizeDouble(OrderOpenPrice(), 5), NormalizeDouble(ldStopLoss, 5), NormalizeDouble(OrderTakeProfit(), 5), 0, CLR_NONE);
	if (lFlagModify && lFlagUseSound)
	{
		PlaySound(sSoundFileName);
	}
}
void OpenBuy(double BuyLots)
{
	if (BuyLots == 0)
	{
		return (0);
	}
	
	double dStopLoss = 0, dTakeProfit = 0;
	int order = OrderSend(Symbol(), OP_BUY, BuyLots, Ask, nSlippage, 0, 0, CommentTxt, MagicNo, 0, colorOpenBuy);
	if (order > -1)
	{
		OrderSelect(order, SELECT_BY_TICKET);
		if (dBuyStopLossPips > 0)
		{
			dStopLoss = NormalizeDouble(OrderOpenPrice() - dBuyStopLossPips * PipSize, Digits);
		}
		if (dBuyTakeProfitPips > 0)
		{
			dTakeProfit = NormalizeDouble(OrderOpenPrice() + dBuyTakeProfitPips * PipSize, Digits);
		}
		OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
	}


	if (order > -1 && lFlagUseSound)
	{
		PlaySound(sSoundFileName);
	}
}

void OpenSell(double SellLots)
{
	if (SellLots == 0)
	{
		return (0);
	}

	double dStopLoss = 0, dTakeProfit = 0;
	int order = OrderSend(Symbol(), OP_SELL, SellLots, Bid, nSlippage, 0, 0, CommentTxt, MagicNo, 0, colorOpenSell);

	if (order > -1)
	{
		OrderSelect(order, SELECT_BY_TICKET);
		if (dSellStopLossPips > 0)
		{
			dStopLoss = NormalizeDouble(OrderOpenPrice() + dSellStopLossPips * PipSize, Digits);
		}
		if (dSellTakeProfitPips > 0)
		{
			dTakeProfit = NormalizeDouble(OrderOpenPrice() - dSellTakeProfitPips * PipSize, Digits);
		}
		OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
	}


	if (order > -1 && lFlagUseSound)
	{
		PlaySound(sSoundFileName);
	}
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


//Updated Values by this func: 
//                   MinLots, MaxLots, LotStep, CurSpread, mmTradeLots, mmTestLots, HistoryOrderProfit, mmMessage, mmMessageColor
double Gen_Lots() 
{
	// Update  EA Meter Display
	double lots;
	double RiskEquity;

	MinLots = MarketInfo(Symbol(), MODE_MINLOT);
	MaxLots = MarketInfo(Symbol(), MODE_MAXLOT);
	LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
	CurSpread = getSpreadPips(Symbol());

	if (FXOpenECN && (StringFind(AccountServer(), "FXOpen-ECN", 0) >= 0 ))
	{
		MinLots = 0.1;
	}

	RiskEquity = AccountFreeMargin() * (Risk / 100);
	mmTradeLots = RiskEquity / (dlStopLossPips * getPipValue(Symbol()));
	mmTradeLots = getWorkingLots(mmTradeLots);

	if (TestLotScale > 0)
	{
		mmTestLots = mmTradeLots * TestLotScale;
		mmTestLots = getWorkingLots(mmTestLots);
	}
	else
	{
		mmTestLots = MinLots;
	}

	// Set Default Smart message
	mmMessage = "Margin level is healthy, M-EA is running in full mode";
	mmMessageColor = LightGreen;

	// Warn for Low margin if EA can only open MinLots
	if (mmTradeLots == MinLots)
	{
		mmMessage = "Free margin / risk% is too low, M-EA can open MinLot orders only";
		mmMessageColor = Pink;
	}

	for (int ioht = OrdersHistoryTotal() - 1; ioht >= 0; ioht--)
	{
		OrderSelect(ioht, SELECT_BY_POS, MODE_HISTORY);
		if (OrderMagicNumber() == MagicNo)
		{
			HistoryOrderProfit = OrderProfit();
			ioht = 0;
		}
	}

	if (HistoryOrderProfit == 0)
	{
		lots = mmTestLots;
	}

	if (HistoryOrderProfit > 0)
	{
		lots = mmTradeLots;
	}

	// if lose, use smallest lot to test the market before resume full lots
	if (HistoryOrderProfit < 0)
	{
		lots = mmTestLots;
	}

	// !!!!!!!Special days - trade min lot / stop trading to avoid risk!!!!!!!!!
	if ((DayOfWeek() == 5) && (Hour() > FridayCutHour))
	{
		mmMessage = "It's Fridy after " + DoubleToStr(FridayCutHour, 0) + ":00, ";
		mmMessageColor = Silver;
		if (!TradeLateFri)
		{
			lots = 0;
			mmMessage = mmMessage + "M-EA will not open new orders";
		}
		else
		{
			lots = mmTestLots;
			mmMessage = mmMessage + "M-EA will open new TestLot orders only";
		}
	}

	if ((Month() == 12) && (Day() > DecCutDate))
	{
		mmMessage = "It's December after" + DoubleToStr(DecCutDate, 0) + "th, ";
		mmMessageColor = Silver;
		if (!TradeLateDec)
		{
			lots = 0;
			mmMessage = mmMessage + "M-EA will not open new orders";
		}
		else
		{
			lots = mmTestLots;
			mmMessage = mmMessage + "M-EA will open new TestLot orders only";
		}
	}

	// Stop Trading if spreads are too high
	if (CurSpread > MaxSpread)
	{
		mmMessage = "Spread is too high, M-EA will not open new orders";
		mmMessageColor = Silver;
		lots = 0;
	}

	// Stop M-EA from trading if capital is danger low, less than 100
	if (AccountFreeMargin() < 110)
	{
		mmMessage = "Free Margin is dangerously low, M-EA will not open new orders";
		mmMessageColor = HotPink;
		lots = 0;
	}

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

double getPipValue(string eSymbol)
{
	double iPipValue, iPipSize;
	double iTickSize, iTickValue;

	iTickValue = MarketInfo(eSymbol, MODE_TICKVALUE);
	iTickSize  = MarketInfo(eSymbol, MODE_TICKSIZE);
	iPipSize   = getPipSize(eSymbol);

	iPipValue = iTickValue * (iPipSize / iTickSize);

	return (iPipValue);
}

double getWorkingLots(double eLots)
{
	double iLots;

	if (eLots < MinLots)
	{
		iLots = MinLots;
	}
	else
	{
		iLots = MinLots + NormalizeDouble((eLots - MinLots) / LotStep, 0) * LotStep;
		if (iLots > MaxLots)
		{
			iLots = MaxLots;
		}
	}

	return (iLots);
}

void DisplayText(string eName, int eYD, int eXD, string eText, int eSize, string eFont, color eColor)
{
	ObjectCreate(eName, OBJ_LABEL, 0, 0, 0);
	ObjectSet(eName, OBJPROP_CORNER, 0);
	ObjectSet(eName, OBJPROP_XDISTANCE, eXD);
	ObjectSet(eName, OBJPROP_YDISTANCE, eYD);
	ObjectSetText(eName, eText, eSize, eFont, eColor);
}

bool ExistPositions()
{
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			bool lMagic = true;

			if (MagicNo > 0 && OrderMagicNumber() != MagicNo)
			{
				lMagic = false;
			}

			if (OrderSymbol() == Symbol() && lMagic)
			{
				return (true);
			}
		}
	}
	return (false);
}