#property copyright "Copyright 2012, laoyee"
#property link      "http://www.docin.com/yiwence"

//----����Ԥ�����
extern string str1 = "====ϵͳԤ�����====";
extern double ������=1;
double Lots;
extern string str2 = "====����ָ�����====";

extern string ��Ч���׿�ʼʱ��="00:00";
string ValidStartTime;
extern string ��Ч���׽���ʱ��="00:00";
string ValidEndTime;
extern bool �Ƿ���÷�����ʱ��=true;
bool ServerTime;
//�������Ʋ���
string ����ע��="";
string MyOrderComment;
int ����������=0;
int MyMagicNum;

//----������Ʋ���
int BuyGroupOrders, SellGroupOrders; //���롢������ɽ��ֲֵ������ܼ�
int BuyLimitOrders, SellLimitOrders; //�������ƹҵ����������ƹҵ������ܼ�
int BuyStopOrders, SellStopOrders; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�
double BuyGroupLots, SellGroupLots; //���롢������ɽ��ֲֵ��������ܼ�
double BuyGroupProfit, SellGroupProfit; //���롢������ɽ��ֲֵ������ܼ�
int BuyGroupFirstTicket, SellGroupFirstTicket; //���롢�������һ������
int BuyGroupLastTicket, SellGroupLastTicket; //���롢���������һ������
int BuyGroupMaxProfitTicket, SellGroupMaxProfitTicket; //���롢���������ӯ��������
int BuyGroupMinProfitTicket, SellGroupMinProfitTicket; //���롢��������Сӯ��������
int BuyGroupMaxLossTicket, SellGroupMaxLossTicket; //���롢�����������𵥵���
int BuyGroupMinLossTicket, SellGroupMinLossTicket; //���롢��������С���𵥵���
int Corner=1; //������Ϣ��ʾ�ĸ���λ��
int FontSize=9; //��ʾ��Ϣ�ֺ�
bool CloseAll=false; //��ֱ���
int cnt,i,j; //����������
int TradingDelay=1000; //������ʱ������1000����
int start()
{
    iMain();
    return(0);
}

/*
��    �������س���
���������
���������
��    ����
*/
void iMain()
{
    iWait(TradingDelay);
    iShowInfo();
    //�������
    //---- ����ղ֣������
    if (BuyGroupOrders+SellGroupOrders+BuyLimitOrders+SellLimitOrders+BuyStopOrders+SellStopOrders==0) CloseAll=false;
    if (CloseAll==true && (BuyGroupOrders+SellGroupOrders)>0)
    {
        iBatchClose(9,0,MyMagicNum);
        return(0);
    }
    //---- �������
    iTradingSignals();
    return(0);
}

