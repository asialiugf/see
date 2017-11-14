#property copyright "小添  QQ：8284518"
extern bool 是否显示信息框=true;
extern bool 使用资金管理=true;
double 倍率=1;
extern double 小于净值阶段1=1000;
extern double 单量倍率1=1;
extern double 小于净值阶段2=2000;
extern double 单量倍率2=2;
extern double 小于净值阶段3=3000;
extern double 单量倍率3=3;
extern double 单量倍率4=3;

extern double 止损=0;
extern double 止盈=0;
 double 滑点=30;
extern string 备注="20140308";
extern int magic=15420;
extern bool 周期结束后不停止运行EA=true;
bool 可交易1=true;
bool 可交易2=true;
extern bool 逆势部分总开关=true;
extern bool 顺势部分总开关=true;
extern string comm1X="----------------------------";
extern bool 首单接受均线管理=true;
extern bool 逆势单接受均线管理=true;
extern double 逆势间隔=50;
extern double 逆市单止盈=50;
extern double 逆势N单内设置止盈=7;
extern double 逆势N单后可以对冲=7;
extern int 获利个数=3;
extern int 亏损个数=3;  
extern double 对冲时需要获利金额=0;
extern double 防守区亏损N美金后全平=100;
extern string comm2X="----------------------------";
extern double 顺势间隔=50;
extern double 顺势回撤止损距离=25;
extern bool 减仓模式=true;
extern double 顺势减仓单止盈=50;
extern string comm3X="----------------------------";
extern double 首单单量=0.01;
extern double 逆势单量2=0.01;
extern double 逆势单量3=0.01;
extern double 逆势单量4=0.02;
extern double 逆势单量5=0.02;
extern double 逆势单量6=0.02;
extern double 逆势单量7=0.04;
extern double 逆势单量8=0.04;
extern double 逆势单量9=0.04;
extern double 逆势单量10=0.08;
extern double 逆势单量11=0.08;
extern double 逆势单量12=0.08;
extern double 逆势单量13=0.16;
extern double 逆势单量14=0.16;
extern double 逆势单量15=0.16;
extern double 逆势单量16=0.32;
extern double 逆势单量17=0.32;
extern double 逆势单量18=0.32;
extern double 逆势单量19=0.64;
extern double 逆势单量20=0.64;
extern double 逆势单量21=0.64;
extern double 逆势单量22=1.28;
extern double 逆势单量23=1.28;
extern double 逆势单量24=1.28;
extern double 逆势单量25=2.56;
extern double 逆势单量26=2.56;
extern double 逆势单量27=2.56;
extern double 逆势单量28=5.12;
extern double 逆势单量29=5.12;
extern double 逆势单量30=5.12;
extern double 逆势单量31=10.24;
extern double 逆势单量32=10.24;
extern double 逆势单量33=10.24;
double 逆势单量[100];
extern string comm4X="----------------------------";
extern double 顺势单量2=0.01;
extern double 顺势单量3=0.01;
extern double 顺势单量4=0.02;
extern double 顺势单量5=0.02;
extern double 顺势单量6=0.02;
extern double 顺势单量7=0.04;
extern double 顺势单量8=0.04;
extern double 顺势单量9=0.04;
extern double 顺势单量10=0.08;
extern double 顺势单量11=0.08;
extern double 顺势单量12=0.08;
extern double 顺势单量13=0.16;
extern double 顺势单量14=0.16;
extern double 顺势单量15=0.16;
extern double 顺势单量16=0.32;
extern double 顺势单量17=0.32;
extern double 顺势单量18=0.32;
extern double 顺势单量19=0.64;
extern double 顺势单量20=0.64;
extern double 顺势单量21=0.64;
extern double 顺势单量22=1.28;
extern double 顺势单量23=1.28;
extern double 顺势单量24=1.28;
extern double 顺势单量25=2.56;
extern double 顺势单量26=2.56;
extern double 顺势单量27=2.56;
extern double 顺势单量28=5.12;
extern double 顺势单量29=5.12;
extern double 顺势单量30=5.12;
extern double 顺势单量31=10.24;
extern double 顺势单量32=10.24;
extern double 顺势单量33=10.24;
double 顺势单量[100];
extern string comm5X="----------------------------";
extern string comm1="------MA------";
extern bool 指标1开关=true;
extern int 指标1信号0或1=1;
extern int 指标1时间轴=0;
extern string 指标1名称="MA";
extern int MA周期1=21;
extern int MA周期2=34;
extern int MA计算方式1=MODE_EMA;
extern int MA计算方式2=MODE_EMA;
extern int MA价格方式1=PRICE_CLOSE;
extern int MA价格方式2=PRICE_CLOSE;
int 指标1做多,指标1做空;
extern string comm6X="----------------------------";
extern string comm7X="----------------------------";
extern string comm8X="----------------------------";
extern string comm9X="----------------------------";
extern int 做多1做空2全做3=3;
extern bool 是否显示文字标签=true;
extern bool EA加载首个柱子不开仓=false;
extern bool 国际点差自适应=true;
extern color 多单颜色标记=Blue;
extern color 空单颜色标记=Red;
int X=20;
int Y=20;
int Y间隔=15;
color 标签颜色=Yellow;
int 标签字体大小=10;
int 固定角=0;

//////////////////////////////////////////////////////////////

datetime time1,time2;
int 单量小数保留=2;
datetime 启动时间;




void 指标1()
{
指标1做多=0;
指标1做空=0;

   if(指标1开关==false)
   {
   指标1做多=1;
   指标1做空=1;
   return(0);
   }

   double MA1=iMA(Symbol(),指标1时间轴,MA周期1,0,MA计算方式1,MA价格方式1,指标1信号0或1);
   double MA2=iMA(Symbol(),指标1时间轴,MA周期2,0,MA计算方式2,MA价格方式2,指标1信号0或1);
   
   if(MA1>MA2)
   指标1做多=1;   
   
   if(MA1<MA2)
   指标1做空=1;
}




