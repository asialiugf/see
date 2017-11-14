//Added options for slopes & sizes MrC 2012
#property copyright "Extreme TMA System"
#property link      "http://www.forexfactory.com/showthread.php?t=343533m"

#property indicator_chart_window
  
extern color NeutralColor = DimGray;
extern color BullColor = OliveDrab;
extern color ExtremeBullColor = ForestGreen;
extern color BearColor = SaddleBrown;
extern color ExtremeBearColor = FireBrick;
extern color ValueColor = Gray;  
extern int TmaPeriod = 56;
extern int TmaAtrPeriod = 100;  
 
extern double TmaBandSize = 2;
extern double TmaSlopeThreshold = 0.4; 

extern double TmaBandSizeM15 = 2;
extern double TmaBandSizeH1 = 2;
extern double TmaBandSizeH4 = 2.5;
extern double TmaBandSizeD1 = 3;
extern double TmaBandSizeW1 = 3;

extern int PivotHoursShift = 0;
extern double PivotThreshold = 10; 

extern int MaPeriod = 10;  
//This is the same as 4 in the original TMA MACross
extern int MaShift = 1;

extern int Size = 9;
extern string Font = "Arial";
extern int corner = 3;

extern bool ShowPrice = true;
extern bool ShowDailyAtr = true;
extern bool ShowSpread = true;

extern bool ShowTmaSize = false;
extern bool ShowTmaSizeM15 = true; 
extern bool ShowTmaSizeH1 = true; 
extern bool ShowTmaSizeH4 = true; 
extern bool ShowTmaSizeD1 = true;
extern bool ShowTmaSizeW1 = true;

extern bool ShowSlope = false; 
extern bool ShowSlopeM15 = true;
extern bool ShowSlopeH1 = true;
extern bool ShowSlopeH4 = true;
extern bool ShowSlopeD1 = true; 
extern bool ShowSlopeW1 = true;  
extern bool ShowExtremeTMA = true; 

extern bool ShowSlopeChange = true; 
extern bool ShowPivotDistance = true;

extern bool ShowHeikenAshi = true;
extern bool ShowMACrossover = true;

extern bool AlertOn = false;
extern bool AlertMessage = false;
extern bool AlertEmail = false;
extern bool AlertSound = false;
extern string AlertSoundFile = "alert2.wav"; 



int LinearRegressionPeriod = 7; 

bool ShowLinearPriceChange = false; 


int Bottom = 25;
double Tick = 0;
bool AdditionalDigit;
double Pivots[];
 
int LastPivotDay= 0;
bool AlertHappened = false;
//+------------------------------------------------------------------+
//     expert initialization function                                |       
//+------------------------------------------------------------------+
int init()
  { 
  
   ArrayResize(Pivots,11);
	Tick = MarketInfo(Symbol(), MODE_TICKSIZE);	
   AdditionalDigit = MarketInfo(Symbol(), MODE_MARGINCALCMODE) == 0 && MarketInfo(Symbol(), MODE_PROFITCALCMODE) == 0 && Digits % 2 == 1;
   if (AdditionalDigit) {
        Tick *= 10;
    }    
       
   initGraph();
   return(0);                                                              
  }
  
int deinit()
  {
   deinitGraph();
   Print("shutdown error - ",GetLastError());                               
   return(0);                                                             
  }
int start()
  {
   main();
   return(0);                                                               
  }
  
