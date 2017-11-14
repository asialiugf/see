//Revisions by Trainman, July 26, 2012
#property copyright "Extreme TMA System"
#property link      "http://www.forexfactory.com/showthread.php?t=343533m"

#property indicator_chart_window
#property indicator_buffers    6
#property indicator_color1     CLR_NONE
#property indicator_color2     White
#property indicator_color3     White
#property indicator_color4     Lime 
#property indicator_color5     Red
#property indicator_color6     White
#property indicator_style2     STYLE_DOT
#property indicator_style3     STYLE_DOT
#property  indicator_width1 1
#property  indicator_width2 1
#property  indicator_width3 1
#property  indicator_width4 1
#property  indicator_width5 1
#property  indicator_width6 1

#define PIPSTOFORCERECALC 10

extern string TimeFrame       = "Current";
extern int    TMAPeriod      = 56;
extern int    Price           = PRICE_CLOSE;
extern double ATRMultiplier   = 2.0;
extern int    ATRPeriod       = 100;
extern double TrendThreshold = 0.5;
extern bool ShowCenterLine = false;


extern bool   alertsOn        = false;
extern bool   alertsMessage   = false;
extern bool   alertsSound     = false;
extern bool   alertsEmail     = false;
extern bool   MoveEndpointEveryTick = false;
extern int    MaxBarsBack     = 5000;


double tma[];
double upperBand[];
double lowerBand[];
double bull[];
double bear[];
double neutral[];
 
int    TimeFrameValue,
       FirstAvailableBar;
bool AlertHappened;
datetime AlertTime;
double TICK;
bool AdditionalDigit;
double  SumTMAPeriod,
        TickScaleFactor,
        Threshold,
        PriorTick,
        FullSumW;

int init()
{
  AdditionalDigit = MarketInfo(Symbol(), MODE_MARGINCALCMODE) == 0 && MarketInfo(Symbol(), MODE_PROFITCALCMODE) == 0 && Digits % 2 == 1;

  TICK = MarketInfo(Symbol(), MODE_TICKSIZE);
  if (AdditionalDigit)
    TICK *= 10;

  TimeFrameValue         = stringToTimeFrame(TimeFrame);
             
  IndicatorBuffers(6); 
  SetIndexBuffer(0,tma); 
  SetIndexBuffer(1,upperBand); 
  SetIndexBuffer(2,lowerBand); 
  SetIndexBuffer(3,bull); 
  SetIndexBuffer(4,bear); 
  SetIndexBuffer(5,neutral); 
  
  //SetIndexLabel(0, "FastTMA " + TimeFrame + ")");  
  SetIndexLabel(1, "FastTMA " + TimeFrame + " Upper line");  
  SetIndexLabel(2, "FastTMA " + TimeFrame + " Lower line");  
  SetIndexLabel(3, "FastTMA(" + TimeFrame + ")");  
  SetIndexLabel(4, "FastTMA(" + TimeFrame + ")");  
  SetIndexLabel(5, "FastTMA(" + TimeFrame + ")");  

  IndicatorShortName(TimeFrameValueToString(TimeFrameValue)+" TMA bands ("+TMAPeriod+")");
  SumTMAPeriod = 0;
  for (int i = 1; i <= TMAPeriod; i++)
    SumTMAPeriod += i;
  FullSumW = TMAPeriod + 1 + 2 * SumTMAPeriod;
  TickScaleFactor = (TMAPeriod + 1) / (TMAPeriod + 1 + SumTMAPeriod); // relative weight of latest tick
  PriorTick = Close[0];
  if (Digits < 4)
    Threshold = PIPSTOFORCERECALC * 0.01;
  else
    Threshold = PIPSTOFORCERECALC * 0.0001;
    
  FirstAvailableBar = iBars(NULL, TimeFrameValue) - TMAPeriod - 1;
  return(0);
}
int deinit() { return(0); }


int start()
{
  int counted_bars=IndicatorCounted();
  if(counted_bars<0) return(-1);
  if(Period() > TimeFrameValue) 
    return(0); // don't plot lower TFs on upper TF charts

  int i,j,k,limit;
  static double PriceAtFullRecalc = 0;
  static double range = 0;
  static double slope = 0;
  // if (uncounted bars are zero and price change is small)
  if (((Bars - counted_bars) == 1) && (MathAbs(Close[0] - PriceAtFullRecalc) < Threshold))
    {
    if (MoveEndpointEveryTick)
      { // incremental change to end point
      tma[0] = CalcTmaUpdate(tma[0]);
      upperBand[0] = tma[0] + range;
      lowerBand[0] = tma[0] - range;
      DrawCenterLine(0, slope);   
      }
    else
      return(0);
    }
  else // complete recalculation
    {
    PriceAtFullRecalc = Close[0];
    if(counted_bars>0) counted_bars--;
    double barsPerTma = (TimeFrameValue / Period());
    limit=MathMin(Bars-1, MaxBarsBack); 
    limit=MathMin(limit,Bars-counted_bars+ TMAPeriod * barsPerTma ); 
   
    int mtfShift = 0;
    int lastMtfShift = 999;
    double prevTma = tma[limit+1];
    double tmaVal = tma[limit+1];
    for (i=limit; i>=0; i--)
      {
      if (TimeFrameValue == Period())
        {
        mtfShift = i;
        }
      else
        {         
        mtfShift = iBarShift(Symbol(),TimeFrameValue,Time[i]);
        } 
      
      if (mtfShift > FirstAvailableBar) continue; // exceeded available historical data
      if(mtfShift == lastMtfShift)
        {       
        tma[i] =tma[i+1] + ((tmaVal - prevTma) * (1/barsPerTma));         
        upperBand[i] = tma[i] + range;
        lowerBand[i] = tma[i] - range;
        DrawCenterLine(i, slope);   
        continue;
        }
      
      lastMtfShift = mtfShift;
      prevTma = tmaVal;
      tmaVal = CalcTma(mtfShift);
      
      range = iATR(NULL,TimeFrameValue,ATRPeriod,mtfShift+10)*ATRMultiplier;
      if(range == 0) range = 1;
      
      if (barsPerTma > 1)
        {
        tma[i] =prevTma + ((tmaVal - prevTma) * (1/barsPerTma));
        }
      else
        {
        tma[i] =tmaVal;
        }
      upperBand[i] = tma[i]+range;
      lowerBand[i] = tma[i]-range;

      slope = (tmaVal-prevTma) / ((range / ATRMultiplier) * 0.1);
            
      DrawCenterLine(i, slope);
          
      }
    }

   manageAlerts();
   return(0);
}

