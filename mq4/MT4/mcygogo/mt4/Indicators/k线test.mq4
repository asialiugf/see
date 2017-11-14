//K Pattern Recognition

#property copyright "Mea"
#property link      "mcygogo@126.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Yellow

extern bool Show_Alert = true;

extern string ShootStarNote = "Á÷ÐÇ";
extern bool  Display_ShootStar_2 = true;
extern bool  Show_ShootStar_Alert_2 = true;
extern bool  Display_ShootStar_3 = false;
extern bool  Show_ShootStar_Alert_3 = false;
extern bool  Display_ShootStar_4 = false;
extern bool  Show_ShootStar_Alert_4 = false;
extern color Color_ShootStar = Red;
int FrontSize = 8;

extern string EveningStarNote = "»Æ»èÖ®ÐÇ";
extern bool  Display_EveningStar = true;
extern bool  Show_EveningStar_Alert = true;
extern int   EveningStar_Body_Length = 5;
extern color Color_EveningStar = Red;

extern string EveningDojiStarNote = "»Æ»èÊ®×ÖÐÇ";
extern bool  Display_EveningDojiStar = true;
extern bool  Show_EveningDojiStar_Alert = true;
extern color Color_EveningDojiStar = Red;

extern string DarkCouldCoverNote = "ÎÚÔÆ¸Ç¶¥";
extern bool  Display_DarkCloudCover = true;
extern bool  Show_DarkCloudCover_Alert = true;
extern color Color_DarkCloudCover = Red;

extern string BearishEngulfingNote = "¿´µøÍÌÃ»";
extern bool  Display_BearishEngulfing = true;
extern bool  Show_BearishEngulfing_Alert = true;
extern color Color_BearishEngulfing = Red;

extern bool  Display_Piercing_Line = true;
extern bool  Show_Piercing_Line_Alert = true;
extern color Color_Piercing_Line = Aqua;

/*
extern bool  Display_Bullish_Engulfing = true;
extern bool  Show_Bullish_Engulfing_Alert = true;
extern color Color_Bullish_Engulfing = Aqua;
int Text_Bullish_Engulfing = 8;
*/

extern string HammerNote = "´¸Í·";
extern bool  Display_Hammer_2 = true;
extern bool  Show_Hammer_Alert_2 = true;
extern bool  Display_Hammer_3 = true;
extern bool  Show_Hammer_Alert_3 = true;
extern bool  Display_Hammer_4 = true;
extern bool  Show_Hammer_Alert_4 = true;
extern color Color_Hammer = Lime;



double Pip;
int gDigits;

//---buffers
double upArrow[];
double downArrow[];

int init()
{
/*
	Comment("\n", "\n", "Bearish",
	"\n", "SS 2,3,4 - Shooting Star",
	"\n", "E_Star   - Evening Star",
	"\n", "E_Doji   - Evening Doji Star",
	"\n", "DCC      - Dark Cloud Pattern",
	"\n", "S_E      - Bearish Engulfing Pattern",
	"\n", "\n", "Bullish",
	"\n", "HMR 2,3,4 - Bullish Hammer",
	"\n", "M_Star    - Morning Star",
	"\n", "M_Doji    - Morning Doji Star",
	"\n", "P_L       - Piercing Line Pattern",
	"\n", "L_E       - Bullish Engulfing Pattern");
*/
/*
	Comment("\n", "Bearish",
	"\n", "SS 2,3,4 - Á÷ÐÇ",
	"\n", "E_Star   - »Æ»èÖ®ÐÇ",
	"\n", "E_Doji   - »Æ»èÊ®×ÖÐÇ",
	"\n", "DCC      - ÎÚÔÆ¸Ç¶¥",
	"\n", "S_E      - ´©Í·ÆÆ½Å",
	"\n", "\n", "Bullish",
	"\n", "HMR 2,3,4 - ´¸Í·",
	"\n", "M_Star    - Ôç³¿Ö®ÐÇ",
	"\n", "M_Doji    - Ôç³¿Ê®×ÖÐÇ",
	"\n", "P_L       - Piercing Line",
	"\n", "L_E       - Bullish Engulfing Pattern");
*/
	Comment("Designed by Michael(1055655869), ²âÊÔ°æ");
	
	SetIndexStyle(0, DRAW_ARROW, EMPTY);
	SetIndexArrow(0, 72);
	SetIndexBuffer(0, downArrow);

	SetIndexStyle(1, DRAW_ARROW, EMPTY);
	SetIndexArrow(1, 71);
	SetIndexBuffer(1, upArrow);

	//figure out what a pip and its value is on this broker
	if (Point == 0.01 || Point == 0.0001)
	{
		Pip = Point;
	}
	else if (Point == 0.001 || Point == 0.00001) //??? 0.001 or 0.0001???
	{
		Pip = Point * 10;
	}

	if (Point == 0.01 || Point == 0.001)
	{
		gDigits = 2;
	}
	else if (Point == 0.0001 || Point == 0.00001)
	{
		gDigits = 4;
	}

	return (0);
}

