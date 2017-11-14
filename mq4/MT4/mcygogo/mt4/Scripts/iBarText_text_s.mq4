//+------------------------------------------------------------------+
//|                                              iBarText_text_s.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   iBarText("5", 0, Low[5], "wingdings 3", 18, Red);
   return(0);
  }
  
void iBarText(string myString, int myBarPos, double myPrice, string myDocStyle, int myDocSize, color myColor)
{
	string TextBarString = myString + Time[myBarPos];
	ObjectCreate(TextBarString, OBJ_TEXT, 0, Time[myBarPos], myPrice);
	ObjectSetText(TextBarString, myString, myDocSize, myDocStyle, myColor);
}

//+------------------------------------------------------------------+