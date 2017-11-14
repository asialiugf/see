#include <WinUser32.mqh>

string str1="=======xtyscsz=======";
double Lots = 0.01;
input int PendingNum = 3;
input double GridDensity = 1;
input int GridSpace = 0;

string MyOrderComment = "Mea_Gold";
int MyMagicNum = 668866;

int BuyGroupOrders, SellGroupOrders;
int BuyGroupFirstTicket, SellGroupFirstTicket;
int BuyGroupLastTicket, SellGroupLastTicket;
int BuyGroupMaxProfitTicket, SellGroupMaxProfitTicket;
int BuyGroupMinProfitTicket, SellGroupMinProfitTicket;
int BuyGroupMaxLossTicket, SellGroupMaxLossTicket;
int BuyGroupMinLossTicket, SellGroupMinLossTicket;
double BuyGroupLots, SellGroupLots;
double BuyGroupProfit, SellGroupProfit;
int BuyLimitOrders, SellLimitOrders;
int BuyStopOrders, SellStopOrders;

double OrdersArray[][12];
double TempOrdersArray[][12];
int MyArrayRange;
int Corner = 1;
int cnt, i, j;
string TextBarString;
string DotBarString;
string HLineBarString;
string VLineBarString;

int FontSize = 10;
double MinLots;
double BasePrice;
double LastTakeProfit;
int OrdersNow;
bool BuWangBool = true;
int LastHistoryTicket = -1;
bool FirstNet = true;
double myTempBuyStopPrice;



class order;

void OnTick()
{
	iMain();
	//return (0);
}

void iMain()
{
	iShowInfo();
	iLimitTakeProfit();
	iComplianceRepair();
	if (BuyGroupOrders == 0 && iTradingSignals()==0)
	{
		iWait(100);
		iDisplayInfo("TradeInfo", "SJMRKC", 1, 5, 50, FontSize, "", Olive);
		bool SendOK = OrderSend(Symbol(), OP_BUY, Lots, Ask, 0, 0, 0, MyOrderComment+DoubleToStr(Ask, Digits), MyMagicNum);
		if (SendOK == false)
		{
			Print("OrderSend error:"+GetLastError());
		}
	}

	return 0;
}