//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      if(AccountEquity()>小于净值阶段3)倍率=单量倍率4;
      if(AccountEquity()<=小于净值阶段3)倍率=单量倍率3;
      if(AccountEquity()<=小于净值阶段2)倍率=单量倍率2;
      if(AccountEquity()<=小于净值阶段1)倍率=单量倍率1;
      if(使用资金管理==false)
      倍率=1;
      
逆势单量[1]=首单单量*倍率;
逆势单量[2]=逆势单量2*倍率;
逆势单量[3]=逆势单量3*倍率;
逆势单量[4]=逆势单量4*倍率;
逆势单量[5]=逆势单量5*倍率;
逆势单量[6]=逆势单量6*倍率;
逆势单量[7]=逆势单量7*倍率;
逆势单量[8]=逆势单量8*倍率;
逆势单量[9]=逆势单量9*倍率;
逆势单量[10]=逆势单量10*倍率;
逆势单量[11]=逆势单量11*倍率;
逆势单量[12]=逆势单量12*倍率;
逆势单量[13]=逆势单量13*倍率;
逆势单量[14]=逆势单量14*倍率;
逆势单量[15]=逆势单量15*倍率;
逆势单量[16]=逆势单量16*倍率;
逆势单量[17]=逆势单量17*倍率;
逆势单量[18]=逆势单量18*倍率;
逆势单量[19]=逆势单量19*倍率;
逆势单量[20]=逆势单量20*倍率;
逆势单量[21]=逆势单量21*倍率;
逆势单量[22]=逆势单量22*倍率;
逆势单量[23]=逆势单量23*倍率;
逆势单量[24]=逆势单量24*倍率;
逆势单量[25]=逆势单量25*倍率;
逆势单量[26]=逆势单量26*倍率;
逆势单量[27]=逆势单量27*倍率;
逆势单量[28]=逆势单量28*倍率;
逆势单量[29]=逆势单量29*倍率;
逆势单量[30]=逆势单量30*倍率;
逆势单量[31]=逆势单量31*倍率;
逆势单量[32]=逆势单量32*倍率;
逆势单量[33]=逆势单量33*倍率;

