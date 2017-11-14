#property copyright "Copyright 2012, laoyee"
#property link      "http://www.docin.com/yiwence"

//----程序预设参数
extern string str1 = "====系统预设参数====";
extern double 开仓量=1;
double Lots;
extern string str2 = "====技术指标参数====";

extern string 有效交易开始时间="00:00";
string ValidStartTime;
extern string 有效交易结束时间="00:00";
string ValidEndTime;
extern bool 是否采用服务器时间=true;
bool ServerTime;
//订单控制参数
string 订单注释="";
string MyOrderComment;
int 订单特征码=0;
int MyMagicNum;

//----程序控制参数
int BuyGroupOrders, SellGroupOrders; //买入、卖出组成交持仓单数量总计
int BuyLimitOrders, SellLimitOrders; //买入限制挂单、卖出限制挂单数量总计
int BuyStopOrders, SellStopOrders; //买入停止挂单、卖出停止挂单数量总计
double BuyGroupLots, SellGroupLots; //买入、卖出组成交持仓单开仓量总计
double BuyGroupProfit, SellGroupProfit; //买入、卖出组成交持仓单利润总计
int BuyGroupFirstTicket, SellGroupFirstTicket; //买入、卖出组第一单单号
int BuyGroupLastTicket, SellGroupLastTicket; //买入、卖出组最后一单单号
int BuyGroupMaxProfitTicket, SellGroupMaxProfitTicket; //买入、卖出组最大盈利单单号
int BuyGroupMinProfitTicket, SellGroupMinProfitTicket; //买入、卖出组最小盈利单单号
int BuyGroupMaxLossTicket, SellGroupMaxLossTicket; //买入、卖出组最大亏损单单号
int BuyGroupMinLossTicket, SellGroupMinLossTicket; //买入、卖出组最小亏损单单号
int Corner=1; //交易信息显示四个角位置
int FontSize=9; //提示信息字号
bool CloseAll=false; //清仓变量
int cnt,i,j; //计数器变量
int TradingDelay=1000; //交易延时变量，1000毫秒
int start()
{
    iMain();
    return(0);
}

/*
函    数：主控程序
输入参数：
输出参数：
算    法：
*/
void iMain()
{
    iWait(TradingDelay);
    iShowInfo();
    //清仓优先
    //---- 如果空仓，则不清仓
    if (BuyGroupOrders+SellGroupOrders+BuyLimitOrders+SellLimitOrders+BuyStopOrders+SellStopOrders==0) CloseAll=false;
    if (CloseAll==true && (BuyGroupOrders+SellGroupOrders)>0)
    {
        iBatchClose(9,0,MyMagicNum);
        return(0);
    }
    //---- 结束清仓
    iTradingSignals();
    return(0);
}

/*
函    数：计算交易信号
输入参数：
输出参数：N/A-无信号
算    法：
*/
string iTradingSignals()
{
    string myReturn="N/A";//预定义返回变量
    
    if (!iValidTime(ValidStartTime,ValidEndTime,ServerTime))//无效时间段内，不发送交易信号
    {
        myReturn="N/A";
    }
    return(myReturn);
}