void DrawCenterLine(int shift, double slope)
{

   bull[shift] = EMPTY_VALUE;
   bear[shift] = EMPTY_VALUE;          
   neutral[shift] = EMPTY_VALUE; 
   if (ShowCenterLine)
   {
      if(slope > TrendThreshold)
      {
         bull[shift] = tma[shift];
      }
      else if(slope < -1 * TrendThreshold)
      {
         bear[shift] = tma[shift];
      }
      else
      {
         neutral[shift] = tma[shift];
      }
   }
}


//---------------------------------------------------------------------
double CalcTma( int inx )
  {
  double tma;
  if(inx >= TMAPeriod)
    tma = CalcPureTma(inx);
  else
    tma = CalcTmaEstimate(inx);
  return( tma );
  }
  
//---------------------------------------------------------------------
double CalcPureTma( int i )
  {
  int j = TMAPeriod + 1; 
  int k;
  double sum = j * iClose(NULL, TimeFrameValue, i);
  for (k = 1; k <= TMAPeriod; k++)
    sum = sum + (j - k) * (iClose(NULL, TimeFrameValue, i+k) + iClose(NULL, TimeFrameValue, i-k));
  return( sum / FullSumW );
  }

//---------------------------------------------------------------------
double CalcTmaEstimate( int i )
//only returns correct result if i <= TMAPeriod
  {
  double sum = 0;
  double sumW;
  int k,
      j = TMAPeriod + 1;
      sumW = 0;
  // compute left half
  for (k = 0; k <= TMAPeriod; k++)
    {
    sum += (j - k) * iClose(NULL, TimeFrameValue, i+k);
    sumW += (j - k);
    }
  // compute right half
  j = TMAPeriod;
  for (k = i-1; k >= 0; k--)
    {
    sum += j * iClose(NULL, TimeFrameValue, k);
    sumW += j;
    j--;
    }
    
  PriorTick = Close[0];
  return( sum / sumW );
  }

//---------------------------------------------------------------------
// if the next tick arrives but it still goes in the same bar, this
// function updates the latest value without a complete recalculation
double CalcTmaUpdate( double PreviousTma )
  {
  double r = PreviousTma + (Close[0] - PriorTick) * TickScaleFactor;
  PriorTick = Close[0];
  return( r );
  }
//---------------------------------------------------------------------

void manageAlerts()
{
   if (alertsOn)
   { 
      int trend;        
      if (Close[0] > upperBand[0]) trend =  1;
      else if (Close[0] < lowerBand[0]) trend = -1;
      else {AlertHappened = false;}
            
      if (!AlertHappened && AlertTime != Time[0])
      {       
         if (trend == 1) doAlert("up");
         if (trend ==-1) doAlert("down");
      }         
   }
}


void doAlert(string doWhat)
{ 
   if (AlertHappened) return;
   AlertHappened = true;
   AlertTime = Time[0];
   string message;
     
   message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," "+TimeFrameValueToString(TimeFrameValue)+" TMA bands price penetrated ",doWhat," band");
   if (alertsMessage) Alert(message);
   if (alertsEmail)   SendMail(StringConcatenate(Symbol(),"TMA bands "),message);
   if (alertsSound)   PlaySound("alert2.wav");

}

//+-------------------------------------------------------------------
//|   Time Frame Handlers                                                               
//+-------------------------------------------------------------------


string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};


int stringToTimeFrame(string tfs)
{
   tfs = StringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
   {
      if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) 
      {
//         return(MathMax(iTfTable[i],Period()));
         return(iTfTable[i]);
      }
   }
   return(Period());
   
}
string TimeFrameValueToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

string StringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int char = StringGetChar(s, length);
         if((char > 96 && char < 123) || (char > 223 && char < 256))
                     s = StringSetChar(s, length, char - 32);
         else if(char > -33 && char < 0)
                     s = StringSetChar(s, length, char + 224);
   }
   return(s);
}