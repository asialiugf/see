#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 LimeGreen
#property indicator_color2 Yellow
#property indicator_color3 FireBrick
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2

extern int MAPeriod = 5;
extern int MA_Type = 0;
extern int MA_AppliedPrice = 0;
extern double AngleThreshold = 8;
extern int PrevMAShift = 1;
extern int CurMAShift = 0;

int MA_Mode;
string strMAType;

double UpBuffer[];
double DownBuffer[];
double ZeroBuffer[];

int init()
{
//---2 additional buffers are used for counting
	IndicatorBuffers(3);

	SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID);
	SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID);
	SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID);

	IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS+2));

//----3 indicator buffers mapping
	if (!SetIndexBuffer(0, UpBuffer) &&
	    !SetIndexBuffer(1, DownBuffer) &&
	    !SetIndexBuffer(2, ZeroBuffer))
	{
		Print("Can not Set indicator buffers!");    
	}

	switch(MA_Type)
	{
		case 0:
		 	strMAType = "SAM";
		 	MA_Mode = MODE_SMA;
		 	break;
		case 1:
			strMAType = "EMA";
			MA_Mode = MODE_EMA;
			break;
		default:
		 	strMAType = "SAM";
		 	MA_Mode = MODE_SMA;
		 	break;
	}

	IndicatorShortName("MA_"+strMAType+"_Angle("+MAPeriod+","+AngleThreshold+","+PrevMAShift+","+CurMAShift+")");
	return (0);
}

int deinit()
{
	return (0);
}

///*



double ma_angle(int bar)
{
	
	if (CurMAShift >= PrevMAShift)
	{
		Print("Error: CurMAShift>=PrevMAShift");
		PrevMAShift = 6;
		CurMAShift = 0;
	}
	double fCurMA, fPrevMA;
	double fAngle, scale, dFactor;
	double angle;
	double xShiftDif;
	double yMADif;
	string sym;
	
	dFactor = 3.14159/180.0;
	scale = 1000.0;

	if (StringSubstr(Symbol(), 3, 3) == "JPY")
	{
		scale = 10.0;
	}

	xShiftDif = PrevMAShift - CurMAShift;

	fCurMA  = iMA(NULL, 0, MAPeriod, 0, MA_Mode, MA_AppliedPrice, bar+CurMAShift);
	fPrevMA = iMA(NULL, 0, MAPeriod, 0, MA_Mode, MA_AppliedPrice, bar+PrevMAShift);
	yMADif = (fCurMA - fPrevMA) * scale;
	fAngle = yMADif/xShiftDif;
	//Print("xShiftDif: "+ xShiftDif+" yMADif: "+yMADif+" fAngle: "+ fAngle);

	fAngle = MathArctan(fAngle)/dFactor;

	return (fAngle);
}


