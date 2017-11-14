#property copyright "QQ:80064229 YellowSpecie 有机会多交流 2014年01月14日"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 BlueViolet
#property indicator_color2 Red
#property indicator_color3 Navy
#property indicator_color4 Green


extern string _displaMaSetUp= "设置区间均线的全部参数";
extern int maPeriod=56;
extern int maShift=1;
extern int maMethod=MODE_LWMA;
extern int maAppliedPrice=PRICE_CLOSE;
extern int maCount=20;
extern double maDValue=100.0;
extern bool isDisplay=true;
extern int disPlayPeriod=0;

double Ma_Value[];
double Ma_UpArrow[];
double Ma_FlatArrow[];
double Ma_DownArrow[];

int maxCount=2000;


int init() {
      IndicatorBuffers(5);
      SetIndexBuffer(0, Ma_Value);
      SetIndexBuffer(1, Ma_UpArrow);
      SetIndexBuffer(2, Ma_FlatArrow);
      SetIndexBuffer(3, Ma_DownArrow);

      SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 3);
      SetIndexStyle(1, DRAW_ARROW,0,2);
      SetIndexStyle(2,DRAW_ARROW,0,2);
      SetIndexStyle(3,DRAW_ARROW,0,2);
      SetIndexArrow(1,241);
      SetIndexArrow(2,214);
      SetIndexArrow(3,234);
     
      SetIndexDrawBegin(0,maPeriod);
      IndicatorShortName("Ma Direction "+ maPeriod); 
      
   return (0);
}

int deinit() {
   ObjectDelete("Ma趋势 "+maPeriod);
   for(int k=0;k<1000;k++)
   {
   ObjectDelete("Ma趋势 "+maPeriod+k);
   ObjectDelete("MaP "+maPeriod+k);

   
   }
   return (0);
}

