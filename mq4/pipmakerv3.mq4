//+--------------------------------------------------+
//|PipMaker v2 Last Update 06-17-2007 16:35pm
//+--------------------------------------------------+ 

#include  <stdlib.mqh>
#define   NL    "\n"

// Regular Variables
extern bool   Bothways              =  true;
extern double MinTime               =  91;
extern double Lots                  =  0.1;      
extern double Increment             =  0;
extern bool   Multiplier            =  false;
extern bool   Conservative          =  false;
extern double ProfitReducer         =  0.75;
extern int    ProfitTarget          =  50;
extern int    Spacing               =  2;
extern int    TrendSpacing          =  1;
extern double CounterTrendMultiplier=  2;
extern bool   EndTrading            =  false;  
extern bool   Boost                 =  true;

// ixternal settings
int      Step          = 1;
int      Orders        = 1;    
int      Slippage      = 0;                   
int      MagicNumber   = 7476253781;     
string   TradeComment  = "PipMaker v2";
datetime bartime       = 0;                    
static bool     TradeAllowed  = true;             
double   BoostTrack    = 0;                
bool     OppositeClose = true;

//+-------------+
//| Custom init |
//|-------------+
int init()
  {

  }

//+----------------+
//| Custom DE-init |
//+----------------+

int deinit()
  {

  }
    
//+-----------------------------------------------+
//| Closes all Buys in Profit                   
//+-----------------------------------------------+
void CloseBuysinProfit()
{
  double OrdersBUY, BuyProfit, LastBuyTime;
 
   for(int i = OrdersTotal()-1; i >=0; i--)
       {
       OrderSelect(i, SELECT_BY_POS);
       bool result = false;
       if (OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY)  
         {
           BuyProfit = OrderProfit() + OrderSwap() + OrderCommission();
           if (OrderOpenTime()>LastBuyTime) LastBuyTime=OrderOpenTime();
           if (TimeCurrent()-LastBuyTime >=MinTime && (OrderProfit()+OrderSwap()+OrderCommission())>0)  result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
         }
       }
  return; 
}
   
//+-----------------------------------------------+
//| Closes all Sells in Profit                   
//+-----------------------------------------------+
void CloseSellsinProfit()
{
  double OrdersSELL, SellProfit, LastSellTime;
 
   for(int i = OrdersTotal()-1; i >=0; i--)
      {
      OrderSelect(i, SELECT_BY_POS);
      bool result = false;
      if (OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL)  
       {
         SellProfit = OrderProfit() + OrderSwap() + OrderCommission();
         if (OrderOpenTime()>LastSellTime) LastSellTime=OrderOpenTime();
         if (TimeCurrent()-LastSellTime >=MinTime && (OrderProfit()+OrderSwap()+OrderCommission())>0) result = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red);
       }
     }
 
  return; 
}
      
