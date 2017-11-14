#property copyright "Copyright 2012, laoyee"
#property link      "http://www.docin.com/yiwence"

#property indicator_separate_window
//----����Ԥ�����
extern string str1 = "====ϵͳԤ�����====";
extern int ����ʱ��=8;
int TimeZone;
extern string str2 = "====������ʱ���====";
extern string ŦԼ����ʱ��="8:30";
string NewYorkStartTime;
extern string ŦԼ����ʱ��="15:00";
string NewYorkCloseTime;
extern string �׶ؿ���ʱ��="9:30";
string LondonStartTime;
extern string �׶�����ʱ��="16:30";
string LondonCloseTime;
extern string �����˸�����ʱ��="9:00";
string FrankfurtStartTime;
extern string �����˸�����ʱ��="16:00";
string FrankfurtCloseTime;
extern string ��������ʱ��="9:00";
string TokyoStartTime;
extern string ��������ʱ��="15:30";
string TokyoCloseTime;
extern string Ϥ�Ὺ��ʱ��="9:00";
string SydneyStartTime;
extern string Ϥ������ʱ��="17:00";
string SydneyCloseTime;
extern string ����ٿ���ʱ��="9:00";
string WellingtonStartTime;
extern string ���������ʱ��="17:00";
string WellingtonCloseTime;

int Corner=0; //������Ϣ��ʾ�ĸ���λ��
int cnt;
datetime GMT;
color myColor=SlateGray;
color TitleColor=Yellow; //������ɫ
color TimeIntervalColor=SlateGray; //Сʱ�����ɫ
color TimeColor=SlateGray; //Сʱ������ɫ
color TradingColor=Green; //����ʱ���


int init()
   {
      TimeZone=����ʱ��;
      NewYorkStartTime=ŦԼ����ʱ��;
      NewYorkCloseTime=ŦԼ����ʱ��;
      LondonStartTime=�׶ؿ���ʱ��;
      LondonCloseTime=�׶�����ʱ��;
      FrankfurtStartTime=�����˸�����ʱ��;
      FrankfurtCloseTime=�����˸�����ʱ��;
      TokyoStartTime=��������ʱ��;
      TokyoCloseTime=��������ʱ��;
      SydneyStartTime=Ϥ�Ὺ��ʱ��;
      SydneyCloseTime=Ϥ������ʱ��;
      WellingtonStartTime=����ٿ���ʱ��;
      WellingtonCloseTime=���������ʱ��;
      return(0);
   }

int deinit()
   {
      Comment("");
      return(0);
   }

int start()
   {
      iMain();
      return(0);
   }

