//+------------------------------------------------------------------+
//|                                             test_do_order_ea.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   
//----
   do_order();
   return(0);
  }
//+------------------------------------------------------------------+

int BuyTimes = 0;
int SellTimes = 0;
bool lFlagBuyOpen = false;
bool lFlagSellOpen = false;
void do_order()
{
   double diMA_15_50  = iMA(Symbol(), 15, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_15_100 = iMA(Symbol(), 15, 100, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_15_200 = iMA(Symbol(), 15, 200, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_15_300 = iMA(Symbol(), 15, 300, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_15_400 = iMA(Symbol(), 15, 400, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_15_500 = iMA(Symbol(), 15, 500, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diWPR_60_5  = iWPR(Symbol(), 60, 5, 0);
	double diMFI_30_1  = iMFI(Symbol(), 30, 1, 0);
	double diClose_1   = iClose(Symbol(), 1, 0);
	double diMA_1_700  = iMA(Symbol(), 1, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_5_700  = iMA(Symbol(), 5, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_15_700 = iMA(Symbol(), 15, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA_30_700 = iMA(Symbol(), 30, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diAC_1 = iAC(Symbol(), 1, 0);
	
	/*Print("diMA_15_50->"+diMA_15_50+"   diMA_15_100->"+diMA_15_100+"  diMA_15_200->"+diMA_15_200+"  diMA_15_300->"+diMA_15_300+"  diMA_15_400->"+diMA_15_400+"  diMA_15_500->"+diMA_15_500);
	Print("diMA_1_700->"+diMA_1_700+"    diMA_5_700->"+diMA_5_700+"   diMA_15_700->"+diMA_15_700+"  diMA_30_700->"+diMA_30_700);
	Print("diWPR_60_5->"+diWPR_60_5+"     diMFI_30_1->"+diMFI_30_1+"    diClose_1:->"+diClose_1);
	Print("diAC_1->"+diAC_1);
   */
   double 	HistoryOrderProfit = 0;
	if (HistoryOrderProfit >= 0)
	{
		//lFlagBuyOpen = (diAC_1<0) && (diMFI_30_1<0.1) && (diWPR_60_5<-99.99) &&
	   //				   (diMA_1_700 < diClose_1) && (diMA_5_700 < diClose_1) && (diMA_15_700 < diClose_1) && (diMA_30_700 < diClose_1) &&
		//				   (diMA_15_100 > diMA_15_200) && (diMA_15_200 < diMA_15_300) && (diMA_15_300 > diMA_15_400) && (diMA_15_400 > diMA_15_500);
		lFlagBuyOpen = (diAC_1<0) && (diMFI_30_1<0.1) && (diWPR_60_5<-99.99) &&
		               (diMA_1_700 < diClose_1) && (diMA_5_700 < diClose_1) && (diMA_15_700 < diClose_1) && (diMA_30_700 < diClose_1) &&
		               (diMA_15_100 > diMA_15_200) && (diMA_15_200 > diMA_15_300) && (diMA_15_300 > diMA_15_400) && (diMA_15_400 > diMA_15_500);					
		
		lFlagSellOpen = (diAC_1 > 0) && (diMFI_30_1>99.9) && (diWPR_60_5>-0.01) && 
							(diMA_1_700 > diClose_1) && (diMA_5_700 > diClose_1) && (diMA_15_700 > diClose_1) && (diMA_30_700 > diClose_1) &&
							(diMA_15_100 < diMA_15_200) && (diMA_15_200 < diMA_15_300) && (diMA_15_300 < diMA_15_400) && (diMA_15_400<diMA_15_500);
		//lFlagSellOpen = (diMA_1_700 > diClose_1) && (diMA_5_700 > diClose_1) && (diMA_15_700 > diClose_1) && (diMA_30_700 > diClose_1) && 
		//     lFlagSellOpen =           (diMA_15_100 < diMA_15_200) && (diMA_15_200 < diMA_15_300) && (diMA_15_300 < diMA_15_400) && (diMA_15_400<diMA_15_500);	                
	}
	//if (HistoryOrderProfit < 0)
	//{
	//	lFlagBuyOpen  = (diAC_1 < 0) && (diWPR_60_5 < -50) && (diMA_15_100 < diMA_15_200);
	//	lFlagSellOpen = (diAC_1 > 0) && (diWPR_60_5 > -50) && (diMA_15_100 > diMA_15_200);
	//}
	if (lFlagBuyOpen)
	{
	  BuyTimes++;
	  Print("BuyTimes: "+BuyTimes);
	  lFlagBuyOpen = false;
	}
	
	if (lFlagSellOpen)
	{
	  SellTimes++;
	  Print("SellTimes: "+SellTimes);
	  lFlagSellOpen = false;
	}
	
	
}