void main()                                                             
  {   
   RefreshRates();  
   //General Info   
    
   double spread=NormalizeDouble(((Ask-Bid)/Point)/10,1);
   int dayShift = iBarShift(Symbol(),PERIOD_D1,Time[0]);
   
   double atr = iATR(Symbol(),PERIOD_D1, 14,dayShift);
   double price = NormalizeDouble(Close[0],4);     
   atr =  NormalizeDouble((atr/Point)/10,1);

   if (ShowSpread)  paintGeneral("SpreadValue", spread, ExtremeBullColor, 1);
   if (ShowDailyAtr)  paintGeneral("AtrValue", atr, ExtremeBearColor);
   if (ShowPrice)  paintPrice(price); 


   
   double tmaM15,tmaM15Prev,tmaH1,tmaH1Prev,tmaH4,tmaH4Prev,tmaD1,tmaD1Prev,tmaW1,tmaW1Prev;
   
   //Tma Info
   GetPivots(Symbol());
      int shiftM15 = iBarShift(NULL,15,Time[0]);
      int shiftH1 = iBarShift(Symbol(),60,Time[0]);
      int shiftH4 = iBarShift(Symbol(),240,Time[0]);
      int shiftD1 = iBarShift(Symbol(),1440,Time[0]);
      int shiftW1 = iBarShift(Symbol(),10080,Time[0]);  
   if (ShowSlopeM15)
   {      
      tmaM15 = CalcTma(15, shiftM15); 
      tmaM15Prev  = CalcTma(15, shiftM15+1);
   }
   if (ShowSlopeH1)
   {    
      tmaH1 = CalcTma(60, shiftH1); 
      tmaH1Prev  = CalcTma(60, shiftH1+1);
   }
   if (ShowSlopeH4)
   {    
      tmaH4 = CalcTma(240, shiftH4); 
      tmaH4Prev  = CalcTma(240, shiftH4+1);
   }
   if (ShowSlopeD1)
   {    
      tmaD1 = CalcTma(1440, shiftD1); 
      tmaD1Prev  = CalcTma(1440, shiftD1+1);
   }
   if (ShowSlopeW1)
   {      
      tmaW1 = CalcTma(10080, shiftW1); 
      tmaW1Prev  = CalcTma(10080, shiftW1+1);
   }
   
   //if (Symbol() == "EURUSDm") Print (" tmaH1 ",tmaH1," tmaH1Prev ",tmaH1Prev, " shiftH1 ", shiftH1, " Time[0] ", TimeToStr(Time[0])
   //, "iClose(Symbol(),60,shiftH1);", iClose(Symbol(),60,shiftH1), "iTime(Symbol(),60,shiftH1);", TimeToStr(iTime(Symbol(),60,shiftH1)));
   double tma = getTma(Symbol(),0, 0); 
   double tmaPrev  = getTma(Symbol(),0, 1);
   double tmaPrev2  = getTma(Symbol(),0, 2);
   double tmaPrev3  = getTma(Symbol(),0, 3);
   double tmaPrev4  = getTma(Symbol(),0, 4);
   double tmaPrev5  = getTma(Symbol(),0, 5);
   double tmaPrev6  = getTma(Symbol(),0, 6);
   double priceSlope  = getPriceSlope(Symbol(),0,LinearRegressionPeriod);
   double pivotDist = GetNearestPivotDistance()/Tick;
   
   double tmaAtr = iATR( Symbol(), 0, TmaAtrPeriod, 10);   
   double tmaAtrM15 = iATR( Symbol(), 15, TmaAtrPeriod,shiftM15 + 10);
   double tmaAtrH1 = iATR( Symbol(), 60, TmaAtrPeriod,shiftH1 + 10);
   double tmaAtrH4 = iATR( Symbol(), 240, TmaAtrPeriod, shiftH4 + 10);
   double tmaAtrD1 = iATR( Symbol(), 1440, TmaAtrPeriod,shiftD1 + 10);
   double tmaAtrW1 = iATR( Symbol(), 10080, TmaAtrPeriod, shiftW1 + 10);   
   double diff = Close[0] - tma;
   double extremeTma = (diff/tmaAtr) / TmaBandSize; 
   
   double n = tmaAtr * 0.1;    
   
   double tmaSlope = ((tma- tmaPrev) / n) ; 
   double tmaSlopeM15 = ((tmaM15- tmaM15Prev) / (tmaAtrM15 * 0.1)) ; 
   double tmaSlopeH1 = ((tmaH1- tmaH1Prev) / (tmaAtrH1 * 0.1)) ; 
   double tmaSlopeH4 = ((tmaH4- tmaH4Prev) / (tmaAtrH4 * 0.1)) ;
   double tmaSlopeD1 = ((tmaD1- tmaD1Prev) / (tmaAtrD1 * 0.1)) ; 
   double tmaSlopeW1 = ((tmaW1- tmaW1Prev) / (tmaAtrW1 * 0.1)) ; 
   double tmaSlope1 = ((tmaPrev- tmaPrev2) / n) ; 
   double tmaSlope2 = ((tmaPrev2- tmaPrev3) / n) ;
   double tmaSlope3 = ((tmaPrev3- tmaPrev4) / n) ; 
   double tmaSlope4 = ((tmaPrev4- tmaPrev5) / n) ;
   double tmaSlope5 = ((tmaPrev5- tmaPrev6) / n) ;
   double tmaSlopeChange = ((tmaSlope - tmaSlope1) + (tmaSlope1 - tmaSlope2) + (tmaSlope2 - tmaSlope3) + (tmaSlope3 - tmaSlope4) + (tmaSlope4 - tmaSlope5)) / 2.0;
   
   if (ShowTmaSize) paintGeneral("TmaSizeValue", (tmaAtr/Tick) * 2 * TmaBandSize   , ValueColor);
   if (ShowTmaSizeM15) paintGeneral("TmaSizeM15Value", (tmaAtrM15/Tick) * 2 * TmaBandSizeM15   , ValueColor);
   if (ShowTmaSizeH1) paintGeneral("TmaSizeH1Value", (tmaAtrH1/Tick) * 2 * TmaBandSizeH1   , ValueColor);
   if (ShowTmaSizeH4) paintGeneral("TmaSizeH4Value", (tmaAtrH4/Tick) * 2 * TmaBandSizeH4   , ValueColor);
   if (ShowTmaSizeD1) paintGeneral("TmaSizeD1Value", (tmaAtrD1/Tick) * 2 * TmaBandSizeD1   , ValueColor);   
   if (ShowTmaSizeW1) paintGeneral("TmaSizeW1Value", (tmaAtrW1/Tick) * 2 * TmaBandSizeW1   , ValueColor);
      
   color c = NeutralColor;
   
   if (ShowExtremeTMA)
   {
      if(extremeTma<=-1){c = ExtremeBullColor; } 
      else if(extremeTma>=1){c = ExtremeBearColor; }
      else if(extremeTma>0){c = BearColor; }
      else if(extremeTma<0){c = BullColor; } 
      else {c = NeutralColor; }   
      paintGeneral("ExtremeTMA", extremeTma, c);  
   }

   if (ShowSlope)
   {
      if(tmaSlope<-1 * TmaSlopeThreshold){c = ExtremeBearColor; } 
      else if(tmaSlope>TmaSlopeThreshold){c = ExtremeBullColor; } 
      else {c = NeutralColor; } 
      paintGeneral("TmaSlope", tmaSlope, c,2);     
   }
    
   if (ShowSlopeM15)
   {
      if(tmaSlopeM15 <-1 * TmaSlopeThreshold){c = ExtremeBearColor; } 
      else if(tmaSlopeM15 >TmaSlopeThreshold){c = ExtremeBullColor; } 
      else if(tmaSlopeM15 > 0){c = BullColor; } 
      else if(tmaSlopeM15 < 0 ){c = BearColor; } 
      else {c = NeutralColor; } 
      paintGeneral("TmaSlopeM15", tmaSlopeM15, c,2);
   }
   
   if (ShowSlopeH1)
   {
      if(tmaSlopeH1 <-1 * TmaSlopeThreshold){c = ExtremeBearColor; } 
      else if(tmaSlopeH1 >TmaSlopeThreshold){c = ExtremeBullColor; } 
      else if(tmaSlopeH1 > 0){c = BullColor; } 
      else if(tmaSlopeH1 < 0 ){c = BearColor; } 
      else {c = NeutralColor; } 
      paintGeneral("TmaSlopeH1", tmaSlopeH1, c,2);
   }
   
   if (ShowSlopeH4)
   {
      if(tmaSlopeH4 <-1 * TmaSlopeThreshold){c = ExtremeBearColor; } 
      else if(tmaSlopeH4 >TmaSlopeThreshold){c = ExtremeBullColor; } 
      else if(tmaSlopeH4 > 0){c = BullColor; } 
      else if(tmaSlopeH4 < 0 ){c = BearColor; } 
      else {c = NeutralColor; } 
      paintGeneral("TmaSlopeH4", tmaSlopeH4, c,2);
   }
   
   if (ShowSlopeD1)
   {
      if(tmaSlopeD1 <-1 * TmaSlopeThreshold){c = ExtremeBearColor; } 
      else if(tmaSlopeD1 >TmaSlopeThreshold){c = ExtremeBullColor; } 
      else if(tmaSlopeD1 > 0){c = BullColor; } 
      else if(tmaSlopeD1 < 0 ){c = BearColor; } 
      else {c = NeutralColor; } 
      paintGeneral("TmaSlopeD1", tmaSlopeD1, c,2);
   }
   
   if (ShowSlopeW1)
   {
      if(tmaSlopeW1 <-1 * TmaSlopeThreshold){c = ExtremeBearColor; } 
      else if(tmaSlopeW1 >TmaSlopeThreshold){c = ExtremeBullColor; } 
      else if(tmaSlopeW1 > 0){c = BullColor; } 
      else if(tmaSlopeW1 < 0 ){c = BearColor; } 
      else {c = NeutralColor; } 
      paintGeneral("TmaSlopeW1", tmaSlopeW1, c,2);
   }
   
   if (ShowSlopeChange)
   {
      if(tmaSlopeChange<0 && extremeTma>= 1){c = ExtremeBearColor; } 
      else if(tmaSlopeChange<0){c = BearColor; } 
      else if(tmaSlopeChange>0 && extremeTma<= -1){c = ExtremeBullColor; }
      else if(tmaSlopeChange>0){c = BullColor; } 
      else {c = NeutralColor; } 
      paintGeneral("TmaSlopeChange", tmaSlopeChange* 100, c);
   }
   
   if(ShowLinearPriceChange)
   {
      if(priceSlope<0 && tmaSlopeChange>0){c = ExtremeBullColor; }    
      else if(priceSlope>0 && tmaSlopeChange<0){c = ExtremeBearColor; } 
      else {c = NeutralColor; }    
      paintGeneral("PriceSlope", priceSlope, c);
   }
   
   if(ShowPivotDistance)
   {
      if(pivotDist>0 && pivotDist < PivotThreshold){c = ExtremeBullColor; } 
      else if (pivotDist>0){c = BullColor; } 
      else if(pivotDist<0 && MathAbs(pivotDist) < PivotThreshold){c = ExtremeBearColor; } 
      else if(pivotDist<0){c = BearColor; }
      //else if(extremeTma>0){c = BearColor; }
      //else if(extremeTma<0){c = BullColor; } 
      else {c = NeutralColor; }   
      paintGeneral("PivotDistance", pivotDist, c);  
   }
   if(ShowHeikenAshi)
   {
      double ha = (GetHAClose(0) - GetHAOpen(0))/Tick;
      
      if(ha > 0 && extremeTma<=-1){c = ExtremeBullColor; } 
      else if(ha<0 && extremeTma>=1){c = ExtremeBearColor; }
      else if(ha>0){c = BullColor; }
      else if(ha<0 ){c = BearColor; } 
      else {c = NeutralColor; }   
   
      paintGeneral("HeikenAshi", ha, c);   
   }
   
   if(ShowMACrossover)
   {
      double back = getMaBack(Symbol(),0); 
      double front = getMaFront(Symbol(),0);
      double maCrossover = back-front;
      
      if(maCrossover > 0 && extremeTma<=1){c = ExtremeBullColor; } 
      else if(maCrossover<0 && extremeTma<=-1){c = ExtremeBearColor; }
      else if(maCrossover>0){c = BullColor; }
      else if(maCrossover<0 ){c = BearColor; } 
      else {c = NeutralColor; }   
   
      paintGeneral("MaCrossover", maCrossover/Tick, c);
   }
   
   if (AlertOn)
   {
      if(extremeTma <= -1 && tmaSlope > -1 * TmaSlopeThreshold && tmaSlopeChange > 0 && MathAbs(pivotDist) < PivotThreshold)
      {
         Print("ALERT BUY");
         if(!AlertHappened)
         {
            string message = StringConcatenate(Symbol()," Extreme TMA Buy");
            
            if (AlertMessage) Alert(message);
            if (AlertEmail)   SendMail(message,message);
            if (AlertSound)   PlaySound(AlertSoundFile);
            AlertHappened = true;
        }      
      } 
      else if(extremeTma >= 1 && tmaSlope < TmaSlopeThreshold && tmaSlopeChange < 0 && MathAbs(pivotDist) < PivotThreshold)
      {
         Print("ALERT SELL");
         if(!AlertHappened)
         {
            message = StringConcatenate(Symbol()," Extreme TMA Sell");
            
            if (AlertMessage) Alert(message);
            if (AlertEmail)   SendMail(message,message);
            if (AlertSound)   PlaySound(AlertSoundFile);
            AlertHappened = true;
         } 
      }
      else
      {
         AlertHappened = false;
      }
   }
  
  }
  
  
