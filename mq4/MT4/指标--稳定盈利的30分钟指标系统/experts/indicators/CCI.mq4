
#property indicator_separate_window

#property indicator_buffers 7
#property indicator_color1 Lime
#property indicator_color2 Magenta
#property indicator_color3 White //Black
#property indicator_color4 Yellow  //Gold
#property indicator_color5 Gold  //Blue
#property indicator_color6 Aqua  //LightGray
#property indicator_color7 Gold
#property indicator_level1 100  //50
#property indicator_level2 250
#property indicator_level3 -250
#property indicator_level4 -100

//---- input parameters
extern int TrendCCI_Period = 50;
extern int EntryCCI_Period = 14;
extern bool Zero_Cross_Alert = true;
extern bool Automatic_Timeframe_Setting = false;
extern int M1_TrendCCI_Period = 50;
extern int M1_EntryCCI_Period = 14;
extern int M5_TrendCCI_Period = 50;
extern int M5_EntryCCI_Period = 14;
extern int M15_TrendCCI_Period = 14;
extern int M15_EntryCCI_Period = 6;
extern int M30_TrendCCI_Period = 14;
extern int M30_EntryCCI_Period = 6;
extern int H1_TrendCCI_Period = 14;
extern int H1_EntryCCI_Period = 6;

double TrendCCI[];
double EntryCCI[];
double CCITrendUp[];
double CCITrendDown[];
double CCINoTrend[];
double CCITimeBar[];
double ZeroLine[];

int trendUp, trendDown;

int init()  
{
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexBuffer(4, TrendCCI);
   SetIndexLabel(4, "TrendCCI");
   SetIndexStyle(0, DRAW_HISTOGRAM, 0, 1);  //1
   SetIndexBuffer(0, CCITrendUp);
   SetIndexStyle(1, DRAW_HISTOGRAM, 0, 1);
   SetIndexBuffer(1, CCITrendDown);
   SetIndexStyle(2, DRAW_HISTOGRAM, 0, 2);
   SetIndexBuffer(2, CCINoTrend);
   SetIndexStyle(3, DRAW_HISTOGRAM, 0, 2);
   SetIndexBuffer(3, CCITimeBar);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexBuffer(5, EntryCCI);
   SetIndexLabel(5, "EntryCCI");
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexBuffer(6, ZeroLine);   
   return(0);
  }

int start() 
{
   int limit, i, trendCCI, entryCCI;
   int counted_bars = IndicatorCounted();
   static datetime prevtime = 0;
//---- check for possible errors
   if(counted_bars < 0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) counted_bars--; 

   limit=Bars;//-counted_bars;
   
   if (Automatic_Timeframe_Setting == true) 
      {
      switch(Period()) 
        {
         case 1: trendCCI = M1_TrendCCI_Period; entryCCI = M1_EntryCCI_Period; break;
         case 5: trendCCI = M5_TrendCCI_Period; entryCCI = M5_EntryCCI_Period; break;
         case 15: trendCCI = M15_TrendCCI_Period; entryCCI = M15_EntryCCI_Period; break;
         case 30: trendCCI = M30_TrendCCI_Period; entryCCI = M30_EntryCCI_Period; break;
         case 60: trendCCI = H1_TrendCCI_Period; entryCCI = H1_EntryCCI_Period; break;
        }
       }
   else {
         trendCCI = TrendCCI_Period;
         entryCCI = EntryCCI_Period;
         }
      
   IndicatorShortName("(TCCI: " +trendCCI+ ",ECCI: " +entryCCI+ ")");   
   
   for(i = limit; i >= 0; i--) 
      {
      CCINoTrend[i] = 0;
      CCITrendDown[i] = 0;
      CCITimeBar[i] = 0;
      CCITrendUp[i] = 0;
      ZeroLine[i] = 0;
      TrendCCI[i] = iCCI(NULL, 0, trendCCI, PRICE_TYPICAL, i);
      EntryCCI[i] = iCCI(NULL, 0, entryCCI, PRICE_TYPICAL, i);
      
      if(TrendCCI[i] > 0 && TrendCCI[i+1] < 0) 
        {
         if (trendDown > 4) trendUp = 0;
        }
      if (TrendCCI[i] > 0) 
         {
         if (trendUp < 5)
            {
            CCINoTrend[i] = TrendCCI[i];
            trendUp++;
            }
         if (trendUp == 5) 
            {
            CCITimeBar[i] = TrendCCI[i];
            trendUp++;
            }
         if (trendUp > 5) 
            {
            CCITrendUp[i] = TrendCCI[i];
            }
         }
      if(TrendCCI[i] < 0 && TrendCCI[i+1] > 0) 
        {
         if (trendUp > 4) trendDown = 0;
        }
      if (TrendCCI[i] < 0) 
         {         
         if (trendDown < 5)
            {
            CCINoTrend[i] = TrendCCI[i];
            trendDown++;
            }
         if (trendDown == 5) 
            {
            CCITimeBar[i] = TrendCCI[i];
            trendDown++;
            }
         if (trendDown > 5) 
            {
            CCITrendDown[i] = TrendCCI[i];
            }
         }
     }
   
   if (Zero_Cross_Alert == true) 
      {
      if (prevtime == Time[0]) 
      {
         return(0);
      }
      else {
         if(EntryCCI[0] < -100) 
           {
            if((TrendCCI[0] < -100) && (TrendCCI[1] >= -100)) 
            {
               Alert(Symbol(), " M", Period(), " CCI14&50 crossed below 100!");
               SendMail(Symbol()+"-M"+Period()+" SELL:"+DoubleToStr(Close[0],Digits),
               "CCI50:"+DoubleToStr(TrendCCI[0],Digits)+
               ",CCI14:"+DoubleToStr(EntryCCI[0],Digits)+"."+
               Symbol()+"-M"+Period()+" SELL:"+DoubleToStr(Close[0],Digits));
            }
           }
         else if(EntryCCI[0] > 100) 
           {
            if((TrendCCI[0] > 100) && (TrendCCI[1] <= 100)) 
            {
               Alert(Symbol(), " M", Period(), " CCI14&50 crossed above 100!");
               SendMail(Symbol()+"-M"+Period()+" BUY:"+DoubleToStr(Close[0],Digits),
               "CCI50:"+DoubleToStr(TrendCCI[0],Digits)+
               ",CCI14:"+DoubleToStr(EntryCCI[0],Digits)+"."+
               Symbol()+"-M"+Period()+" BUY:"+DoubleToStr(Close[0],Digits));
            }
           }
         prevtime = Time[0];
      }
   }
   return(0);
  }

