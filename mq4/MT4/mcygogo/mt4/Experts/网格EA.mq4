
//inputs esterni
extern double TakeProfitLong     = 50;
extern double TakeProfitShort    = 50;
extern int     DLong             = 30;
extern int     DShort            = 30;
extern double     Pct_Equity        = 1;
extern double Multiplier         = 2;
extern int    MaxTrades          = 5;
extern int    Slippage           = 3;
extern int    cangliang          =20;
extern bool   UseSound           = false;
extern int    minicang           =2; //0.01=2
extern int shift = 0;
extern int ma7_period = 7;              //ma参数值
extern int ma14_period = 14;
extern int ma27_period = 27;
extern int ma52_period = 52;
extern int ma60_period = 60;

double ma7; 
double ma14;                           //ma的值       
double ma27; 
double ma52;
double ma60;
//variabili globali
string  Name_Expert    = "";
double  stopLossB      = 30; 
double  stopLossS      = 30; 
string  NameFileSound  = "alert.wav";
double  InitLots       = 0.01;
double  MaxLot         = 1000000;
int     SL             = 20;
double  sB=0,sS=0,MinAccount=9999999;
int c,j;
double LotsB,LotsS,Long,Short;
double LastB=0,LastS=1000; 

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
  MinAccount=AccountEquity();
  return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
  return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
   {
   
   if(Bars<1)   {Print("bars less than 1");return(0);}
   
   double   Price=iClose(NULL,0,0);
  
   if (!ExistPositions()) {sB=0; sS=0;}
    
   int T=0;
   int B=0;  
   for(int i=0;i<OrdersTotal();i++) 
      {    
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderComment()==Name_Expert)   
        { 
        int type=OrderType();
        switch(type)
           {
           case OP_BUY:
              sB=1;
              T++;
              LastB=OrderOpenPrice();
              break;
           case OP_SELL:
              sS=2;
              B++;
              LastS=OrderOpenPrice();
               
              break;
           }
        }    
      }
      
 
   InitLots=MathCeil(AccountBalance()/10000)/cangliang;
   LotsB=InitLots;
   LotsS=InitLots;
   LotsB=NormalizeDouble(MathFloor(LotsB*100)/100,minicang);
   LotsS=NormalizeDouble(MathFloor(LotsS*100)/100,minicang);
   if (minicang==2){
       if (LotsB<0.01) LotsB=0.01;
       if (LotsS<0.01) LotsS=0.01;}
   if (minicang==1){
       if (LotsB<0.1) LotsB=0.1;
       if (LotsS<0.1) LotsS=0.1;}
  
  
   stopLossB=SL+(MaxTrades-1)*DLong;
   stopLossS=SL+(MaxTrades-1)*DShort;
   for (j=0;j<T;j++) {LotsB=Multiplier*LotsB; stopLossB=stopLossB-DLong;}
   for (j=0;j<B;j++) {LotsS=Multiplier*LotsS; stopLossS=stopLossS-DShort;}
  // if (AccountBalance()>6000) MaxLot=MathFloor(AccountBalance()/4)/100;
   if (LotsB>MaxLot) LotsB=MaxLot; 
   if (LotsS>MaxLot) LotsS=MaxLot; 
   if (LotsB>100) LotsB=100; 
   if (LotsS>100) LotsS=100; 

   if (T==0) { Long=1000;}
   if (B==0) {Short=-1000;}
   if ((T>0)||(B>0))
      {
      if ((sB==1)&&(Long>LastB)) Long=LastB;
      if ((sS==2)&&(Short<LastS)) Short=LastS;
      }
   if ((T==MaxTrades)||(B==MaxTrades)) c=1;//达到最大开仓数量,限制最大开仓个数
   if ((T==0)||(B==0)) c=0;
   if ((sB==0)||(sS==0)) if(AccountFreeMargin()<(1000*LotsB))
      {
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return(0);
      }
   double spread=(Ask-Bid)/Point;
   double V1=High[iHighest(NULL,0,MODE_HIGH,2,1)];
   double V2=Low[iLowest(NULL,0,MODE_LOW,2,1)];
   
    ma7 = iMA(Symbol() , NULL , ma7_period , 0 , MODE_EMA , PRICE_CLOSE , i );
    ma14 = iMA(Symbol() , NULL , ma14_period , 0 , MODE_EMA , PRICE_CLOSE , i );
    ma27 = iMA(Symbol() , NULL , ma27_period , 0 , MODE_EMA , PRICE_CLOSE , i );
    ma52 = iMA(Symbol() , NULL , ma52_period , 0 , MODE_EMA , PRICE_CLOSE , i );
    ma60 = iMA(Symbol() , NULL , ma60_period , 0 , MODE_EMA , PRICE_CLOSE , i );
   if ((sB==0)&&(c==0)&& ma27 > ma52 && ma52 > ma60 &&V2< ma14)  {OpenBuy();sB=1;} 
   if ((sS==0)&&(c==0)&& ma27< ma52 && ma52<ma60&&V1>  ma14)  {OpenSell();sS=2;}   
   if ((T<MaxTrades)&&(B<MaxTrades))
      {
      if ((sB==1)&&(Price<=(LastB-(DLong+spread)*Point))&&(c==0))   {OpenBuy();sB=1;return(0);}
      if ((sS==2)&&(Price>=(LastS+(DShort)*Point))&&(c==0))         {OpenSell();sS=2;return(0);}
      if ((sB==1)&&(Price>=(Long+TakeProfitLong*Point)))            {closeAllOrders(0);sB=0;return(0);}
      if ((sS==2)&&(Price<=(Short-(TakeProfitShort+spread)*Point))) {closeAllOrders(1);sS=0;return(0);} 
     
      }
      
  
  return (0);
}//end start

