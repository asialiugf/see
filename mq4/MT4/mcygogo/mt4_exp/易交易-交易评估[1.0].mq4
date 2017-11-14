#property copyright "laoyee"
#property link      "qq:921795"
//ָ������ͼ��ʾ
#property indicator_chart_window
extern bool DisplayText=true;
extern color TextColor=Yellow;
int cnt;
string TextBarString,DotBarString,HLineBarString,VLineBarString; 
double myLots; //��ǰ�ֲ�����
color myLineColor; //��ɫ����

int start()
{
    iDisplayText(); //��Ϣģ��
    iDrawLine(); //����ģ��
    return(0);
}

void iDisplayText()
{
    if (DisplayText==false) return(0);
    //����ͳ�Ʊ���
    int BuyHistoryOrders,SellHistoryOrders,HistoryOrderTotal; //������ʷ������������ʷ��������ʷ��������
    int WinHistory,LossHistory; //��ʷӯ���������ۼ�
    double TotalHistoryLots;//��ʷ����������
    double TotalHistoryProfit,TotalHistoryLoss;//ӯ��������������������
    double myWinRate; //ʤ�ʱ���
    double myWinAvg,myLossAvg; //ƽ��ӯ��������
    double myOdds; //���ʱ���
    double myKelly; //����ָ�����
    double myMaxLots; //�ֲ����Ʊ���
    //������ر���
    for (cnt=0;cnt<=OrdersHistoryTotal()-1;cnt++)
    {
        if (OrderSelect(cnt,SELECT_BY_POS,MODE_HISTORY)
            && OrderSymbol()==Symbol() //ѡ��ǰ���Ҷ�
            && (OrderType()==OP_BUY || OrderType()==OP_SELL)
           )
        {
            if (OrderType()==OP_BUY) BuyHistoryOrders=BuyHistoryOrders+1; //���뵥�ۼ�
            if (OrderType()==OP_SELL) SellHistoryOrders=SellHistoryOrders+1; //���뵥�ۼ�
            if (OrderProfit()>=0)
            {
                WinHistory=WinHistory+1; //ӯ���������������������ۼ�
                TotalHistoryProfit=TotalHistoryProfit+OrderProfit(); //��ӯ������ۼ�
            }
            if (OrderProfit()<0)
            {
                LossHistory=LossHistory+1; //���������ۼ�
                TotalHistoryLoss=TotalHistoryLoss+OrderProfit(); //�ܿ��������ۼ�
            }
            TotalHistoryLots=TotalHistoryLots+OrderLots(); //�����������֣�
        }
    }
    HistoryOrderTotal=BuyHistoryOrders+SellHistoryOrders; //��ʷ�������ܼ�
    //����ʤ��
    if (WinHistory+LossHistory>0)
    {
        myWinRate=(WinHistory*1.00)/((WinHistory+LossHistory)*1.00)*100; //ʤ�ʱ�����int����תdouble����
    }
    if (WinHistory>0) myWinAvg=TotalHistoryProfit/WinHistory; //����ƽ��ӯ��
    if (LossHistory>0) myLossAvg=TotalHistoryLoss/LossHistory; //����ƽ������
    //��������
    if (myLossAvg!=0) myOdds=MathAbs(myWinAvg/myLossAvg); //��������=ƽ��ӯ��/ƽ������
    //���㿭��ָ��
    if (myOdds!=0) myKelly=MathAbs(((myOdds+1)*(myWinRate/100)-1)/myOdds);
    //�������ֲ�����
    if (MarketInfo(Symbol(), MODE_MARGINREQUIRED)!=0)
    {
        myMaxLots=AccountBalance()*myKelly/MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    }

    
    
    //��ʾͳ����Ϣ
    iDisplayInfo("jypg-Author", "[��ϵ���� QQ:921795]",0,210,1,7,"",Gray);
    iDisplayInfo("jypg-Times","��̬����ʱ��:"+TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS)+" ����"+DayOfWeek(),0,4,15,9,"Verdana",TextColor);
    iDisplayInfo("jypg-HistoryOrderTotal", "��ʷ���׵��ܼ�:"+HistoryOrderTotal+"  �������뵥:"+BuyHistoryOrders+"  ������:"+SellHistoryOrders,0,4,35,9,"",TextColor);
    iDisplayInfo("jypg-HistoryWinLoss", "��ʷӯ�����ܼ�:"+WinHistory+"  ��ʷ����:"+LossHistory+"  ʤ��:"+DoubleToStr(myWinRate,2)+"%",0,4,50,9,"",TextColor);
    iDisplayInfo("jypg-HistoryLots", "��ʷ���µ���:"+DoubleToStr(TotalHistoryLots,2)+"��"+"  ��ӯ��:"+DoubleToStr(TotalHistoryProfit,2)+"  �ܿ���:"+DoubleToStr(TotalHistoryLoss,2),0,4,65,9,"",TextColor);
    iDisplayInfo("AverageRate", "�˻�����:"+DoubleToStr(TotalHistoryProfit+TotalHistoryLoss,2)+"  ƽ��ӯ��:"+DoubleToStr(myWinAvg,2)+"  ƽ������:"+DoubleToStr(myLossAvg,2),0,4,80,9,"",TextColor);
    iDisplayInfo("Kelly", "����:"+DoubleToStr(myOdds,2)+"  ����ָ��:"+DoubleToStr(myKelly*100,2)+"%"+"  ���ֲ�����:"+DoubleToStr(myMaxLots,2)+"��",0,4,95,9,"",TextColor);

}