int start()
{
	int nLimit = 1000;
	int i;
	double fAngle = 0.0;
	double fAngle1 = 0.0;
	for (i = 0; i < nLimit; i++)
	{
		fAngle = ma_angle(i);
		//fAngle = ma_angle_(i);
      	//fAngle1 = ma_angle_trendbyangle(i);
      	//Print("fAngle: "+ fAngle + " fAngle1: "+ fAngle1);
		DownBuffer[i] = 0.0;
		UpBuffer[i] = 0.0;
		ZeroBuffer[i] = 0.0;

		if (fAngle > AngleThreshold)
		{
			UpBuffer[i] = fAngle;
		}
		else if (fAngle < -AngleThreshold)
		{
			DownBuffer[i] = fAngle;
		}
		else
		{
			ZeroBuffer[i] = fAngle;
		}
	}
	return (0);
}
//*/
/*
double getYdif(string Sym, int TimeFrame, double Dif)
{
	double YDif = 0.0;
	double Factor = 0.0;
	if (Sym == "EURUSD")
	{
		switch (TimeFrame)
		{
			case PERIOD_H1:
				Factor = 0.00045;
				break;
			case PERIOD_D1:
				Factor = 0.0019;
		}
	}
	Print("Dif: "+ Dif+"  Factor: "+Factor);
	YDif = Dif/Factor;
	return (YDif);
}

double getMA_Angle(int TimeFrame, int MAPeriod, int CurMAShift, int PreMAShift)
{

	double xShiftDif = PreMAShift - CurMAShift;
	double SMA_5_D1_Cur = iMA(Symbol(), TimeFrame, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, CurMAShift);
	double SMA_5_D1_Pre = iMA(Symbol(), TimeFrame, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, PreMAShift);
	double yMADif = getYdif(Symbol(), TimeFrame, SMA_5_D1_Cur - SMA_5_D1_Pre);
	
	
	double dFactor = 3.14159/180.0;

	double MA_Angle = yMADif/xShiftDif;
	Print("--------------yMADif: "+yMADif+"  xShiftDif: "+xShiftDif +"  MA_Angle: "+MA_Angle);

	MA_Angle = MathArctan(MA_Angle)/dFactor;
	Print("MA_Angle: "+MA_Angle);

	return (MA_Angle);
}

double ma_angle_(int bar)
{
	//return (getMA_Angle(PERIOD_H1, 12, bar+0, bar+1));
	return (getMA_Angle(PERIOD_D1, 12, bar+0, bar+1));

}

int start()
{
	double fCurMA, fPrevMA;
	double fAngle, mFactor, dFactor;
	int nLimit, i;
	int nCountedBars;
	double angle;
	int ShiftDif;
	string sym;

	if (CurMAShift >= PrevMAShift)
	{
		Print("Error: CurMAShift>=PrevMAShift");
		PrevMAShift = 6;
		CurMAShift = 0;
	}

	nCountedBars = IndicatorCounted();

	if (nCountedBars < 0)
	{
		return (-1);
	}

	if (nCountedBars > 0)
	{
		nCountedBars--;
	}

	nLimit = Bars - nCountedBars;
	//nLimit = 50;
	Print("Bars: "+Bars+" nCountedBars: " + nCountedBars+" nLimit: "+nLimit);
	dFactor = 3.14159/180.0;
	mFactor = 1000.0;
	sym = StringSubstr(Symbol(), 3, 3);

	if (sym == "JPY")
	{
		mFactor = 10.0;
	}

	ShiftDif = PrevMAShift - CurMAShift;

	for (i = 0; i < nLimit; i++)
	{

		fCurMA  = iMA(NULL, 0, MAPeriod, 0, MA_Mode, MA_AppliedPrice, i+CurMAShift);
		fPrevMA = iMA(NULL, 0, MAPeriod, 0, MA_Mode, MA_AppliedPrice, i+PrevMAShift);
		Print("ShiftDif: "+ ShiftDif);
		fAngle = (fCurMA - fPrevMA) / ShiftDif;
		fAngle = mFactor * MathArctan(fAngle)/dFactor;

		DownBuffer[i] = 0.0;
		UpBuffer[i] = 0.0;
		ZeroBuffer[i] = 0.0;

		if (fAngle > AngleThreshold)
		{
			UpBuffer[i] = fAngle;
		}
		else if (fAngle < -AngleThreshold)
		{
			DownBuffer[i] = fAngle;
		}
		else
		{
			ZeroBuffer[i] = fAngle;
		}
	}

	return (0);
}

int ma_angle_trendbyangle(int bar)
{
	CurMAShift = 1;
	PrevMAShift = 2;
	double fCurMA, fPrevMA;
	datetime curTime, PrevTime;
	fCurMA  = iMA(NULL, 0, MAPeriod, 0, MA_Mode, MA_AppliedPrice, bar+CurMAShift);
	fPrevMA = iMA(NULL, 0, MAPeriod, 0, MA_Mode, MA_AppliedPrice, bar+PrevMAShift);
	curTime = iTime(NULL, 0, bar+CurMAShift);
	PrevTime = iTime(NULL, 0, bar+PrevMAShift);
	string objName = "TrendByAngle"+bar;
	//ObjectCreate(objName, OBJ_TRENDBYANGLE, 0, PrevTime, fPrevMA, curTime, fCurMA);
	//ObjectCreate(objName, OBJ_TREND, 0, PrevTime, fPrevMA, curTime, fCurMA);
	//ObjectCreate(objName, TRIANGLE, 0, PrevTime, fPrevMA, curTime, fCurMA, );
   //ObjectSet(objName, OBJPROP_COLOR, Green);
   	double angle;
   	angle = ObjectGet(objName, OBJPROP_ANGLE);
   	Print("fCurMA:"+fCurMA+" fPrevMA:"+fPrevMA+
   	      " curTime:"+TimeToStr(curTime,TIME_SECONDS)+" PrevTime:"+TimeToStr(PrevTime,TIME_SECONDS)+
   	      "Angle: "+angle);


   	//ObjectDelete("TrendByAngle");
   	return (angle);
}

//*/