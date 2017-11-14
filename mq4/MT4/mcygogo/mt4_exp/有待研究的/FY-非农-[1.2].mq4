//+------------------------------------------------------------------+
//|                                                FY-��ũ-[1.0].mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//----����Ԥ�����
extern double  InitLots       = 2.0;                                          //��ʼ������
extern int     PendingNum     = 3;                                            //�ҵ�����
extern double  DecreaseRate   = 0.8;                                          //�ҵ���չϵ��

extern int     StartPending   = 100;                                          //��ʼ�ҵ�����
extern int     Interval       = 100;                                          //�ҵ����
extern int     TrallingStop   = 150;                                          //�ƶ�ֹ�������0-��ʾ��ִ��

//�������Ʋ���
string ����ע��               = "";
string MyOrderComment         = "";
int ����������                = 20121212;
int MyMagicNum                = 0;


//----������Ʋ���
int BuyGroupOrders            = 0,        SellGroupOrders            = 0;     //���롢������ɽ��ֲֵ������ܼ�
//int BuyLimitOrders            = 0,        SellLimitOrders            = 0;     //�������ƹҵ����������ƹҵ������ܼ�
int BuyStopOrders             = 0,        SellStopOrders             = 0;     //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�
double BuyGroupLots           = 0.0,      SellGroupLots              = 0.0;   //���롢������ɽ��ֲֵ��������ܼ�
double BuyGroupProfit         = 0.0,      SellGroupProfit            = 0.0;   //���롢������ɽ��ֲֵ������ܼ�
int BuyGroupFirstTicket       = 0,        SellGroupFirstTicket       = 0;     //���롢�������һ������
int BuyGroupLastTicket        = 0,        SellGroupLastTicket        = 0;     //���롢���������һ������
int BuyGroupMaxProfitTicket   = 0,        SellGroupMaxProfitTicket   = 0;     //���롢���������ӯ��������
int BuyGroupMinProfitTicket   = 0,        SellGroupMinProfitTicket   = 0;     //���롢��������Сӯ��������
int BuyGroupMaxLossTicket     = 0,        SellGroupMaxLossTicket     = 0;     //���롢�����������𵥵���
int BuyGroupMinLossTicket     = 0,        SellGroupMinLossTicket     = 0;     //���롢��������С���𵥵���


double LotsArray[];                                                           //����������
bool StartTrad                = false;                                        //��ʼ���ױ���
bool endTrad                  = false;                                        //�������ױ���
int TradingDelay              = 1000;                                         //������ʱ������1000����


bool InfoDisplay              = true;                                         //��Ϣ��ʾ����
int Corner                    = 1;                                            //������Ϣ��ʾ�ĸ���λ��

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      //��ʼ��Ԥ�����
      MyOrderComment = ����ע��;
      MyMagicNum     = ����������;
      
      //��ʼ������������
      ArrayResize(LotsArray,PendingNum);
      ArrayInitialize(LotsArray,0.0);
      
      //��ʼ����ֵ
      LotsArray[0] = iLotsFormat(Symbol(),InitLots);
      
      for (int cnt = 1; cnt < PendingNum; cnt ++)
      {
         LotsArray[cnt] = iLotsFormat(Symbol(),LotsArray[cnt-1] * DecreaseRate);
      }
//----

      return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll();
   Comment ("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
    iMain();
    return(0); 
//----
   return(0);
  }
//+------------------------------------------------------------------+

/*
��    �������س���
���������
���������
��    ����
*/
void iMain()
{    
    iShowInfo();
    
    if(endTrad == false)
    {
      if(StartTrad == false)
      {
        //����
        iCreatNets();
        StartTrad = true;
      }
      else
      { 
        //���������ˣ� ��û�н���
        if(BuyGroupOrders>0 || SellGroupOrders>0)
        {
            //�ƶ�ֹ��
           iTrallingStop();
        }
        //���������ˣ� �������������
        else if((BuyGroupOrders==0 && BuyStopOrders!=PendingNum) || (SellGroupOrders==0 && SellStopOrders!=PendingNum))
        {
            //����
           iBatchClose(9,0,MyMagicNum);
           endTrad = true;       
        }
        //���黹û����
        else if((BuyGroupOrders==0 && BuyStopOrders==PendingNum) || (SellGroupOrders==0 && SellStopOrders==PendingNum))
        {
            //�ƶ�����
            iTrallingOpen();
        }
      }
   }

    return(0);
}