void iDrawLine()
{
   //����ʷ��
   //������ʷ���������������Ϣ
   for (cnt=0;cnt<=OrdersHistoryTotal()-1;cnt++)
   {
      if (OrderSelect(cnt,SELECT_BY_POS,MODE_HISTORY))
      {
         if (OrderType()==OP_BUY)
         {
            if (OrderProfit()>0)  myLineColor=Blue;
            if (OrderProfit()<0)  myLineColor=Red;
            if (OrderSymbol()==Symbol()) //ֻ����ǰ���Ҷ�ͼ��
            {
               iTwoPointsLine(TimeToStr(OrderOpenTime()),OrderOpenTime(),OrderOpenPrice(),OrderCloseTime(),OrderClosePrice(),2,myLineColor);
               iDrawSign("Text",iBarShift(OrderSymbol(),0,OrderOpenTime()),OrderOpenPrice(),myLineColor,0,DoubleToStr(OrderTicket(),0)+" buy",8);
            }
         }
         if (OrderType()==OP_SELL)
         {
            if (OrderProfit()>0)  myLineColor=Blue;
            if (OrderProfit()<0)  myLineColor=Red;
            if (OrderSymbol()==Symbol()) //ֻ����ǰ���Ҷ�ͼ��
            {
               iTwoPointsLine(TimeToStr(OrderOpenTime()),OrderOpenTime(),OrderOpenPrice(),OrderCloseTime(),OrderClosePrice(),3,myLineColor);
               iDrawSign("Text",iBarShift(OrderSymbol(),0,OrderOpenTime()),OrderOpenPrice(),myLineColor,0,DoubleToStr(OrderTicket(),0)+" sell",8);
            }
         }
      }
   }
   //���ֲֵ�
   for (cnt=0;cnt<OrdersTotal();cnt++)
   {
      if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
      {
         myLots=myLots+OrderLots();
         //���ֲֵ��߶Σ���̬
         if (OrderProfit()>0)  myLineColor=Blue;
         if (OrderProfit()<0)  myLineColor=Red;
         if (OrderSymbol()==Symbol() && OrderType()==OP_BUY)
         {
            ObjectDelete(TimeToStr(OrderOpenTime()));
            ObjectDelete("Text"+OrderOpenTime());
            iTwoPointsLine(TimeToStr(OrderOpenTime()),OrderOpenTime(),OrderOpenPrice(),Time[0],Bid,2,myLineColor);
            iDrawSign("Text",iBarShift(OrderSymbol(),0,OrderOpenTime()),OrderOpenPrice(),myLineColor,0,DoubleToStr(OrderTicket(),0)+" buy",8);
         }
         if (OrderSymbol()==Symbol() && OrderType()==OP_SELL)
         {
            ObjectDelete(TimeToStr(OrderOpenTime()));
            ObjectDelete("Text"+OrderOpenTime());
            iTwoPointsLine(TimeToStr(OrderOpenTime()),OrderOpenTime(),OrderOpenPrice(),Time[0],Ask,3,myLineColor);
            iDrawSign("Text",iBarShift(OrderSymbol(),0,OrderOpenTime()),OrderOpenPrice(),myLineColor,0,DoubleToStr(OrderTicket(),0)+" sell",8);
         }
      }
   }
}

