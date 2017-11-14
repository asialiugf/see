//+------------------------------------------------------------------+
//|                                               test_smart_lot.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

extern bool   FXOpenECN = false;
extern double PercentToRisk = 2.00;
extern double TestLotScale = 0.00;
extern int    MagicNo = 338833;
extern bool   TradeLateFri = False;
extern int    FridayCutHour = 15;
int           DecCutDate = 15;
extern bool   TradeLateDec = false;
extern double MaxSpread = 4.0;

double MinLots = 0;
double MaxLots = 0;
double LotStep = 0;
double PipSize = 0;

double dLots = 0.1;
double dStepPips = 0;

double mmTradeLots = 0.1;
double mmTestLots  = 0.1;
double CurSpread;
double HistoryOrderProfit = 0;

double dlStopLossPips = 110;
double dlTakeProfitPips = 55;
double dlTrailingStopPips = 22;
double dlTrailingReservePips = 5;
double dlStepPips = 0;


string mmMessage = "Smart MM finds nothing wrong";
color  mmMessageColor = LightGreen;


int start()
  {
//----
   
//----
	Set_SmartMM_Lots();

   return(0);
  }
//+------------------------------------------------------------------+


void Set_SmartMM_Lots()
{
	//Smart MM - Update MM dLots and EA Meter Display

	double RiskEquity;

	MinLots = MarketInfo(Symbol(), MODE_MINLOT);
	Print("MinLots: "+ MinLots);
	MaxLots = MarketInfo(Symbol(), MODE_MAXLOT);
	Print("MaxLots: "+ MaxLots);
	LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
	Print("LotStep: "+ LotStep);
	CurSpread = getSpreadPips(Symbol());
	Print("CurSpread: "+ CurSpread);

	if (FXOpenECN && (StringFind(AccountServer(), "FXOpen-ECN", 0) >= 0 ))
	{
		MinLots = 0.1;
	}

	RiskEquity = AccountFreeMargin() * (PercentToRisk / 100);
	Print("RiskEquity: "+ RiskEquity);
	mmTradeLots = RiskEquity / (dlStopLossPips * getPipValue(Symbol()));
	Print("mmTradeLots: "+ mmTradeLots);
	mmTradeLots = getWorkingLots(mmTradeLots);
	Print("mmTradeLots: "+ mmTradeLots);


	if (TestLotScale > 0)
	{
		mmTestLots = mmTradeLots * TestLotScale;
		mmTestLots = getWorkingLots(mmTestLots);
	}
	else
	{
		mmTestLots = MinLots;
	}
	Print("mmTestLots: "+ mmTestLots);

	// Set Default SmartMM message
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

	Print("HistroyOrderProfit: "+ HistoryOrderProfit);
	if (HistoryOrderProfit == 0)
	{
		dLots = mmTestLots;
	}

	if (HistoryOrderProfit > 0)
	{
		dLots = mmTradeLots;
	}

	// if lose, use smallest lot to test the market before resume full lots
	if (HistoryOrderProfit < 0)
	{
		dLots = mmTestLots;
	}
	Print("dLots : "+ dLots);
	// !!!!!!!Special days - trade min lot / stop trading to avoid risk!!!!!!!!!
	if ((DayOfWeek() == 5) && (Hour() > FridayCutHour))
	{
		mmMessage = "It's Fridy after " + DoubleToStr(FridayCutHour, 0) + ":00, ";
		mmMessageColor = Silver;
		if (!TradeLateFri)
		{
			dLots = 0;
			mmMessage = mmMessage + "M-EA will not open new orders";
		}
		else
		{
			dLots = mmTestLots;
			mmMessage = mmMessage + "M-EA will open new TestLot orders only";
		}
	}

	if ((Month() == 12) && (Day() > DecCutDate))
	{
		mmMessage = "It's December after" + DoubleToStr(DecCutDate, 0) + "th, ";
		mmMessageColor = Silver;
		if (!TradeLateDec)
		{
			dLots = 0;
			mmMessage = mmMessage + "M-EA will not open new orders";
		}
		else
		{
			dLots = mmTestLots;
			mmMessage = mmMessage + "M-EA will open new TestLot orders only";
		}
	}

	// Stop Trading if spreads are too high
	if (CurSpread > MaxSpread)
	{
		mmMessage = "Spread is too high, M-EA will not open new orders";
		mmMessageColor = Silver;
		dLots = 0;
	}

	// Stop M-EA from trading if capital is danger low, less than 100
	if (AccountFreeMargin() < 110)
	{
		mmMessage = "Free Margin is dangerously low, M-EA will not open new orders";
		mmMessageColor = HotPink;
		dLots = 0;
	}
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

double getSpreadPips(string eSymbol)
{
	double iSpreadPips, iPipSize;
	double iTickSize, iTickValue;

	iTickSize = MarketInfo(eSymbol, MODE_TICKSIZE);
	iPipSize  = getPipSize(eSymbol);

	iSpreadPips = MarketInfo(eSymbol, MODE_SPREAD) * (iTickSize/iPipSize);

	return (iSpreadPips);
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