顺势单量[1]=首单单量*倍率;
顺势单量[2]=顺势单量2*倍率;
顺势单量[3]=顺势单量3*倍率;
顺势单量[4]=顺势单量4*倍率;
顺势单量[5]=顺势单量5*倍率;
顺势单量[6]=顺势单量6*倍率;
顺势单量[7]=顺势单量7*倍率;
顺势单量[8]=顺势单量8*倍率;
顺势单量[9]=顺势单量9*倍率;
顺势单量[10]=顺势单量10*倍率;
顺势单量[11]=顺势单量11*倍率;
顺势单量[12]=顺势单量12*倍率;
顺势单量[13]=顺势单量13*倍率;
顺势单量[14]=顺势单量14*倍率;
顺势单量[15]=顺势单量15*倍率;
顺势单量[16]=顺势单量16*倍率;
顺势单量[17]=顺势单量17*倍率;
顺势单量[18]=顺势单量18*倍率;
顺势单量[19]=顺势单量19*倍率;
顺势单量[20]=顺势单量20*倍率;
顺势单量[21]=顺势单量21*倍率;
顺势单量[22]=顺势单量22*倍率;
顺势单量[23]=顺势单量23*倍率;
顺势单量[24]=顺势单量24*倍率;
顺势单量[25]=顺势单量25*倍率;
顺势单量[26]=顺势单量26*倍率;
顺势单量[27]=顺势单量27*倍率;
顺势单量[28]=顺势单量28*倍率;
顺势单量[29]=顺势单量29*倍率;
顺势单量[30]=顺势单量30*倍率;
顺势单量[31]=顺势单量31*倍率;
顺势单量[32]=顺势单量32*倍率;
顺势单量[33]=顺势单量33*倍率;



  //Alert("重复加载EA请用独立的magic代码,请不要随意切换时间轴");

  if(IsTradeAllowed()==false)
  {
  Alert("           不允许智能交易");
  }
  
  
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<10)单量小数保留=0; 
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<1)单量小数保留=1;
   if(MarketInfo(Symbol(),MODE_LOTSTEP)<0.1)单量小数保留=2;

   启动时间=TimeCurrent();
  
   if(EA加载首个柱子不开仓)
   {
   time1=Time[0];
   time2=Time[0]; 
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
  for(int i=ObjectsTotal();i>=0;i--)
  {
     if(StringFind(ObjectName(i),"标签",0)==0)
     {
     ObjectDelete(ObjectName(i));
     i=ObjectsTotal();
     }
  }        
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

int start()
  {
  RefreshRates();


  指标1();
  
  if(可交易1)
  if(做多1做空2全做3==1||做多1做空2全做3==3)
  if(指标1做多==1||首单接受均线管理==false)
  if(分项单据统计(OP_BUY,magic,"") ==0)
  {
  deleteorder(OP_BUYLIMIT,magic,"");  
  deleteorder(OP_BUYSTOP,magic,"");  
  
     if(分项单据统计(-100,magic,"") ==0)
     {
     init(); 
     laber("重算单量倍率",Yellow,3);
     } 
  建立单据(Symbol(),OP_BUY,逆势单量[1],0,0,止损,止盈,"中{0}"+备注,magic,多单颜色标记);
  laber("首",Yellow,3);
     if(周期结束后不停止运行EA==false)
     可交易1=false;
  }

  if(可交易2)
  if(做多1做空2全做3==2||做多1做空2全做3==3)
  if(指标1做空==1||首单接受均线管理==false)
  if(分项单据统计(OP_SELL,magic,"") ==0)
  {
  deleteorder(OP_SELLLIMIT,magic,"");  
  deleteorder(OP_SELLSTOP,magic,"");  
  
     if(分项单据统计(-100,magic,"") ==0)
     {
     init(); 
     laber("重算单量倍率",Yellow,3);
     } 
  建立单据(Symbol(),OP_SELL,逆势单量[1],0,0,止损,止盈,"中{0}"+备注,magic,空单颜色标记);
  laber("首",Yellow,3);
     if(周期结束后不停止运行EA==false)
     可交易2=false;
  }


  
  if(逆势部分总开关)
  逆势部分();
  if(顺势部分总开关)
  顺势部分();

  

if(是否显示信息框&&IsOptimization()==false)
{
string 内容[100];
内容[0]="小添  QQ：8284518";
内容[1]="平台商:"+AccountCompany()+" 杠杆:"+DoubleToStr(AccountLeverage(),0);
内容[2]="EA独立代码 magic :"+magic;
内容[3]="启动时间:"+DoubleToStr((TimeCurrent()-启动时间)/60/60,1)+"小时";
内容[4]="------------------------------------";
内容[5]="多单个数:"+分项单据统计(OP_BUY,magic,"");
内容[6]="多单获利:"+DoubleToStr(分类单据利润(OP_BUY,magic,""),2);
内容[7]="多单手数:"+DoubleToStr(总交易量(OP_BUY,magic,""),2);
内容[8]="顺势多单个数:"+分项单据统计(OP_BUY,magic,"顺");
内容[9]="顺势多单获利:"+DoubleToStr(分类单据利润(OP_BUY,magic,"顺"),2);
内容[10]="顺势多单手数:"+DoubleToStr(总交易量(OP_BUY,magic,"顺"),2);
内容[11]="逆势多单个数:"+分项单据统计(OP_BUY,magic,"逆");
内容[12]="逆势多单获利:"+DoubleToStr(分类单据利润(OP_BUY,magic,"逆"),2);
内容[13]="逆势多单手数:"+DoubleToStr(总交易量(OP_BUY,magic,"逆"),2);
内容[14]="------------------------------------";
内容[15]="空单个数:"+分项单据统计(OP_SELL,magic,"");
内容[16]="空单获利:"+DoubleToStr(分类单据利润(OP_SELL,magic,""),2);
内容[17]="空单手数:"+DoubleToStr(总交易量(OP_SELL,magic,""),2);
内容[18]="顺势空单个数:"+分项单据统计(OP_SELL,magic,"顺");
内容[19]="顺势空单获利:"+DoubleToStr(分类单据利润(OP_SELL,magic,"顺"),2);
内容[20]="顺势空单手数:"+DoubleToStr(总交易量(OP_SELL,magic,"顺"),2);
内容[21]="逆势空单个数:"+分项单据统计(OP_SELL,magic,"逆");
内容[22]="逆势空单获利:"+DoubleToStr(分类单据利润(OP_SELL,magic,"逆"),2);
内容[23]="逆势空单手数:"+DoubleToStr(总交易量(OP_SELL,magic,"逆"),2);
内容[24]="------------------------------------";
内容[25]="浮动盈亏:"+DoubleToStr(分类单据利润(-100,magic,""),2);
内容[26]="------------------------------------";

   
   for(int ixx=0;ixx<=26;ixx++)
   固定位置标签("标签"+ixx,内容[ixx],X,Y+Y间隔*ixx,标签颜色,标签字体大小,固定角);
}



  
//----

   return(0);
  }
//+------------------------------------------------------------------+
void 顺势部分()
{  
  if(OrderSelect(最高最低单据订单号(OP_BUY,OP_BUY,magic,"H",""),SELECT_BY_TICKET))
  {
  int 序号=StrToInteger(StringSubstr(OrderComment(),StringFind(OrderComment(),"{",0)+1,StringFind(OrderComment(),"}",0)-StringFind(OrderComment(),"{",0)-1))+1;
  double 位置=OrderOpenPrice()+顺势间隔*Point*系数(Symbol());
  
     if(OrderSelect(findlassorder(OP_BUY,OP_BUYSTOP,magic,"后","现在",DoubleToStr(位置,Digits)),SELECT_BY_TICKET)==false)
     {
        if(-Ask+位置>MarketInfo(Symbol(),MODE_STOPLEVEL)*Point)
        {
        建立单据(Symbol(),OP_BUYSTOP,顺势单量[序号],位置,0,止损,止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,多单颜色标记);
           if(减仓模式)
           建立单据(Symbol(),OP_BUYSTOP,顺势单量[序号],位置,0,止损,顺势减仓单止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,多单颜色标记);
        }
        else
        {
        建立单据(Symbol(),OP_BUY,顺势单量[序号],0,0,止损,止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,多单颜色标记);
           if(减仓模式)
           建立单据(Symbol(),OP_BUY,顺势单量[序号],0,0,止损,顺势减仓单止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,多单颜色标记);
        }
     }
  }     
  
  if(分项单据统计(OP_BUY,magic,"顺")>0)
  if(OrderSelect(最高最低单据订单号(OP_BUY,OP_BUY,magic,"H","顺"),SELECT_BY_TICKET))
  批量修改止盈止损(OP_BUY,0,OrderOpenPrice()-顺势回撤止损距离*Point*系数(Symbol()),magic,"");
/////////////////////////////////////////////////
  if(OrderSelect(最高最低单据订单号(OP_SELL,OP_SELL,magic,"L",""),SELECT_BY_TICKET))
  {
  序号=StrToInteger(StringSubstr(OrderComment(),StringFind(OrderComment(),"{",0)+1,StringFind(OrderComment(),"}",0)-StringFind(OrderComment(),"{",0)-1))+1;
  位置=OrderOpenPrice()-顺势间隔*Point*系数(Symbol());
  
     if(OrderSelect(findlassorder(OP_SELL,OP_SELLSTOP,magic,"后","现在",DoubleToStr(位置,Digits)),SELECT_BY_TICKET)==false)
     {
        if(Bid-位置>MarketInfo(Symbol(),MODE_STOPLEVEL)*Point)
        {
        建立单据(Symbol(),OP_SELLSTOP,顺势单量[序号],位置,0,止损,止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,空单颜色标记);
           if(减仓模式)
           建立单据(Symbol(),OP_SELLSTOP,顺势单量[序号],位置,0,止损,顺势减仓单止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,空单颜色标记);
        }
        else
        {
        建立单据(Symbol(),OP_SELL,顺势单量[序号],0,0,止损,止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,空单颜色标记);
           if(减仓模式)
           建立单据(Symbol(),OP_SELL,顺势单量[序号],0,0,止损,顺势减仓单止盈,"顺{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,空单颜色标记);
        }
     }
  }     
  
  if(分项单据统计(OP_SELL,magic,"顺")>0)
  if(OrderSelect(最高最低单据订单号(OP_SELL,OP_SELL,magic,"L","顺"),SELECT_BY_TICKET))
  批量修改止盈止损(OP_SELL,0,OrderOpenPrice()+顺势回撤止损距离*Point*系数(Symbol()),magic,"");  
}


void 逆势部分()
{  
  
  if(OrderSelect(最高最低单据订单号(OP_BUY,OP_BUY,magic,"L",""),SELECT_BY_TICKET))
  {
  int 序号=StrToInteger(StringSubstr(OrderComment(),StringFind(OrderComment(),"{",0)+1,StringFind(OrderComment(),"}",0)-StringFind(OrderComment(),"{",0)-1))+1;
  double 位置=OrderOpenPrice()-逆势间隔*Point*系数(Symbol());
        if(Ask<=位置)
        if(指标1做多==1||序号<逆势N单后可以对冲||逆势单接受均线管理==false)
        建立单据(Symbol(),OP_BUY,逆势单量[序号],0,0,止损,止盈,"逆{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,多单颜色标记);
  }
  
  批量修改止盈止损X(OP_BUY,逆市单止盈,0,magic,"逆",逆势N单内设置止盈);
  
  //if(分项单据统计(OP_BUY,magic,"逆")+1>=逆势持有N单后可以对冲)
  if(OrderSelect(最高最低单据订单号(OP_BUY,OP_BUY,magic,"L","逆"),SELECT_BY_TICKET))
  if(StrToInteger(StringSubstr(OrderComment(),StringFind(OrderComment(),"{",0)+1,StringFind(OrderComment(),"}",0)-StringFind(OrderComment(),"{",0)-1))>=逆势N单后可以对冲)
  if(分类单据利润AB(OP_BUY,magic,"","反","获利",获利个数)+分类单据利润AB(OP_BUY,magic,"","顺","亏损",亏损个数)>=对冲时需要获利金额)
  {
     for(int ix=1;ix<=获利个数;ix++)
     if(OrderSelect(最高最低单据订单号(OP_BUY,OP_BUY,magic,"L",""),SELECT_BY_TICKET))
     if(OrderProfit()+OrderSwap()+OrderCommission()>0)
     OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),滑点);

     for(ix=1;ix<=亏损个数;ix++)
     if(OrderSelect(最高最低单据订单号(OP_BUY,OP_BUY,magic,"H",""),SELECT_BY_TICKET))
     if(OrderProfit()+OrderSwap()+OrderCommission()<0)
     OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),滑点);
  }
  
  if(分项单据统计(OP_BUY,magic,"逆")>0)
  if(分类单据利润(OP_BUY,magic,"")<-防守区亏损N美金后全平)
  {
  deleteorder(OP_BUY,magic,"");
  laber("防守区亏损N美金后全平",Yellow,3);
  }
