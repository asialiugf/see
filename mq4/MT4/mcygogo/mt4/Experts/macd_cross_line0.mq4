//+------------------------------------------------------------------+
//|                                                        test2.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |

//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int mark=0;           //全局变量 //避免重复报警控制
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
   ObjectDelete("macd");   //关闭EA,删除对象
    ObjectDelete("macd2");   //关闭EA,删除对象
     ObjectDelete("macd3");   //关闭EA,删除对象
      ObjectDelete("macd4");   //关闭EA,删除对象
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
double macdcurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);   //引用内部MACD函数，并赋值  为当前+1价格位置
double macdprevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,2);  //引用内部MACD函数，并赋值  为当前+2价格位置 
wt("macd","MACD均线现：  "+DoubleToStr(macdcurrent,Digits),1,20,20,Yellow,11);     //屏幕输出 
wt("macd2","MACD均线前：  "+DoubleToStr(macdprevious,Digits),1,20,40,Red,11);     //屏幕输出

//string nameo;
//nameo=ObjectDescription("macd");
//Print(nameo);
//###########################################################判断突破0，这很简单。 各位我习惯屏幕直接输出。这样更容易学习。
    
if( macdcurrent>0.0000 && macdprevious<0.0000 && mark!=1)   //判断是否突破
    {
    wt("macd3","MACD均线状态：  上突破0轴",1,20,60,Red,11);            //屏幕输出
    ObjectDelete("macd4");                                            //删除向下突破显示
    
    Alert(Symbol(),"MACD：已向上突破0");                             //警报提示
     mark=1;                                                         //避免重复报警控制
    } 
//   else
//   {
//   wt("macd3","MACD上突破0轴：  pending......",1,20,60,Red,11);    //屏幕输出
//  }
if( macdcurrent<0.0000 && macdprevious>0.0000 && mark!=2)      //判断是否突破
    {
    wt("macd4","MACD均线状态：  下突破0轴",1,20,80,Red,11);    //屏幕输出
    ObjectDelete("macd3");
    
     Alert(Symbol(),"MACD：已向下突破0");                       //警报
     mark=2;                                                      //避免重复报警控制
    }
//   else
//   {
//  wt("macd4","MACD下突破0轴：  pending......",1,20,80,Red,11);       //屏幕输出
//  }
//----
   return(0);
  }
//自定义函数  
void wt(string labelname,string date,int j,int x,int y,color colorvalue,int fontsize) //创建WT函数，进行文字显示。
{
   ObjectDelete(labelname);
   ObjectCreate(labelname,OBJ_LABEL,0,0,0);
   ObjectSetText(labelname,date,fontsize,"arial",colorvalue);
   ObjectSet(labelname,OBJPROP_CORNER,j);
   ObjectSet(labelname,OBJPROP_XDISTANCE,x);
   ObjectSet(labelname,OBJPROP_YDISTANCE,y);
}