int start() 
{
   int UporDown[];

   int counted_bars = IndicatorCounted();
   if (counted_bars < 0) return (-1);

   int i = 0;int j=0; int k=0;


    int limit = Bars - counted_bars + maPeriod + 2; //多算一条K线
    if (limit > Bars) limit = Bars;

//  if (limit > maxCount) limit = maxCount;
   
   ArrayResize(UporDown, limit);
   ArraySetAsSeries(UporDown, TRUE);

   for (i = 0; i < limit; i++) Ma_Value[i] = iMA(NULL,0,maPeriod ,maShift,maMethod,maAppliedPrice,i);  //取得均线的值 

   for (i = limit - maPeriod; i >= 0; i--) 
   {
      UporDown[i] = UporDown[i + 1];
      if (Ma_Value[i] - Ma_Value[i + maCount]>maDValue*Point)  UporDown[i] = 1;   //上升 为1
      if (Ma_Value[i] - Ma_Value[i + maCount]<-maDValue*Point) UporDown[i] = -1;  //下降为 -1
      if (Ma_Value[i] - Ma_Value[i + maCount]<maDValue*Point && Ma_Value[i] - Ma_Value[i + maCount]>-maDValue*Point) UporDown[i] = 11;   //中间为11
   
      if (UporDown[i] ==1) 
      {
         if (UporDown[i + 1]==-1 || UporDown[i + 1]==11) 
         {
           Ma_UpArrow[i]= Ma_Value[i]-Period()*6*Point;
           if (Ma_UpArrow[i+1]==1) Ma_UpArrow[i+1] = EMPTY_VALUE;
         }
         Ma_DownArrow[i] = EMPTY_VALUE;
         Ma_FlatArrow[i] = EMPTY_VALUE;
      } 

      if (UporDown[i] ==-1) 
      {
         if (UporDown[i+1]==1 || UporDown[i+1]==11) 
         {
            Ma_DownArrow[i]= Ma_Value[i]+Period()*6*Point;
            if (Ma_DownArrow[i+1]==-1) Ma_DownArrow[i+1] = EMPTY_VALUE;
         }
            Ma_UpArrow[i] = EMPTY_VALUE;
            Ma_FlatArrow[i] = EMPTY_VALUE;
      }
 
       if (UporDown[i] ==11) 
      {
           if (UporDown[i + 1] ==1 || UporDown[i + 1]==-1) 
           {
            Ma_FlatArrow[i]= Ma_Value[i]-Period()*6*Point;
            if (Ma_FlatArrow[i+1]==11) Ma_FlatArrow[i+1] = EMPTY_VALUE;
           }
            Ma_UpArrow[i] = EMPTY_VALUE;
            Ma_DownArrow[i] = EMPTY_VALUE;
      
      }
      
   }
 
   k=0;
 
   int iWave[20];
   int iWaveUpDown[20];
 
   for (i=0;i<=limit && k<10;i++)
   {
      if (Ma_UpArrow[i]!=EMPTY_VALUE && Ma_UpArrow[i+1]==EMPTY_VALUE)
      {
         if (isDisplay==true)
         drawText("Ma趋势 "+maPeriod+k,0,disPlayPeriod,">>升 "+DTS(Ma_Value[i] - Ma_Value[i+maCount],Digits),0,iTime(NULL,0,i)+Period()*8*60, ND(Ma_Value[i]-500*Point,Digits),9,"Tahoma",Red); 
         iWave[k]=i;
         iWaveUpDown[k]=1;

         k++;
      }
      if (Ma_FlatArrow[i]!=EMPTY_VALUE && Ma_FlatArrow[i+1]==EMPTY_VALUE)
      {
         if (isDisplay==true)
         drawText("Ma趋势 "+maPeriod+k,0,disPlayPeriod,">>平 "+DTS(Ma_Value[i] - Ma_Value[i+maCount],Digits),0,iTime(NULL,0,i)+Period()*8*60, ND(Ma_Value[i]-500*Point,Digits),9,"Tahoma",Red); 
         iWave[k]=i;
         iWaveUpDown[k]=11;

         k++;
      }

      if (Ma_DownArrow[i]!=EMPTY_VALUE && Ma_DownArrow[i+1]==EMPTY_VALUE)
      {
         if (isDisplay==true)
         drawText("Ma趋势 "+maPeriod+k,0,disPlayPeriod,">>降 "+DTS(Ma_Value[i] - Ma_Value[i+maCount],Digits),0,iTime(NULL,0,i)+Period()*8*60, ND(Ma_Value[i]+500*Point,Digits),9,"Tahoma",Red); 
         iWave[k]=i;
         iWaveUpDown[k]=-1;

         k++;
      }
    
   }
   if (isDisplay==true)   
   drawText("Ma趋势"+maPeriod,0,disPlayPeriod,">> "+DTS(Ma_Value[0] - Ma_Value[maCount],Digits),0,Time[0]+10*60*30, ND(Ma_Value[0],Digits),9,"Tahoma",Blue); 
   
   for (k=0;k<=10;k++)
   {
      if (iWaveUpDown[k]==11 && k==0)
      {
      if (isDisplay==true)
      drawRectangle("MaP "+maPeriod+k,0, disPlayPeriod,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]-500*Point,Time[0]+5*30*60,Ma_Value[iWave[k]]+500*Point,PowderBlue);
      }

      if (iWaveUpDown[k]==1 && k==0)
      {
      if (isDisplay==true)
      drawTriangle("MaP "+maPeriod+k,0, disPlayPeriod,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]-500*Point,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]+500*Point,Time[0]+5*30*60,Ma_Value[0]+1000*Point,Pink);
      }

      if (iWaveUpDown[k]==-1 && k==0)
      {
      if (isDisplay==true)
      drawTriangle("MaP "+maPeriod+k,0, disPlayPeriod,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]-500*Point,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]+500*Point,Time[0]+5*30*60,Ma_Value[0]-1000*Point,PaleGreen);
      }


      if (k>=1)
      {
   
         if (iWaveUpDown[k]==11)
         {
         if (isDisplay==true)
         drawRectangle("MaP "+maPeriod+k,0, disPlayPeriod,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]-500*Point,iTime(NULL,0,iWave[k-1]),Ma_Value[iWave[k]]+500*Point,PowderBlue);
         }

         if (iWaveUpDown[k]==1)
         {
         if (isDisplay==true)
         drawTriangle("MaP "+maPeriod+k,0, disPlayPeriod,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]-500*Point,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]+500*Point,iTime(NULL,0,iWave[k-1]),Ma_Value[iWave[k-1]],Pink);
         }

         if (iWaveUpDown[k]==-1)
         {
         if (isDisplay==true)
         drawTriangle("MaP "+maPeriod+k,0, disPlayPeriod,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]-500*Point,iTime(NULL,0,iWave[k]),Ma_Value[iWave[k]]+500*Point,iTime(NULL,0,iWave[k-1]),Ma_Value[iWave[k-1]],PaleGreen);
         }
      }
   }  

   return (0);
}