////////////////////////////////////////////////////////////////////////////////
  

  if(OrderSelect(最高最低单据订单号(OP_SELL,OP_SELL,magic,"H",""),SELECT_BY_TICKET))
  {
  序号=StrToInteger(StringSubstr(OrderComment(),StringFind(OrderComment(),"{",0)+1,StringFind(OrderComment(),"}",0)-StringFind(OrderComment(),"{",0)-1))+1;
  位置=OrderOpenPrice()+逆势间隔*Point*系数(Symbol());
  
        if(Bid>=位置)
        if(指标1做空==1||序号<逆势N单后可以对冲||逆势单接受均线管理==false)
        建立单据(Symbol(),OP_SELL,逆势单量[序号],0,0,止损,止盈,"逆{"+序号+"}"+"("+DoubleToStr(位置,Digits)+")"+备注,magic,空单颜色标记);
  }
  
  批量修改止盈止损X(OP_SELL,逆市单止盈,0,magic,"逆",逆势N单内设置止盈);
  

  
  //if(分项单据统计(OP_SELL,magic,"逆")+1>=逆势持有N单后可以对冲)
  if(OrderSelect(最高最低单据订单号(OP_SELL,OP_SELL,magic,"H","逆"),SELECT_BY_TICKET))
  if(StrToInteger(StringSubstr(OrderComment(),StringFind(OrderComment(),"{",0)+1,StringFind(OrderComment(),"}",0)-StringFind(OrderComment(),"{",0)-1))>=逆势N单后可以对冲)
  if(分类单据利润AB(OP_SELL,magic,"","反","获利",获利个数)+分类单据利润AB(OP_SELL,magic,"","顺","亏损",亏损个数)>=对冲时需要获利金额)
  {
     for(ix=1;ix<=获利个数;ix++)
     if(OrderSelect(最高最低单据订单号(OP_SELL,OP_SELL,magic,"H",""),SELECT_BY_TICKET))
     if(OrderProfit()+OrderSwap()+OrderCommission()>0)
     OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),滑点);

     for(ix=1;ix<=亏损个数;ix++)
     if(OrderSelect(最高最低单据订单号(OP_SELL,OP_SELL,magic,"L",""),SELECT_BY_TICKET))
     if(OrderProfit()+OrderSwap()+OrderCommission()<0)
     OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),滑点);
  }
  
  if(分项单据统计(OP_SELL,magic,"逆")>0)
  if(分类单据利润(OP_SELL,magic,"")<-防守区亏损N美金后全平)
  {
  deleteorder(OP_SELL,magic,"");
  laber("防守区亏损N美金后全平",Yellow,3);
  }  
}