/*
��    ����ʱ����
����˵����string myName ������
          int myStartX ��ʼ����X
          int myStartY ��ʼ����Y
          color myBaseColor ������ɫ
�������أ�
*/
void iTimeLine(string myName,int myStartX,int myStartY,color myBaseColor)
{
    iDisplayInfo(myName,myName, Corner, 5, myStartY, 8, "", TitleColor);
    int myCount=24*12; //ÿ5����һ������
    int myInterval=myStartX;
    int myTimesBet=12; //Сʱ���������+12,<288
    int myTimesNum=1; //Сʱ���֣�+1 <24
    double myStartHour,myStartMinute,myEndHour,myEndMinute;
    //����ʱ����
    if (myName=="Local")
    {
        myTimesBet=12;
        myTimesNum=1;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,":", Corner, myInterval, myStartY, 8, "", myBaseColor); //�����ʱ����ͼ��
            //�浱ǰʱ��λ�á�1Сʱ�����Сʱ���֡�����ʱ���
            //----��1Сʱ�����Сʱ����
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
            }
            //----�浱ǰʱ��λ��
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+TimeZone*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //�����ʱ����  +12
    if (myName=="Wellington")
    {
        myTimesBet=12;
        myTimesNum=5;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //�����ʱ����ͼ��
            //�浱ǰʱ��λ�á�1Сʱ�����Сʱ���֡�����ʱ���
            //----�潻��ʱ���
            myStartHour=TimeHour(StrToTime(WellingtonStartTime));
            myStartMinute=TimeMinute(StrToTime(WellingtonStartTime));
            myEndHour=TimeHour(StrToTime(WellingtonCloseTime));
            myEndMinute=TimeMinute(StrToTime(WellingtonCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60-4)*12 
                && cnt<=(myEndHour+myEndMinute/60-4)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //�潻��ʱ���
            }
            //----��1Сʱ�����Сʱ����
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----�浱ǰʱ��λ��
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+12*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //Ϥ��ʱ����  +10
    if (myName=="Sydney")
    {
        myTimesBet=12;
        myTimesNum=3;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //�����ʱ����ͼ��
            //�浱ǰʱ��λ�á�1Сʱ�����Сʱ���֡�����ʱ���
            //----�潻��ʱ���
            myStartHour=TimeHour(StrToTime(SydneyStartTime));
            myStartMinute=TimeMinute(StrToTime(SydneyStartTime));
            myEndHour=TimeHour(StrToTime(SydneyCloseTime));
            myEndMinute=TimeMinute(StrToTime(SydneyCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60-2)*12 
                && cnt<=(myEndHour+myEndMinute/60-2)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //�潻��ʱ���
            }
            //----��1Сʱ�����Сʱ����
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----�浱ǰʱ��λ��
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+10*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //����ʱ����  +9
    if (myName=="Tokyo")
    {
        myTimesBet=12;
        myTimesNum=2;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //�����ʱ����ͼ��
            //�浱ǰʱ��λ�á�1Сʱ�����Сʱ���֡�����ʱ���
            //----�潻��ʱ���
            myStartHour=TimeHour(StrToTime(TokyoStartTime));
            myStartMinute=TimeMinute(StrToTime(TokyoStartTime));
            myEndHour=TimeHour(StrToTime(TokyoCloseTime));
            myEndMinute=TimeMinute(StrToTime(TokyoCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60-1)*12 
                && cnt<=(myEndHour+myEndMinute/60-1)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //�潻��ʱ���
            }
            //----��1Сʱ�����Сʱ����
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----�浱ǰʱ��λ��
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+9*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //�����˸�ʱ����  +1
    if (myName=="Frankfurt")
    {
        myTimesBet=12;
        myTimesNum=18;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //�����ʱ����ͼ��
            //�浱ǰʱ��λ�á�1Сʱ�����Сʱ���֡�����ʱ���
            //----�潻��ʱ���
            myStartHour=TimeHour(StrToTime(FrankfurtStartTime));
            myStartMinute=TimeMinute(StrToTime(FrankfurtStartTime));
            myEndHour=TimeHour(StrToTime(FrankfurtCloseTime));
            myEndMinute=TimeMinute(StrToTime(FrankfurtCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60+7)*12 
                && cnt<=(myEndHour+myEndMinute/60+7)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //�潻��ʱ���
            }
            //----��1Сʱ�����Сʱ����
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----�浱ǰʱ��λ��
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+1*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //�׶�ʱ����  +0
    if (myName=="London(GMT)")
    {
        myTimesBet=12;
        myTimesNum=17;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //�����ʱ����ͼ��
            //�浱ǰʱ��λ�á�1Сʱ�����Сʱ���֡�����ʱ���
            //----�潻��ʱ���
            myStartHour=TimeHour(StrToTime(LondonStartTime));
            myStartMinute=TimeMinute(StrToTime(LondonStartTime));
            myEndHour=TimeHour(StrToTime(LondonCloseTime));
            myEndMinute=TimeMinute(StrToTime(LondonCloseTime));
            if ((cnt>=(myStartHour+myStartMinute/60+8)*12 
                && cnt<=(myEndHour+myEndMinute/60+8)*12)
                ||((myEndHour+myEndMinute/60+8)*12>288 
                    && cnt>=0 && cnt<=(myEndHour+myEndMinute/60+8)*12-288))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //�潻��ʱ���
            }
            
            //----��1Сʱ�����Сʱ����
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----�浱ǰʱ��λ��
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+0*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //ŦԼʱ����  -5
    if (myName=="NewYork")
    {
        myTimesBet=12;
        myTimesNum=12;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //�����ʱ����ͼ��
            //�浱ǰʱ��λ�á�1Сʱ�����Сʱ���֡�����ʱ���
            //----�潻��ʱ���
            myStartHour=TimeHour(StrToTime(NewYorkStartTime));
            myStartMinute=TimeMinute(StrToTime(NewYorkStartTime));
            myEndHour=TimeHour(StrToTime(NewYorkCloseTime));
            myEndMinute=TimeMinute(StrToTime(NewYorkCloseTime));
            if ((cnt>=(myStartHour+myStartMinute/60+13)*12 
                && cnt<=(myEndHour+myEndMinute/60+13)*12)
                ||((myEndHour+myEndMinute/60+13)*12>288 
                    && cnt>=0 && cnt<=(myEndHour+myEndMinute/60+13)*12-288))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //�潻��ʱ���
            }
            //----�浱ǰʱ��λ��
            //----��1Сʱ�����Сʱ����
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT-5*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
}

void iMain()
{
    //�����ǩ
    int myWindowsHandle = WindowFind(WindowExpertName()); //��ȡ��ǰָ���������ڴ������
    ObjectsDeleteAll(myWindowsHandle, OBJ_LABEL);
    GMT=TimeLocal()-TimeZone*3600;
    iDisplayInfo("Author", "[��ϵ���� QQ:921795]", Corner, 90, 3, 7, "", SlateGray);
    iDisplayInfo("ServerTime","Server  "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS), Corner, 230, 3, 8, "", TitleColor);
    //��ʱ����
    iTimeLine("Local",80,15,myColor);
    iTimeLine("Tokyo",80,35,myColor);
    iTimeLine("Sydney",80,55,myColor);
    iTimeLine("Wellington",80,75,myColor);
    iTimeLine("NewYork",80,95,myColor);
    iTimeLine("London(GMT)",80,115,myColor);
    iTimeLine("Frankfurt",80,135,myColor);
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
      int myWindowsHandle = WindowFind(WindowExpertName());
      ObjectCreate(LableName, OBJ_LABEL, myWindowsHandle, 0, 0);
      ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor);
      ObjectSet(LableName, OBJPROP_CORNER, Corner);
      ObjectSet(LableName, OBJPROP_XDISTANCE, LableX);
      ObjectSet(LableName, OBJPROP_YDISTANCE, LableY);
      return(0);
   }