/*
��    ��:����������
�������:mySymbol-���Ҷ� myLots-������
�������:����ƽ̨������㿪����
��    ��:�������淶�Ŀ��������ݣ�������������ԭ��ƽ̨��������ʽ�淶����
         ���������С���������򷵻���С������
         ���������󽨲������򷵻���󽨲���
*/
double iLotsFormat(string mySymbol,double myLots)
{    
    double retLots = 0.0;
    //�������������ƽ̨��С�����׼������������С�����׼����������
    if (myLots < MarketInfo(mySymbol, MODE_MINLOT)) 
    {
      retLots = MarketInfo(mySymbol, MODE_MINLOT);
    }
    //�������������ƽ̨��������׼������������������׼����������
    else if (myLots > MarketInfo(mySymbol, MODE_MAXLOT)) 
    {
      retLots = MarketInfo(mySymbol, MODE_MAXLOT);
    }
    else 
    {
      //����������
      retLots = MathRound(myLots/MarketInfo(mySymbol, MODE_MINLOT)) * MarketInfo(mySymbol, MODE_MINLOT);
     }
    
    
    return (retLots);
}

/*
��    ��������
���������
���������
��    ����
*/
void iCreatNets()
{
   //û�гֲֵ��� Ҳû�йҵ�
   if (BuyGroupOrders + SellGroupOrders + BuyStopOrders + SellStopOrders == 0)
   {
      //�Ѿ�����
      StartTrad = true;

      double myBuyStopPrice=NormalizeDouble(Ask+StartPending*Point,Digits);
      double mySellStopPrice=NormalizeDouble(Bid-StartPending*Point,Digits);
		//������ʱ
      iWait(TradingDelay);

      for (int cnt = 0; cnt < PendingNum; cnt ++)
      {
         OrderSend(Symbol(),OP_BUYSTOP,LotsArray[cnt],myBuyStopPrice,0,0,0,"1",MyMagicNum);
         OrderSend(Symbol(),OP_SELLSTOP,LotsArray[cnt],mySellStopPrice,0,0,0,"1",MyMagicNum);
			   
         myBuyStopPrice=NormalizeDouble(myBuyStopPrice+Interval*Point,Digits);
         mySellStopPrice=NormalizeDouble(mySellStopPrice-Interval*Point,Digits);
      }
   }
    
   return(0);
}


/*
��    ��:�������
�������:int myType 0-OP_BUY,1-OP_SELL,2-OP_BUYLIMIT,3-OP_SELLLIMIT,4-OP_BUYSTOP,5-OP_SELLSTOP,9-ȫ��
         double myLots 0-����������,��0�����
         int myMagicNum ����������
�������:
��    ��:
*/
void iBatchClose(int myType, double myLots, int myMagicNum)
{
   int total = OrdersTotal();
	for (int cnt = total - 1; cnt >= 0; cnt --)
   {
      if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==myMagicNum && OrderSymbol()==Symbol())
      {
         //ƽ�ֳɽ���
         if ((myType==0 || myType==9) && OrderType()==OP_BUY)
         {
				OrderClose(OrderTicket(),OrderLots(),MarketInfo(Symbol(), MODE_BID),0, CLR_NONE);
         }
         if ((myType==1 || myType==9) && OrderType()==OP_SELL)
         {
				OrderClose(OrderTicket(),OrderLots(),MarketInfo(Symbol(), MODE_ASK),0, CLR_NONE);
         }
         
			//ȡ���ҵ�
         if ((myType==OP_BUYLIMIT || myType==OP_SELLLIMIT || myType==OP_BUYSTOP || myType==OP_SELLSTOP || myType==9)
                && ((OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)))
         {
            OrderDelete(OrderTicket());
         }
      }
   }
   
   return(0);
}