void iComplianceRepair()
{
	int myNetNum;
	double myTempNetTop, myTempNetBot;
	if ((BuyGroupOrders + SellGroupOrders) == 0)
	{
		return 0;
	}

	if (OrderSelect(BuyGroupLastTicket, SELECT_BY_TICKET, MODE_TRADES))
	{
		BasePrice = NormalizeDouble(StrToDouble(StringSubstr(OrderComment(), 6, StringLen(OrderComment())-1)), Digits);
	}
	if (BasePrice == 0)
	{
		return 0;
	}

	myNetNum = PendingNum*3;
	double myGridArray[];
	ArrayResize(myGridArray, myNetNum);
	ArrayInitialize(myGridArray, 0.0);
	myGridArray[0] = BasePrice+GridSpace*Point*PendingNum;
	string myteststr = myGridArray[0]+"\n";

	for (cnt = 1; cnt < myNetNum; cnt++)
	{
		myGridArray[cnt] = myGridArray[cnt-1] - GridSpace*Point;
		myteststr = myteststr + myGridArray[cnt]+"\n";
	}

	string mystring, mytempstring;
	if (BuyLimitOrders<(PendingNum*2)&&OrderSelect(iOrdersSort(2,3,1),SELECT_BY_TICKET,MODE_TRADES)
		&&(BasePrice-OrderOpenPrice())/(GridSpace*Point)>(PendingNum*2))
	{
		double myTempLimitPrice1 = OrderOpenPrice()-GridSpace*Point;
		iWait(100);
		iDisplayInfo("TradeInfo", "add BuyLimit Orders", 1, 5, 50, FontSize, "", Olive);
		OrderSend(Symbol(), OP_BUYLIMIT, Lots, myTempLimitPrice1, 0, 0, 0, MyOrderComment+DoubleToStr(myTempLimitPrice1,Digits),
				MyMagicNum);
	}
	if (BuyLimitOrders>(PendingNum*2) && OrderSelect(iOrdersSort(2,3,1),SELECT_BY_TICKET,MODE_TRADES)
		&& (BasePrice - OrderOpenPrice())/(GridSpace*Point)>(PendingNum*2))
	{
		iWait(100);
		iDisplayInfo("TradeInfo", "delete BuyLimit order", 1, 5, 50, FontSize, "", Olive);
		OrderDelete(iOrdersSort(2, 3, 1));
	}

	for (cnt =0; cnt <= 5; cnt++)
	{
		if (myGridArray[cnt]==0)
		{
			break;
		}
		mytempstring="";
		for (i=0;cnt<500;i++)
		{
			if (OrdersArray[i][0]==0)
			{
				break;
			}
			if (OrderSelect(OrdersArray[i][0],SELECT_BY_TICKET,MODE_TRADES)
				&& StringFind(OrderComment(), "Gold"+DoubleToStr(myGridArray[cnt],Digits), 0) > 0)
			{
				mytempstring = mytempstring+DoubleToStr(OrdersArray[i][0], 0)+"*"+i;
			}
		}
		if (StringLen(mytempstring)==0&&myGridArray[cnt]<(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) &&
			myGridArray[cnt-1]!=0)
		{
			iWait(100);
			iDisplayInfo("TradeInfo","BuyLimit Order", 1, 5, 50, FontSize, "", Olive);
			OrderSend(Symbol(), OP_BUYLIMIT, Lots, myGridArray[cnt], 0, 0, 0, MyOrderComment+DoubleToStr(myGridArray[cnt],Digits),MyMagicNum);
			mytempstring = "BuWang";
		}
		mystring = mystring+DoubleToStr(myGridArray[cnt],Digits)+":"+mytempstring+"\n";
	}

	if (BuyStopOrders<PendingNum)
	{
		if (OrderSelect(iOrdersSort(4,3,0),SELECT_BY_TICKET,MODE_TRADES))
		{
			myTempBuyStopPrice = NormalizeDouble(StrToDouble(StringSubstr(OrderComment(),6,StringLen(OrderComment())-1)),Digits)+GridSpace*Point;
		}
		else
		{
			if (OrderSelect(iOrdersSort(0,3,0),SELECT_BY_TICKET,MODE_TRADES))
			{
				myTempBuyStopPrice = BasePrice + GridSpace*Point;
			}
		}
		iWait(100);
		iDisplayInfo("TradeInfo","BuyStop Order",1,5,50,FontSize,"",Olive);
		OrderSend(Symbol(), OP_BUYSTOP, Lots, myTempBuyStopPrice,0,0,0,MyOrderComment+DoubleToStr(myTempBuyStopPrice,Digits),MyMagicNum);
	}
	return 0;
}

int iTradingSignals()
{
	int myReturn = 9;
	double myEMA = iMA(Symbol(), 60, 120, 0, 2, 6, 1);
	if (Ask>myEMA)
	{
		myReturn = 0;
	}
	if (Bid < myEMA)
	{
		myReturn = 1;
	}

	return myReturn;
}

void iLimitTakeProfit()
{
	for (cnt = 0; cnt <= OrdersTotal(); cnt++)
	{
		if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)&&OrderMagicNumber()==MyMagicNum && OrderSymbol()==Symbol() && OrderType() == OP_BUY)
		{
			if (Bid > (OrderOpenPrice()+GridSpace*Point))
			{
				iWait(100);
				iDisplayInfo("TradeInfo",OrderTicket()+"TakeProfit Close",1,5,50,FontSize,"",Olive);
				OrderClose(OrderTicket(),OrderLots(),Bid,3, Red);
				break;
			}
			double myTPPrice;
			if(StringSubstr(OrderComment(),0,6)=="lyGold")
			{
				myTPPrice = NormalizeDouble(StrToDouble(StringSubstr(OrderComment(),6,StringLen(OrderComment())-1)),Digits)+GridSpace*Point;
			}
			if (OrderTakeProfit() != myTPPrice && Bid < myTPPrice)
			{
				iWait(100);
				iDisplayInfo("TradeInfo", OrderTicket()+" Set TakeProfit", 1, 5, 50, FontSize, "", Olive);
				OrderModify(OrderTicket(), OrderOpenPrice(),0,myTPPrice,0);
			}
		}
	}
	return 0;
}