int deinit()
{
	ObjectsDeleteAll(0, OBJ_TEXT);
	return (0);
}
int Pointer_Offset = 10;       // The offset value for the arrow to be located off the candle high or low point
int Text_Offset = 15;
int start()
{
	double Range, AvgRange;
	int counter, setalert;
	static datetime prevtime = 0;
	int shift;
	int shift1;
	int shift2;
	int shift3;
	int shift4;
	string pattern, period;
	int setPattern = 0;
	int alert = 0;
	int arrowShift;
	int textShift;
	double open1, open2, open3, close1, close2, close3, close4, low1, low2, low3, low4, high1, high2, high3, high4;
	double CandleLen1, CLmin, CandleLen2, CandleLen3;
	double BodyLen1, BodyLen_a, BodyLen_90, BodyLen2, BodyLen3, BodyHigh, BodyLow; 
	double UpWick1, UWa, UW1, UW2, DownWick1, LWa, LW1, LW2;
	BodyHigh = 0;
	BodyLow  = 0;
	double Doji_Star_Ratio = 0;
	double Doji_MinLength = 0;
	double Star_MinLength = 0;
	int CumOffset = 0;            // The counter value to be added to as more candle types are met
	int IncOffset = 0;            // The offset value that is added to a cummaltive offset value for each pass through the routing so any
	                              // additional candle patterns that are also met, the label will print above the previous label
	double Piercing_Line_Ratio = 0;
	int Piercing_Candle_Length = 0;
	int Engulfing_Length = 0;
	double Candle_WickBody_Percent = 0;
	int CandleLenBase = 0;

	if (prevtime == Time[0])
	{	
		return (0);
	}
	
	prevtime = Time[0];

	switch (Period())
	{
		case 1:
			period = "M1";
			Doji_Star_Ratio = 0;
			Piercing_Line_Ratio = 0.5;
			Piercing_Candle_Length = 10;
			Candle_WickBody_Percent = 0.9;
			Engulfing_Length = 10;
			CandleLenBase = 12;
			IncOffset = 16;
			break;
		case 60:
			period = "H1";
			Doji_Star_Ratio = 0;
			Piercing_Line_Ratio = 0.5;
			Piercing_Candle_Length = 10;
			Engulfing_Length = 25;
			Candle_WickBody_Percent = 0.9;
			CandleLenBase = 12;
			IncOffset = 18;
			break;
		default:
			Print("This Period Not Support Now!");
			return (0);
			break;
			
	}

	for (shift = 0; shift < Bars; shift++)
	{
		CumOffset = 0;
		setalert = 0;
		counter = shift;
		Range = 0;
		AvgRange = 0;
		for (counter = shift; counter <= shift + 9; counter++)
		{
			AvgRange = AvgRange + MathAbs(NormalizeDouble(High[counter], gDigits) - NormalizeDouble(Low[counter], gDigits));
		}

		Range  = AvgRange / 10;
		shift1 = shift + 1;
		shift2 = shift + 2;
		shift3 = shift + 3;
		shift4 = shift + 4;

		open1  = NormalizeDouble(Open[shift1], gDigits); /// not shift???
		open2  = NormalizeDouble(Open[shift2], gDigits);
		open3  = NormalizeDouble(Open[shift3], gDigits);
		high1  = NormalizeDouble(High[shift1], gDigits);
		high2  = NormalizeDouble(High[shift2], gDigits);
		high3  = NormalizeDouble(High[shift3], gDigits);
		high4  = NormalizeDouble(High[shift4], gDigits);
		low1   = NormalizeDouble(Low[shift1],  gDigits);
		low2   = NormalizeDouble(Low[shift2],  gDigits);
		low3   = NormalizeDouble(Low[shift3],  gDigits);
		low4   = NormalizeDouble(Low[shift4],  gDigits);
		close1 = NormalizeDouble(Close[shift1], gDigits);
		close2 = NormalizeDouble(Close[shift2], gDigits);
		close3 = NormalizeDouble(Close[shift3], gDigits);
		close4 = NormalizeDouble(Close[shift4], gDigits);

		if (MathAbs(high1 - low1) < 1*Pip)
		{
			continue;
		}
		if (MathAbs(high2 - low2) < 1*Pip)
		{
			continue;
		}
		if (MathAbs(high3 - low3) < 1*Pip)
		{

			continue;
		}
		if (MathAbs(high4 - low4) < 1*Pip)
		{
			continue;
		}
		if (open1 > close1)
		{
			BodyHigh = open1;
			BodyLow  = close1;
		}
		else
		{
			BodyHigh = close1;
			BodyLow  = open1;
		}

		CandleLen1 = NormalizeDouble(High[shift1], gDigits) - NormalizeDouble(Low[shift1], gDigits);
		CandleLen2 = NormalizeDouble(High[shift2], gDigits) - NormalizeDouble(Low[shift2], gDigits);
		CandleLen3 = NormalizeDouble(High[shift3], gDigits) - NormalizeDouble(Low[shift3], gDigits);
		BodyLen1   = NormalizeDouble(Open[shift1], gDigits) - NormalizeDouble(Close[shift1], gDigits);
		UpWick1    = NormalizeDouble(High[shift1], gDigits) - BodyHigh; //ÉÏÓ°Ïß
		DownWick1  = BodyLow - NormalizeDouble(Low[shift1], gDigits);   //ÏÂÓ°Ïß
		BodyLen_a  = MathAbs(BodyLen1);  //À¯ÖòÖòÌå³¤¶È
		BodyLen_90 = BodyLen_a * Candle_WickBody_Percent;

// Bearish Patterns
		//Check for Bearish Shooting ShootStar
		if ((high1 >= high2) && (high1 > high3) && (high1 > high4))
		{
			if (((UpWick1/2) > DownWick1) && (UpWick1 > (2*BodyLen_90)) 
				&& (CandleLen1 >= (CandleLenBase*Pip)) && (open1 != close1) 
				&& ((UpWick1/3) <= DownWick1) /*&& ((UpWick/4) <= DownWick)*/)
			{
				if (Display_ShootStar_2 == true)
				{
					ObjectCreate(GetName("SS 2", shift), OBJ_TEXT, 0, Time[shift1], 
							NormalizeDouble(High[shift1],gDigits)+Text_Offset*Pip);
					ObjectSetText(GetName("SS 2", shift), "Á÷ÐÇ 2", FrontSize, "Times New Roman", Color_ShootStar);
					CumOffset = CumOffset + IncOffset;
					downArrow[shift1] = NormalizeDouble(High[shift1], gDigits) + (Pointer_Offset*Pip);
				}
				if (Show_ShootStar_Alert_2)
				{
					if (setalert == 0 && Show_Alert == true)
					{
						pattern = "Shooting ShootStar 2";
						setalert = 1;
					}
				}
			}
		}

		//Check for Bearish Shooting ShootStar
		if ((high1 >= high2) && (high1 > high3) && (high1 > high4))
		{
			if (((UpWick1/3)>DownWick1) && (UpWick1>(2*BodyLen_90))
				&& (CandleLen1>=(CandleLenBase*Pip))&&(open1!=close1)
				&&((UpWick1/4)<=DownWick1))
			{
				if (Display_ShootStar_3 == true)
				{
					ObjectCreate(GetName("SS 3", shift), OBJ_TEXT, 0, Time[shift1], 
						NormalizeDouble(High[shift1],gDigits)+Text_Offset*Pip);
					ObjectSetText(GetName("SS 3", shift), "Á÷ÐÇ 3", FrontSize, "Times New Roman", Color_ShootStar);
					CumOffset = CumOffset + IncOffset;
					downArrow[shift1] = NormalizeDouble(High[shift1], gDigits)+(Pointer_Offset*Pip);
				}
			}
			if (Show_ShootStar_Alert_3)
			{
				if (setalert == 0 && Show_Alert == true)
				{
					pattern = "Shooting ShootStar 3";
					setalert = 1;
				}
			}
		}

		//Check for Bearish Shooting ShootStar
		if ((high1 >= high2) && (high1 > high3) && (high1 > high4))
		{
			if (((UpWick1/4)>DownWick1)&&(UpWick1>(2*BodyLen_90)) 
			  && (CandleLen1 >= (CandleLenBase*Pip)) && (open1!=close1))
			{
				if (Display_ShootStar_4 == true)
				{
					ObjectCreate(GetName("SS 4", shift), OBJ_TEXT, 0, Time[shift1], 
						NormalizeDouble(High[shift1],gDigits)+Text_Offset*Pip);
					ObjectSetText(GetName("SS 4", shift), "Á÷ÐÇ 4", FrontSize, "Times New Roman", Color_ShootStar);
					CumOffset = CumOffset + IncOffset;
					downArrow[shift1] = NormalizeDouble(High[shift1], gDigits)+(Pointer_Offset*Pip);
				}
				if (Show_ShootStar_Alert_4)
				{
					if (setalert == 0 && Show_Alert == true)
					{
						pattern = "Shooting ShootStar 4";
						setalert = 1;
					}
				}
			}
		}


		//Check for Evening Star Pattern
		if ((high1 > high2) && (high1 > high3) && (high1 > high4))
		{
		/*
			if ( (BodyLen_a<(Star_Body_Length*Pip)) && (close3>open3) 
			   &&(!open1==close1) && ((close3-open3)/(high3-low3)>Doji_Star_Ratio) 
			   &&(close2>open2) && (open1>close1) 
			   &&(CandleLen1>=(Star_MinLength*Pip)))
		*/
			if ( (BodyLen_a<(EveningStar_Body_Length*Pip)) && (close3>open3) 
			   &&(open1!=close1) && ((close3-open3)/(high3-low3) > Doji_Star_Ratio) 
			   &&(close2>open2) && (open1>close1) 
			   &&(CandleLen1>=(Star_MinLength*Pip)))			
			{
				if (Display_EveningStar == true)
				{
					ObjectCreate(GetName("Star", shift), OBJ_TEXT, 0, Time[shift1], 
						NormalizeDouble(High[shift1],gDigits)+Text_Offset*Pip);
					ObjectSetText(GetName("Star", shift), "»Æ»èÖ®ÐÇ", FrontSize, "Times New Roman", Color_EveningStar);
					CumOffset = CumOffset + IncOffset;
					downArrow[shift1] = NormalizeDouble(High[shift1],gDigits) + (Pointer_Offset*Pip);
				}
				if (Show_EveningStar_Alert)
				{
					if (setalert == 0 && Show_Alert == true)
					{
						pattern = "Evening Star Pattern";
						setalert = 1;
					}
				}
			}
		}

		//Check for Evening Doji Star pattern
		if ((high1 >= high2) && (high2 > high3) && (high2 > high4))
		{
			if ((open1==close1) 
			 && ( (close3>open3) && (((close3-open3)/(high3-low3))>Doji_Star_Ratio) ) 
			 && (close2>open2) && (CandleLen1>=(Doji_MinLength*Pip)))
			{
				if (Display_EveningDojiStar == true)
				{
					ObjectCreate(GetName("Doji",shift), OBJ_TEXT, 0, Time[shift1],
						NormalizeDouble(High[shift1],gDigits)+Text_Offset*Pip);
					ObjectSetText(GetName("Doji",shift), "»Æ»èÊ®×ÖÐÇ", FrontSize, "Times New Roman", Color_EveningDojiStar);
					CumOffset = CumOffset + IncOffset;
					downArrow[shift1] = NormalizeDouble(High[shift1],gDigits)+(Pointer_Offset*Pip);
				}
				if (Show_EveningDojiStar_Alert)
				{
					if (setalert == 0 && Show_Alert == true)
					{
						pattern = "Evening Doji Star Pattern";
						setalert = 1;
					}
				}
			}
		}

		//Check for a Dark Cloud Cover Pattern
		if ((close2>open3) && (((close2+open2)/2)> close1) 
		  && (open1>close1)&&(close1>open2)
		  && ((open1-close1)/((high1-low1))> Piercing_Line_Ratio)
		  && ((CandleLen1 >= Piercing_Candle_Length*Pip)))
		{
			if (Display_DarkCloudCover == true)
			{
				ObjectCreate(GetName("DCC", shift), OBJ_TEXT, 0, Time[shift1], 
					NormalizeDouble(High[shift1],gDigits)+Text_Offset*Pip);

				ObjectSetText(GetName("DCC", shift), "ÎÚÔÆ¸Ç¶¥", FrontSize, "Times New Roman", Color_DarkCloudCover);
				CumOffset = CumOffset + IncOffset;
				downArrow[shift1] = NormalizeDouble(High[shift1],gDigits)+(Pointer_Offset*Pip);
			}
			if (Show_DarkCloudCover_Alert)
			{
				if (setalert == 0 && Show_Alert == true)
				{
					pattern = "Dark Cloud Cover Pattern";
					setalert = 1;
				}
			}
		}

		//Check for Bearish Engulfing pattern
		if ((close2>open2)&&(open1>close1)&&(open1>=close2)&&(open2>=close1)
			&&((open1-close1)>(close2-open2))&&(CandleLen1>=(Engulfing_Length*Pip)))
		{
			if (Display_BearishEngulfing == true)
			{
				ObjectCreate(GetName("S_E", shift), OBJ_TEXT, 0, Time[shift1],
				    NormalizeDouble(High[shift1],gDigits)+Text_Offset*Pip);
				ObjectSetText(GetName("S_E", shift), "¿´µøÍÌÃ»", FrontSize, "Times New Roman", Color_BearishEngulfing);
				CumOffset = CumOffset + IncOffset;
				downArrow[shift1] = NormalizeDouble(High[shift1],gDigits)+(Pointer_Offset*Pip);
			}
			if (Show_BearishEngulfing_Alert)
			{
				if (setalert == 0 && Show_Alert == true)
				{
					pattern = "Bearish Engulfing Pattern";
					setalert = 1;
				}
			}
		}
//End of Bearish Patterns


//Bullish Patterns
	
	//Check for Bullish Hammer
	if ((low1<=low2)&&(low1<low3)&&(low1<low4))
	{
		if (((DownWick1/2) > UpWick1) && (DownWick1 > BodyLen_90) && (CandleLen1 >= (CandleLenBase*Pip))
			&& (open1!=close1) && ((DownWick1/3) <= UpWick1) && ((DownWick1/4) <= UpWick1))
		{
			if (Display_Hammer_2 == true)
			{
				ObjectCreate(GetName("HMR 2",shift), OBJ_TEXT, 0, Time[shift1],
					NormalizeDouble(Low[shift1],gDigits)-(Pointer_Offset)*Pip);
				ObjectSetText(GetName("HMR 2", shift), "´¸Í· 2", FrontSize, "Times New Roman", Color_Hammer);
				CumOffset = CumOffset+IncOffset;
				upArrow[shift1] = NormalizeDouble(Low[shift1],gDigits) - (Pointer_Offset * Pip);
			}
			if (Show_Hammer_Alert_2)
			{
				if (setalert == 0 && Show_Alert == true)
				{
					pattern = "Bullish Hammer 2";
					setalert = 1;
				}
			}
		}
	}
		
	}
}

string GetName(string aName, int shift)
{
	return (aName + DoubleToStr(Time[shift], 0));
}