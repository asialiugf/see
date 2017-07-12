//+------------------------------------------------------------------------------------------------+
//| FX5_Divergence_V2.1.mq4 |
//| FX5 |
//| hazem@uk2.net |
//+-------------------------------------------------------------------------------------------------+
#property copyright "Copyright ?2007, FX5"
#property link "hazem@uk2.net"
 
 
//----基本定义
#property indicator_separate_window //显示在副图
#property indicator_buffers 5 //定义5个数组
#property indicator_color1 LimeGreen //第1线颜色—橙绿色
#property indicator_color2 FireBrick //第2线颜色—火砖色
#property indicator_color3 Green //第3线颜色—绿色
#property indicator_color4 Red //第4线颜色—红色
 
 
//---- input parameters 外部参数设置
extern string separator1 = "*** OSMA Settings ***"; //MACD柱线设置
extern int fastEMA = 12; //快线周期数
extern int slowEMA = 26; //慢线周期数
extern int signal = 9; //移动周期数
extern string separator2 = "*** Indicator Settings ***"; //指标设置
extern bool drawDivergenceLines = true; //画背离线=真
extern bool displayAlert = true; //信号显示=真
 
 
//---- buffers 数组定义—小数型
double upOsMA[]; //MACD柱线上升
double downOsMA[]; //MACD柱线下降
double bullishDivergence[]; //牛背离
double bearishDivergence[]; //熊背离
double OsMA[]; //MACD柱线
//----
static datetime lastAlertTime; //静止变量-时间日期型：最后报警时间
//+------------------------------------------------------------------+
 
 
//| Custom indicator initialization function |
//+------------------------------------------------------------------+
int init() //加载时运行
{
//---- indicators
SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 2);
//指标类型（索引-0，画柱线，实心线，宽-2像素）
SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 2);
//指标类型（索引-1，画柱线，实心线，宽-2像素）
SetIndexStyle(2, DRAW_ARROW);
//指标类型（索引-2，画箭头）
SetIndexStyle(3, DRAW_ARROW);
//指标类型（索引-3，画箭头）
SetIndexStyle(4, DRAW_NONE);
//指标类型（索引-4，不画线）
//----
SetIndexBuffer(0, upOsMA); //指标索引（索引-0，MACD柱线上升）
SetIndexBuffer(1, downOsMA); //指标索引（索引-1，MACD柱线下降）
SetIndexBuffer(2, bullishDivergence); //指标索引（索引-2，牛背离）
SetIndexBuffer(3, bearishDivergence); //指标索引（索引-3，熊背离）
SetIndexBuffer(4, OsMA); //指标索引（索引-4，MACD柱线）
//----
SetIndexArrow(2, 233); //箭头类型（索引-2，编号233）
SetIndexArrow(3, 234); //箭头类型（索引-3，编号234）
//----
IndicatorDigits(Digits + 2); //指标取小数点位数(取当前货币兑的小数位+2)，如果当前货币对的小数位为5位，则指标小数位：5+2=7，则取小数后7位进行保留，以便计算中产生“四舍五入”，进行计列。
IndicatorShortName("FX5_Divergence_v2.1(" + fastEMA + "," + slowEMA + "," + signal + ")"); //指标简称（“FX_背离指标_V2.1（快速EMA，慢速EMA，移动周期）”）
return(0);
}
//+------------------------------------------------------------------+
 
 
//| Custom indicator deinitialization function |
//+------------------------------------------------------------------+
int deinit() //卸载时运行
{
for(int i = ObjectsTotal() - 1; i >= 0; i--) //循环检查（对象总数-1，0，递减1）
{
string label = ObjectName(i); //变量-文本型：标签=对象名称（i）
if(StringSubstr(label, 0, 14) != "DivergenceLine")
//如果（提取文本（标签，从0字符开始，取字符长度=14）≠“背离线”）
continue; //继续
ObjectDelete(label); //删除对象（标签）
}
return(0);
}
//+------------------------------------------------------------------+
 
 
//| Custom indicator iteration function |
//+------------------------------------------------------------------+
int start() //主函数
{
int countedBars = IndicatorCounted(); //计算K线数=K线总数函数（）
if(countedBars < 0) // 如果（计算K线数< 0）
countedBars = 0; //计算K线数=0
CalculateIndicator(countedBars); //指标计算（计算K线数）-自定义函数调用
return(0);
}
//+------------------------------------------------------------------+
//| 自定义函数-无返回型:指标计算 |
//+------------------------------------------------------------------+
void CalculateIndicator(int countedBars) //自定义函数：指标计算（计算K线数）
{
for(int i = Bars - countedBars; i >= 0; i--) //循环检查（i=K线数-计算K线数，0，i=i-1）
{
CalculateOsMA(i); //计算MACD柱线（i）-自定义函数
CatchBullishDivergence(i + 2); //捕捉牛背离函数（i+2）-自定义函数
CatchBearishDivergence(i + 2); //捕捉熊背离函数（i+2）-自定义函数
}
}
//+------------------------------------------------------------------+
//| 自定义函数-无返回型：计算MACD柱线 |
//+------------------------------------------------------------------+
void CalculateOsMA(int i) //自定义函数：计算MACD柱线
{
OsMA[i] = iOsMA(NULL, 0, fastEMA, slowEMA, signal, PRICE_CLOSE, i);
//MACD柱线[i]=调用MACD柱线函数（当前货币对，当前图表，快速EMA，慢速EMA，移动周期，收盘价，i）
if(OsMA[i] > 0) //如果（MACD柱线[i]>0）
{
upOsMA[i] = OsMA[i]; //MACD柱线上升[i]= MACD柱线[i]
downOsMA[i] = 0; //MACD柱线下降[i]=0
}
else
if(OsMA[i] < 0) //如果（MACD柱线[i]<0）
{
downOsMA[i] = OsMA[i]; //MACD柱线下降[i]=MACD柱线[i]
upOsMA[i] = 0; //MACD柱线上升[i]=0
}
else
{
upOsMA[i] = 0; //MACD柱线上升[i]=0
downOsMA[i] = 0; //MACD柱线下降[i]=0
}
}
//+------------------------------------------------------------------+
//| 自定义函数-无返回型：捕捉牛背离函数 |
//+------------------------------------------------------------------+
void CatchBullishDivergence(int shift) //捕捉牛背离函数（K线序号）
{
if(IsIndicatorTrough(shift) == false) //如果（是否是指标的波谷（K线序号）=假）
return;
int currentTrough = shift; //变量-整数型：当前波谷=K线序号
int lastTrough = GetIndicatorLastTrough(shift);
//变量-整数型：上次波谷=获取指标的上次波谷（K线序号）
if(OsMA[currentTrough] > OsMA[lastTrough] && Low[currentTrough] < Low[lastTrough])
//如果（MACD柱线[当前波谷]> MACD柱线[上次波谷] 且 K线低价[当前波谷] > K线低价[上次波谷]）
{
bullishDivergence[currentTrough] = OsMA[currentTrough];
//牛背离[当前波谷]=MACD柱线[当前波谷]
if(drawDivergenceLines == true) //如果（画背离线=真）
{
DrawPriceTrendLine(Time[currentTrough], Time[lastTrough],
Low[currentTrough], Low[lastTrough], Green, STYLE_SOLID);
//画价格趋势线（位置[当前波谷]，位置[上次波谷]，最低价[当前波谷]，最低价[上次波谷]，绿色，实线）
DrawIndicatorTrendLine(Time[currentTrough], Time[lastTrough],
OsMA[currentTrough],OsMA[lastTrough], Green, STYLE_SOLID);
//画指标趋势线（位置[当前波谷]，位置[上次波谷]，MACD柱线[当前波谷]，MACD柱线[上次波谷]，绿色，实线）
}
if(displayAlert == true) //如果（显示信号=真）
DisplayAlert("Classical bullish divergence on: ", currentTrough);
//显示信号（“标准牛背离出现：”，当前波谷）
}
if(OsMA[currentTrough] < OsMA[lastTrough] && Low[currentTrough] > Low[lastTrough])
//如果（MACD柱线[当前波谷]<MACD[上次波谷] 且最低价[当前波谷]>最低价[上次波谷]）
{
bullishDivergence[currentTrough] = OsMA[currentTrough];
//牛背离[当前波谷]=MACD柱线[当前波谷]
if(drawDivergenceLines == true) //如果（画背离线=真）
{
DrawPriceTrendLine(Time[currentTrough], Time[lastTrough], Low[currentTrough],
Low[lastTrough], Green, STYLE_DOT);
//画价格趋势线（位置[当前波谷]，位置[上次波谷]，最低价[当前波谷]，最低价[上次波谷]，绿色，点线）
DrawIndicatorTrendLine(Time[currentTrough], Time[lastTrough],
OsMA[currentTrough],OsMA[lastTrough], Green, STYLE_DOT);
//画指标趋势线（位置[当前波谷]，位置[上次波谷]，MACD柱线[当前波谷]，MACD柱线[上次波谷]，绿色，点线）
}
if(displayAlert == true) //如果（警示信号显示=真）
DisplayAlert("Reverse bullish divergence on: ", currentTrough);
//警示信号显示（“反向牛背离出现：”，当前波谷）
}
}
//+------------------------------------------------------------------+
//| 自定义函数-无返回型：捕捉熊背离函数 |
//+------------------------------------------------------------------+
void CatchBearishDivergence(int shift) //捕捉熊背离函数（K线序号）
{
if(IsIndicatorPeak(shift) == false) //如果（是否是指标的波峰（K线序号）=假）
return;
int currentPeak = shift; //当前波峰=K线序号
int lastPeak = GetIndicatorLastPeak(shift); //上次波峰=获取指标的上次波峰（K线序号）
if(OsMA[currentPeak] < OsMA[lastPeak] && High[currentPeak] > High[lastPeak])
//如果（MACD柱线[当前波峰]<MACD柱线[上次波峰] 且最高价[当前波峰]>最高价[上次波峰]）
{
bearishDivergence[currentPeak] = OsMA[currentPeak];
//熊背离[当前波峰]=MACD柱线[当前波峰]
if(drawDivergenceLines == true) //如果（画背离线=真）
{
DrawPriceTrendLine(Time[currentPeak], Time[lastPeak], High[currentPeak],
High[lastPeak], Red, STYLE_SOLID);
//画价格趋势线（位置[当前波峰]，位置[上次波峰]，最高价[当前波峰]，最高价[上次波峰]，红色，实线）
DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak], OsMA[currentPeak],
OsMA[lastPeak], Red, STYLE_SOLID);
//画指标趋势线（位置[当前波峰]，位置[上次波峰]，MACD柱线[当前波峰]，MACD柱线[上次波峰]，红色，实线）
}
if(displayAlert == true) //如果（信号显示=真）
DisplayAlert("Classical bearish divergence on: ", currentPeak);
//信号显示（“标准熊背离出现：”+当前波峰）
}
if(OsMA[currentPeak] > OsMA[lastPeak] && High[currentPeak] < High[lastPeak])
//如果（MACD柱线[当前波峰]>MACD柱线[上次波峰] 且最高价[当前波峰]<最高价[上次波峰]）
{
bearishDivergence[currentPeak] = OsMA[currentPeak];
//熊背离[当前波峰]=MACD柱线[当前波峰]
if(drawDivergenceLines == true) //如果（画背离线=真）
{
DrawPriceTrendLine(Time[currentPeak], Time[lastPeak], High[currentPeak],
High[lastPeak], Red, STYLE_DOT);
//画价格趋势线（位置[当前波峰]，位置[上次波峰]，最高价[当前波峰]，最高价[上次波峰]，红色，点线）
DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak], OsMA[currentPeak],
OsMA[lastPeak], Red, STYLE_DOT);
//画指标趋势线（位置[当前波峰]，位置[上次波峰]，MACD柱线[当前波峰]，MACD柱线[上次波峰]，红色，点线）
}
if(displayAlert == true) //如果（警示信号显示=真）
DisplayAlert("Reverse bearish divergence on: ", currentPeak);
//警示信号显示（“反向熊背离出现：”+当前波峰）
}
}
//+------------------------------------------------------------------+
//| 自定义函数-逻辑型：判断指标波峰函数 |
//+------------------------------------------------------------------+
bool IsIndicatorPeak(int shift) //判断指标是否为波峰（K线序号）
{
if(OsMA[shift] > 0 && OsMA[shift] > OsMA[shift+1] && OsMA[shift] > OsMA[shift-1])
//如果（MACD柱线[K线序号]>0 且 MACD柱线[K线序号]> MACD柱线[K线序号+1] 且MACD柱线[K线序号]> MACD柱线[K线序号-1]）
{
for(int i = shift + 1; i < Bars; i++) //循环查找（i=K线序号+1，i<K线数；i=i+1）
{
if(OsMA[i] < 0) //如果（MACD柱线[i]<0）
return(true);
if(OsMA[i] > OsMA[shift]) //如果（MACD柱线[i]>MACD柱线[K线序号]）
break; //跳转
}
}
return(false); //返回（假）
}
//+------------------------------------------------------------------+
//| 自定义函数-逻辑型：判断指标波谷函数 |
//+------------------------------------------------------------------+
bool IsIndicatorTrough(int shift) //判断指标是否为波谷（K线序号）
{
if(OsMA[shift] < 0 && OsMA[shift] < OsMA[shift+1] && OsMA[shift] < OsMA[shift-1])
//如果（MACD柱线[K线序号]<0 且 MACD柱线[K线序号]< MACD柱线[K线序号+1] 且MACD柱线[K线序号]><MACD柱线[K线序号-1]）
{
for(int i = shift + 1; i < Bars; i++) //循环查找（i=K线序号+1，i<K线数；i=i+1）
{
if(OsMA[i] > 0) //如果(MACD柱线[i]>0)
return(true);
if(OsMA[i] < OsMA[shift]) //如果（MACD柱线[i]>MACD柱线[K线序号]）
break; //跳转
}
}
return(false); //返回(假)
}
//+------------------------------------------------------------------+
//| 自定义函数-整数型:获取指标上次波峰 |
//+------------------------------------------------------------------+
int GetIndicatorLastPeak(int shift) //获取指标上次波峰(K线序号)
{
for(int i = shift + 5; i < Bars; i++) //循环查找(i=K线序号+5;i<K线数;i=i+1)
{
if(OsMA[i] >= OsMA[i+1] && OsMA[i] > OsMA[i+2] &&
OsMA[i] >= OsMA[i-1] && OsMA[i] > OsMA[i-2])
//如果(MACD柱线[i] >=MACD柱线[i+1] 且MACD柱线[i]>MACD柱线[i+2]且MACD柱线[i] >=MACD柱线[i-1] 且MACD柱线[i]>MACD柱线[i-2])
return(i); //返回(i)
}
return(-1); //返回(-1)
}
//+------------------------------------------------------------------+
//| 自定义函数-整数型:获取指标上次波谷 |
//+------------------------------------------------------------------+
int GetIndicatorLastTrough(int shift) //获取指标上次波谷(K线序号)
{
for(int i = shift + 5; i < Bars; i++) //循环查找(i=K线序号+5；i<K线数；i=i+1))
{
if(OsMA[i] <= OsMA[i+1] && OsMA[i] < OsMA[i+2] &&
OsMA[i] <= OsMA[i-1] && OsMA[i] < OsMA[i-2])
//如果(MACD柱线[i] <=MACD柱线[i+1] 且MACD柱线[i]<MACD柱线[i+2]且MACD柱线[i] <=MACD柱线[i-1] 且MACD柱线[i]<MACD柱线[i-2])
return(i); //返回(i)
}
return(-1); //返回(-1)
}
//+------------------------------------------------------------------+
//|自定义函数-无返回型:警示信号显示 |
//+------------------------------------------------------------------+
void DisplayAlert(string message, int shift) //警示信号显示(通知,K线序号)
{
if(shift <= 2 && Time[shift] != lastAlertTime)
//如果(K线序号<=2 且 位置[K线序号]≠上次信号位置)
{
lastAlertTime = Time[shift]; //上次信号位置=位置[K线序号]
Alert(message, Symbol(), " , ", Period(), " minutes chart");
//弹出警告窗口(通知，当前货币对，“，”当前周期，“分钟计算”)
}
}
//+------------------------------------------------------------------+
//| 自定义函数-无返回型:画价格趋线 |
//+------------------------------------------------------------------+
void DrawPriceTrendLine(datetime x1, datetime x2, double y1,
double y2, color lineColor, double style)
//画价格趋线(X1-时间日期型,X2-时间日期型,Y1-小数型,Y2-小数型,线条颜色,线条类型-小数型)
{
string label = "DivergenceLine2.1# " + DoubleToStr(x1, 0);
//标签=“背离线2.1#”+小数到文本(X1,0)
ObjectDelete(label); //删除对象（标签）
ObjectCreate(label, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
//创建对象（标签，趋势线，0，X1，Y1，X2，Y2，0，0，）
ObjectSet(label, OBJPROP_RAY, 0); //对象属性设置（标签，射线，0）
ObjectSet(label, OBJPROP_COLOR, lineColor); //对象属性设置（标签，颜色，线条颜色）
ObjectSet(label, OBJPROP_STYLE, style); //对象属性设置（标签，线条类型，类型）
}
//+------------------------------------------------------------------+
//| 自定义函数-无返回型：画指标趋势线 |
//+------------------------------------------------------------------+
void DrawIndicatorTrendLine(datetime x1, datetime x2, double y1,
double y2, color lineColor, double style)
//画指标趋势线（X1-时间日期型，X2-时间日期型，Y1-小数型，Y2-小数型，线条颜色，类型-小数型）
{
int indicatorWindow = WindowFind("FX5_Divergence_v2.1(" + fastEMA + "," + slowEMA + "," + signal + ")");
//指标窗口数=指标检查（“FX5_背离_V2.1（”+快线EMA+“，”+慢线EMA+“，”+移动周期+“）”）
if(indicatorWindow < 0)
//如果（指标窗口数）<0
return;
string label = "DivergenceLine2.1$# " + DoubleToStr(x1, 0);
//标签内容=“背离线2.1$#”+数值到文本（X1，0）
ObjectDelete(label);
//删除对象（标签）
ObjectCreate(label, OBJ_TREND, indicatorWindow, x1, y1, x2, y2, 0, 0);
//创建对象（标签，趋线，指标窗口，X1，Y1，X2，Y2，0，0）
ObjectSet(label, OBJPROP_RAY, 0);
//对象属性设置（标签，射线，0）
ObjectSet(label, OBJPROP_COLOR, lineColor);
//对象属性设置（标签，颜色，线条颜色）
ObjectSet(label, OBJPROP_STYLE, style);
//对象属性设置（标签，线条类型，类型）
}
//+------------------------------------------------------------------+