void 批量修改止盈止损(int type,double 止盈,double 止损,int magic,string comm)
{
   if(止盈!=0)
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderTakeProfit()>NormalizeDouble(止盈,Digits)+Point||OrderTakeProfit()<NormalizeDouble(止盈,Digits)-Point)
   if(OrderType()==type)
   {
   OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(止盈,Digits),0);
   报错组件("");
   }

   if(止损!=0)
   for(i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic|| magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderStopLoss()>NormalizeDouble(止损,Digits)+Point||OrderStopLoss()<NormalizeDouble(止损,Digits)-Point)
   //if((OrderStopLoss()>NormalizeDouble(止损,Digits)+Point&&OrderType()==OP_SELL)||(OrderStopLoss()<NormalizeDouble(止损,Digits)-Point&&OrderType()==OP_BUY)||OrderStopLoss()==0)
   if(OrderType()==type)
   {
   OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(止损,Digits),OrderTakeProfit(),0);
   报错组件("");
   }
}

double 分类单据利润AB(int type,int magic,string comm,string 方向,string 获利亏损,int 个数)
{
   double 利润=0;
   int GS=个数;
  
   if(方向=="顺")
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderType()==type||type==-100)
   if(GS>0)
   {
      if(获利亏损=="获利")
      if(OrderProfit()+OrderSwap()+OrderCommission()>0)
      {
      利润+=OrderProfit()+OrderSwap()+OrderCommission();
      GS--;
      }

      if(获利亏损=="亏损")
      if(OrderProfit()+OrderSwap()+OrderCommission()<0)
      {
      利润+=OrderProfit()+OrderSwap()+OrderCommission();
      GS--;
      }
   }

   if(方向=="反")
   for(i=OrdersTotal();i>=0;i--)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderType()==type||type==-100)
   if(GS>0)
   {
      if(获利亏损=="获利")
      if(OrderProfit()+OrderSwap()+OrderCommission()>0)
      {
      利润+=OrderProfit()+OrderSwap()+OrderCommission();
      GS--;
      }

      if(获利亏损=="亏损")
      if(OrderProfit()+OrderSwap()+OrderCommission()<0)
      {
      利润+=OrderProfit()+OrderSwap()+OrderCommission();
      GS--;
      }
   }   
   
return(利润);
}


void 批量修改止盈止损X(int type,double 止盈,double 止损,int magic,string comm,int 序号)
{
   if(止盈!=0)
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderTakeProfit()==0)
   {
   int XX=StrToInteger(StringSubstr(OrderComment(),StringFind(OrderComment(),"{",0)+1,StringFind(OrderComment(),"}",0)-StringFind(OrderComment(),"{",0)-1));
   
      if(XX<=序号)
      if(OrderType()==type||type==-100)
      if(OrderType()==OP_BUY||OrderType()==OP_BUYLIMIT||OrderType()==OP_BUYSTOP)
      if(OrderTakeProfit()!=NormalizeDouble(OrderOpenPrice()+止盈*Point*系数(Symbol()),Digits))
      OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(OrderOpenPrice()+止盈*Point*系数(Symbol()),Digits),0);
      
      if(XX<=序号)
      if(OrderType()==type||type==-100)
      if(OrderType()==OP_SELL||OrderType()==OP_SELLLIMIT||OrderType()==OP_SELLSTOP)
      if(OrderTakeProfit()!=NormalizeDouble(OrderOpenPrice()-止盈*Point*系数(Symbol()),Digits))
      OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(OrderOpenPrice()-止盈*Point*系数(Symbol()),Digits),0);
   }
   if(止损!=0)
   for(i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderStopLoss()==0)
   {
      if(OrderType()==type||type==-100)
      if(OrderType()==OP_BUY||OrderType()==OP_BUYLIMIT||OrderType()==OP_BUYSTOP)
      if(OrderStopLoss()!=NormalizeDouble(OrderOpenPrice()-止损*Point*系数(Symbol()),Digits))
      OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损*Point*系数(Symbol()),Digits),OrderTakeProfit(),0);
      if(OrderType()==type||type==-100)
      if(OrderType()==OP_SELL||OrderType()==OP_SELLLIMIT||OrderType()==OP_SELLSTOP)
      if(OrderStopLoss()!=NormalizeDouble(OrderOpenPrice()+止损*Point*系数(Symbol()),Digits))
      OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损*Point*系数(Symbol()),Digits),OrderTakeProfit(),0);
   }
}
int 最高最低单据订单号(int a,int b,int magic,string 高低,string comm)
{
double 价格=0;
int 订单号=0;
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderType()==a||OrderType()==b||a==-100||b==-100)
   if(  (  (价格==0||价格>OrderOpenPrice())&&高低=="L"  )
      ||(  (价格==0||价格<OrderOpenPrice())&&高低=="H"  )  )
   {
   价格=OrderOpenPrice();
   订单号=OrderTicket();
   }
return(订单号);
}



