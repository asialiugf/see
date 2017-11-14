//+------------------------------------------------------------------+
//|                                                test_do_order.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   
//----

   do_order();
   return(0);
  }
//+------------------------------------------------------------------+


void do_order()
{
   double diMA0 = iMA(Symbol(), 15, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA1 = iMA(Symbol(), 15, 100, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA2 = iMA(Symbol(), 15, 200, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA3 = iMA(Symbol(), 15, 300, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA4 = iMA(Symbol(), 15, 400, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA5 = iMA(Symbol(), 15, 500, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diWPR10 = iWPR(Symbol(), 60, 5, 0);
	double diMFI11 = iMFI(Symbol(), 30, 1, 0);
	double diClose12 = iClose(Symbol(), 1, 0);
	double diMA13 = iMA(Symbol(), 1, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA14 = iMA(Symbol(), 5, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA15 = iMA(Symbol(), 15, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diMA16 = iMA(Symbol(), 30, 700, 0, MODE_EMA, PRICE_CLOSE, 0);
	double diAC17 = iAC(Symbol(), 1, 0);
	
	Print("diMA0->"+diMA0+"   diMA1->"+diMA1+"  diMA2->"+diMA2+"  diMA3->"+diMA3+"  diMA4->"+diMA4+"  diMA5->"+diMA5);
	Print("diMA13->"+diMA13+"    diMA14->"+diMA14+"   diMA15->"+diMA15+"  diMA16->"+diMA16);
	Print("diWPR10->"+diWPR10+"     diMFI11->"+diMFI11+"    diClose12:->"+diClose12);
	Print("diAC17->"+diAC17);
	
	
}