#property copyright "mea"
#property link "mcygogo@126.com"


int gLastBar = 0;
int start()
{
	int i;
	for (i = 0; i < Bars - 1; i++)
	{
		//iBarText("5", i, Low[i], "wingdings 3", 18, Green);
      iDrawSign("VLine", i, Low[0], Red);
	}
	if (Bars != gLastBar)
	{
    	iBarText("5", 0, Low[5], "wingdings 3", 18, White);
    	gLastBar = Bars;
    }
	return (0);
}

int init()
{
   iDrawSign("VLine", 0, Low[0], Red);
	iBarText("5", 5, Low[5], "wingdings 3", 18, Red);
	return (0);
}

int deinit()
{
	return (0);
}

void iBarText(string myString, int myBarPos, double myPrice, string myDocStyle, int myDocSize, color myColor)
{
	string TextBarString = myString + Time[myBarPos];
	ObjectCreate(TextBarString, OBJ_TEXT, 0, Time[myBarPos], myPrice);
	ObjectSetText(TextBarString, myString, myDocSize, myDocStyle, myColor);
}

void iDrawSign(string myType, int myBarPos, double myPrice, color myColor)
{
   if (myType == "HLine")
   {
      string myHLineBarString = myType+Time[myBarPos];
      ObjectCreate(myHLineBarString, OBJ_HLINE, 0, Time[myBarPos], myPrice);
      ObjectSet(myHLineBarString, OBJPROP_COLOR, myColor);
      //ObjectSet(myHLineBarString, OBJPROP_BACK, false);
   }
   if (myType == "VLine")
   {
      string myVLineBarString = myType+Time[myBarPos];
      ObjectCreate(myVLineBarString, OBJ_VLINE, 0, Time[myBarPos], myPrice);
      ObjectSet(myVLineBarString, OBJPROP_COLOR, myColor);
      //ObjectSet(myVLineBarString, OBJPROP_BACK, false);
   }
}