/*
��    �������㽻���ź�
���������
���������N/A-���ź�
��    ����
*/
string iTradingSignals()
{
    string myReturn="N/A";//Ԥ���巵�ر���
    
    if (!iValidTime(ValidStartTime,ValidEndTime,ServerTime))//��Чʱ����ڣ������ͽ����ź�
    {
        myReturn="N/A";
    }
    return(myReturn);
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
        iDisplayInfo("LastErrorStr", iGetErrorInfo(myLastError), Corner, 180, 5, 12, "", Red);
    }
    //����22�������ص�����
    BuyGroupOrders=iOrderStatistics(OP_BUY,MyMagicNum);
    SellGroupOrders=iOrderStatistics(OP_SELL,MyMagicNum);
    BuyLimitOrders=iOrderStatistics(OP_BUYLIMIT,MyMagicNum);
    SellLimitOrders=iOrderStatistics(OP_SELLLIMIT,MyMagicNum);
    BuyStopOrders=iOrderStatistics(OP_BUYSTOP,MyMagicNum);
    SellStopOrders=iOrderStatistics(OP_SELLSTOP,MyMagicNum);
    BuyGroupLots=iGroupLots(OP_BUY,MyMagicNum);
    SellGroupLots=iGroupLots(OP_SELL,MyMagicNum);
    BuyGroupProfit=iGroupEquity(OP_BUY,MyMagicNum);
    SellGroupProfit=iGroupEquity(OP_SELL,MyMagicNum);
    BuyGroupFirstTicket=iOrdersSort(OP_BUY,0,0,MyMagicNum);
    SellGroupFirstTicket=iOrdersSort(OP_SELL,0,0,MyMagicNum);
    BuyGroupLastTicket=iOrdersSort(OP_BUY,0,1,MyMagicNum);
    SellGroupLastTicket=iOrdersSort(OP_SELL,0,1,MyMagicNum);
    BuyGroupMaxProfitTicket=iOrdersSort(OP_BUY,1,0,MyMagicNum);
    SellGroupMaxProfitTicket=iOrdersSort(OP_SELL,1,0,MyMagicNum);
    BuyGroupMinProfitTicket=iOrdersSort(OP_BUY,1,1,MyMagicNum);
    SellGroupMinProfitTicket=iOrdersSort(OP_SELL,1,1,MyMagicNum);
    BuyGroupMaxLossTicket=iOrdersSort(OP_BUY,2,0,MyMagicNum);
    SellGroupMaxLossTicket=iOrdersSort(OP_SELL,2,0,MyMagicNum);
    BuyGroupMinLossTicket=iOrdersSort(OP_BUY,2,1,MyMagicNum);
    SellGroupMinLossTicket=iOrdersSort(OP_SELL,2,1,MyMagicNum);
    //��ʾ������Ϣ
    iDisplayInfo("Author", "����:���� QQ:921795", Corner, 18, 15, 8, "", SlateGray);
    iDisplayInfo("Symbol", Symbol(), Corner, 25, 30, 14, "Arial Bold", DodgerBlue);
    //��ʾ������Ϣ
    iDisplayInfo(Symbol()+"-BuyGroup", "������", Corner, 70, 70, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"-SellGroup", "������", Corner, 5, 70, 12, "Arial", Green);
    iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
    //��ʾ��������Ϣ
    iDisplayInfo(Symbol()+"-BuyGroup", "������", Corner, 70, 70, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"BuyOrders", BuyGroupOrders+"  "+BuyLimitOrders+"  "+BuyStopOrders, Corner, 80, 110, 10, "Arial", iObjectColor(BuyGroupProfit));
    iDisplayInfo(Symbol()+"BuyGroupLots", DoubleToStr(BuyGroupLots, 2), Corner, 80, 125, 10, "Arial", iObjectColor(BuyGroupProfit));
    iDisplayInfo(Symbol()+"BuyGroupProfit", DoubleToStr(BuyGroupProfit, 2), Corner, 80, 140, 10, "Arial", iObjectColor(BuyGroupProfit));
    //��ʾ��������Ϣ
    iDisplayInfo(Symbol()+"-SellGroup", "������", Corner, 5, 70, 12, "Arial", Green);
    iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
    iDisplayInfo(Symbol()+"SellOrders", SellGroupOrders+"  "+SellLimitOrders+"  "+SellStopOrders, Corner, 10, 110, 10, "Arial", iObjectColor(SellGroupProfit));
    iDisplayInfo(Symbol()+"SellGroupLots", DoubleToStr(SellGroupLots, 2), Corner, 10, 125, 10, "Arial", iObjectColor(SellGroupProfit));
    iDisplayInfo(Symbol()+"SellGroupProfit", DoubleToStr(SellGroupProfit, 2), Corner, 10, 140, 10, "Arial", iObjectColor(SellGroupProfit));