void iShowInfo()
{
	BuyGroupOrders = 0;
	SellGroupOrders = 0;
	BuyGroupFirstTicket = 0;
	SellGroupFirstTicket = 0;
	BuyGroupLastTicket = 0;
	SellGroupLastTicket = 0;
	BuyGroupMaxProfitTicket = 0;
	SellGroupMaxProfitTicket = 0;
	BuyGroupMinProfitTicket = 0;
	SellGroupMinProfitTicket = 0;
	BuyGroupMaxLossTicket = 0;
	SellGroupMaxLossTicket = 0;
	BuyGroupMinLossTicket = 0;
	SellGroupMinLossTicket = 0;
	BuyGroupLots = 0;
	SellGroupLots = 0;
	BuyGroupProfit = 0;
	SellGroupProfit = 0;
	BuyLimitOrders = 0;
	SellLimitOrders = 0;
	BuyStopOrders = 0;
	SellStopOrders = 0;

	MyArrayRange = OrdersTotal() + 1;
	ArrayResize(OrdersArray, MyArrayRange);
	ArrayInitialize(OrdersArray, 0.0);
	if (OrdersTotal() > 0)
	{
		for (cnt = 0; cnt <= MyArrayRange;cnt++)
		{
			iWait(100);
			if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)&&OrderSymbol()==Symbol()&&OrderMagicNumber()==MyMagicNum)
			{
				OrdersArray[cnt][0]=OrderTicket();
				OrdersArray[cnt][1]=OrderOpenTime();
				OrdersArray[cnt][2]=OrderProfit();
				OrdersArray[cnt][3]=OrderType();
				OrdersArray[cnt][4]=OrderLots();
				OrdersArray[cnt][5]=OrderOpenPrice();
				OrdersArray[cnt][6]=OrderStopLoss();
				OrdersArray[cnt][7]=OrderTakeProfit();
				OrdersArray[cnt][8]=OrderMagicNumber();
				OrdersArray[cnt][9]=OrderCommission();
				OrdersArray[cnt][10]=OrderSwap();
				OrdersArray[cnt][11]=OrderExpiration();

			}
		}
		for (cnt=0; cnt<MyArrayRange; cnt++)
		{
			if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUY)
			{
				BuyGroupOrders = BuyGroupOrders + 1;
				BuyGroupLots = BuyGroupLots + OrdersArray[cnt][4];
				BuyGroupProfit = BuyGroupProfit + OrdersArray[cnt][2];
			}
			if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELL)
			{
				SellGroupOrders = SellGroupOrders + 1;
				SellGroupLots = SellGroupLots + OrdersArray[cnt][4];
				SellGroupProfit = SellGroupProfit + OrdersArray[cnt][2];
			}
			if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT)
			{
				BuyLimitOrders = BuyLimitOrders+1;
			}
			if (OrdersArray[cnt][0]!= 0 && OrdersArray[cnt][3]==OP_SELLLIMIT)
			{
				SellLimitOrders = SellLimitOrders+1;
			}
			if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3] == OP_BUYSTOP)
			{
				BuyStopOrders = BuyStopOrders+1;
			}
			if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3] == OP_SELLSTOP)
			{
				SellStopOrders = SellStopOrders+1;
			}
		}

		BuyGroupFirstTicket = iOrdersSort(0,0,1);
		SellGroupFirstTicket = iOrdersSort(1,0,1);
		BuyGroupLastTicket = iOrdersSort(0,0,0);
		SellGroupLastTicket = iOrdersSort(1,0,0);

		BuyGroupMinProfitTicket = iOrdersSort(0,1,1);
		SellGroupMinProfitTicket = iOrdersSort(1,1,1);
		BuyGroupMaxProfitTicket = iOrdersSort(0,1,0);
		SellGroupMaxProfitTicket = iOrdersSort(1,1,0);
		BuyGroupMaxLossTicket = iOrdersSort(0,2,0);
		SellGroupMaxLossTicket = iOrdersSort(1,2,0);
		BuyGroupMinLossTicket = iOrdersSort(0,2,1);
		SellGroupMinLossTicket = iOrdersSort(1,2,1);
	}
	iDisplayInfo(Symbol()+"-BuyGroup", "MaiRuZu", Corner, 70,70,12,"Arial", Red);
	iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask,Digits), Corner, 70, 90, 12, "Arial", Red);
	iDisplayInfo(Symbol()+"-SellGroup", "MaiChuZu", Corner, 5, 70, 12, "Arial", Green);
	iDisplayInfo(Symbol()+"-Bid",DoubleToStr(Bid,Digits),Corner,5,90,12,"Arial",Green);

	iDisplayInfo(Symbol()+"-BuyGroup", "MaiRuZu", Corner, 70, 70, 12, "Arial", Red);
	iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask,Digits), Corner, 70, 90, 12, "Arial", Red);
	iDisplayInfo(Symbol()+"BuyOrders", BuyGroupOrders, Corner, 80, 110, 10, "Arial", iObjectColor(BuyGroupProfit));
	iDisplayInfo(Symbol()+"BuyGroupLots", DoubleToStr(BuyGroupLots,2), Corner, 80,125,10,"Arial", iObjectColor(BuyGroupProfit));
	iDisplayInfo(Symbol()+"BuyGroupProfit", DoubleToStr(BuyGroupLots,2), Corner, 80,140,10,"Arial", iObjectColor(BuyGroupProfit));

	iDisplayInfo(Symbol()+"-SellGroup", "MaiChuZu", Corner, 5, 70, 12, "Arial", Green);
	iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
	iDisplayInfo(Symbol()+"SellOrders", SellGroupOrders, Corner, 10, 110, 10, "Arial", iObjectColor(SellGroupProfit));
	iDisplayInfo(Symbol()+"SellGroupLots",DoubleToStr(SellGroupLots,2),Corner,10,125,10,"Arial",iObjectColor(SellGroupProfit));
	iDisplayInfo(Symbol()+"SellGroupProfit",DoubleToStr(SellGroupProfit,2),Corner,10,140,10,"Arial",iObjectColor(SellGroupProfit));
	OrdersNow = BuyGroupOrders+SellGroupOrders+BuyLimitOrders+SellLimitOrders+BuyStopOrders+SellStopOrders;
	iDisplayInfo(Symbol()+"-OrdersTotal","ChiChangDanZongShu:"+OrdersNow, Corner, 10, 160, 12, "Arial", Red);
	
	return 0;
}