/*
��    �����ƶ�ֹ��
���������
���������
��    ����
*/
void iTrallingStop()
{
    double myTrallingStop; //�ƶ�ֹ��۱���
    //�������ƶ�ֹ��
    if (BuyGroupOrders>0)
    {
        if (TrallingStop>0) //����ƶ�ֹ���>0��ִ���ƶ�ֹ��
        {
            //����ֹӯ��ֵ
            myTrallingStop=NormalizeDouble(Bid-TrallingStop*Point,Digits); //�����ƶ�ֹ���
        }

        for (int cnt = 0; cnt < OrdersTotal(); cnt ++)
        {
            if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
                && OrderMagicNumber()==MyMagicNum
                && OrderSymbol()==Symbol()
                && OrderType()==OP_BUY 
                && (myTrallingStop>NormalizeDouble(OrderStopLoss(),Digits) || OrderStopLoss()==0) 
               )
            {
                iWait(TradingDelay);
                //�޸Ķ�������ֹӯ��ֵ
                OrderModify(OrderTicket(),OrderOpenPrice(),myTrallingStop,OrderTakeProfit(),0);
            }
        }
    }
    
    //�������ƶ�ֹ��
    if (SellGroupOrders>0)
    {
        if (TrallingStop>0) //����ƶ�ֹ���>0��ִ���ƶ�ֹ��
        {
            myTrallingStop=NormalizeDouble(Ask+TrallingStop*Point,Digits); //�����ƶ�ֹ���
        }
        
        for (cnt = 0; cnt < OrdersTotal(); cnt ++)
        {
            if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
                && OrderMagicNumber()==MyMagicNum
                && OrderSymbol()==Symbol()
                && OrderType()==OP_SELL 
                && (myTrallingStop<NormalizeDouble(OrderStopLoss(),Digits) || OrderStopLoss()==0)
               )
            {
                iWait(TradingDelay);
                OrderModify(OrderTicket(),OrderOpenPrice(),myTrallingStop,OrderTakeProfit(),0);
            }
        }
    }
    
    return(0);
}

/*
��    �����ƶ�����
���������
���������
��    ����
*/

void iTrallingOpen()
{
   double myBuyStopPrice=NormalizeDouble(Ask+StartPending*Point,Digits);
   double mySellStopPrice=NormalizeDouble(Bid-StartPending*Point,Digits);
   for (int cnt=0;cnt<OrdersTotal();cnt++)
   {
      if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
            && OrderMagicNumber()==MyMagicNum
            && OrderSymbol()==Symbol()
            && OrderType()==OP_BUYSTOP)
      {
         iWait(TradingDelay);
         OrderModify(OrderTicket(),myBuyStopPrice,0,0,0);
         myBuyStopPrice=NormalizeDouble(myBuyStopPrice+Interval*Point,Digits); 
      }
      else if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
            && OrderMagicNumber()==MyMagicNum
            && OrderSymbol()==Symbol()
            && OrderType()==OP_SELLSTOP)
      {
         iWait(TradingDelay);
         OrderModify(OrderTicket(),mySellStopPrice,0,0,0);
         mySellStopPrice=NormalizeDouble(mySellStopPrice-Interval*Point,Digits);
      }
   }
   
   return (0);
}

/*
��    ��:�ֲֵ�����ͳ��
�������:myOrderType:��������
�������:ָ�����͵Ķ�������
��    ��:�����㷨
*/
int iOrderStatistics(int myOrderType,int myMagicNum)
{
    int myReturn;
    if (OrdersTotal()==0) return(0);
    for (int cnt=0;cnt<OrdersTotal();cnt++)
    {
        if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
            && OrderMagicNumber()==myMagicNum
            && OrderSymbol()==Symbol()
            && OrderType()==myOrderType)
        {
            myReturn=myReturn+1;
        }
    }
    return(myReturn);
}

/*
��    ��:�ֲֵ���ֵ�ܼ�
�������:myOrderType:��������
�������:���롢�����龻ֵ�ܼ�
��    ��:�����㷨
*/
double iGroupEquity(int myOrderType,int myMagicNum)
{
    double myReturn = 0.0;
    int total = OrdersTotal();
    for (int cnt=total-1;cnt>=0;cnt--)
    {
        if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
            && OrderMagicNumber()==myMagicNum && OrderSymbol()==Symbol() && OrderType()==myOrderType)
        {
            myReturn=myReturn+OrderProfit();
        }
    }
    return(myReturn);
}

/*
��    ��:�ֲֵ��������ܼ�
�������:myOrderType:��������
�������:���롢�����鿪�����ܼ�
��    ��:�����㷨
*/
double iGroupLots(int myOrderType,int myMagicNum)
{
    double myReturn = 0.0;
    int total = OrdersTotal();
    for (int cnt=total-1;cnt>=0;cnt--)
    {
        if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
            && OrderMagicNumber()==myMagicNum && OrderSymbol()==Symbol() && OrderType()==myOrderType)
        {
            myReturn=myReturn+OrderLots();
        }
    }
    return(myReturn);
}