/*
函    数：显示交易信息
输入参数：
输出参数：
算    法：
*/
void iShowInfo()
{
    int myLastError=GetLastError();
    if (myLastError>0)
    {
        iDisplayInfo("LastErrorStr", iGetErrorInfo(myLastError), Corner, 180, 5, 12, "", Red);
    }
    //计算22个基本控单变量
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
    //显示基本信息
    iDisplayInfo("Author", "作者:老易 QQ:921795", Corner, 18, 15, 8, "", SlateGray);
    iDisplayInfo("Symbol", Symbol(), Corner, 25, 30, 14, "Arial Bold", DodgerBlue);
    //显示订单信息
    iDisplayInfo(Symbol()+"-BuyGroup", "买入组", Corner, 70, 70, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"-SellGroup", "卖出组", Corner, 5, 70, 12, "Arial", Green);
    iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
    //显示买入组信息
    iDisplayInfo(Symbol()+"-BuyGroup", "买入组", Corner, 70, 70, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
    iDisplayInfo(Symbol()+"BuyOrders", BuyGroupOrders+"  "+BuyLimitOrders+"  "+BuyStopOrders, Corner, 80, 110, 10, "Arial", iObjectColor(BuyGroupProfit));
    iDisplayInfo(Symbol()+"BuyGroupLots", DoubleToStr(BuyGroupLots, 2), Corner, 80, 125, 10, "Arial", iObjectColor(BuyGroupProfit));
    iDisplayInfo(Symbol()+"BuyGroupProfit", DoubleToStr(BuyGroupProfit, 2), Corner, 80, 140, 10, "Arial", iObjectColor(BuyGroupProfit));
    //显示卖出组信息
    iDisplayInfo(Symbol()+"-SellGroup", "卖出组", Corner, 5, 70, 12, "Arial", Green);
    iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
    iDisplayInfo(Symbol()+"SellOrders", SellGroupOrders+"  "+SellLimitOrders+"  "+SellStopOrders, Corner, 10, 110, 10, "Arial", iObjectColor(SellGroupProfit));
    iDisplayInfo(Symbol()+"SellGroupLots", DoubleToStr(SellGroupLots, 2), Corner, 10, 125, 10, "Arial", iObjectColor(SellGroupProfit));
    iDisplayInfo(Symbol()+"SellGroupProfit", DoubleToStr(SellGroupProfit, 2), Corner, 10, 140, 10, "Arial", iObjectColor(SellGroupProfit));
Comment("买入组持仓单总计:"+BuyGroupOrders+"  卖出组持仓单总计:"+SellGroupOrders+"\n"+
        "买入组第1单单号:"+BuyGroupFirstTicket+"  卖出组第1单单号:"+SellGroupFirstTicket+"\n"+
        "买入组最后1单单号:"+BuyGroupLastTicket+"  卖出组最后1单单号:"+SellGroupLastTicket+"\n"+"\n"+

        "买入组最小盈利单单号:"+BuyGroupMinProfitTicket+"  卖出组最小盈利单单号:"+SellGroupMinProfitTicket+"\n"+
        "买入组最大盈利单单号:"+BuyGroupMaxProfitTicket+"  卖出组最大盈利单单号:"+SellGroupMaxProfitTicket+"\n"+
        "买入组最小亏损单单号:"+BuyGroupMinLossTicket+"  卖出组最小亏损单单号:"+SellGroupMinLossTicket+"\n"+
        "买入组最大亏损单单号:"+BuyGroupMaxLossTicket+"  卖出组最大亏损单单号:"+SellGroupMaxLossTicket+"\n"+"\n"+
        "买入组开仓量总计:"+BuyGroupLots+"  卖出组开仓量总计:"+SellGroupLots+"\n"+
        "买入组利润:"+BuyGroupProfit+"  卖出组利润:"+SellGroupProfit+"\n"+
        "买入组限制挂单总计:"+BuyLimitOrders+"  卖出组限制挂单总计:"+SellLimitOrders+"\n"+"\n"+
        iOrdersSort(OP_BUY,3,0,MyMagicNum)+"  "+iOrdersSort(OP_BUY,3,1,MyMagicNum)+"\n"+
        iOrdersSort(OP_SELL,3,0,MyMagicNum)+"  "+iOrdersSort(OP_SELL,3,1,MyMagicNum)+"\n"+
        "买入停止挂单总计:"+BuyStopOrders+"  卖出停止挂单总计:"+SellStopOrders+"\n"+
        "2%资金余额本货币对开仓量:"+iFundsToHands(Symbol(),AccountBalance()*2/100)+"\n"+
        "开仓量0.165整形:"+iLotsFormat(Symbol(),0.165));
}

int init()
{
    iShowInfo();
    iDisplayInfo("TradeInfo", "^_^快乐交易^_^      ", Corner, 5, 50, FontSize, "", Olive);
    //初始化预设变量
    Lots=开仓量;
    ValidStartTime=有效交易开始时间;
    ValidEndTime=有效交易结束时间;
    ServerTime=是否采用服务器时间;
    MyOrderComment=订单注释;
    MyMagicNum=订单特征码;
    return(0);
}

int deinit()
{
    ObjectsDeleteAll();
    Comment ("");
    return(0);
}

//====以下为常用自定义函数====

/*
函    数:文件操作
输入参数:myFileName--文件名
         myFileType--文件类型，其中0--FILE_BIN，1--FILE_CSV 
         myFileMode--文件操作模式，其中0--新建文件，1-创建写入字符串，2-追加写入字符串
         myFileString--写入字符串
输出参数:
算    法:
*/
void iFileOperation(string myFileName,int myFileType,int myFileMode,string myFileString)
{
    int myHandle; //文件序列号
    if (myFileMode==0 && myFileString=="") //新建文件
    {
        if (myFileType==0) myHandle=FileOpen(myFileName,FILE_BIN|FILE_WRITE);
        if (myFileType==1) myHandle=FileOpen(myFileName,FILE_CSV|FILE_WRITE,";");
        FileClose(myHandle);
    }
    if (myFileMode==1 && myFileString!="") //创建写入字符串
    {
        if (myFileType==0) myHandle=FileOpen(myFileName,FILE_BIN|FILE_WRITE);
        if (myFileType==1) myHandle=FileOpen(myFileName,FILE_CSV|FILE_WRITE,";");
        FileWrite(myHandle,myFileString);
        FileClose(myHandle);
    }
    if (myFileMode==2 && myFileString!="") //追加写入字符串
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
函    数:时间周期转换字符
输入参数:时间周期，分钟
输出参数:时间周期字符
算    法:
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
函    数：标注符号和画线、文字
参数说明：string myType 标注类型：Dot画点、HLine画水平线、VLine画垂直线、Text显示文字
          int myBarPos 指定蜡烛坐标
          double myPrice 指定价格坐标
          color myColor 符号颜色
          int mySymbol 符号代码，108为圆点
          string myString 文字内容，在指定的蜡烛位置显示文字
函数返回：在指定的蜡烛和价格位置标注符号或者画水平线、垂直线
*/
void iDrawSign(string myType,int myBarPos,double myPrice,color myColor,int mySymbol,string myString,int myDocSize)
{
    if (myType=="Text")
    {
        string TextBarString=myType+Time[myBarPos];
        ObjectCreate(TextBarString,OBJ_TEXT,0,Time[myBarPos],myPrice);
        ObjectSet(TextBarString,OBJPROP_COLOR,myColor);//颜色
        ObjectSet(TextBarString,OBJPROP_FONTSIZE,myDocSize);//大小
        ObjectSetText(TextBarString,myString);//文字内容
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
函    数:批量清仓
输入参数:int myType 0-OP_BUY,1-OP_SELL,2-OP_BUYLIMIT,3-OP_SELLLIMIT,4-OP_BUYSTOP,5-OP_SELLSTOP,9-全部
         double myLots 0-订单开仓量,非0则减仓
         int myMagicNum 订单特征码
输出参数:
算    法:
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
函    数:开仓量整形
输入参数:mySymbol-货币对 myLots-开仓量
输出参数:按照平台规则计算开仓量
算    法:调整不规范的开仓量数据，按照四舍五入原则及平台开仓量格式规范数据
*/
double iLotsFormat(string mySymbol,double myLots)
{
    if (MarketInfo(mySymbol, MODE_MINLOT)==0) myLots=0;
    else
        myLots=MathRound(myLots/MarketInfo(mySymbol, MODE_MINLOT))*MarketInfo(mySymbol, MODE_MINLOT);//开仓量整形
    return(myLots);
}

/*
函    数:持仓单净值总计
输入参数:myOrderType:订单类型
输出参数:买入、卖出组净值总计
算    法:遍历算法
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
函    数:持仓单开仓量总计
输入参数:myOrderType:订单类型
输出参数:买入、卖出组开仓量总计
算    法:遍历算法
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
函    数：物件颜色
输入参数：数值
输出参数：颜色
算    法：负数为红色，正数为绿色，0为灰色
*/
color iObjectColor(double myInput)
{
    color myColor;
    if (myInput > 0) myColor = Green; //正数颜色为绿色
    if (myInput < 0) myColor = Red; //负数颜色为红色
    if (myInput == 0) myColor = DarkGray; //0颜色为灰色
    return(myColor);
}

/*
函    数:持仓单数量统计
输入参数:myOrderType:订单类型
输出参数:指定类型的订单数量
算    法:遍历算法
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
函    数:计算特定条件的订单
输入参数:myOrderType:订单类型 0-Buy,1-Sell,2-BuyLimit,3-SellLimit,4-BuyStop,5-SellStop
         myOrderSort:排序类型 0-按时间,1-按盈利,2-按亏损,3-按开仓价
         myMaxMin:最值 0-最大,1-最小
         int myMagicNum:订单特征码
输出参数:返回订单号
算    法：冒泡算法
*/
int iOrdersSort(int myOrderType,int myOrderSort,int myMaxMin,int myMagicNum)
{
    int myReturn,myArrayRange,cnt,i,j;
    myArrayRange=OrdersTotal();
    if (myArrayRange<=0) return(0);
    //持仓订单基本信息:0订单号,1开仓时间,2订单利润,3订单类型,4开仓量,5开仓价,
    //                 6止损价,7止赢价,8订单特征码,9订单佣金,10掉期,11挂单有效日期
    double myOrdersArray[][12]; //定义订单数组,第1维:订单序号;第2维:订单信息
    ArrayResize(myOrdersArray,myArrayRange); //重新界定订单数组
    ArrayInitialize(myOrdersArray, 0.0); //初始化订单数组
    //订单数组赋值
    for (cnt=0; cnt<myArrayRange; cnt++)
    {
        //选中当前货币对相关持仓订单
        if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol()==Symbol()
            && OrderMagicNumber()==myMagicNum)
        {
            myOrdersArray[cnt][0]=OrderTicket();//0订单号
            myOrdersArray[cnt][1]=OrderOpenTime();//1开仓时间
            myOrdersArray[cnt][2]=OrderProfit();//2订单利润
            myOrdersArray[cnt][3]=OrderType();//3订单类型
            myOrdersArray[cnt][4]=OrderLots();//4开仓量
            myOrdersArray[cnt][5]=OrderOpenPrice();//5开仓价
            myOrdersArray[cnt][6]=OrderStopLoss();//6止损价
            myOrdersArray[cnt][7]=OrderTakeProfit();//7止赢价
            myOrdersArray[cnt][8]=OrderMagicNumber();//8订单特征码
            myOrdersArray[cnt][9]=OrderCommission();//9订单佣金
            myOrdersArray[cnt][10]=OrderSwap();//10掉期
            myOrdersArray[cnt][11]=OrderExpiration();//11挂单有效日期
        }
    }
    double myTempArray[12]; //定义临时数组
    //ArrayResize(myTempArray,myArrayRange); //重新界定临时数组
    ArrayInitialize(myTempArray, 0.0); //初始化临时数组
    //开始按条件排序
    //---- 按时间降序排列数组,原始数组重新排序
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
    
    //---- 按订单净值降序排列数组,原始数组重新排序
    if (myOrderSort==1 || myOrderSort==2)
    {
        ArrayInitialize(myTempArray, 0.0); //初始化临时数组
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
    
    //---- 按开仓价降序排列数组,原始数组重新排序
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
函    数：有效时间段
输入参数：string myStartTime:开始时间，标准格式为hh:mm
          string myEndTime:结束时间，标准格式为hh:mm
          bool myServerTime:true为服务器时间, false为计算机时间
输出参数：true:有效  false:无效
算    法：
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
    if (TimeCurrent()>myST && TimeCurrent()<myET && myServerTime==true)//服务器时间
    {
        myValue=true;
    }
    if (TimeLocal()>myST && TimeLocal()<myET && myServerTime==false)//计算机时间
    {
        myValue=true;
    }
    if (myST==myET) myValue=true;
    return(myValue);
}

/*
函    数：交易繁忙，程序等待，更新缓存数据
输入参数：
输出参数：
算法说明：
*/
void iWait(int myDelayTime) 
{
    while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(myDelayTime);
    RefreshRates();
    return(0);
}

/*
函    数：获取最后错误信息
输入参数：int myErrorNum - 错误代码
输出参数：错误信息
算    法：
*/
string iGetErrorInfo(int myErrorNum)
{
    string myLastErrorStr;
    if(myErrorNum>=0)
    {
        switch (myErrorNum)
        {
            case 0:myLastErrorStr="错误代码:"+0+"-没有错误返回";break;
            case 1:myLastErrorStr="错误代码:"+1+"-没有错误返回但结果不明";break;
            case 2:myLastErrorStr="错误代码:"+2+"-一般错误";break;
            case 3:myLastErrorStr="错误代码:"+3+"-无效交易参量";break;
            case 4:myLastErrorStr="错误代码:"+4+"-交易服务器繁忙";break;
            case 5:myLastErrorStr="错误代码:"+5+"-客户终端旧版本";break;
            case 6:myLastErrorStr="错误代码:"+6+"-没有连接服务器";break;
            case 7:myLastErrorStr="错误代码:"+7+"-没有权限";break;
            case 8:myLastErrorStr="错误代码:"+8+"-请求过于频繁";break;
            case 9:myLastErrorStr="错误代码:"+9+"-交易运行故障";break;
            case 64:myLastErrorStr="错误代码:"+64+"-账户禁止";break;
            case 65:myLastErrorStr="错误代码:"+65+"-无效账户";break;
            case 128:myLastErrorStr="错误代码:"+128+"-交易超时";break;
            case 129:myLastErrorStr="错误代码:"+129+"-无效价格";break;
            case 130:myLastErrorStr="错误代码:"+130+"-无效停止";break;
            case 131:myLastErrorStr="错误代码:"+131+"-无效交易量";break;
            case 132:myLastErrorStr="错误代码:"+132+"-市场关闭";break;
            case 133:myLastErrorStr="错误代码:"+133+"-交易被禁止";break;
            case 134:myLastErrorStr="错误代码:"+134+"-资金不足";break;
            case 135:myLastErrorStr="错误代码:"+135+"-价格改变";break;
            case 136:myLastErrorStr="错误代码:"+136+"-开仓价过期";break;
            case 137:myLastErrorStr="错误代码:"+137+"-经纪繁忙";break;
            case 138:myLastErrorStr="错误代码:"+138+"-重新开价";break;
            case 139:myLastErrorStr="错误代码:"+139+"-定单被锁定";break;
            case 140:myLastErrorStr="错误代码:"+140+"-只允许看涨仓位";break;
            case 141:myLastErrorStr="错误代码:"+141+"-过多请求";break;
            case 145:myLastErrorStr="错误代码:"+145+"-因为过于接近市场，修改无效";break;
            case 146:myLastErrorStr="错误代码:"+146+"-交易文本已满";break;
            case 147:myLastErrorStr="错误代码:"+147+"-时间周期被经纪否定";break;
            case 148:myLastErrorStr="错误代码:"+148+"-开单和挂单总数已被经纪限定";break;
            case 149:myLastErrorStr="错误代码:"+149+"-当对冲被拒绝时,打开相对于现有的一个单量";break;
            case 150:myLastErrorStr="错误代码:"+150+"-把为反FIFO规定的单子平掉";break;
            case 4000:myLastErrorStr="错误代码:"+4000+"-没有错误";break;
            case 4001:myLastErrorStr="错误代码:"+4001+"-错误函数指示";break;
            case 4002:myLastErrorStr="错误代码:"+4002+"-数组索引超出范围";break;
            case 4003:myLastErrorStr="错误代码:"+4003+"-对于调用堆栈储存器函数没有足够内存";break;
            case 4004:myLastErrorStr="错误代码:"+4004+"-循环堆栈储存器溢出";break;
            case 4005:myLastErrorStr="错误代码:"+4005+"-对于堆栈储存器参量没有内存";break;
            case 4006:myLastErrorStr="错误代码:"+4006+"-对于字行参量没有足够内存";break;
            case 4007:myLastErrorStr="错误代码:"+4007+"-对于字行没有足够内存";break;
            case 4008:myLastErrorStr="错误代码:"+4008+"-没有初始字行";break;
            case 4009:myLastErrorStr="错误代码:"+4009+"-在数组中没有初始字串符";break;
            case 4010:myLastErrorStr="错误代码:"+4010+"-对于数组没有内存";break;
            case 4011:myLastErrorStr="错误代码:"+4011+"-字行过长";break;
            case 4012:myLastErrorStr="错误代码:"+4012+"-余数划分为零";break;
            case 4013:myLastErrorStr="错误代码:"+4013+"-零划分";break;
            case 4014:myLastErrorStr="错误代码:"+4014+"-不明命令";break;
            case 4015:myLastErrorStr="错误代码:"+4015+"-错误转换(没有常规错误)";break;
            case 4016:myLastErrorStr="错误代码:"+4016+"-没有初始数组";break;
            case 4017:myLastErrorStr="错误代码:"+4017+"-禁止调用DLL ";break;
            case 4018:myLastErrorStr="错误代码:"+4018+"-数据库不能下载";break;
            case 4019:myLastErrorStr="错误代码:"+4019+"-不能调用函数";break;
            case 4020:myLastErrorStr="错误代码:"+4020+"-禁止调用智能交易函数";break;
            case 4021:myLastErrorStr="错误代码:"+4021+"-对于来自函数的字行没有足够内存";break;
            case 4022:myLastErrorStr="错误代码:"+4022+"-系统繁忙 (没有常规错误)";break;
            case 4050:myLastErrorStr="错误代码:"+4050+"-无效计数参量函数";break;
            case 4051:myLastErrorStr="错误代码:"+4051+"-无效开仓量";break;
            case 4052:myLastErrorStr="错误代码:"+4052+"-字行函数内部错误";break;
            case 4053:myLastErrorStr="错误代码:"+4053+"-一些数组错误";break;
            case 4054:myLastErrorStr="错误代码:"+4054+"-应用不正确数组";break;
            case 4055:myLastErrorStr="错误代码:"+4055+"-自定义指标错误";break;
            case 4056:myLastErrorStr="错误代码:"+4056+"-不协调数组";break;
            case 4057:myLastErrorStr="错误代码:"+4057+"-整体变量过程错误";break;
            case 4058:myLastErrorStr="错误代码:"+4058+"-整体变量未找到";break;
            case 4059:myLastErrorStr="错误代码:"+4059+"-测试模式函数禁止";break;
            case 4060:myLastErrorStr="错误代码:"+4060+"-没有确认函数";break;
            case 4061:myLastErrorStr="错误代码:"+4061+"-发送邮件错误";break;
            case 4062:myLastErrorStr="错误代码:"+4062+"-字行预计参量";break;
            case 4063:myLastErrorStr="错误代码:"+4063+"-整数预计参量";break;
            case 4064:myLastErrorStr="错误代码:"+4064+"-双预计参量";break;
            case 4065:myLastErrorStr="错误代码:"+4065+"-数组作为预计参量";break;
            case 4066:myLastErrorStr="错误代码:"+4066+"-刷新状态请求历史数据";break;
            case 4067:myLastErrorStr="错误代码:"+4067+"-交易函数错误";break;
            case 4099:myLastErrorStr="错误代码:"+4099+"-文件结束";break;
            case 4100:myLastErrorStr="错误代码:"+4100+"-一些文件错误";break;
            case 4101:myLastErrorStr="错误代码:"+4101+"-错误文件名称";break;
            case 4102:myLastErrorStr="错误代码:"+4102+"-打开文件过多";break;
            case 4103:myLastErrorStr="错误代码:"+4103+"-不能打开文件";break;
            case 4104:myLastErrorStr="错误代码:"+4104+"-不协调文件";break;
            case 4105:myLastErrorStr="错误代码:"+4105+"-没有选择定单";break;
            case 4106:myLastErrorStr="错误代码:"+4106+"-不明货币对";break;
            case 4107:myLastErrorStr="错误代码:"+4107+"-无效价格";break;
            case 4108:myLastErrorStr="错误代码:"+4108+"-无效定单编码";break;
            case 4109:myLastErrorStr="错误代码:"+4109+"-不允许交易";break;
            case 4110:myLastErrorStr="错误代码:"+4110+"-不允许长期";break;
            case 4111:myLastErrorStr="错误代码:"+4111+"-不允许短期";break;
            case 4200:myLastErrorStr="错误代码:"+4200+"-对象已经存在";break;
            case 4201:myLastErrorStr="错误代码:"+4201+"-不明定单属性";break;
            case 4202:myLastErrorStr="错误代码:"+4202+"-定单不存在";break;
            case 4203:myLastErrorStr="错误代码:"+4203+"-不明定单类型";break;
            case 4204:myLastErrorStr="错误代码:"+4204+"-没有定单名称";break;
            case 4205:myLastErrorStr="错误代码:"+4205+"-定单坐标错误";break;
            case 4206:myLastErrorStr="错误代码:"+4206+"-没有指定子窗口";break;
            case 4207:myLastErrorStr="错误代码:"+4207+"-定单一些函数错误";break;
            case 4250:myLastErrorStr="错误代码:"+4250+"-错误设定发送通知到队列中";break;
            case 4251:myLastErrorStr="错误代码:"+4251+"-无效参量- 空字符串传递到SendNotification()函数";break;
            case 4252:myLastErrorStr="错误代码:"+4252+"-无效设置发送通知(未指定ID或未启用通知)";break;
            case 4253:myLastErrorStr="错误代码:"+4253+"-通知发送过于频繁";break;
        }
    }
    return(myLastErrorStr);
}

/*
函    数：订单净值转换点数
输入参数：myTicket:订单号
输出参数：订单净值点数
算    法：
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
函    数：金额转换手数
输入参数：mySymbol:货币对  
          myFunds:资金基数
输出参数：
算    法：
*/
double iFundsToHands(string mySymbol,double myFunds)
{
    double myLots=myFunds/MarketInfo(mySymbol, MODE_MARGINREQUIRED);//换算可开仓手数
    double myMinLOT=MarketInfo(mySymbol, MODE_MINLOT);//最小开仓量变量
    if (myMinLOT==0) myLots=0;
    else
        myLots=MathRound(myLots/myMinLOT)*myMinLOT;//手数整形
    return(myLots);
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
    if (Corner == -1) return(0);
    for (cnt=0;cnt<ObjectsTotal();cnt++)
    {
        if (ObjectName(cnt)==LableName)  break;//如果有对象名称，退出循环
    }
    if (cnt==ObjectsTotal())  ObjectCreate(LableName, OBJ_LABEL, 0, 0, 0);//新建对象
    ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor);
    ObjectSet(LableName, OBJPROP_CORNER, Corner);
    ObjectSet(LableName, OBJPROP_XDISTANCE, LableX);
    ObjectSet(LableName, OBJPROP_YDISTANCE, LableY);
    return(0);
} 