//+------------------------------------------------------------------+
//| Check for BUY order conditions                                   |
//+------------------------------------------------------------------+
void CheckForBuy()
  {
   double   BuyOrders; 
   double LowestBuy=1000, HighestBuy;
   int      cnt=0;
   int      gle=0;
   
   if(bartime!=Time[0]) 
     {
      bartime=Time[0];
      BoostTrack=0;
      TradeAllowed=true;
     }
     
   for(cnt=OrdersTotal();cnt>=0;cnt--)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderType() == OP_BUY && OrderMagicNumber()==MagicNumber)
        {
            if (OrderOpenPrice()<LowestBuy) LowestBuy=OrderOpenPrice();
            if (OrderOpenPrice()>HighestBuy) HighestBuy=OrderOpenPrice();
            BuyOrders++;
        }
     }
     
   if(TradeAllowed && Multiplier)
      {
         if (Ask >= HighestBuy+(TrendSpacing*Point))
            {
               for(int i=1;i<Orders+1;i++) 
                  {
                     OrderSend(Symbol(),OP_BUY,Lots * (MathPow(Increment, BuyOrders)/Orders),Ask,Slippage,0,0,TradeComment,MagicNumber,Blue);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
         if (Ask <= LowestBuy-(Spacing*Point))
            {
               for(int l=1;l<Orders+1;l++) 
                  {
                     OrderSend(Symbol(),OP_BUY,(Lots * CounterTrendMultiplier) * (MathPow(Increment, BuyOrders)/Orders),Ask,Slippage,0,0,TradeComment,MagicNumber,Blue);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
     }
            
   if(TradeAllowed && !Multiplier)
      {
         if (Ask >= HighestBuy+(TrendSpacing*Point))
            {
               for(int o=1;o<Orders+1;o++) 
                  {
                     OrderSend(Symbol(),OP_BUY,Lots + ((BuyOrders * Increment)/Orders),Ask,Slippage,0,0,TradeComment,MagicNumber,Blue);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
         if (Ask <= LowestBuy-(Spacing*Point))
            {
               for(int m=1;m<Orders+1;m++) 
                  {
                     OrderSend(Symbol(),OP_BUY,(Lots * CounterTrendMultiplier) + ((BuyOrders * Increment)/Orders),Ask,Slippage,0,0,TradeComment,MagicNumber,Blue);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
     }
            
   }

    
//+------------------------------------------------------------------+
//| Check for SELL order conditions                                   |
//+------------------------------------------------------------------+
void CheckForSell()
  {
   double   SellOrders;
   double HighestSell, LowestSell=1000;
   int      cnt=0;
   int      gle=0;
      
   if(bartime!=Time[0]) 
     {
      bartime=Time[0];
      BoostTrack=0;
      TradeAllowed=true;
     }
     
   for(cnt=OrdersTotal();cnt>=0;cnt--)
     {
     OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if( OrderSymbol()==Symbol() && OrderType() == OP_SELL && OrderMagicNumber()==MagicNumber)
        {
            if (OrderOpenPrice()>HighestSell) HighestSell=OrderOpenPrice();
            if (OrderOpenPrice()<LowestSell) LowestSell=OrderOpenPrice();
            SellOrders++;
        }
     } 
    
   if(TradeAllowed && Multiplier)
      {
         if (Bid <= LowestSell-(TrendSpacing*Point))
            {
               for(int i=1;i<Orders+1;i++) 
                  {
                     OrderSend(Symbol(),OP_SELL,Lots * (MathPow(Increment, SellOrders)/Orders),Bid,Slippage,0,0,TradeComment,MagicNumber,Red);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
         if (Bid >= HighestSell+(Spacing*Point))
            {
               for(int l=1;l<Orders+1;l++) 
                  {
                     OrderSend(Symbol(),OP_SELL,(Lots * CounterTrendMultiplier) * (MathPow(Increment, SellOrders)/Orders),Bid,Slippage,0,0,TradeComment,MagicNumber,Red);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
     }
            
   if(TradeAllowed && !Multiplier)
      {
         if (Bid <= LowestSell-(TrendSpacing*Point))
            {
               for(int o=1;o<Orders+1;o++) 
                  {
                     OrderSend(Symbol(),OP_SELL,Lots + ((SellOrders*Increment)/Orders),Bid,Slippage,0,0,TradeComment,MagicNumber,Red);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
         if (Bid >= HighestSell+(Spacing*Point))
            {
               for(int m=1;m<Orders+1;m++) 
                  {
                     OrderSend(Symbol(),OP_SELL,(Lots * CounterTrendMultiplier) + ((SellOrders*Increment)/Orders),Bid,Slippage,0,0,TradeComment,MagicNumber,Red);
                     Print(AccountMargin());
                  }
               gle=GetLastError();
               if(gle==0)
                  {
                     BoostTrack=Close[0];
                     TradeAllowed=false;
                  }
            }
      }
            
   }

//+-----------+
//| Main      |
//+-----------+
int start()
  {
  
// Regular count

   double         MarginPercent;
   static double  LowMarginPercent=10000000;
   double         BUYPipInfo, SELLPipInfo;
   double         i, OrdersSELL, OrdersBUY, BuyPips, SellPips, BuyLots, SellLots;
   static double  LowestBuy=1000, HighestBuy, LowestSell=1000, HighestSell, HighPoint, MidPoint, LowPoint;
   double         BuyProfit, SellProfit, PosBuyProfit, PosSellProfit;
   static double  HighestBuyTicket, LowestBuyTicket, HighestSellTicket, LowestSellTicket;
   double         HighestBuyProfit, LowestBuyProfit, HighestSellProfit, LowestSellProfit;
   double         CurrentTime = (TimeHour(CurTime()+TimeMinute(CurTime())));
   bool           SELLme = false;
   bool           BUYme = false;
   double         Margin = MarketInfo(Symbol(), MODE_MARGINREQUIRED);

   for(i = 0; i < OrdersTotal(); i++)
     {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
       if (OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber)
        {
           if(OrderType()==OP_BUY && OrderOpenPrice()>HighestBuy) HighestBuy=OrderOpenPrice();
           if(OrderType()==OP_BUY && OrderOpenPrice()<LowestBuy) LowestBuy=OrderOpenPrice();
           if(OrderType()==OP_SELL && OrderOpenPrice()>HighestSell) HighestSell=OrderOpenPrice();
           if(OrderType()==OP_SELL && OrderOpenPrice()<LowestSell) LowestSell=OrderOpenPrice();
           if(OrderType()==OP_BUY && OrderOpenPrice()==HighestBuy) HighestBuyTicket=OrderTicket();
           if(OrderType()==OP_SELL && OrderOpenPrice()==LowestSell) LowestSellTicket=OrderTicket();
           if(OrderType()==OP_BUY && OrderTicket()==HighestBuyTicket) HighestBuyProfit=OrderProfit() + OrderSwap() + OrderCommission();
           if(OrderType()==OP_SELL && OrderTicket()==LowestBuyTicket) LowestBuyProfit=OrderProfit() + OrderSwap() + OrderCommission();
           if(OrderType()==OP_BUY && OrderTicket()==HighestSellTicket) HighestSellProfit=OrderProfit() + OrderSwap() + OrderCommission();
           if(OrderType()==OP_SELL && OrderTicket()==LowestSellTicket) LowestSellProfit=OrderProfit() + OrderSwap() + OrderCommission();
           if(OrderType()==OP_BUY)  OrdersBUY++;
           if(OrderType()==OP_SELL) OrdersSELL++;
           if(OrderType()==OP_BUY)  BuyLots += OrderLots();
           if(OrderType()==OP_SELL) SellLots += OrderLots();
           if(OrderType()==OP_BUY)  BuyProfit += OrderProfit() + OrderCommission() + OrderSwap();
           if(OrderType()==OP_SELL) SellProfit += OrderProfit() + OrderCommission() + OrderSwap();
           if(OrderType()==OP_BUY && (OrderProfit() + OrderSwap() + OrderCommission())>0)  PosBuyProfit += OrderProfit() + OrderCommission() + OrderSwap();
           if(OrderType()==OP_SELL && (OrderProfit() + OrderSwap() + OrderCommission())>0) PosSellProfit += OrderProfit() + OrderCommission() + OrderSwap();
        }
     }

   if (OrdersBUY > 1 && Multiplier) BUYPipInfo = ProfitTarget * MathPow(ProfitReducer, OrdersBUY - 1) * Orders;
   else 
   BUYPipInfo = ProfitTarget;
   if (OrdersSELL > 1 && Multiplier) SELLPipInfo = ProfitTarget * MathPow(ProfitReducer, OrdersSELL - 1)* Orders; 
   else 
   SELLPipInfo = ProfitTarget;   
  
   if (HighestBuy > HighestSell)
      {
         HighPoint = HighestBuy;}
      else {
         HighPoint = HighestSell;
      }
      
   if (LowestBuy < LowestSell)
      {
         LowPoint = LowestBuy;}
      else {
         LowPoint = LowestSell;
      }

   if ((OrdersSELL > 1 && OrdersBUY > 0) || (OrdersSELL > 0 && OrdersBUY > 1)) MidPoint = (HighPoint + LowPoint) / 2;
      
   if (Bid>MidPoint){
      if((PosBuyProfit + LowestSellProfit) >= ProfitTarget && LowestSell < LowestBuy)
         {  
            CloseBuysinProfit();
            OrderSelect(LowestSellTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red);
            LowestBuy=1000;HighestBuy=0;
            LowestSellTicket=0;
         }

      if((PosSellProfit + LowestSellProfit) >= ProfitTarget && LowestSell < LowestBuy)
         {
            CloseSellsinProfit();
            OrderSelect(LowestSellTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red);
            LowestSell=1000;HighestSell=0;
            LowestSellTicket=0;
         }
      
      if((PosBuyProfit + LowestBuyProfit) >= ProfitTarget && LowestBuy < LowestSell)
         {  
            CloseBuysinProfit();
            OrderSelect(LowestBuyTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red);
            LowestBuy=1000; HighestBuy=0;
            LowestBuyTicket=0;
         }

      if((PosSellProfit + LowestBuyProfit) >= ProfitTarget && LowestBuy < LowestSell)
         {
            CloseSellsinProfit();
            OrderSelect(LowestBuyTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red);
            LowestSell=1000; HighestSell=0;
            LowestBuyTicket=0;
         }
      }
      
   if (Bid<MidPoint){
      if((PosBuyProfit + HighestBuyProfit) >= ProfitTarget && HighestBuy > HighestSell)
         {  
            CloseBuysinProfit();
            OrderSelect(HighestBuyTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red);
            LowestBuy=1000; HighestBuy=0;
            HighestBuyTicket=0;
         }

      if((PosSellProfit + HighestBuyProfit) >= ProfitTarget && HighestBuy > HighestSell)
         {
            CloseSellsinProfit();
            OrderSelect(HighestBuyTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red);
            LowestSell=1000;HighestSell=0;
            HighestBuyTicket=0;
         }
      if((PosBuyProfit + HighestSellProfit) >= ProfitTarget && HighestSell > HighestBuy)
         {  
            CloseBuysinProfit();
            OrderSelect(HighestSellTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red);
            LowestBuy=1000; HighestBuy=0;
            HighestSellTicket=0;
         }

      if((PosSellProfit + HighestSellProfit) >= ProfitTarget && HighestSell > HighestBuy)
         {
            CloseSellsinProfit();
            OrderSelect(HighestSellTicket, SELECT_BY_TICKET);
            OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red);
            LowestSell=1000;HighestSell=0;
            HighestSellTicket=0;
         }
      }
      
// BUY Trade Criteria

    
    if (Ask <= LowestBuy-(Spacing*Point) || Ask >= HighestBuy+(TrendSpacing*Point))
       {
       BUYme=true;  
       if(Boost && BoostTrack>0 && Close[0]<BoostTrack)
         {
         BUYme=true;
         TradeAllowed=true;
         }
      }
    if (EndTrading == true && OrdersBUY == 0) BUYme = false;
    if (BUYme == true) CheckForBuy(); 

// SELL Trade Criteria

    if (Bid >= HighestSell+(Spacing*Point) || Bid <= LowestSell-(TrendSpacing*Point))
       {
       SELLme=true; 
       if(Boost && BoostTrack>0 && Close[0]>BoostTrack)
        {
         SELLme=true; 
         TradeAllowed=true;
        }
     } 
    if (EndTrading == true && OrdersSELL == 0) SELLme = false;
    if (SELLme == true) CheckForSell();
    
    
//   if (OrdersBUY == 0 && OrdersSELL == 0) MarginPercent = 0;
//   else
   MarginPercent = MathRound((AccountEquity()/AccountMargin())*100);
   
   if (LowMarginPercent > MarginPercent) LowMarginPercent = MarginPercent;
   

   Comment("                    PipMaker v2 Last Update 06-17-2007 16:35pm", NL,
           "                            ProfitTarget ", BUYPipInfo, NL,
           "                            Buys    ", OrdersBUY, NL,
           "                            BuyLots        ", BuyLots, NL,
           "                            BuyProfit             ", BuyProfit, NL,
           "                            Highest Buy  ", HighestBuy, NL, NL,
           "                            ProfitTarget ", SELLPipInfo, NL,
           "                            Sells    ", OrdersSELL, NL,
           "                            SellLots        ", SellLots, NL,
           "                            SellProfit             ", SellProfit, NL,
           "                            Lowest Sell    ", LowestSell, NL, NL,
           "                            Balance ", AccountBalance(), NL,
           "                            Equity        ", AccountEquity(), NL, NL,
           "                            Margin      ", MathRound(AccountMargin()), NL,
           "                            MarginPercent        ", MarginPercent, NL,
           "                            LowMarginPercent     ", LowMarginPercent, NL,
           "                            Current Time is  ",TimeHour(TimeCurrent()),":",TimeMinute(TimeCurrent()),".",TimeSeconds(TimeCurrent()));   


//----------------------------------------------------------//
// Low Margin Percent Label                                 //
//----------------------------------------------------------//

   string MarPercent = DoubleToStr(MarginPercent,0);
   string LowMarPercent = DoubleToStr(LowMarginPercent,0);
   
   string ACCBAL     = DoubleToStr(AccountBalance(),0);
   ObjectDelete("MarginPercent");
   ObjectDelete("LowMarginPercent");
   
   if(ObjectFind("MarginPercent") != 0)
   {
   ObjectCreate("MarginPercent", OBJ_TEXT, 0, Time[0], Close[0]+20*Point);
   ObjectSetText("MarginPercent", MarPercent+"%  "+LowMarPercent+"%   $"+ACCBAL, 24, "Arial", White);
   }
   else
   {
   ObjectMove("MarginPercent", 0, Time[0], Close[0]+20*Point);
   }

//----------------------------------------------------------//
// Mid Point Line                                           //
//----------------------------------------------------------//
   if(ObjectFind("MidPoint") != 0)
   {
   ObjectCreate("MidPoint", OBJ_HLINE, 0, Time[0], MidPoint);
      ObjectSet("MidPoint", OBJPROP_COLOR, Blue);
      ObjectSet("MidPoint", OBJPROP_WIDTH, 2);
   }
   else
   {
   ObjectMove("MidPoint", 0, Time[0], MidPoint);
   }
   
} // end start()