int init()
{
   return(0);
}

int deinit()
{
   Comment("");
   ObjectsDeleteAll(0);
   return(0);
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
      ObjectCreate(LableName, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor);
      ObjectSet(LableName, OBJPROP_CORNER, Corner);
      ObjectSet(LableName, OBJPROP_XDISTANCE, LableX);
      ObjectSet(LableName, OBJPROP_YDISTANCE, LableY);
   }
/*
��    �������������(��ͼ)
���������string myLineName  �߶�����
          int myFirstTime  ���ʱ��
          int myFirstPrice  ���۸�
          int mySecondTime  �յ�ʱ��
          int mySecondPrice  �յ�۸�
          int myLineStyle  ���� 0-ʵ�� 1-���� 2-���� 3-�㻮�� 4-˫�㻮��
          color myLineColor ��ɫ
�����������ָ�������������
�㷨˵����
*/
void iTwoPointsLine(string myLineName,int myFirstTime,double myFirstPrice,int mySecondTime,double mySecondPrice,int myLineStyle,color myLineColor)
   {
      ObjectCreate(myLineName,OBJ_TREND,0,myFirstTime,myFirstPrice,mySecondTime,mySecondPrice);//ȷ����������
      ObjectSet(myLineName,OBJPROP_STYLE,myLineStyle); //����
      ObjectSet(myLineName,OBJPROP_COLOR,myLineColor); //��ɫ
      ObjectSet(myLineName,OBJPROP_WIDTH, 1); //�߿�
      ObjectSet(myLineName,OBJPROP_BACK,false);
      ObjectSet(myLineName,OBJPROP_RAY,false);
   }
   
/*
��    ������ע���źͻ��ߡ�����
����˵����string myType ��ע���ͣ�Dot���㡢HLine��ˮƽ�ߡ�VLine����ֱ�ߡ�myString��ʾ����
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
               TextBarString=myType+Time[myBarPos];
               ObjectCreate(TextBarString,OBJ_TEXT,0,Time[myBarPos],myPrice);
               ObjectSet(TextBarString,OBJPROP_COLOR,myColor);//��ɫ
               ObjectSet(TextBarString,OBJPROP_FONTSIZE,myDocSize);//��С
               ObjectSetText(TextBarString,myString);//��������
               ObjectSet(TextBarString,OBJPROP_BACK,true);
            }
         if (myType=="Dot")
            {
               DotBarString=myType+Time[myBarPos];
               ObjectCreate(DotBarString,OBJ_ARROW,0,Time[myBarPos],myPrice);
               ObjectSet(DotBarString,OBJPROP_COLOR,myColor);
               ObjectSet(DotBarString,OBJPROP_ARROWCODE,mySymbol);
               ObjectSet(DotBarString,OBJPROP_BACK,false);
            }
         if (myType=="HLine")
            {
               HLineBarString=myType+Time[myBarPos];
               ObjectCreate(HLineBarString,OBJ_HLINE,0,Time[myBarPos],myPrice);
               ObjectSet(HLineBarString,OBJPROP_COLOR,myColor);
               ObjectSet(HLineBarString,OBJPROP_BACK,false);
            }
         if (myType=="VLine")
            {
               VLineBarString=myType+Time[myBarPos];
               ObjectCreate(VLineBarString,OBJ_VLINE,0,Time[myBarPos],myPrice);
               ObjectSet(VLineBarString,OBJPROP_COLOR,myColor);
               ObjectSet(VLineBarString,OBJPROP_BACK,false);
            }
     }