//int iOrdersSort(int myOrderType,int myOrderSort,int myMaxMin,int myMagicNum)
int iOrdersSort(int myOrderType,int myOrderSort,int myMaxMin)
{
    int myReturn,myArrayRange;
    myArrayRange=OrdersTotal();
    double myOrdersArray[][12]; //
    ArrayResize(myOrdersArray,myArrayRange); //
    ArrayInitialize(myOrdersArray, -0.00000001); //
    
    for (cnt=0; cnt<myArrayRange; cnt++)
    {
        //
        if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol()==Symbol())
            //&& OrderMagicNumber()==myMagicNum)
        {
            myOrdersArray[cnt][0]=OrderTicket();//
            myOrdersArray[cnt][1]=OrderOpenTime();//
            myOrdersArray[cnt][2]=OrderProfit();//
            myOrdersArray[cnt][3]=OrderType();//
            myOrdersArray[cnt][4]=OrderLots();//
            myOrdersArray[cnt][5]=OrderOpenPrice();//
            myOrdersArray[cnt][6]=OrderStopLoss();//
            myOrdersArray[cnt][7]=OrderTakeProfit();//
            myOrdersArray[cnt][8]=OrderMagicNumber();//
            myOrdersArray[cnt][9]=OrderCommission();//
            myOrdersArray[cnt][10]=OrderSwap();//
            myOrdersArray[cnt][11]=OrderExpiration();//
        }
    }
    double myTempArray[12]; //
    //ArrayResize(myTempArray,myArrayRange); //
    ArrayInitialize(myTempArray, 0.0); //

    if (myOrderSort==0)
    {
        for (i=0;i<myArrayRange;i++)
        {
            for (j=myArrayRange-1;j>i;j--)
            {
                if (myOrdersArray[j][1]>myOrdersArray[j-1][1])
                {
                    myTempArray[0]=myOrdersArray[j-1][0];
                    myTempArray[1]=myOrdersArray[j-1][1];
                    myTempArray[2]=myOrdersArray[j-1][2];
                    myTempArray[3]=myOrdersArray[j-1][3];
                    myTempArray[4]=myOrdersArray[j-1][4];
                    myTempArray[5]=myOrdersArray[j-1][5];
                    myTempArray[6]=myOrdersArray[j-1][6];
                    myTempArray[7]=myOrdersArray[j-1][7];
                    myTempArray[8]=myOrdersArray[j-1][8];
                    myTempArray[9]=myOrdersArray[j-1][9];
                    myTempArray[10]=myOrdersArray[j-1][10];
                    myTempArray[11]=myOrdersArray[j-1][11];
                              
                    myOrdersArray[j-1][0]=myOrdersArray[j][0];
                    myOrdersArray[j-1][1]=myOrdersArray[j][1];
                    myOrdersArray[j-1][2]=myOrdersArray[j][2];
                    myOrdersArray[j-1][3]=myOrdersArray[j][3];
                    myOrdersArray[j-1][4]=myOrdersArray[j][4];
                    myOrdersArray[j-1][5]=myOrdersArray[j][5];
                    myOrdersArray[j-1][6]=myOrdersArray[j][6];
                    myOrdersArray[j-1][7]=myOrdersArray[j][7];
                    myOrdersArray[j-1][8]=myOrdersArray[j][8];
                    myOrdersArray[j-1][9]=myOrdersArray[j][9];
                    myOrdersArray[j-1][10]=myOrdersArray[j][10];
                    myOrdersArray[j-1][11]=myOrdersArray[j][11];
                              
                    myOrdersArray[j][0]=myTempArray[0];
                    myOrdersArray[j][1]=myTempArray[1];
                    myOrdersArray[j][2]=myTempArray[2];
                    myOrdersArray[j][3]=myTempArray[3];
                    myOrdersArray[j][4]=myTempArray[4];
                    myOrdersArray[j][5]=myTempArray[5];
                    myOrdersArray[j][6]=myTempArray[6];
                    myOrdersArray[j][7]=myTempArray[7];
                    myOrdersArray[j][8]=myTempArray[8];
                    myOrdersArray[j][9]=myTempArray[9];
                    myOrdersArray[j][10]=myTempArray[10];
                    myOrdersArray[j][11]=myTempArray[11];
                }
            }
        }
        if (myMaxMin==0) //x,0,0
        {
            for (cnt=myArrayRange-1;cnt>=0;cnt--)
            {
                if (myOrdersArray[cnt][0]!=0
                    && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
        if (myMaxMin==1) //x,0,1
        {
            for (cnt=0;cnt<myArrayRange;cnt++)
            {
                if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
    }
    
    //----
    if (myOrderSort==1 || myOrderSort==2)
    {
        ArrayInitialize(myTempArray, 0.0); //
        for (i=0;i<myArrayRange;i++)
        {
            for (j=myArrayRange-1;j>i;j--)
            {
                if (myOrdersArray[j][2]>myOrdersArray[j-1][2])
                {
                    myTempArray[0]=myOrdersArray[j-1][0];
                    myTempArray[1]=myOrdersArray[j-1][1];
                    myTempArray[2]=myOrdersArray[j-1][2];
                    myTempArray[3]=myOrdersArray[j-1][3];
                    myTempArray[4]=myOrdersArray[j-1][4];
                    myTempArray[5]=myOrdersArray[j-1][5];
                    myTempArray[6]=myOrdersArray[j-1][6];
                    myTempArray[7]=myOrdersArray[j-1][7];
                    myTempArray[8]=myOrdersArray[j-1][8];
                    myTempArray[9]=myOrdersArray[j-1][9];
                    myTempArray[10]=myOrdersArray[j-1][10];
                    myTempArray[11]=myOrdersArray[j-1][11];
                              
                    myOrdersArray[j-1][0]=myOrdersArray[j][0];
                    myOrdersArray[j-1][1]=myOrdersArray[j][1];
                    myOrdersArray[j-1][2]=myOrdersArray[j][2];
                    myOrdersArray[j-1][3]=myOrdersArray[j][3];
                    myOrdersArray[j-1][4]=myOrdersArray[j][4];
                    myOrdersArray[j-1][5]=myOrdersArray[j][5];
                    myOrdersArray[j-1][6]=myOrdersArray[j][6];
                    myOrdersArray[j-1][7]=myOrdersArray[j][7];
                    myOrdersArray[j-1][8]=myOrdersArray[j][8];
                    myOrdersArray[j-1][9]=myOrdersArray[j][9];
                    myOrdersArray[j-1][10]=myOrdersArray[j][10];
                    myOrdersArray[j-1][11]=myOrdersArray[j][11];
                              
                    myOrdersArray[j][0]=myTempArray[0];
                    myOrdersArray[j][1]=myTempArray[1];
                    myOrdersArray[j][2]=myTempArray[2];
                    myOrdersArray[j][3]=myTempArray[3];
                    myOrdersArray[j][4]=myTempArray[4];
                    myOrdersArray[j][5]=myTempArray[5];
                    myOrdersArray[j][6]=myTempArray[6];
                    myOrdersArray[j][7]=myTempArray[7];
                    myOrdersArray[j][8]=myTempArray[8];
                    myOrdersArray[j][9]=myTempArray[9];
                    myOrdersArray[j][10]=myTempArray[10];
                    myOrdersArray[j][11]=myTempArray[11];
                }
            }
        }
        
        if (myOrderSort==1 && myMaxMin==1) //x,1,1
        {
            for (cnt=myArrayRange-1;cnt>=0;cnt--)
            {
                if (myOrdersArray[cnt][0]!=0
                    && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)
                    && myOrdersArray[cnt][2]>0) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
        
        if (myOrderSort==1 && myMaxMin==0) //x,1,0
        {
            for (cnt=0;cnt<myArrayRange;cnt++)
            {
                if (myOrdersArray[cnt][0]!=0
                    && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)
                    && myOrdersArray[cnt][2]>0) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
        
        if (myOrderSort==2 && myMaxMin==0) //x,2,1
        {
            for (cnt=myArrayRange-1;cnt>=0;cnt--)
            {
                if (myOrdersArray[cnt][0]!=0
                    && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)
                    && myOrdersArray[cnt][2]<0) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
        
        if (myOrderSort==2 && myMaxMin==1) //x,2,0
        {
            for (cnt=0;cnt<myArrayRange;cnt++)
            {
                if (myOrdersArray[cnt][0]!=0
                    && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)
                    && myOrdersArray[cnt][2]<0) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
    }
    
    //---- 
    if (myOrderSort==3)
    {
        for (i=0;i<myArrayRange;i++)
        {
            for (j=myArrayRange-1;j>i;j--)
            {
                if (myOrdersArray[j][5]>myOrdersArray[j-1][5])
                {
                    myTempArray[0]=myOrdersArray[j-1][0];
                    myTempArray[1]=myOrdersArray[j-1][1];
                    myTempArray[2]=myOrdersArray[j-1][2];
                    myTempArray[3]=myOrdersArray[j-1][3];
                    myTempArray[4]=myOrdersArray[j-1][4];
                    myTempArray[5]=myOrdersArray[j-1][5];
                    myTempArray[6]=myOrdersArray[j-1][6];
                    myTempArray[7]=myOrdersArray[j-1][7];
                    myTempArray[8]=myOrdersArray[j-1][8];
                    myTempArray[9]=myOrdersArray[j-1][9];
                    myTempArray[10]=myOrdersArray[j-1][10];
                    myTempArray[11]=myOrdersArray[j-1][11];
                              
                    myOrdersArray[j-1][0]=myOrdersArray[j][0];
                    myOrdersArray[j-1][1]=myOrdersArray[j][1];
                    myOrdersArray[j-1][2]=myOrdersArray[j][2];
                    myOrdersArray[j-1][3]=myOrdersArray[j][3];
                    myOrdersArray[j-1][4]=myOrdersArray[j][4];
                    myOrdersArray[j-1][5]=myOrdersArray[j][5];
                    myOrdersArray[j-1][6]=myOrdersArray[j][6];
                    myOrdersArray[j-1][7]=myOrdersArray[j][7];
                    myOrdersArray[j-1][8]=myOrdersArray[j][8];
                    myOrdersArray[j-1][9]=myOrdersArray[j][9];
                    myOrdersArray[j-1][10]=myOrdersArray[j][10];
                    myOrdersArray[j-1][11]=myOrdersArray[j][11];
                              
                    myOrdersArray[j][0]=myTempArray[0];
                    myOrdersArray[j][1]=myTempArray[1];
                    myOrdersArray[j][2]=myTempArray[2];
                    myOrdersArray[j][3]=myTempArray[3];
                    myOrdersArray[j][4]=myTempArray[4];
                    myOrdersArray[j][5]=myTempArray[5];
                    myOrdersArray[j][6]=myTempArray[6];
                    myOrdersArray[j][7]=myTempArray[7];
                    myOrdersArray[j][8]=myTempArray[8];
                    myOrdersArray[j][9]=myTempArray[9];
                    myOrdersArray[j][10]=myTempArray[10];
                    myOrdersArray[j][11]=myTempArray[11];
                }
            }
        }
        
        if (myMaxMin==1) //x,3,0
        {
            for (cnt=myArrayRange-1;cnt>=0;cnt--)
            {
                if (myOrdersArray[cnt][0]!=0
                    && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)
                    && myOrdersArray[cnt][5]>0) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
        
        if (myMaxMin==0) //x,3,1
        {
            for (cnt=0;cnt<myArrayRange;cnt++)
            {
                if (myOrdersArray[cnt][0]!=0
                    && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)
                    && myOrdersArray[cnt][5]>0) 
                {
                    myReturn=NormalizeDouble(myOrdersArray[cnt][0],0);
                    break;
                }
            }
        }
    }
    return(myReturn);
}

void iWait(int myDelayTime) 
{
    while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(myDelayTime);
    RefreshRates();
}

int iOrderEquitToPoint(int myTicket)
{
    int myPoint=0;
    if (OrderSelect(myTicket,SELECT_BY_TICKET,MODE_TRADES))
    {
        if (OrderType()==OP_BUY)
        {
            myPoint=(Bid-OrderOpenPrice())/Point;
        }
        if (OrderType()==OP_SELL)
        {
            myPoint=(OrderOpenPrice()-Ask)/Point;
        }
    }
    return(myPoint);
}

double iFundsToHands(string mySymbol,double myFunds)
{
    double myLots=myFunds/MarketInfo(mySymbol, MODE_MARGINREQUIRED);//闂佺懓绠嶉崹濠氭偩婵犳艾鐭楁い鏍ㄦ皑绾捐霉閻樿櫕灏板褎绮撳?
    double myMinLOT=MarketInfo(mySymbol, MODE_MINLOT);//闂佸搫鐗冮崑鎾绘倶韫囨挾绠扮紒杈ㄥ灦缁傛帡骞樼拠鍙夘仭闂佸憡鐟﹂敃銏ゅ闯?
    if (myMinLOT==0) myLots=0;
    else
        myLots=MathRound(myLots/myMinLOT)*myMinLOT;//闂佸綊娼ч鍡涘汲閻旂厧鏋侀柡澶嬪灱閸?
    return(myLots);
}

//int iDisplayInfo(bool myInfoDsp, string LableName,string LableDoc,int myCorner,int LableX,int LableY,int DocSize,string DocStyle,color DocColor)
int iDisplayInfo(string LableName,string LableDoc,int myCorner,int LableX,int LableY,int DocSize,string DocStyle,color DocColor)
{
    //if (Corner == -1 || myInfoDsp==false) 
    if (Corner == -1) 
    	return(0);
    	
    for (cnt=0;cnt<ObjectsTotal();cnt++)
    {
        if (ObjectName(cnt)==LableName)  break;//婵犵鈧啿鈧綊鎮樻径鎰珘濠㈣泛顭崵鐘绘偣閻愨斁鍋撻搹顐⑩偓宕囩磼婢跺﹤绨荤紒杈ㄧ箞閺屽懘鍩€椤掑嫬绀勯柛婵嗗閸庢洟鏌?
    }
    if (cnt==ObjectsTotal())  ObjectCreate(LableName, OBJ_LABEL, 0, 0, 0);//闂佸搫鍊瑰妯肩磽閹惧灈鍋撻悽娈挎敯闁?
    ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor);
    ObjectSet(LableName, OBJPROP_CORNER, Corner);
    ObjectSet(LableName, OBJPROP_XDISTANCE, LableX);
    ObjectSet(LableName, OBJPROP_YDISTANCE, LableY);
    return(0);
} 

color iObjectColor(double myInput)
{
    color myColor;
    if (myInput > 0) myColor = Green; 
    if (myInput < 0) myColor = Red; 
    if (myInput == 0) myColor = DarkGray;
    return(myColor);
}