Comment("������ֲֵ��ܼ�:"+BuyGroupOrders+"  ������ֲֵ��ܼ�:"+SellGroupOrders+"\n"+
        "�������1������:"+BuyGroupFirstTicket+"  �������1������:"+SellGroupFirstTicket+"\n"+
        "���������1������:"+BuyGroupLastTicket+"  ���������1������:"+SellGroupLastTicket+"\n"+"\n"+

        "��������Сӯ��������:"+BuyGroupMinProfitTicket+"  ��������Сӯ��������:"+SellGroupMinProfitTicket+"\n"+
        "���������ӯ��������:"+BuyGroupMaxProfitTicket+"  ���������ӯ��������:"+SellGroupMaxProfitTicket+"\n"+
        "��������С���𵥵���:"+BuyGroupMinLossTicket+"  ��������С���𵥵���:"+SellGroupMinLossTicket+"\n"+
        "�����������𵥵���:"+BuyGroupMaxLossTicket+"  �����������𵥵���:"+SellGroupMaxLossTicket+"\n"+"\n"+
        "�����鿪�����ܼ�:"+BuyGroupLots+"  �����鿪�����ܼ�:"+SellGroupLots+"\n"+
        "����������:"+BuyGroupProfit+"  ����������:"+SellGroupProfit+"\n"+
        "���������ƹҵ��ܼ�:"+BuyLimitOrders+"  ���������ƹҵ��ܼ�:"+SellLimitOrders+"\n"+"\n"+
        iOrdersSort(OP_BUY,3,0,MyMagicNum)+"  "+iOrdersSort(OP_BUY,3,1,MyMagicNum)+"\n"+
        iOrdersSort(OP_SELL,3,0,MyMagicNum)+"  "+iOrdersSort(OP_SELL,3,1,MyMagicNum)+"\n"+
        "����ֹͣ�ҵ��ܼ�:"+BuyStopOrders+"  ����ֹͣ�ҵ��ܼ�:"+SellStopOrders+"\n"+
        "2%�ʽ������ҶԿ�����:"+iFundsToHands(Symbol(),AccountBalance()*2/100)+"\n"+
        "������0.165����:"+iLotsFormat(Symbol(),0.165));
}

int init()
{
    iShowInfo();
    iDisplayInfo("TradeInfo", "^_^���ֽ���^_^      ", Corner, 5, 50, FontSize, "", Olive);
    //��ʼ��Ԥ�����
    Lots=������;
    ValidStartTime=��Ч���׿�ʼʱ��;
    ValidEndTime=��Ч���׽���ʱ��;
    ServerTime=�Ƿ���÷�����ʱ��;
    MyOrderComment=����ע��;
    MyMagicNum=����������;
    return(0);
}

int deinit()
{
    ObjectsDeleteAll();
    Comment ("");
    return(0);
}

//====����Ϊ�����Զ��庯��====

/*
��    ��:�ļ�����
�������:myFileName--�ļ���
         myFileType--�ļ����ͣ�����0--FILE_BIN��1--FILE_CSV 
         myFileMode--�ļ�����ģʽ������0--�½��ļ���1-����д���ַ�����2-׷��д���ַ���
         myFileString--д���ַ���
�������:
��    ��:
*/
void iFileOperation(string myFileName,int myFileType,int myFileMode,string myFileString)
{
    int myHandle; //�ļ����к�
    if (myFileMode==0 && myFileString=="") //�½��ļ�
    {
        if (myFileType==0) myHandle=FileOpen(myFileName,FILE_BIN|FILE_WRITE);
        if (myFileType==1) myHandle=FileOpen(myFileName,FILE_CSV|FILE_WRITE,";");
        FileClose(myHandle);
    }
    if (myFileMode==1 && myFileString!="") //����д���ַ���
    {
        if (myFileType==0) myHandle=FileOpen(myFileName,FILE_BIN|FILE_WRITE);
        if (myFileType==1) myHandle=FileOpen(myFileName,FILE_CSV|FILE_WRITE,";");
        FileWrite(myHandle,myFileString);
        FileClose(myHandle);
    }
    if (myFileMode==2 && myFileString!="") //׷��д���ַ���
    {
        if (myFileType==0)
        {
            myHandle=FileOpen(myFileName,FILE_BIN|FILE_READ|FILE_WRITE);
            FileSeek(myHandle,0,SEEK_END);
            FileWrite(myHandle,myFileString);
            FileClose(myHandle);
        }
        if (myFileType==1)
        {
            myHandle=FileOpen(myFileName,FILE_CSV|FILE_READ|FILE_WRITE,";");
            FileSeek(myHandle,SEEK_SET,SEEK_END);
            FileWrite(myHandle,myFileString);
            FileClose(myHandle);
        }
    }
    return(0);
}