//Data Retrieval
double getMaBack(string symbol, int timeFrame)
{
   int backIdx = MaShift - MaPeriod;
   //double back = iCustom(symbol,timeFrame,"Ma_Crossover_Lines",MaPeriod,MaShift,0,0);
   double back = iMA( symbol, timeFrame, MaPeriod + backIdx, 0, MODE_LWMA, PRICE_TYPICAL, 0);
   return (back);
}
double getMaFront(string symbol, int timeFrame)
{
   double front = iMA( symbol, timeFrame, MaPeriod, 0, MODE_LWMA, PRICE_TYPICAL, MaShift); 
   return (front);
} 
 
 
double getPriceSlope(string symbol, int timeFrame,int Length)
{

   double SumBars = Length * (Length - 1) * 0.5;
   double SumSqrBars = (Length - 1.0) * Length * (2.0 * Length - 1.0) / 6.0;
   double slope;
   int i=0;
   
   double Sum1 = 0;
   for(i=0;i<=Length-1;i++) Sum1 += i*iMA(NULL,0,1,0,1,PRICE_CLOSE,i);

   double SumY = 0;
   for(i=0;i<=Length-1;i++) SumY += iMA(NULL,0,1,0,1,PRICE_CLOSE,i);

   double Sum2 = SumBars * SumY;
   
   double Num1 = Length * Sum1 - Sum2;
   double Num2 = SumBars * SumBars - Length * SumSqrBars;

   if( Num2 != 0 ) 
	slope = 10000*Num1/Num2;
   else 
	slope = 0; 
    
   if (StringSubstr(Symbol(),3,3) == "JPY") slope = slope / 100;
   return (slope);
}

 double CalcTma(int timeFrame, int inx)
{ 
   double dblSum  = (TmaPeriod+1)*iClose(Symbol(),timeFrame,inx);
   double dblSumw = (TmaPeriod+1);
   int jnx, knx;
         
   for ( jnx = 1, knx = TmaPeriod; jnx <= TmaPeriod; jnx++, knx-- )
   {
      dblSum  += ( knx * iClose(Symbol(),timeFrame,inx+jnx) );
      dblSumw += knx;      
      
      if ( jnx <= inx )
      {         
         if (iTime(Symbol(),timeFrame,inx-jnx) > Time[0])
         {
            //Print (" TimeFrameValue ", TimeFrameValue , " inx ", inx," jnx ", jnx, " iTime(Symbol(),TimeFrameValue,inx-jnx) ", TimeToStr(iTime(Symbol(),TimeFrameValue,inx-jnx)), " Time[0] ", TimeToStr(Time[0])); 
            continue;
         }
         dblSum  += ( knx * iClose(Symbol(),timeFrame,inx-jnx) );
         dblSumw += knx;
      }
   }
   
   return( dblSum / dblSumw );
}
 