/*
��    ��:�����ض������Ķ���
�������:myOrderType:�������� 0-Buy,1-Sell,2-BuyLimit,3-SellLimit,4-BuyStop,5-SellStop
         myOrderSort:�������� 0-��ʱ��,1-��ӯ��,2-������,3-�����ּ�
         myMaxMin:��ֵ 0-���,1-��С
         int myMagicNum:����������
�������:���ض�����
��    ����ð���㷨
*/
int iOrdersSort(int myOrderType,int myOrderSort,int myMaxMin,int myMagicNum)
{
    int myReturn,myArrayRange,cnt,i,j;
    myArrayRange=OrdersTotal();
    if (myArrayRange<=0) return(0);
    //�ֲֶ���������Ϣ:0������,1����ʱ��,2��������,3��������,4������,5���ּ�,
    //                 6ֹ���,7ֹӮ��,8����������,9����Ӷ��,10����,11�ҵ���Ч����
    double myOrdersArray[][12]; //���嶩������,��1ά:�������;��2ά:������Ϣ
    ArrayResize(myOrdersArray,myArrayRange); //���½綨��������
    ArrayInitialize(myOrdersArray, 0.0); //��ʼ����������
    //�������鸳ֵ
    for (cnt=0; cnt<myArrayRange; cnt++)
    {
        //ѡ�е�ǰ���Ҷ���سֲֶ���
        if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol()==Symbol()
            && OrderMagicNumber()==myMagicNum)
        {
            myOrdersArray[cnt][0]=OrderTicket();//0������
            myOrdersArray[cnt][1]=OrderOpenTime();//1����ʱ��
            myOrdersArray[cnt][2]=OrderProfit();//2��������
            myOrdersArray[cnt][3]=OrderType();//3��������
            myOrdersArray[cnt][4]=OrderLots();//4������
            myOrdersArray[cnt][5]=OrderOpenPrice();//5���ּ�
            myOrdersArray[cnt][6]=OrderStopLoss();//6ֹ���
            myOrdersArray[cnt][7]=OrderTakeProfit();//7ֹӮ��
            myOrdersArray[cnt][8]=OrderMagicNumber();//8����������
            myOrdersArray[cnt][9]=OrderCommission();//9����Ӷ��
            myOrdersArray[cnt][10]=OrderSwap();//10����
            myOrdersArray[cnt][11]=OrderExpiration();//11�ҵ���Ч����
        }
    }
    double myTempArray[12]; //������ʱ����
    //ArrayResize(myTempArray,myArrayRange); //���½綨��ʱ����
    ArrayInitialize(myTempArray, 0.0); //��ʼ����ʱ����
    //��ʼ����������
    //---- ��ʱ�併����������,ԭʼ������������
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
    
    //---- ��������ֵ������������,ԭʼ������������
    if (myOrderSort==1 || myOrderSort==2)
    {
        ArrayInitialize(myTempArray, 0.0); //��ʼ����ʱ����
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
    
    //---- �����ּ۽�����������,ԭʼ������������
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


/*
��    �������׷�æ������ȴ������»�������
���������
���������
�㷨˵����
*/
void iWait(int myDelayTime) 
{
    while (!IsTradeAllowed() || IsTradeContextBusy()) 
    {
      Sleep(myDelayTime);
    }
    
    RefreshRates();
    return(0);
}


/*
��    ������ʾ������Ϣ
���������
���������
��    ����
*/
void iShowInfo()
{
    int myLastError=GetLastError();
    if (myLastError>0)
    {
        if (InfoDisplay==true) 
        {
            iDisplayInfo("LastErrorStr", iGetErrorInfo(myLastError), Corner, 180, 5, 12, "", Red);
        }
    }
    //����22�������ص�����
	//6�����͵�������
    BuyGroupOrders=iOrderStatistics(OP_BUY,MyMagicNum);
    SellGroupOrders=iOrderStatistics(OP_SELL,MyMagicNum);
    //BuyLimitOrders=iOrderStatistics(OP_BUYLIMIT,MyMagicNum);
    //SellLimitOrders=iOrderStatistics(OP_SELLLIMIT,MyMagicNum);
    BuyStopOrders=iOrderStatistics(OP_BUYSTOP,MyMagicNum);
    SellStopOrders=iOrderStatistics(OP_SELLSTOP,MyMagicNum);

	//2�ֳɽ��ֲֵ��������ܼ�
    BuyGroupLots=iGroupLots(OP_BUY,MyMagicNum);
    SellGroupLots=iGroupLots(OP_SELL,MyMagicNum);

	//2�ֳɽ��ֲֵ������ܼ�
    BuyGroupProfit=iGroupEquity(OP_BUY,MyMagicNum);
    SellGroupProfit=iGroupEquity(OP_SELL,MyMagicNum);

	//2�ֵ�һ�����ţ�2�����һ������
    BuyGroupFirstTicket=iOrdersSort(OP_BUY,0,0,MyMagicNum);
    SellGroupFirstTicket=iOrdersSort(OP_SELL,0,0,MyMagicNum);
    BuyGroupLastTicket=iOrdersSort(OP_BUY,0,1,MyMagicNum);
    SellGroupLastTicket=iOrdersSort(OP_SELL,0,1,MyMagicNum);

	//2�����ӯ�������ţ�2����Сӯ��������
    BuyGroupMaxProfitTicket=iOrdersSort(OP_BUY,1,0,MyMagicNum);
    SellGroupMaxProfitTicket=iOrdersSort(OP_SELL,1,0,MyMagicNum);
    BuyGroupMinProfitTicket=iOrdersSort(OP_BUY,1,1,MyMagicNum);
    SellGroupMinProfitTicket=iOrdersSort(OP_SELL,1,1,MyMagicNum);

	//2�������𵥵��ţ�2����С���𵥵���
    BuyGroupMaxLossTicket=iOrdersSort(OP_BUY,2,0,MyMagicNum);
    SellGroupMaxLossTicket=iOrdersSort(OP_SELL,2,0,MyMagicNum);
    BuyGroupMinLossTicket=iOrdersSort(OP_BUY,2,1,MyMagicNum);
    SellGroupMinLossTicket=iOrdersSort(OP_SELL,2,1,MyMagicNum);
}

/*
��    ��������Ļ����ʾ���ֱ�ǩ
���������string LableName ��ǩ���ƣ������ʾ����ı������Ʋ�����ͬ
          string LableDoc �ı�����
          int Corner �ı���ʾ��
          int LableX ��ǩXλ������
          int LableY ��ǩYλ������
          int DocSize �ı��ֺ�
          string DocStyle �ı�����
          color DocColor �ı���ɫ
�����������ָ����λ�ã�X,Y������ָ�����ֺš����弰��ɫ��ʾָ�����ı�
�㷨˵����
*/
void iDisplayInfo(string LableName,string LableDoc,int Corner,int LableX,int LableY,int DocSize,string DocStyle,color DocColor)
{
    if (Corner == -1) 
    { 
      return (0);
    }
    
    for (int cnt = 0; cnt < ObjectsTotal(); cnt ++)
    {
        if (ObjectName(cnt)==LableName)  break;//����ж������ƣ��˳�ѭ��
    }
    if (cnt==ObjectsTotal())  ObjectCreate(LableName, OBJ_LABEL, 0, 0, 0);//�½�����
    ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor);
    ObjectSet(LableName, OBJPROP_CORNER, Corner);
    ObjectSet(LableName, OBJPROP_XDISTANCE, LableX);
    ObjectSet(LableName, OBJPROP_YDISTANCE, LableY);
    return(0);
} 