/*
��    ��:ʱ������ת���ַ�
�������:ʱ�����ڣ�����
�������:ʱ�������ַ�
��    ��:
*/
string iTimeFrameToString(int myTimeFrame)
{
    switch(myTimeFrame)
    {
        case 1:
            return("M1");
            break;
        case 5:
            return("M5");
            break;
        case 15:
            return("M15");
            break;
        case 30:
            return("M30");
            break;
        case 60:
            return("H1");
            break;
        case 240:
            return("H4");
            break;
        case 1440:
            return("D1");
            break;
        case 10080:
            return("W1");
            break;
        case 43200:
            return("MN1");
            break;
    } 
}

/*
��    ������ע���źͻ��ߡ�����
����˵����string myType ��ע���ͣ�Dot���㡢HLine��ˮƽ�ߡ�VLine����ֱ�ߡ�Text��ʾ����
          int myBarPos ָ����������
          double myPrice ָ���۸�����
          color myColor ������ɫ
          int mySymbol ���Ŵ��룬108ΪԲ��
          string myString �������ݣ���ָ��������λ����ʾ����
�������أ���ָ��������ͼ۸�λ�ñ�ע���Ż��߻�ˮƽ�ߡ���ֱ��
*/
void iDrawSign(string myType,int myBarPos,double myPrice,color myColor,int mySymbol,string myString,int myDocSize)
{
    if (myType=="Text")
    {
        string TextBarString=myType+Time[myBarPos];
        ObjectCreate(TextBarString,OBJ_TEXT,0,Time[myBarPos],myPrice);
        ObjectSet(TextBarString,OBJPROP_COLOR,myColor);//��ɫ
        ObjectSet(TextBarString,OBJPROP_FONTSIZE,myDocSize);//��С
        ObjectSetText(TextBarString,myString);//��������
        ObjectSet(TextBarString,OBJPROP_BACK,false);
    }
    if (myType=="Dot")
    {
        string DotBarString=myType+Time[myBarPos];
        ObjectCreate(DotBarString,OBJ_ARROW,0,Time[myBarPos],myPrice);
        ObjectSet(DotBarString,OBJPROP_COLOR,myColor);
        ObjectSet(DotBarString,OBJPROP_ARROWCODE,mySymbol);
        ObjectSet(DotBarString,OBJPROP_BACK,false);
    }
    if (myType=="HLine")
    {
        string HLineBarString=myType+Time[myBarPos];
        ObjectCreate(HLineBarString,OBJ_HLINE,0,Time[myBarPos],myPrice);
        ObjectSet(HLineBarString,OBJPROP_COLOR,myColor);
        ObjectSet(HLineBarString,OBJPROP_BACK,false);
    }
    if (myType=="VLine")
    {
        string VLineBarString=myType+Time[myBarPos];
        ObjectCreate(VLineBarString,OBJ_VLINE,0,Time[myBarPos],myPrice);
        ObjectSet(VLineBarString,OBJPROP_COLOR,myColor);
        ObjectSet(VLineBarString,OBJPROP_BACK,false);
    }
}

