//+------------------------------------------------------------------+
//|                                                      BarTime.mq4 |
//|                           Copyright © 2010, Forex-Tools-Cafe.Com |
//|                                  http://www.forex-tools-cafe.com |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2010, Forex-Tools-Cafe.Com"
#property link      "http://www.forex-tools-cafe.com"

#property indicator_chart_window

extern int      ChartX   = 30 ;
extern int      ChartY   = 20 ;
extern int      Corner   = 1 ;
extern string   Font  = "Ariel";
extern int      FontSize = 14 ;
extern color    colorText  = Blue ;
extern bool     EnableBarOpenAnnouncement=false; 
extern int      ChooseAnnouncement=1; // 0,1,2,3 
extern string   S1="0 => New Bar";
extern string   S2="1 => New Bar is Open.";
extern string   S3="2 => A New Bar is Open.";
extern string   S4="3 => Belly up to the Bar, a new one is open.";
string          theObject="BarTime"; 

string   lasttime; 

int init()
{

   return(0);
}

int deinit()
{
   ObjectDelete(theObject); 
   return(0);
}

int start()
{
   int    counted_bars=IndicatorCounted();

    int thisbarminutes = Period();
    int thisbarseconds = thisbarminutes*60; 
    int seconds= thisbarseconds - (TimeCurrent()-Time[0]); // seconds left in bar 
    
    int minutes= MathFloor(seconds/60);
    int hours  = MathFloor(seconds/3600);
    
    minutes = minutes -  hours*60  ;
    seconds = seconds - minutes*60 - hours*3600; 
    
   string str = DoubleToStr( hours,0)+ ":" + DoubleToStr(minutes,0) + ":" + DoubleToStr(seconds,0);
   
   if ( StringFind(lasttime, str ) < 0 )     
      ShowLabel("BarTime:   " + str, colorText);
   
   lasttime = str; 
   
   if ( EnableBarOpenAnnouncement && NewBar() )
      PlaySound(Choose( ChooseAnnouncement)); 
 
        
   return(0);
}

void ShowLabel( string str, color dsColor  )
{

   if ( ObjectFind(theObject) >= 0 ) 
      ObjectDelete(theObject); 

   ObjectCreate(theObject,OBJ_LABEL,0,Time[0],PRICE_CLOSE);
   ObjectSet(theObject, OBJPROP_CORNER, Corner );
   ObjectSet(theObject,OBJPROP_XDISTANCE, ChartX);
   ObjectSet(theObject,OBJPROP_YDISTANCE, ChartY);
    
   ObjectSetText(theObject,str,FontSize,Font,dsColor);

}  




bool NewBar()
{
   static datetime lastbar = 0;
   datetime curbar = Time[0];
   if(lastbar!=curbar)
   {
      lastbar=curbar;
      return (true);
   }
   else
   {
      return(false);
   }
}  


string Choose(int  choice )
{
    
    string asound; 
    
    switch(choice) {
       case 0:  asound="NewBar.wav"; break;
       case 1:  asound="NewBar_IsOpen.wav"; break;
       case 2: asound="ANewBarIsOpen.wav"; break;
       case 3: asound="BellyUpToTheBar.wav"; break;
       default: asound="NewBar.wav"; 
    }
    
    return(asound);
}