double getTma(string symbol, int timeFrame, int index)
{
   double dblSum  = (TmaPeriod+1)*iClose(symbol, timeFrame,index);
   double dblSumw = (TmaPeriod+1);
   int jnx, knx;
         
   for ( jnx = 1, knx = TmaPeriod; jnx <= TmaPeriod; jnx++, knx-- )
   {
      dblSum  += ( knx * iClose(symbol, timeFrame,index+jnx) );
      dblSumw += knx;

      if ( jnx <= index )
      {
         dblSum  += ( knx * iClose(symbol, timeFrame,index-jnx) );
         dblSumw += knx;
      }
   }
   
   return( dblSum / dblSumw );
}
 
// Start Pivot Code
double GetNearestPivotDistance()
{
   int index = 0;
   double minDistance = 999999;
   for(int i=0; i < ArraySize(Pivots);i++)
   {
      if(MathAbs(Close[0]-Pivots[i]) < minDistance)
      {
         minDistance = MathAbs(Close[0]-Pivots[i]);
         index = i;
      }      
   } 
   double distance = Close[0]-Pivots[index];
   
   return (distance);
   
}
void GetPivots(string symbol)
{
 
   double prices[4];
   datetime start = GetDayStart(Time[0]);
   if(LastPivotDay == start) return;
   GetPrevDayPrices(prices,start);
      
   double range = prices[PRICE_HIGH]-prices[PRICE_LOW];
   
   Pivots[0]=NormalizeDouble((prices[PRICE_HIGH]+prices[PRICE_LOW]+ prices[PRICE_CLOSE] )/3.0,Digits); 
    
   Pivots[1] = Pivots[0] - (0.382 *  range);
   Pivots[2] = Pivots[0] - (0.618033 *  range);
   Pivots[3] = Pivots[0] - (1 *  range);
   Pivots[4] = Pivots[0] - (1.618033 *  range);
   Pivots[5] = Pivots[0] - (2.618033 *  range);
   Pivots[6] = Pivots[0] + (0.382 *  range);
   Pivots[7] = Pivots[0] + (0.618033 *  range);
   Pivots[8] = Pivots[0] + (1 *  range);
   Pivots[9] = Pivots[0] + (1.618033 *  range);
   Pivots[10] = Pivots[0] + (2.618033 *  range);
   
   LastPivotDay = start;
  
//----
}

