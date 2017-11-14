//+------------------------------------------------------------------+
//|                                                 均线交叉报警.mq4 |
//|                                                          Michael |
//|                                                       1055655869 |
//+------------------------------------------------------------------+
#property copyright "Michael"
#property link      "1055655869"

#property indicator_chart_window
//--- input parameters
extern int       FastMA=21;
extern int       SlowMA=60;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int gAlertBars = 0;
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   
//----
   double iMA1  = iMA(Symbol(), 0, FastMA, 0, MODE_EMA, PRICE_CLOSE, 1);
	double iMA1p = iMA(Symbol(), 0, FastMA, 0, MODE_EMA, PRICE_CLOSE, 2);
	double iMA2  = iMA(Symbol(), 0, SlowMA, 0, MODE_EMA, PRICE_CLOSE, 1);
	double iMA2p = iMA(Symbol(), 0, SlowMA, 0, MODE_EMA, PRICE_CLOSE, 2);
	
	if ((iMA1 > iMA2) && (iMA1p < iMA2p))
	{
	  if (gAlertBars != Bars)
	  {
	     Alert("金叉");
	     gAlertBars = Bars;
	  }
	}
   if ((iMA1 < iMA2) && (iMA1p > iMA2p))
   {
      if (gAlertBars != Bars)
      {
       Alert("死叉");
       gAlertBars = Bars;
      }  
   } 
   
   return(0);
  }
//+------------------------------------------------------------------+