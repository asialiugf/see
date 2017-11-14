//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
#import "kernel32.dll"
void GetLocalTime(int& TimeArray[]);
void GetSystemTime(int& TimeArray[]);
int  GetTimeZoneInformation(int& TZInfoArray[]);
#import
string MQL4_getLocalTime(int& nYear,int& nMonth,int& nDay,int& nHour,int& nMin,int& nSec,int& nMilliSec)
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
	MQL4_getLocalTime(nYear, nMonth, nDay, nHour, nMin, nSec, nMilliSec);
	return (nHour);
}

int start()
  {
//----
   
//----
   /*
   Print("MinLot: "+ MarketInfo(Symbol(), MODE_MINLOT));
   Print("MaxLot: "+ MarketInfo(Symbol(), MODE_MAXLOT));
   Print("LotStep: "+ MarketInfo(Symbol(), MODE_LOTSTEP));
   Print("LotSize: "+ MarketInfo(Symbol(), MODE_LOTSIZE));
   Print("TicketSize: "+ MarketInfo(Symbol(), MODE_TICKSIZE));
   Print("TicketValue: "+ MarketInfo(Symbol(), MODE_TICKVALUE));
   Print("Spread: "+ MarketInfo(Symbol(), MODE_SPREAD));
   Print("Digit: "+ MarketInfo(Symbol(), MODE_DIGITS));
   Print("AccountServer: "+ AccountServer());
   Print("AccountFreeMargin: "+ AccountFreeMargin());
   Print("Seconds: "+ Seconds()+ "Minute: "+ Minute()+ "Hour : "+ Hour() 
          +"Day Of Week: "+ DayOfWeek()+ "DayOfYear: "+ DayOfYear() + "Day : "+ Day() + "Year: " + Year() );
          
   Print("NormalizeDouble: "+ NormalizeDouble((10-0.01)/0.01, 0)  );
   
   Print("AccountNumber: "+ AccountNumber());
   */
   Print("Hour: "+Hour());
   int nYear, nMonth, nDay, nHour, nMin, nSec, nMilliSec;
   string localTime  = MQL4_getLocalTime(nYear, nMonth, nDay, nHour, nMin, nSec, nMilliSec);
   Print("loaclTime: "+localTime + "nHour: "+ nHour+ "LocalHour: "+getLocalHour());
   return(0);
  }
//+------------------------------------------------------------------+