// - - - - - - FUNZIONI - - - - - - -
 
bool ExistPositions()
   {
   for(int i=0;i<OrdersTotal(); i++)
      {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderComment()==Name_Expert) return(True);
         else return(false);
      }   
}
void OpenBuy()
   { 
   double ldLot, ldStop, ldTake; 
   string lsComm; 
   ldLot = GetSizeLotB(); 
   ldStop = Ask-Point*stopLossB; 
   if (ldStop<0.01) ldStop=0; 
    //Comment("lotB="+ ldStop);
   ldTake = NormalizeDouble(GetTakeProfitBuy(),Digits); 
   lsComm = GetCommentForOrder(); 
   OrderSend(Symbol(),OP_BUY,ldLot,NormalizeDouble(Ask,Digits),Slippage,ldStop,ldTake,lsComm,0,0,NULL);
  //OrderSend(Symbol(),OP_BUY,0.1,Ask,Slippage,ldStop,ldTake,lsComm,0,0,NULL);
  
   if (UseSound) PlaySound(NameFileSound);
}
 
void OpenSell()
   { 
   double ldLot, ldStop, ldTake; 
   string lsComm; 
   ldLot = GetSizeLotS(); 
   ldStop = Bid+Point*stopLossS; 
   ldTake = NormalizeDouble(GetTakeProfitSell(),Digits); 
   lsComm = GetCommentForOrder();
   OrderSend(Symbol(),OP_SELL,ldLot,NormalizeDouble(Bid,Digits),Slippage,ldStop,ldTake,lsComm,0,0,NULL); 
   if (UseSound) PlaySound(NameFileSound);
}
void closeAllOrders(int type)
   {
   for(int c=0;c<OrdersTotal();c++)
      {
      OrderSelect(c,SELECT_BY_POS,MODE_TRADES); 
      if (OrderSymbol()==Symbol() && OrderComment()==Name_Expert && OrderType()==OP_BUY && type==0)
         {
         OrderClose(OrderTicket(), OrderLots(),Bid,Slippage, White);
         }
      if (OrderSymbol()==Symbol() && OrderComment()==Name_Expert && OrderType()==OP_SELL && type==1)
         {
         OrderClose(OrderTicket(), OrderLots(), Ask,Slippage, White);
         }   
      if (OrderSymbol()==Symbol() && OrderComment()==Name_Expert && OrderType() > 1)  {OrderDelete(OrderTicket());
      }
   }
} 

string GetCommentForOrder() {return(Name_Expert);} 
double GetSizeLotB() {return(LotsB);} 
double GetSizeLotS() {return(LotsS);} 
double GetTakeProfitBuy() {return(Ask+TakeProfitLong*Point);} 
double GetTakeProfitSell() {return(Bid-TakeProfitShort*Point);} 