/*
��    ������ȡ��������Ϣ
���������int myErrorNum - �������
���������������Ϣ
��    ����
*/
string iGetErrorInfo(int myErrorNum)
{
    string myLastErrorStr;
    if(myErrorNum>=0)
    {
        switch (myErrorNum)
        {
            case 0:myLastErrorStr="�������:"+0+"-û�д��󷵻�";break;
            case 1:myLastErrorStr="�������:"+1+"-û�д��󷵻ص��������";break;
            case 2:myLastErrorStr="�������:"+2+"-һ�����";break;
            case 3:myLastErrorStr="�������:"+3+"-��Ч���ײ���";break;
            case 4:myLastErrorStr="�������:"+4+"-���׷�������æ";break;
            case 5:myLastErrorStr="�������:"+5+"-�ͻ��ն˾ɰ汾";break;
            case 6:myLastErrorStr="�������:"+6+"-û�����ӷ�����";break;
            case 7:myLastErrorStr="�������:"+7+"-û��Ȩ��";break;
            case 8:myLastErrorStr="�������:"+8+"-�������Ƶ��";break;
            case 9:myLastErrorStr="�������:"+9+"-�������й���";break;
            case 64:myLastErrorStr="�������:"+64+"-�˻���ֹ";break;
            case 65:myLastErrorStr="�������:"+65+"-��Ч�˻�";break;
            case 128:myLastErrorStr="�������:"+128+"-���׳�ʱ";break;
            case 129:myLastErrorStr="�������:"+129+"-��Ч�۸�";break;
            case 130:myLastErrorStr="�������:"+130+"-��Чֹͣ";break;
            case 131:myLastErrorStr="�������:"+131+"-��Ч������";break;
            case 132:myLastErrorStr="�������:"+132+"-�г��ر�";break;
            case 133:myLastErrorStr="�������:"+133+"-���ױ���ֹ";break;
            case 134:myLastErrorStr="�������:"+134+"-�ʽ���";break;
            case 135:myLastErrorStr="�������:"+135+"-�۸�ı�";break;
            case 136:myLastErrorStr="�������:"+136+"-���ּ۹���";break;
            case 137:myLastErrorStr="�������:"+137+"-���ͷ�æ";break;
            case 138:myLastErrorStr="�������:"+138+"-���¿���";break;
            case 139:myLastErrorStr="�������:"+139+"-����������";break;
            case 140:myLastErrorStr="�������:"+140+"-ֻ�����ǲ�λ";break;
            case 141:myLastErrorStr="�������:"+141+"-��������";break;
            case 145:myLastErrorStr="�������:"+145+"-��Ϊ���ڽӽ��г����޸���Ч";break;
            case 146:myLastErrorStr="�������:"+146+"-�����ı�����";break;
            case 147:myLastErrorStr="�������:"+147+"-ʱ�����ڱ����ͷ�";break;
            case 148:myLastErrorStr="�������:"+148+"-�����͹ҵ������ѱ������޶�";break;
            case 149:myLastErrorStr="�������:"+149+"-���Գ屻�ܾ�ʱ,����������е�һ������";break;
            case 150:myLastErrorStr="�������:"+150+"-��Ϊ��FIFO�涨�ĵ���ƽ��";break;
            case 4000:myLastErrorStr="�������:"+4000+"-û�д���";break;
            case 4001:myLastErrorStr="�������:"+4001+"-������ָʾ";break;
            case 4002:myLastErrorStr="�������:"+4002+"-��������������Χ";break;
            case 4003:myLastErrorStr="�������:"+4003+"-���ڵ��ö�ջ����������û���㹻�ڴ�";break;
            case 4004:myLastErrorStr="�������:"+4004+"-ѭ����ջ���������";break;
            case 4005:myLastErrorStr="�������:"+4005+"-���ڶ�ջ����������û���ڴ�";break;
            case 4006:myLastErrorStr="�������:"+4006+"-�������в���û���㹻�ڴ�";break;
            case 4007:myLastErrorStr="�������:"+4007+"-��������û���㹻�ڴ�";break;
            case 4008:myLastErrorStr="�������:"+4008+"-û�г�ʼ����";break;
            case 4009:myLastErrorStr="�������:"+4009+"-��������û�г�ʼ�ִ���";break;
            case 4010:myLastErrorStr="�������:"+4010+"-��������û���ڴ�";break;
            case 4011:myLastErrorStr="�������:"+4011+"-���й���";break;
            case 4012:myLastErrorStr="�������:"+4012+"-��������Ϊ��";break;
            case 4013:myLastErrorStr="�������:"+4013+"-�㻮��";break;
            case 4014:myLastErrorStr="�������:"+4014+"-��������";break;
            case 4015:myLastErrorStr="�������:"+4015+"-����ת��(û�г������)";break;
            case 4016:myLastErrorStr="�������:"+4016+"-û�г�ʼ����";break;
            case 4017:myLastErrorStr="�������:"+4017+"-��ֹ����DLL ";break;
            case 4018:myLastErrorStr="�������:"+4018+"-���ݿⲻ������";break;
            case 4019:myLastErrorStr="�������:"+4019+"-���ܵ��ú���";break;
            case 4020:myLastErrorStr="�������:"+4020+"-��ֹ�������ܽ��׺���";break;
            case 4021:myLastErrorStr="�������:"+4021+"-�������Ժ���������û���㹻�ڴ�";break;
            case 4022:myLastErrorStr="�������:"+4022+"-ϵͳ��æ (û�г������)";break;
            case 4050:myLastErrorStr="�������:"+4050+"-��Ч������������";break;
            case 4051:myLastErrorStr="�������:"+4051+"-��Ч������";break;
            case 4052:myLastErrorStr="�������:"+4052+"-���к����ڲ�����";break;
            case 4053:myLastErrorStr="�������:"+4053+"-һЩ�������";break;
            case 4054:myLastErrorStr="�������:"+4054+"-Ӧ�ò���ȷ����";break;
            case 4055:myLastErrorStr="�������:"+4055+"-�Զ���ָ�����";break;
            case 4056:myLastErrorStr="�������:"+4056+"-��Э������";break;
            case 4057:myLastErrorStr="�������:"+4057+"-����������̴���";break;
            case 4058:myLastErrorStr="�������:"+4058+"-�������δ�ҵ�";break;
            case 4059:myLastErrorStr="�������:"+4059+"-����ģʽ������ֹ";break;
            case 4060:myLastErrorStr="�������:"+4060+"-û��ȷ�Ϻ���";break;
            case 4061:myLastErrorStr="�������:"+4061+"-�����ʼ�����";break;
            case 4062:myLastErrorStr="�������:"+4062+"-����Ԥ�Ʋ���";break;
            case 4063:myLastErrorStr="�������:"+4063+"-����Ԥ�Ʋ���";break;
            case 4064:myLastErrorStr="�������:"+4064+"-˫Ԥ�Ʋ���";break;
            case 4065:myLastErrorStr="�������:"+4065+"-������ΪԤ�Ʋ���";break;
            case 4066:myLastErrorStr="�������:"+4066+"-ˢ��״̬������ʷ����";break;
            case 4067:myLastErrorStr="�������:"+4067+"-���׺�������";break;
            case 4099:myLastErrorStr="�������:"+4099+"-�ļ�����";break;
            case 4100:myLastErrorStr="�������:"+4100+"-һЩ�ļ�����";break;
            case 4101:myLastErrorStr="�������:"+4101+"-�����ļ�����";break;
            case 4102:myLastErrorStr="�������:"+4102+"-���ļ�����";break;
            case 4103:myLastErrorStr="�������:"+4103+"-���ܴ��ļ�";break;
            case 4104:myLastErrorStr="�������:"+4104+"-��Э���ļ�";break;
            case 4105:myLastErrorStr="�������:"+4105+"-û��ѡ�񶨵�";break;
            case 4106:myLastErrorStr="�������:"+4106+"-�������Ҷ�";break;
            case 4107:myLastErrorStr="�������:"+4107+"-��Ч�۸�";break;
            case 4108:myLastErrorStr="�������:"+4108+"-��Ч��������";break;
            case 4109:myLastErrorStr="�������:"+4109+"-��������";break;
            case 4110:myLastErrorStr="�������:"+4110+"-��������";break;
            case 4111:myLastErrorStr="�������:"+4111+"-���������";break;
            case 4200:myLastErrorStr="�������:"+4200+"-�����Ѿ�����";break;
            case 4201:myLastErrorStr="�������:"+4201+"-������������";break;
            case 4202:myLastErrorStr="�������:"+4202+"-����������";break;
            case 4203:myLastErrorStr="�������:"+4203+"-������������";break;
            case 4204:myLastErrorStr="�������:"+4204+"-û�ж�������";break;
            case 4205:myLastErrorStr="�������:"+4205+"-�����������";break;
            case 4206:myLastErrorStr="�������:"+4206+"-û��ָ���Ӵ���";break;
            case 4207:myLastErrorStr="�������:"+4207+"-����һЩ��������";break;
            case 4250:myLastErrorStr="�������:"+4250+"-�����趨����֪ͨ��������";break;
            case 4251:myLastErrorStr="�������:"+4251+"-��Ч����- ���ַ������ݵ�SendNotification()����";break;
            case 4252:myLastErrorStr="�������:"+4252+"-��Ч���÷���֪ͨ(δָ��ID��δ����֪ͨ)";break;
            case 4253:myLastErrorStr="�������:"+4253+"-֪ͨ���͹���Ƶ��";break;
        }
    }
    return(myLastErrorStr);
}