/*
��    ��:�������
�������:int myType 0-OP_BUY,1-OP_SELL,2-OP_BUYLIMIT,3-OP_SELLLIMIT,4-OP_BUYSTOP,5-OP_SELLSTOP,9-ȫ��
         double myLots 0-����������,��0�����
         int myMagicNum ����������
�������:
��    ��:
*/
void iBatchClose(int myType,double myLots,int myMagicNum)
{
    for (int cnt=0;cnt<OrdersTotal();cnt++)
    {
        if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)
            && OrderMagicNumber()==myMagicNum
            && OrderSymbol()==Symbol())
        {
            if ((myType==0 || myType==9) 
                && OrderType()==OP_BUY)
            {
                if (myLots==0) myLots=OrderLots();
                if (myLots<OrderLots()) myLots=myLots;
                OrderClose(OrderTicket(),myLots,Bid,0);
                break;
            }
            if ((myType==1 || myType==9) 
                && OrderType()==OP_SELL)
            {
                if (myLots==0) myLots=OrderLots();
                if (myLots<OrderLots()) myLots=myLots;
                OrderClose(OrderTicket(),myLots,Ask,0);
                break;
            }
            if ((myType==OP_BUYLIMIT || myType==OP_SELLLIMIT || myType==OP_BUYSTOP || myType==OP_SELLSTOP || myType==9)
                && ((OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)))
            {
                OrderDelete(OrderTicket());
                break;
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
*/
double iLotsFormat(string mySymbol,double myLots)
{
    if (MarketInfo(mySymbol, MODE_MINLOT)==0) myLots=0;
    else
        myLots=MathRound(myLots/MarketInfo(mySymbol, MODE_MINLOT))*MarketInfo(mySymbol, MODE_MINLOT);//����������
    return(myLots);
}

/*
��    ��:�ֲֵ���ֵ�ܼ�
�������:myOrderType:��������
�������:���롢�����龻ֵ�ܼ�
��    ��:�����㷨
*/
double iGroupEquity(int myOrderType,int myMagicNum)
{
    double myReturn;
    if (OrdersTotal()==0) return(0);
    for (int cnt=0;cnt<OrdersTotal();cnt++)
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
    double myReturn;
    if (OrdersTotal()==0) return(0);
    for (int cnt=0;cnt<OrdersTotal();cnt++)
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
��    ���������ɫ
�����������ֵ
�����������ɫ
��    ��������Ϊ��ɫ������Ϊ��ɫ��0Ϊ��ɫ
*/
color iObjectColor(double myInput)
{
    color myColor;
    if (myInput > 0) myColor = Green; //������ɫΪ��ɫ
    if (myInput < 0) myColor = Red; //������ɫΪ��ɫ
    if (myInput == 0) myColor = DarkGray; //0��ɫΪ��ɫ
    return(myColor);
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
��    ������Чʱ���
���������string myStartTime:��ʼʱ�䣬��׼��ʽΪhh:mm
          string myEndTime:����ʱ�䣬��׼��ʽΪhh:mm
          bool myServerTime:trueΪ������ʱ��, falseΪ�����ʱ��
���������true:��Ч  false:��Ч
��    ����
*/
bool iValidTime(string myStartTime,string myEndTime,bool myServerTime)
{
    bool myValue=false;
    int myST,myET;
    if (myServerTime==true)
    {
        myST=StrToTime(Year()+"."+Month()+"."+Day()+" "+myStartTime);
        myET=StrToTime(Year()+"."+Month()+"."+Day()+" "+myEndTime);
    }
    if (myServerTime==false)
    {
        myST=StrToTime(myStartTime);
        myET=StrToTime(myEndTime);
    }
    if (myST>myET) myET=myET+1440*60;
    if (TimeCurrent()>myST && TimeCurrent()<myET && myServerTime==true)//������ʱ��
    {
        myValue=true;
    }
    if (TimeLocal()>myST && TimeLocal()<myET && myServerTime==false)//�����ʱ��
    {
        myValue=true;
    }
    if (myST==myET) myValue=true;
    return(myValue);
}

/*
��    �������׷�æ������ȴ������»�������
���������
���������
�㷨˵����
*/
void iWait(int myDelayTime) 
{
    while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(myDelayTime);
    RefreshRates();
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

/*
��    ����������ֵת������
���������myTicket:������
���������������ֵ����
��    ����
*/
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

/*
��    �������ת������
���������mySymbol:���Ҷ�  
          myFunds:�ʽ����
���������
��    ����
*/
double iFundsToHands(string mySymbol,double myFunds)
{
    double myLots=myFunds/MarketInfo(mySymbol, MODE_MARGINREQUIRED);//����ɿ�������
    double myMinLOT=MarketInfo(mySymbol, MODE_MINLOT);//��С����������
    if (myMinLOT==0) myLots=0;
    else
        myLots=MathRound(myLots/myMinLOT)*myMinLOT;//��������
    return(myLots);
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
    if (Corner == -1) return(0);
    for (cnt=0;cnt<ObjectsTotal();cnt++)
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