datetime GetDayStart(datetime timestamp) {

   
   // Shift to start of effective day (could be Sat/Sun)   
   timestamp -= PivotHoursShift * 3600;
   timestamp -= MathMod(timestamp, 86400);

   // Move weekend to Monday start
   if (TimeDayOfWeek(timestamp) == 0) {
      timestamp += 24 * 3600;
   }
   else if(TimeDayOfWeek(timestamp) == 6) {
      timestamp += 48 * 3600;
   }
   
   // Shift back to 5PM EST
   timestamp += PivotHoursShift * 3600;
   
	return(timestamp);
} 

void GetPrevDayPrices(double& prices[], datetime timestamp) {


	// Get the last bar of the previous trading day
	int numHoursShift = 1; // one hour back in most cases.
	// however if it's Weekly open, need to go back 49 hours.
	if (TimeDayOfWeek(timestamp - PivotHoursShift * 3600)==1) {
	  numHoursShift = 48;
	}

	// since iBarShift exact param = false, the previous existing bar will be returned
	int 		iBarIndex 		= iBarShift(NULL,PERIOD_H1,timestamp - numHoursShift*3600,false);
	datetime	dtPrevDayStart	= GetDayStart(iTime(NULL,PERIOD_H1,iBarIndex));
		
	// Get close price for the day and set initial values for high and low
	prices[PRICE_HIGH]	= 0;	prices[PRICE_LOW]	   = 9999;	prices[PRICE_OPEN]	= 0;
	prices[PRICE_CLOSE]	= iClose(NULL,PERIOD_H1,iBarIndex-1);
	
		
	// Iterate back and check for high/low prices until all of previous trading day covered
	while (GetDayStart(iTime(NULL,PERIOD_H1,iBarIndex)) == dtPrevDayStart) {
		prices[PRICE_HIGH] = MathMax(prices[PRICE_HIGH], iHigh (NULL,PERIOD_H1,iBarIndex));
		prices[PRICE_LOW]  = MathMin(prices[PRICE_LOW],  iLow  (NULL,PERIOD_H1,iBarIndex));
		prices[PRICE_OPEN] = iOpen(NULL,PERIOD_H1,iBarIndex);
		iBarIndex++;
	}
	return;
}
// End Pivot Code