int findlassorder(int type1,int type2,int magic,string fx,string 现在与历史,string comm)
{
   if(现在与历史=="现在")
   if(fx=="后")
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      if(Symbol()==OrderSymbol())
      if(OrderMagicNumber()==magic||magic==-1)
      if(OrderType()==type1||OrderType()==type2||type1==-100||type2==-100)
      if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
      return(OrderTicket());
   }

   if(现在与历史=="现在")
   if(fx=="前")
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      if(Symbol()==OrderSymbol())
      if(OrderMagicNumber()==magic||magic==-1)
      if(OrderType()==type1||OrderType()==type2||type1==-100||type2==-100)
      if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
      return(OrderTicket());
   }
   
   if(现在与历史=="历史")
   if(fx=="后")
   for(i=OrdersHistoryTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      if(Symbol()==OrderSymbol())
      if(OrderMagicNumber()==magic||magic==-1)
      if(OrderType()==type1||OrderType()==type2||(type1==-100&&OrderType()<=5&&OrderType()>=0))
      if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
      if(OrderCloseTime()!=0)
      return(OrderTicket());
   }

   if(现在与历史=="历史")
   if(fx=="前")
   for(i=0;i<OrdersHistoryTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      if(Symbol()==OrderSymbol())
      if(OrderMagicNumber()==magic||magic==-1)
      if(OrderType()==type1||OrderType()==type2||(type1==-100&&OrderType()<=5&&OrderType()>=0))
      if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
      if(OrderCloseTime()!=0)
      return(OrderTicket());
   }
   
return(-1);
}



double 系数(string symbol)
{
   int 系数=1;
   if(
        MarketInfo(symbol,MODE_DIGITS)==3
      ||MarketInfo(symbol,MODE_DIGITS)==5
      ||(StringFind(symbol,"XAU",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"GOLD",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"Gold",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"USD_GLD",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      )系数=10;
   
   if(StringFind(symbol,"XAU",0)==0&&MarketInfo(symbol,MODE_DIGITS)==3)系数=100;  

   if(国际点差自适应==false)
   return(1);
   
return(系数);
}




void laber(string a,color b,int jl)
{
   Print(a);
   if(IsOptimization())
   return(0);
   
   if(是否显示文字标签==true)
   {
   int pp=WindowBarsPerChart();
   double hh=High[iHighest(Symbol(),0,MODE_HIGH,pp,0)];
   double ll=Low[iLowest(Symbol(),0,MODE_LOW,pp,0)];
   double 文字小距离=(hh-ll)*0.03;  
   
   ObjectDelete("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a);
   ObjectCreate("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,OBJ_TEXT,0,Time[0],Low[0]-jl*文字小距离);
   ObjectSetText("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,a,8,"Times New Roman",b);
   }
}

void deleteorder(int type,int magic,string comm)
{
//datetime time=TimeCurrent();
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      if(Symbol()==OrderSymbol())
      if(OrderMagicNumber()==magic||magic==-1)
      if(OrderType()==type||type==-100)
      if(StringFind(OrderComment(),comm,0)!=-1||comm=="")      
      //if(OrderOpenTime()<=time)
      {
         if(OrderType()>=2)
         {
         OrderDelete(OrderTicket());
         报错组件("");
         i=OrdersTotal();
         }
         else
         {
         OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),滑点*系数(Symbol()));
         报错组件("");
         i=OrdersTotal();
         }
      }
   }
}

int 分项单据统计(int type,int magic,string comm)
{
int 数量=0;
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic|| magic ==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderType()==type||type==-100)
   数量++;
return(数量);
}

double 分类单据利润(int type,int magic,string comm)
{
   double 利润=0;
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderType()==type||type==-100)
   利润+=OrderProfit()+OrderSwap()+OrderCommission();
return(利润);
}

double 总交易量(int type,int magic,string comm)
{
   double js=0;
   for(int i=0;i<OrdersTotal();i++)
   if(OrderSelect(i,SELECT_BY_POS))
   if(OrderSymbol()==Symbol())
   if(OrderMagicNumber()==magic||magic==-1)
   if(StringFind(OrderComment(),comm,0)!=-1||comm=="")
   if(OrderType()==type||(type==-100&&OrderType()<2))
   js+=OrderLots();

return(js);
}

void 固定位置标签(string 名称,string 内容,int X,int Y,color C,int 字体大小,int 固定角)
{
   if(ObjectFind(名称)==-1)
   {
   ObjectDelete(名称);
   ObjectCreate(名称, OBJ_LABEL, 0, 0, 0);
   }
   ObjectSet(名称, OBJPROP_XDISTANCE, X);
   ObjectSet(名称, OBJPROP_YDISTANCE, Y);
   ObjectSetText(名称,内容, 字体大小, "宋体", C);
   ObjectSet(名称, OBJPROP_CORNER, 固定角);
}