void drawText(string name,int Win_idx,datetime pTime,string Laber,int Corner,datetime T, double P,int fontSize,string font,color Color)
  {
   ObjectDelete(name);
       
   if (ObjectFind(name) == Win_idx)
   {
     ObjectSetText(name,Laber,fontSize, font, Color);
     ObjectSet(name, OBJPROP_CORNER, Corner);
     ObjectSet(name, OBJPROP_TIME1, T);
     ObjectSet(name, OBJPROP_PRICE1, P);
   }
   else
   {
     ObjectCreate(name, OBJ_TEXT, Win_idx, 0, 0);
     ObjectSetText(name,Laber,fontSize, font, Color);
     ObjectSet(name, OBJPROP_CORNER, Corner);
     ObjectSet(name, OBJPROP_TIME1, T);
     ObjectSet(name, OBJPROP_PRICE1, P);
   }
    if (pTime !=0)      
    ObjectSet(name,OBJPROP_TIMEFRAMES, pTime);
    return(0);
  }

void drawRectangle(string name,int Win_idx, int pTime,double T1,double P1,double T2,double P2,color Color)
{         
   ObjectDelete(name);

   if (ObjectFind(name) == Win_idx)
   {
      ObjectCreate(name, OBJ_RECTANGLE, Win_idx, T1, P1,T2,P2);
      ObjectSet(name, OBJPROP_COLOR, Color);
   }
   else
   {
      ObjectDelete(name);
      ObjectCreate(name, OBJ_RECTANGLE, Win_idx, T1, P1,T2,P2);
      ObjectSet(name, OBJPROP_COLOR, Color);
   }
    if (pTime !=0)      
    ObjectSet(name,OBJPROP_TIMEFRAMES, pTime);
   
   return(0);
  
}
  
  
//画三角形
void drawTriangle(string name,int Win_idx, int pTime,int T1,double P1,int T2,double P2,int T3,double P3,color Color)
{         
   ObjectDelete(name);

   if (ObjectFind(name) == -1)
   {
      ObjectCreate(name, OBJ_TRIANGLE, Win_idx, T1, P1,T2,P2,T3,P3);
      ObjectSet(name, OBJPROP_COLOR, Color);
   }
   else
   {
    ObjectDelete(name);
    ObjectCreate(name, OBJ_TRIANGLE, Win_idx, T1, P1,T2,P2,T3,P3);
    ObjectSet(name, OBJPROP_TIME1, T1);
    ObjectSet(name, OBJPROP_PRICE1, P1);
    ObjectSet(name, OBJPROP_TIME2, T2);
    ObjectSet(name, OBJPROP_PRICE2, P2);
    ObjectSet(name, OBJPROP_TIME3, T3);
    ObjectSet(name, OBJPROP_PRICE3, P3);
    ObjectSet(name, OBJPROP_COLOR, Color);
   }
    if (pTime !=0)      
    ObjectSet(name,OBJPROP_TIMEFRAMES, pTime);

  return(0);
}


//+-----------------------------------------------------------------+
//| Normalize Double                                                |
//+-----------------------------------------------------------------+
double ND(double Value,int Precision){return(NormalizeDouble(Value,Precision));}

//+-----------------------------------------------------------------+
//| Double To String                                                |
//+-----------------------------------------------------------------+
string DTS(double Value,int Precision){return(DoubleToStr(Value,Precision));}