//End Data Retrieval

//Drawing
void paintPrice(double value)
{ 
   int precision = 4;

   if (StringSubstr(Symbol(),3,3) == "JPY") precision = 2;
   ObjectSetText("ExtremeTmaInfo_PriceValue",DoubleToStr(value,precision),Size,Font,ExtremeBullColor);
}    
 
  
 
void paintGeneral(string name, double value, color c, int precision = 1)
{   
   ObjectSetText("ExtremeTmaInfo_" + name,DoubleToStr(value,precision),Size,Font,c);
}    



//----------------------------------------   
void initGraph() 
{
   int bottom = Bottom;
   int x = 0, y = 0;
   
   if( corner == 1 || corner == 3)
   {
      x = 12;
      y = 65;
   }
   
   if( corner == 0 || corner == 2)
   {
      x = 12;
      y = 65;   
   }
   
   if( corner != 0 && corner != 1 && corner != 2 && corner != 3)
   {
      corner = 3;
      x = 12;
      y = 65;
   }
   
   if(ShowMACrossover)
   {
      objectCreate("ExtremeTmaInfo_MaCrossover",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_MaCrossoverLabel",y,bottom,"Ma Crossover:",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   if(ShowHeikenAshi)
   {
      objectCreate("ExtremeTmaInfo_HeikenAshi",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_HeikenAshiLabel",y,bottom,"Heiken Ashi:",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   if (ShowPivotDistance)
   {
      objectCreate("ExtremeTmaInfo_PivotDistance",x,bottom,"9",Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_PivotDistanceLabel",y,bottom,"Pivot Distance:",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);     
   }
   
   if (ShowLinearPriceChange)
   {
      objectCreate("ExtremeTmaInfo_PriceSlope",x,bottom,"9",Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_PriceSlopeLabel",y,bottom,"Price Change:",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);   
   }
   if(ShowSlopeChange)
   {
      objectCreate("ExtremeTmaInfo_TmaSlopeChange",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor);
      objectCreate("ExtremeTmaInfo_TmaSlopeChangeLabel",y,bottom,"Slope Change:",Size,Font,NeutralColor);  
      bottom = bottom + (Size * 1.6);   
   }
   if (ShowExtremeTMA)
   {
      objectCreate("ExtremeTmaInfo_ExtremeTMA",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_ExtremeTMALabel",y,bottom,"Extreme TMA:",Size,Font,NeutralColor);
      bottom = bottom + (Size * 1.6);
   }
   if (ShowSlopeW1) 
   {
      objectCreate("ExtremeTmaInfo_TmaSlopeW1",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_TmaSlopeW1Label",y,bottom,"TMA Slope (W1):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowSlopeD1) 
   {
      objectCreate("ExtremeTmaInfo_TmaSlopeD1",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_TmaSlopeD1Label",y,bottom,"TMA Slope (D1):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   if (ShowSlopeH4) 
   {
      objectCreate("ExtremeTmaInfo_TmaSlopeH4",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_TmaSlopeH4Label",y,bottom,"TMA Slope (H4):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowSlopeH1) 
   {
      objectCreate("ExtremeTmaInfo_TmaSlopeH1",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_TmaSlopeH1Label",y,bottom,"TMA Slope (H1):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowSlopeM15) 
   {
      objectCreate("ExtremeTmaInfo_TmaSlopeM15",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_TmaSlopeM15Label",y,bottom,"TMA Slope (15):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowSlope) 
   {
      objectCreate("ExtremeTmaInfo_TmaSlope",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor); 
      objectCreate("ExtremeTmaInfo_TmaSlopeLabel",y,bottom,"TMA Slope CTF:",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowTmaSizeW1) 
   {
      objectCreate("ExtremeTmaInfo_TmaSizeW1Value",x,bottom,DoubleToStr(9,1),Size,Font,BullColor);
      objectCreate("ExtremeTmaInfo_TmaSizeW1Label",y,bottom,"TMA Size (W1):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
      
   if (ShowTmaSizeD1) 
   {
      objectCreate("ExtremeTmaInfo_TmaSizeD1Value",x,bottom,DoubleToStr(9,1),Size,Font,BullColor);
      objectCreate("ExtremeTmaInfo_TmaSizeD1Label",y,bottom,"TMA Size (D1):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
    
   if (ShowTmaSizeH4) 
   {
      objectCreate("ExtremeTmaInfo_TmaSizeH4Value",x,bottom,DoubleToStr(9,1),Size,Font,BullColor);
      objectCreate("ExtremeTmaInfo_TmaSizeH4Label",y,bottom,"TMA Size (H4):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowTmaSizeH1) 
   {
      objectCreate("ExtremeTmaInfo_TmaSizeH1Value",x,bottom,DoubleToStr(9,1),Size,Font,BullColor);
      objectCreate("ExtremeTmaInfo_TmaSizeH1Label",y,bottom,"TMA Size (H1):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowTmaSizeM15) 
   {
      objectCreate("ExtremeTmaInfo_TmaSizeM15Value",x,bottom,DoubleToStr(9,1),Size,Font,BullColor);
      objectCreate("ExtremeTmaInfo_TmaSizeM15Label",y,bottom,"TMA Size (15):",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
   
   if (ShowTmaSize) 
   {
      objectCreate("ExtremeTmaInfo_TmaSizeValue",x,bottom,DoubleToStr(9,1),Size,Font,BullColor);
      objectCreate("ExtremeTmaInfo_TmaSizeLabel",y,bottom,"TMA Size CTF:",Size,Font,NeutralColor); 
      bottom = bottom + (Size * 1.6);
   }
      
      
   if (ShowSpread)
   { 
      objectCreate("ExtremeTmaInfo_SpreadValue",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor);
      objectCreate("ExtremeTmaInfo_SpreadValueLabel",y,bottom,"Spread:",Size,Font,NeutralColor);
      bottom = bottom + (Size * 1.6);
   }
   if (ShowDailyAtr)
   { 
      objectCreate("ExtremeTmaInfo_AtrValue",x,bottom,DoubleToStr(9,1),Size,Font,NeutralColor);   
      objectCreate("ExtremeTmaInfo_AtrValueLabel",y,bottom,"Atr(14-day):",Size,Font,NeutralColor);
      bottom = bottom + (Size * 1.6); 
   }
   if (ShowPrice)
   { 
      objectCreate("ExtremeTmaInfo_PriceValue",x,bottom,DoubleToStr(9,1),Size,Font,ExtremeBullColor); 
      objectCreate("ExtremeTmaInfo_PriceValueLabel",y,bottom,"Price:",Size,Font,ExtremeBullColor); 
      bottom = bottom + (Size * 1.6);
   }

   WindowRedraw();
  }
//----------------------------------------   
void deinitGraph() 
  { 
   DeleteObjectsByPrefix("ExtremeTmaInfo_");  
   DeleteObjectsByPrefix("ParadoxInfo_");    
   WindowRedraw();
  }
  
//+------------------------------------------------------------------+
void objectCreate(string name,int x,int y,string text="-",int size=42,
                  string font="Arial",color colour=CLR_NONE)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,corner);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  } 
  
  
  
  
void DeleteObjectsByPrefix(string Prefix)
  {
   int L = StringLen(Prefix);
   int i = 0; 
   while(i < ObjectsTotal())
     {
       string ObjName = ObjectName(i);
       if(StringSubstr(ObjName, 0, L) != Prefix) 
         { 
           i++; 
           continue;
         }
       ObjectDelete(ObjName);
     }
  }
  //End Drawing
  
  

 
 
 
double GetHAClose(int index)
{
   return((Open[index]+High[index]+Low[index]+Close[index])/4);
}

double GetHAOpen(int index)
{
   //The higher you make this lookback the lower the error with the true Heiken Ashi Open)
   int lookback = 8;
   double open = GetHAClose(index+lookback);
   lookback--;
   for(int j = index + lookback;j > index;j--)
   {
      open = (open + GetHAClose(j)) / 2;
   }
   return (open);
}