int 建立单据(string 货币对,int 类型,double 单量,double 价位,double 间隔,double 止损,double 止盈,string 备注,int magic,color 颜色标记)
{

   if(MarketInfo(货币对,MODE_LOTSTEP)<10)int 单量小数保留X=0; 
   if(MarketInfo(货币对,MODE_LOTSTEP)<1)单量小数保留X=1;
   if(MarketInfo(货币对,MODE_LOTSTEP)<0.1)单量小数保留X=2;


   单量=NormalizeDouble(单量,单量小数保留X);

   if(单量<MarketInfo(货币对,MODE_MINLOT))
   {
   laber("低于最低单量",Yellow,0);
   return(-1);
   }
  
   if(单量>MarketInfo(货币对,MODE_MAXLOT))
   单量=MarketInfo(货币对,MODE_MAXLOT);
   
   while(IsTradeContextBusy())
   Sleep(100);

   int t;
   int i;
   double zs,zy;
   double POINT=MarketInfo(货币对,MODE_POINT)*系数(货币对);
   int DIGITS=MarketInfo(货币对,MODE_DIGITS);
   int 滑点2=滑点*系数(货币对);
   价位=NormalizeDouble(价位,MarketInfo(货币对,MODE_DIGITS));
   if(类型==OP_BUY)
   {
      RefreshRates();
      t=OrderSend(货币对,OP_BUY,单量,MarketInfo(货币对,MODE_ASK),滑点2,0,0,备注,magic,0,颜色标记); 
      报错组件("");  
      if(OrderSelect(t,SELECT_BY_TICKET))
      {
         if(止损!=0&&止盈!=0)
         for(int ix=0;ix<3;ix++)
         if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损*POINT,DIGITS),NormalizeDouble(OrderOpenPrice()+止盈*POINT,DIGITS),0))
         break;

         if(止损==0&&止盈!=0)
         for(ix=0;ix<3;ix++)
         if(OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()+止盈*POINT,DIGITS),0))
         break;

         if(止损!=0&&止盈==0)
         for(ix=0;ix<3;ix++)
         if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损*POINT,DIGITS),0,0))
         break;
         
         报错组件("");
      } 
   }

   if(类型==OP_SELL)
   {
      RefreshRates();
      t=OrderSend(货币对,OP_SELL,单量,MarketInfo(货币对,MODE_BID),滑点2,0,0,备注,magic,0,颜色标记); 
      报错组件("");  
      if(OrderSelect(t,SELECT_BY_TICKET))
      {
         if(止损!=0&&止盈!=0)
         for(ix=0;ix<3;ix++)
         if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损*POINT,DIGITS),NormalizeDouble(OrderOpenPrice()-止盈*POINT,DIGITS),0))
         break;

         if(止损==0&&止盈!=0)
         for(ix=0;ix<3;ix++)
         if(OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()-止盈*POINT,DIGITS),0))
         break;

         if(止损!=0&&止盈==0)
         for(ix=0;ix<3;ix++)
         if(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损*POINT,DIGITS),0,0))
         break;
      }
      报错组件(""); 
   }


   if(类型==OP_BUYLIMIT||类型==OP_BUYSTOP)
   {
      if(价位==0)
      {
      RefreshRates();
      价位=MarketInfo(货币对,MODE_ASK);
      }   

      if(类型==OP_BUYLIMIT)
         {
            if(止损!=0&&止盈!=0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT-止损*POINT,DIGITS),NormalizeDouble(价位-间隔*POINT+止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损==0&&止盈!=0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位-间隔*POINT+止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损!=0&&止盈==0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT-止损*POINT,DIGITS),0,备注,magic,0,颜色标记); 
            if(止损==0&&止盈==0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0,颜色标记);            
         }     
      
      if(类型==OP_BUYSTOP)
         {
            if(止损!=0&&止盈!=0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT-止损*POINT,DIGITS),NormalizeDouble(价位+间隔*POINT+止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损==0&&止盈!=0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位+间隔*POINT+止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损!=0&&止盈==0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT-止损*POINT,DIGITS),0,备注,magic,0,颜色标记); 
            if(止损==0&&止盈==0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0,颜色标记);             
         } 
      报错组件("");
   }   

   if(类型==OP_SELLLIMIT||类型==OP_SELLSTOP)
   {
      if(价位==0)
      {
      RefreshRates();
      价位=MarketInfo(货币对,MODE_BID);
      }

      if(类型==OP_SELLSTOP)
         {
            if(止损!=0&&止盈!=0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT+止损*POINT,DIGITS),NormalizeDouble(价位-间隔*POINT-止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损==0&&止盈!=0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位-间隔*POINT-止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损!=0&&止盈==0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT+止损*POINT,DIGITS),0,备注,magic,0,颜色标记);
            if(止损==0&&止盈==0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0,颜色标记); 
         }     
      
      if(类型==OP_SELLLIMIT)
         {
            if(止损!=0&&止盈!=0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT+止损*POINT,DIGITS),NormalizeDouble(价位+间隔*POINT-止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损==0&&止盈!=0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位+间隔*POINT-止盈*POINT,DIGITS),备注,magic,0,颜色标记); 
            if(止损!=0&&止盈==0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT+止损*POINT,DIGITS),0,备注,magic,0,颜色标记); 
            if(止损==0&&止盈==0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0,颜色标记); 
         } 
      报错组件("");
   }   
