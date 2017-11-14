#property copyright "Copyright 2012, laoyee"
#property link      "http://www.docin.com/yiwence"

#property indicator_separate_window
//----程序预设参数
extern string str1 = "====系统预设参数====";
extern int 本地时区=8;
int TimeZone;
extern string str2 = "====交易所时间表====";
extern string 纽约开市时间="8:30";
string NewYorkStartTime;
extern string 纽约收市时间="15:00";
string NewYorkCloseTime;
extern string 伦敦开市时间="9:30";
string LondonStartTime;
extern string 伦敦收市时间="16:30";
string LondonCloseTime;
extern string 法兰克福开市时间="9:00";
string FrankfurtStartTime;
extern string 法兰克福收市时间="16:00";
string FrankfurtCloseTime;
extern string 东京开市时间="9:00";
string TokyoStartTime;
extern string 东京收市时间="15:30";
string TokyoCloseTime;
extern string 悉尼开市时间="9:00";
string SydneyStartTime;
extern string 悉尼收市时间="17:00";
string SydneyCloseTime;
extern string 惠灵顿开市时间="9:00";
string WellingtonStartTime;
extern string 惠灵顿收市时间="17:00";
string WellingtonCloseTime;

int Corner=0; //交易信息显示四个角位置
int cnt;
datetime GMT;
color myColor=SlateGray;
color TitleColor=Yellow; //标题颜色
color TimeIntervalColor=SlateGray; //小时间隔颜色
color TimeColor=SlateGray; //小时数字颜色
color TradingColor=Green; //交易时间段


