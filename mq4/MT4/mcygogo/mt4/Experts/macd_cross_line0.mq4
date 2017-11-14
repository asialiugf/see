//+------------------------------------------------------------------+
//|                                                        test2.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |

//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int mark=0;           //ȫ�ֱ��� //�����ظ���������
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {

  //double current;
  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("macd");   //�ر�EA,ɾ������
    ObjectDelete("macd2");   //�ر�EA,ɾ������
     ObjectDelete("macd3");   //�ر�EA,ɾ������
      ObjectDelete("macd4");   //�ر�EA,ɾ������
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
double macdcurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);   //�����ڲ�MACD����������ֵ  Ϊ��ǰ+1�۸�λ��
double macdprevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,2);  //�����ڲ�MACD����������ֵ  Ϊ��ǰ+2�۸�λ�� 
wt("macd","MACD�����֣�  "+DoubleToStr(macdcurrent,Digits),1,20,20,Yellow,11);     //��Ļ��� 
wt("macd2","MACD����ǰ��  "+DoubleToStr(macdprevious,Digits),1,20,40,Red,11);     //��Ļ���

//string nameo;
//nameo=ObjectDescription("macd");
//Print(nameo);
//###########################################################�ж�ͻ��0����ܼ򵥡� ��λ��ϰ����Ļֱ�����������������ѧϰ��
    
if( macdcurrent>0.0000 && macdprevious<0.0000 && mark!=1)   //�ж��Ƿ�ͻ��
    {
    wt("macd3","MACD����״̬��  ��ͻ��0��",1,20,60,Red,11);            //��Ļ���
    ObjectDelete("macd4");                                            //ɾ������ͻ����ʾ
    
    Alert(Symbol(),"MACD��������ͻ��0");                             //������ʾ
     mark=1;                                                         //�����ظ���������
    } 
//   else
//   {
//   wt("macd3","MACD��ͻ��0�᣺  pending......",1,20,60,Red,11);    //��Ļ���
//  }
if( macdcurrent<0.0000 && macdprevious>0.0000 && mark!=2)      //�ж��Ƿ�ͻ��
    {
    wt("macd4","MACD����״̬��  ��ͻ��0��",1,20,80,Red,11);    //��Ļ���
    ObjectDelete("macd3");
    
     Alert(Symbol(),"MACD��������ͻ��0");                       //����
     mark=2;                                                      //�����ظ���������
    }
//   else
//   {
//  wt("macd4","MACD��ͻ��0�᣺  pending......",1,20,80,Red,11);       //��Ļ���
//  }
//----
   return(0);
  }
//�Զ��庯��  
void wt(string labelname,string date,int j,int x,int y,color colorvalue,int fontsize) //����WT����������������ʾ��
{
   ObjectDelete(labelname);
   ObjectCreate(labelname,OBJ_LABEL,0,0,0);
   ObjectSetText(labelname,date,fontsize,"arial",colorvalue);
   ObjectSet(labelname,OBJPROP_CORNER,j);
   ObjectSet(labelname,OBJPROP_XDISTANCE,x);
   ObjectSet(labelname,OBJPROP_YDISTANCE,y);
}