return(t);
}
//-----------------------------------------
//------------------------------------
void 报错组件(string a)
{

   while(IsTradeContextBusy())
   Sleep(100);

Sleep(100);
RefreshRates();
   if(IsOptimization())
   return(0);

int t=GetLastError();
string 报警;
   if(t!=0)
   switch (t)
   {
   //case 0:报警="错误代码:"+0+"没有错误返回";break;
   //case 1:报警="错误代码:"+1+"没有错误返回但结果不明";break;
   //case 2:报警="错误代码:"+2+"一般错误";break;
   case 3:报警="错误代码:"+3+"无效交易参量";break;
   case 4:报警="错误代码:"+4+"交易服务器繁忙";break;
   case 5:报警="错误代码:"+5+"客户终端旧版本";break;
   case 6:报警="错误代码:"+6+"没有连接服务器";break;
   case 7:报警="错误代码:"+7+"没有权限";break;
   //case 8:报警="错误代码:"+8+"请求过于频繁";break;
   case 9:报警="错误代码:"+9+"交易运行故障";break;
   case 64:报警="错误代码:"+64+"账户禁止";break;
   case 65:报警="错误代码:"+65+"无效账户";break;
  // case 128:报警="错误代码:"+128+"交易超时";break;
   case 129:报警="错误代码:"+129+"无效价格";break;
   case 130:报警="错误代码:"+130+"无效停止";break;
   case 131:报警="错误代码:"+131+"无效交易量";break;
   case 132:报警="错误代码:"+132+"市场关闭";break;
   case 133:报警="错误代码:"+133+"交易被禁止";break;
   case 134:报警="错误代码:"+134+"资金不足";break;
   case 135:报警="错误代码:"+135+"价格改变";break;
   //case 136:报警="错误代码:"+136+"开价";break;
   case 137:报警="错误代码:"+137+"经纪繁忙";break;
   //case 138:报警="错误代码:"+138+"重新开价";break;
   case 139:报警="错误代码:"+139+"定单被锁定";break;
   case 140:报警="错误代码:"+140+"只允许看涨仓位";break;
   //case 141:报警="错误代码:"+141+"过多请求";break;
   case 145:报警="错误代码:"+145+"因为过于接近市场，修改否定";break;
   //case 146:报警="错误代码:"+146+"交易文本已满";break;
   case 147:报警="错误代码:"+147+"时间周期被经纪否定";break;
   case 148:报警="错误代码:"+148+"开单和挂单总数已被经纪限定";break;
   case 149:报警="错误代码:"+149+"当对冲备拒绝时,打开相对于现有的一个单置";break;
   case 150:报警="错误代码:"+150+"把为反FIFO规定的单子平掉";break;
   case 4000:报警="错误代码:"+4000+"没有错误";break;
   case 4001:报警="错误代码:"+4001+"错误函数指示";break;
   case 4002:报警="错误代码:"+4002+"数组索引超出范围";break;
   case 4003:报警="错误代码:"+4003+"对于调用堆栈储存器函数没有足够内存";break;
   case 4004:报警="错误代码:"+4004+"循环堆栈储存器溢出";break;
   case 4005:报警="错误代码:"+4005+"对于堆栈储存器参量没有内存";break;
   case 4006:报警="错误代码:"+4006+"对于字行参量没有足够内存";break;
   case 4007:报警="错误代码:"+4007+"对于字行没有足够内存";break;
   //case 4008:报警="错误代码:"+4008+"没有初始字行";break;
   case 4009:报警="错误代码:"+4009+"在数组中没有初始字串符";break;
   case 4010:报警="错误代码:"+4010+"对于数组没有内存";break;
   case 4011:报警="错误代码:"+4011+"字行过长";break;
   case 4012:报警="错误代码:"+4012+"余数划分为零";break;
   case 4013:报警="错误代码:"+4013+"零划分";break;
   case 4014:报警="错误代码:"+4014+"不明命令";break;
   case 4015:报警="错误代码:"+4015+"错误转换(没有常规错误)";break;
   case 4016:报警="错误代码:"+4016+"没有初始数组";break;
   case 4017:报警="错误代码:"+4017+"禁止调用DLL ";break;
   case 4018:报警="错误代码:"+4018+"数据库不能下载";break;
   case 4019:报警="错误代码:"+4019+"不能调用函数";break;
   case 4020:报警="错误代码:"+4020+"禁止调用智能交易函数";break;
   case 4021:报警="错误代码:"+4021+"对于来自函数的字行没有足够内存";break;
   case 4022:报警="错误代码:"+4022+"系统繁忙 (没有常规错误)";break;
   case 4050:报警="错误代码:"+4050+"无效计数参量函数";break;
   case 4051:报警="错误代码:"+4051+"无效参量值函数";break;
   case 4052:报警="错误代码:"+4052+"字行函数内部错误";break;
   case 4053:报警="错误代码:"+4053+"一些数组错误";break;
   case 4054:报警="错误代码:"+4054+"应用不正确数组";break;
   case 4055:报警="错误代码:"+4055+"自定义指标错误";break;
   case 4056:报警="错误代码:"+4056+"不协调数组";break;
   case 4057:报警="错误代码:"+4057+"整体变量过程错误";break;
   case 4058:报警="错误代码:"+4058+"整体变量未找到";break;
   case 4059:报警="错误代码:"+4059+"测试模式函数禁止";break;
   case 4060:报警="错误代码:"+4060+"没有确认函数";break;
   case 4061:报警="错误代码:"+4061+"发送邮件错误";break;
   case 4062:报警="错误代码:"+4062+"字行预计参量";break;
   case 4063:报警="错误代码:"+4063+"整数预计参量";break;
   case 4064:报警="错误代码:"+4064+"双预计参量";break;
   case 4065:报警="错误代码:"+4065+"数组作为预计参量";break;
   case 4066:报警="错误代码:"+4066+"刷新状态请求历史数据";break;
   case 4067:报警="错误代码:"+4067+"交易函数错误";break;
   case 4099:报警="错误代码:"+4099+"文件结束";break;
   case 4100:报警="错误代码:"+4100+"一些文件错误";break;
   case 4101:报警="错误代码:"+4101+"错误文件名称";break;
   case 4102:报警="错误代码:"+4102+"打开文件过多";break;
   case 4103:报警="错误代码:"+4103+"不能打开文件";break;
   case 4104:报警="错误代码:"+4104+"不协调文件";break;
   case 4105:报警="错误代码:"+4105+"没有选择定单";break;
   case 4106:报警="错误代码:"+4106+"不明货币对";break;
   case 4107:报警="错误代码:"+4107+"无效价格";break;
   case 4108:报警="错误代码:"+4108+"无效定单编码";break;
   case 4109:报警="错误代码:"+4109+"不允许交易";break;
   case 4110:报警="错误代码:"+4110+"不允许长期";break;
   case 4111:报警="错误代码:"+4111+"不允许短期";break;
   case 4200:报警="错误代码:"+4200+"定单已经存在";break;
   case 4201:报警="错误代码:"+4201+"不明定单属性";break;
   //case 4202:报警="错误代码:"+4202+"定单不存在";break;
   case 4203:报警="错误代码:"+4203+"不明定单类型";break;
   case 4204:报警="错误代码:"+4204+"没有定单名称";break;
   case 4205:报警="错误代码:"+4205+"定单坐标错误";break;
   case 4206:报警="错误代码:"+4206+"没有指定子窗口";break;
   case 4207:报警="错误代码:"+4207+"定单一些函数错误";break;
   case 4250:报警="错误代码:"+4250+"错误设定发送通知到队列中";break;
   case 4251:报警="错误代码:"+4251+"无效参量- 空字符串传递到SendNotification()函数";break;
   case 4252:报警="错误代码:"+4252+"无效设置发送通知(未指定ID或未启用通知)";break;
   case 4253:报警="错误代码:"+4253+"通知发送过于频繁";break;
   }
   if(t!=0)
   {
   Print(报警);
   laber(报警,Yellow,0);
   }
}