int init()
   {
      TimeZone=本地时区;
      NewYorkStartTime=纽约开市时间;
      NewYorkCloseTime=纽约收市时间;
      LondonStartTime=伦敦开市时间;
      LondonCloseTime=伦敦收市时间;
      FrankfurtStartTime=法兰克福开市时间;
      FrankfurtCloseTime=法兰克福收市时间;
      TokyoStartTime=东京开市时间;
      TokyoCloseTime=东京收市时间;
      SydneyStartTime=悉尼开市时间;
      SydneyCloseTime=悉尼收市时间;
      WellingtonStartTime=惠灵顿开市时间;
      WellingtonCloseTime=惠灵顿收市时间;
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
函    数：时间轴
参数说明：string myName 对象名
          int myStartX 起始坐标X
          int myStartY 起始坐标Y
          color myBaseColor 基本颜色
函数返回：
*/
void iTimeLine(string myName,int myStartX,int myStartY,color myBaseColor)
{
    iDisplayInfo(myName,myName, Corner, 5, myStartY, 8, "", TitleColor);
    int myCount=24*12; //每5分钟一个竖线
    int myInterval=myStartX;
    int myTimesBet=12; //小时间隔变量，+12,<288
    int myTimesNum=1; //小时数字，+1 <24
    double myStartHour,myStartMinute,myEndHour,myEndMinute;
    //本地时间轴
    if (myName=="Local")
    {
        myTimesBet=12;
        myTimesNum=1;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,":", Corner, myInterval, myStartY, 8, "", myBaseColor); //绘基础时间柱图形
            //绘当前时间位置、1小时间隔、小时数字、交易时间段
            //----绘1小时间隔、小时数字
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
            }
            //----绘当前时间位置
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+TimeZone*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //惠灵顿时间轴  +12
    if (myName=="Wellington")
    {
        myTimesBet=12;
        myTimesNum=5;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //绘基础时间柱图形
            //绘当前时间位置、1小时间隔、小时数字、交易时间段
            //----绘交易时间段
            myStartHour=TimeHour(StrToTime(WellingtonStartTime));
            myStartMinute=TimeMinute(StrToTime(WellingtonStartTime));
            myEndHour=TimeHour(StrToTime(WellingtonCloseTime));
            myEndMinute=TimeMinute(StrToTime(WellingtonCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60-4)*12 
                && cnt<=(myEndHour+myEndMinute/60-4)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //绘交易时间段
            }
            //----绘1小时间隔、小时数字
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----绘当前时间位置
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+12*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //悉尼时间轴  +10
    if (myName=="Sydney")
    {
        myTimesBet=12;
        myTimesNum=3;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //绘基础时间柱图形
            //绘当前时间位置、1小时间隔、小时数字、交易时间段
            //----绘交易时间段
            myStartHour=TimeHour(StrToTime(SydneyStartTime));
            myStartMinute=TimeMinute(StrToTime(SydneyStartTime));
            myEndHour=TimeHour(StrToTime(SydneyCloseTime));
            myEndMinute=TimeMinute(StrToTime(SydneyCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60-2)*12 
                && cnt<=(myEndHour+myEndMinute/60-2)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //绘交易时间段
            }
            //----绘1小时间隔、小时数字
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----绘当前时间位置
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+10*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //东京时间轴  +9
    if (myName=="Tokyo")
    {
        myTimesBet=12;
        myTimesNum=2;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //绘基础时间柱图形
            //绘当前时间位置、1小时间隔、小时数字、交易时间段
            //----绘交易时间段
            myStartHour=TimeHour(StrToTime(TokyoStartTime));
            myStartMinute=TimeMinute(StrToTime(TokyoStartTime));
            myEndHour=TimeHour(StrToTime(TokyoCloseTime));
            myEndMinute=TimeMinute(StrToTime(TokyoCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60-1)*12 
                && cnt<=(myEndHour+myEndMinute/60-1)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //绘交易时间段
            }
            //----绘1小时间隔、小时数字
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----绘当前时间位置
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+9*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //法兰克福时间轴  +1
    if (myName=="Frankfurt")
    {
        myTimesBet=12;
        myTimesNum=18;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //绘基础时间柱图形
            //绘当前时间位置、1小时间隔、小时数字、交易时间段
            //----绘交易时间段
            myStartHour=TimeHour(StrToTime(FrankfurtStartTime));
            myStartMinute=TimeMinute(StrToTime(FrankfurtStartTime));
            myEndHour=TimeHour(StrToTime(FrankfurtCloseTime));
            myEndMinute=TimeMinute(StrToTime(FrankfurtCloseTime));
            if (cnt>=(myStartHour+myStartMinute/60+7)*12 
                && cnt<=(myEndHour+myEndMinute/60+7)*12)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //绘交易时间段
            }
            //----绘1小时间隔、小时数字
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----绘当前时间位置
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+1*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //伦敦时间轴  +0
    if (myName=="London(GMT)")
    {
        myTimesBet=12;
        myTimesNum=17;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //绘基础时间柱图形
            //绘当前时间位置、1小时间隔、小时数字、交易时间段
            //----绘交易时间段
            myStartHour=TimeHour(StrToTime(LondonStartTime));
            myStartMinute=TimeMinute(StrToTime(LondonStartTime));
            myEndHour=TimeHour(StrToTime(LondonCloseTime));
            myEndMinute=TimeMinute(StrToTime(LondonCloseTime));
            if ((cnt>=(myStartHour+myStartMinute/60+8)*12 
                && cnt<=(myEndHour+myEndMinute/60+8)*12)
                ||((myEndHour+myEndMinute/60+8)*12>288 
                    && cnt>=0 && cnt<=(myEndHour+myEndMinute/60+8)*12-288))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //绘交易时间段
            }
            
            //----绘1小时间隔、小时数字
            if (cnt==myTimesBet)
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TimeIntervalColor);
                iDisplayInfo(myTimesNum+myName+cnt,myTimesNum, Corner, myInterval-2, myStartY+12, 7, "", SlateGray);
                myTimesBet=myTimesBet+12;
                myTimesNum=myTimesNum+1;
                if (myTimesNum==24) myTimesNum=0;
            }
            //----绘当前时间位置
            if (cnt==MathFloor((TimeLocal()-iTime(NULL,1440,0))/300))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", Red);
            }
            myInterval=myInterval+2;
        }
        iDisplayInfo(myName+"Time",TimeToStr(GMT+0*3600,TIME_DATE|TIME_SECONDS), Corner, myInterval+10, myStartY, 8, "", TitleColor);
    }
    //纽约时间轴  -5
    if (myName=="NewYork")
    {
        myTimesBet=12;
        myTimesNum=12;
        for (cnt=0;cnt<myCount;cnt++)
        {
            iDisplayInfo(myName+cnt,".", Corner, myInterval, myStartY, 8, "", myBaseColor); //绘基础时间柱图形
            //绘当前时间位置、1小时间隔、小时数字、交易时间段
            //----绘交易时间段
            myStartHour=TimeHour(StrToTime(NewYorkStartTime));
            myStartMinute=TimeMinute(StrToTime(NewYorkStartTime));
            myEndHour=TimeHour(StrToTime(NewYorkCloseTime));
            myEndMinute=TimeMinute(StrToTime(NewYorkCloseTime));
            if ((cnt>=(myStartHour+myStartMinute/60+13)*12 
                && cnt<=(myEndHour+myEndMinute/60+13)*12)
                ||((myEndHour+myEndMinute/60+13)*12>288 
                    && cnt>=0 && cnt<=(myEndHour+myEndMinute/60+13)*12-288))
            {
                iDisplayInfo(myName+cnt,"|", Corner, myInterval, myStartY, 8, "", TradingColor); //绘交易时间段
            }
            //----绘当前时间位置
            //----绘1小时间隔、小时数字
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
    //清除标签
    int myWindowsHandle = WindowFind(WindowExpertName()); //获取当前指标名称所在窗口序号
    ObjectsDeleteAll(myWindowsHandle, OBJ_LABEL);
    GMT=TimeLocal()-TimeZone*3600;
    iDisplayInfo("Author", "[联系老易 QQ:921795]", Corner, 90, 3, 7, "", SlateGray);
    iDisplayInfo("ServerTime","Server  "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS), Corner, 230, 3, 8, "", TitleColor);
    //绘时间轴
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
函    数：在屏幕上显示文字标签
输入参数：string LableName 标签名称，如果显示多个文本，名称不能相同
          string LableDoc 文本内容
          int Corner 文本显示角
          int LableX 标签X位置坐标
          int LableY 标签Y位置坐标
          int DocSize 文本字号
          string DocStyle 文本字体
          color DocColor 文本颜色
输出参数：在指定的位置（X,Y）按照指定的字号、字体及颜色显示指定的文本
算法说明：
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