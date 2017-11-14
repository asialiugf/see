//+------------------------------------------------------------------+
//|                                                   MEA_Common.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright MEA."
#property link      "qq1055655869"
#property strict

enum ORDER_TYPE
{
	BUY_ORDER = 1,
	BUYLIMIT_ORDER,
	BUYSTOP_ORDER,
	SELL_ORDER,
	SELLLIMIT_ORDER,
	SELLSTOP_ORDER,
	TOTAL_ORDER,
};


int OrdersNumber(ORDER_TYPE type, int _MagicNo)
{
	int numBuy  = 0;
	int numBuyLimit = 0;
	int numBuyStop = 0;
	int numSell = 0;
	int numSellLimit = 0;
	int numSellStop = 0;
	int numTotal = 0;
	for (int i = 0; i < OrdersTotal(); i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
		{
			if (OrderSymbol() == Symbol() && OrderMagicNumber() == _MagicNo) // Checking magic number to make sure this order opened by EA
			{
				switch(OrderType())
				{
					case OP_BUY:
						numBuy++;
						break;
					case OP_BUYLIMIT:
						numBuyLimit++;
						break;
					case OP_BUYSTOP:
						numBuyStop++;
						break;
					case OP_SELL:
						numSell++;
						break;
					case OP_SELLLIMIT:
						numSellLimit++;
						break;
					case OP_SELLSTOP:
						numSellStop++;
						break;
					default:
						Print("OrdersNumber input error: "+ DoubleToStr(OrderType()));
				}
				
				numTotal++;
			}
		}
	}

	switch(type)
	{
		case BUY_ORDER:
			return (numBuy);
			break;
		case BUYLIMIT_ORDER:
			return (numBuyLimit);
			break;
		case BUYSTOP_ORDER:
			return (numBuyStop);
			break;
		case SELL_ORDER:
			return (numSell);
			break;
		case SELLLIMIT_ORDER:
			return (numSellLimit);
			break;
		case SELLSTOP_ORDER:
			return (numSellStop);
			break;
		case TOTAL_ORDER:
			return (numTotal);
			break;
		default:
			Print("OrdersNumber input error :" + DoubleToStr(type));
			return (0);
			break;
	}
}

void DrawSign(string myType,int myBarPos,double myPrice,color myColor,int mySymbol,string myString,int myDocSize)
{
    if (myType=="Text")
    {
        string TextBarString=myType+DoubleToStr(Time[myBarPos]);
        ObjectCreate(TextBarString,OBJ_TEXT,0,Time[myBarPos],myPrice);
        ObjectSet(TextBarString,OBJPROP_COLOR,myColor);
        ObjectSet(TextBarString,OBJPROP_FONTSIZE,myDocSize);
        ObjectSetText(TextBarString,myString);
        ObjectSet(TextBarString,OBJPROP_BACK,false);
    }
    if (myType=="Dot")
    {
        string DotBarString=myType+DoubleToStr(Time[myBarPos]);
        ObjectCreate(DotBarString,OBJ_ARROW,0,Time[myBarPos],myPrice);
        ObjectSet(DotBarString,OBJPROP_COLOR,myColor);
        ObjectSet(DotBarString,OBJPROP_ARROWCODE,mySymbol);
        ObjectSet(DotBarString,OBJPROP_BACK,false);
    }
    if (myType=="HLine")
    {
        string HLineBarString=myType+DoubleToStr(Time[myBarPos]);
        ObjectCreate(HLineBarString,OBJ_HLINE,0,Time[myBarPos],myPrice);
        ObjectSet(HLineBarString,OBJPROP_COLOR,myColor);
        ObjectSet(HLineBarString,OBJPROP_BACK,false);
    }
    if (myType=="VLine")
    {
        string VLineBarString=myType+DoubleToStr(Time[myBarPos]);
        ObjectCreate(VLineBarString,OBJ_VLINE,0,Time[myBarPos],myPrice);
        ObjectSet(VLineBarString,OBJPROP_COLOR,myColor);
        ObjectSet(VLineBarString,OBJPROP_BACK,false);
    }
}


int DisplayInfo(bool myInfoDsp, string LableName,string LableDoc,int Corner,int LableX,int LableY,int DocSize,string DocStyle,color DocColor)
{
    int cnt;
    if (Corner == -1 || myInfoDsp==false) 
    {
    	return(0);
    }
    for (cnt=0;cnt<ObjectsTotal();cnt++)
    {
        if (ObjectName(cnt)==LableName)  
        {
        	break;
        }
    }
    if (cnt==ObjectsTotal())  
    {
    	ObjectCreate(LableName, OBJ_LABEL, 0, 0, 0);
	}
    ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor);
    ObjectSet(LableName, OBJPROP_CORNER, Corner);
    ObjectSet(LableName, OBJPROP_XDISTANCE, LableX);
    ObjectSet(LableName, OBJPROP_YDISTANCE, LableY);
    return(0);
} 
