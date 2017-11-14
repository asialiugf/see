//+--------------------------------------------------+
//|PipMaker v11 Last Update 08-20-2010 14:50pm       |
//+--------------------------------------------------+

#include <stdlib.mqh>
#include <stderror.mqh>

#define  NL    "\n"

// Regular variables
bool    LotIncrease                   = true;
bool    Buy                           = true;
bool    Sell                          = true;
extern string  smallestlotsize               = "0.1 = 1, 0.01 = 2";
extern double  SmallestLotSize               = 2;
extern double  MaxLotSize                    = 5;
extern double  LotSize                       = 0.01;
extern double  LotIncrement                  = 0.01;
//extern bool    Multiplier                  = true;
extern int     Multiplier                    = 0;
extern double  ProfitTarget                  = 5;
extern double  TrendProfitTarget             = 5;
extern double  SafetyLevelPercentage         = 400;
extern double  SafetyProfitTargetPercent     = 25;
//extern bool    OpenOnTick                  = false;
int     OpenOnTick                    = 1;
extern int     Spacing                       = 10;
extern int     TrendSpacing                  = 10;
extern double  CounterTrendMultiplier        = 2;
double  CloseDelay                    = 120;
int     OrdersToClose                 = 0;
int     MinimumOrdersToCloseLosing    = 1;
int     MaxMarginPercentage           = 40;
extern int     TrendTimeFrame                = PERIOD_M1;
extern int     TrendPeriods                  = 40;
extern int     TrendMultiplier               = 25;
extern int     Speed                         = 8;
extern int     SpeedReduction                = 5;
extern int     MaxBuyMoney                   = 25;
extern int     MaxSellMoney                  = 25;
extern bool    CeaseTrading                  = false;
extern bool    RightSideLabel                = true;

// Internal settings
//int            Step           = 1; NOT NEEDED
int            Spacing2       = 0;
int            TrendSpacing2  = 0;
int            TrendPeriods2  = 1;
int            Error          = 0;
int            Order          = 0;
int            Orders         = 0;
int            Slippage       = 0;
int            Reference      = 0;
string         TradeComment   = "PipMaker v11";
datetime       BarTime        = 0;
static bool    TradeAllowed   = true;
double         TickPrice      = 0;
double         BuyProfits [1][2];
double         SellProfits [1][2];
bool           Trending = false;
double         StartingBalance = 0;                
double         StartingEquity  = 0;                


int            MaxBuys        = 0;
int            MaxSells       = 0;

bool           Auditing       = true;
string         Filename       = "PipMaker.txt";

int init()
{
   if (Symbol() == "AUDCADm" || Symbol() == "AUDCAD") Reference = 801001;
   if (Symbol() == "AUDJPYm" || Symbol() == "AUDJPY") Reference = 801002;
   if (Symbol() == "AUDNZDm" || Symbol() == "AUDNZD") Reference = 801003;
   if (Symbol() == "AUDUSDm" || Symbol() == "AUDUSD") Reference = 801004;
   if (Symbol() == "CHFJPYm" || Symbol() == "CHFJPY") Reference = 801005;
   if (Symbol() == "EURAUDm" || Symbol() == "EURAUD") Reference = 801006;
   if (Symbol() == "EURCADm" || Symbol() == "EURCAD") Reference = 801007;
   if (Symbol() == "EURCHFm" || Symbol() == "EURCHF") Reference = 801008;
   if (Symbol() == "EURGBPm" || Symbol() == "EURGBP") Reference = 801009;
   if (Symbol() == "EURJPYm" || Symbol() == "EURJPY") Reference = 801010;
   if (Symbol() == "EURUSDm" || Symbol() == "EURUSD") Reference = 801011;
   if (Symbol() == "GBPCHFm" || Symbol() == "GBPCHF") Reference = 801012;
   if (Symbol() == "GBPJPYm" || Symbol() == "GBPJPY") Reference = 801013;
   if (Symbol() == "GBPUSDm" || Symbol() == "GBPUSD") Reference = 801014;
   if (Symbol() == "NZDJPYm" || Symbol() == "NZDJPY") Reference = 801015;
   if (Symbol() == "NZDUSDm" || Symbol() == "NZDUSD") Reference = 801016;
   if (Symbol() == "USDCHFm" || Symbol() == "USDCHF") Reference = 801017;
   if (Symbol() == "USDJPYm" || Symbol() == "USDJPY") Reference = 801018;
   if (Symbol() == "USDCADm" || Symbol() == "USDCAD") Reference = 801019;
   if (Reference == 0) Reference = 801999;
   
   if(LotIncrease)
     {
      StartingBalance=AccountBalance()/LotSize;
      StartingEquity= AccountEquity();
     }

}


int deinit()
{

}


void CloseBuysInProfit()
{
   double BuyProfit, LastBuyTime;

   RefreshRates();

   Orders = ArraySize(BuyProfits) / 2;
   for (Order = 0; Order < Orders; Order++)
   {
      if (BuyProfits[Order][0] > 0 && (OrdersToClose == 0 || Order < OrdersToClose))
      {
         if (OrderSelect(BuyProfits[Order][1], SELECT_BY_TICKET))
         {
            if (OrderOpenTime() > LastBuyTime) LastBuyTime = OrderOpenTime();
            if ((IsTesting() || TimeCurrent() - LastBuyTime >= CloseDelay) && OrderCloseTime() == 0 && BuyProfits[Order][0] > 0) OrderClose(OrderTicket(), OrderLots(), Bid, 5, Green);

            Error = GetLastError();
            if (Error != 0) Write("Error closing BUY order " + OrderTicket() + ": " + ErrorDescription(Error) + " (A" + Error + ")  Lots:" + OrderLots() + "  Bid:" + MarketInfo(OrderSymbol(), MODE_BID));
         }

         Error = GetLastError();
         if (Error != 0) Write("Error accessing BUY order " + DoubleToStr(BuyProfits[Order][1], 0) + ": " + ErrorDescription(Error) + " (A" + Error + ")  Lots:" + OrderLots() + "  Bid:" + MarketInfo(OrderSymbol(), MODE_BID));
      }
   }
   return;
}


void CloseSellsInProfit()
{
   double SellProfit, LastSellTime;

   RefreshRates();
   
   Orders = ArraySize(SellProfits) / 2;
   for (Order = 0; Order < Orders; Order++)
   {
      if (SellProfits[Order][0] > 0 && (OrdersToClose == 0 || Order < OrdersToClose))
      {
         if (OrderSelect(SellProfits[Order][1], SELECT_BY_TICKET))
         {
            if (OrderOpenTime() > LastSellTime) LastSellTime = OrderOpenTime();
            if ((IsTesting() || TimeCurrent() - LastSellTime >= CloseDelay) && OrderCloseTime() == 0 && SellProfits[Order][0] > 0) OrderClose(OrderTicket(), OrderLots(), Ask, 5, Red);

            Error = GetLastError();
            if (Error != 0) Write("Error closing SELL order " + OrderTicket() + ": " + ErrorDescription(Error) + " (B" + Error + ")  Lots:" + OrderLots() + "  Ask:" + MarketInfo(OrderSymbol(), MODE_ASK));
         }

         Error = GetLastError();
         if (Error != 0) Write("Error accessing SELL order " + DoubleToStr(SellProfits[Order][1], 0) + ": " + ErrorDescription(Error) + " (B" + Error + ")  Lots:" + OrderLots() + "  Ask:" + MarketInfo(OrderSymbol(), MODE_ASK));
      }
   }

   return;
}


void PlaceBuyOrder()
{
   double BuyOrders, Lots;
   double LowestBuy = 1000, HighestBuy;

   if (BarTime != Time[0])
   {
      BarTime = Time[0];
      TickPrice = 0;
      TradeAllowed = true;
   }

   RefreshRates();

   if(LotIncrease)
     {
      Lots=NormalizeDouble(AccountBalance()/StartingBalance,SmallestLotSize);
     } 

   
   for (Order = OrdersTotal() - 1; Order >= 0; Order--)
   {
      if (OrderSelect(Order, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Reference && OrderType() == OP_BUY)
         {
            if (OrderOpenPrice() < LowestBuy) LowestBuy = OrderOpenPrice();
            if (OrderOpenPrice() > HighestBuy) HighestBuy = OrderOpenPrice();
            BuyOrders++;
         }
      }
   }

   if (TradeAllowed)
   {
      if (Ask > HighestBuy + (TrendSpacing * Point))
      {
         if (Multiplier == 1)
            Lots = NormalizeDouble(LotSize * MathPow(LotIncrement, BuyOrders), SmallestLotSize);
         else
            Lots = NormalizeDouble(LotSize + (LotIncrement * BuyOrders), SmallestLotSize);
      }

      if (Ask < LowestBuy - (Spacing * Point))
      {
         if (Multiplier == 1)
            Lots = NormalizeDouble(LotSize * CounterTrendMultiplier * MathPow(LotIncrement, BuyOrders), SmallestLotSize);
         else
            Lots = NormalizeDouble((LotSize * CounterTrendMultiplier) + (LotIncrement * BuyOrders), SmallestLotSize);
      }

      if (Lots == 0) Lots = NormalizeDouble(LotSize, SmallestLotSize);
      
      if (Lots > MaxLotSize) Lots = MaxLotSize;

      OrderSend(Symbol(), OP_BUY, Lots, Ask, Slippage, 0, 0, TradeComment, Reference, Green);

      Error = GetLastError();
      if (Error != 0)
         Write("Error opening BUY order: " + ErrorDescription(Error) + " (C" + Error + ")  Ask:" + Ask + "  Slippage:" + Slippage);
      else
      {
         TickPrice = Close[0];
         TradeAllowed = false;
      }
   }
}


void PlaceSellOrder()
{
   double SellOrders, Lots;
   double HighestSell, LowestSell = 1000;

   if (BarTime != Time[0])
   {
      BarTime = Time[0];
      TickPrice = 0;
      TradeAllowed = true;
   }

   RefreshRates();
   
   if(LotIncrease)
     {
      Lots=NormalizeDouble(AccountBalance()/StartingBalance,SmallestLotSize);
     } 

   for (Order = OrdersTotal() - 1; Order >= 0; Order--)
   {
      if (OrderSelect(Order, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Reference && OrderType() == OP_SELL)
         {
            if (OrderOpenPrice() > HighestSell) HighestSell = OrderOpenPrice();
            if (OrderOpenPrice() < LowestSell) LowestSell = OrderOpenPrice();
            SellOrders++;
         }
      }
   }

   if (TradeAllowed)
   {
      if (Bid < LowestSell - (TrendSpacing * Point))
      {
         if (Multiplier == 1)
            Lots = NormalizeDouble(LotSize * MathPow(LotIncrement, SellOrders), SmallestLotSize);
         else
            Lots = NormalizeDouble(LotSize + (LotIncrement * SellOrders), SmallestLotSize);
      }
      
      if (Bid > HighestSell + (Spacing * Point))
      {
         if (Multiplier == 1)
            Lots = NormalizeDouble(LotSize * CounterTrendMultiplier * MathPow(LotIncrement, SellOrders), SmallestLotSize);
         else
            Lots = NormalizeDouble((LotSize * CounterTrendMultiplier) + (LotIncrement * SellOrders), SmallestLotSize);
      }

      if (Lots == 0) Lots = NormalizeDouble(LotSize, SmallestLotSize);
      
      if (Lots > MaxLotSize) Lots = MaxLotSize;

      OrderSend(Symbol(), OP_SELL, Lots, Bid, Slippage, 0, 0, TradeComment, Reference, Red);

      Error = GetLastError();
      if (Error != 0)
         Write("Error opening SELL order: " + ErrorDescription(Error) + " (D" + Error + ")  Bid:" + Bid + "  Slippage:" + Slippage);
      else
      {
         TickPrice = Close[0];
         TradeAllowed = false;
      }
   }
}


int start()
{
   double         MarginPercent;
   static double  LowMarginPercent = 10000000, LowEquity = 10000000, LowMargin = 10000000;
   double         BuyPipTarget, SellPipTarget;
   double         BuyPips, SellPips, BuyLots, SellLots;
   int            BuyOrders = 0, SellOrders = 0;
   double         LowestBuy = 999, HighestBuy = 0.0001, LowestSell = 999, HighestSell = 0.0001, HighPoint, MidPoint, LowPoint;
   double         Profit, BuyProfit, SellProfit, PosBuyProfit, PosSellProfit;
   int            HighestBuyTicket, LowestBuyTicket, HighestSellTicket, LowestSellTicket;
   double         HighestBuyProfit, LowestBuyProfit, HighestSellProfit, LowestSellProfit;
   double         CurrentTime = (TimeHour(CurTime() + TimeMinute(CurTime())));
   double         Trend, TrendPrev;
   bool           SELLme = false;
   bool           BUYme = false;
   double         Margin = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   string         Message;
   
   
   

Error = GetLastError();
if (Error != 0) Write("Error 00: " + ErrorDescription(Error) + " (E" + Error + ")");
   Orders = OrdersTotal();
   ArrayResize(BuyProfits, Orders + 1);
   ArrayResize(SellProfits, Orders + 1);
   ArrayInitialize(BuyProfits, 0);
   ArrayInitialize(SellProfits, 0);

   for (Order = Orders - 1; Order >= 0; Order--)
   {
      if (OrderSelect(Order, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Reference && OrderCloseTime() == 0)
         {
            Profit = OrderProfit() + OrderSwap() + OrderCommission();
            
            if (OrderType() == OP_BUY)
            {
               if (OrderOpenPrice() > HighestBuy)
               {
                  HighestBuy = OrderOpenPrice();
                  HighestBuyTicket = OrderTicket();
                  HighestBuyProfit = Profit;
               }

               if (OrderOpenPrice() < LowestBuy)
               {
                  LowestBuy = OrderOpenPrice();
                  LowestBuyTicket = OrderTicket();
                  LowestBuyProfit = Profit;
               }

               BuyProfits[BuyOrders][0] = Profit;
               BuyProfits[BuyOrders][1] = OrderTicket();

               BuyOrders++;
               if (BuyOrders > MaxBuys) MaxBuys = BuyOrders;
               BuyLots += OrderLots();

               BuyProfit += Profit;
            }

            if (OrderType() == OP_SELL)
            {
               if (OrderOpenPrice() > HighestSell)
               {
                  HighestSell = OrderOpenPrice();
                  HighestSellTicket = OrderTicket();
                  HighestSellProfit = Profit;
               }

               if (OrderOpenPrice() < LowestSell)
               {
                  LowestSell = OrderOpenPrice();
                  LowestSellTicket = OrderTicket();
                  LowestSellProfit = Profit;
               }

               SellProfits[SellOrders][0] = Profit;
               SellProfits[SellOrders][1] = OrderTicket();

               SellOrders++;
               if (SellOrders > MaxSells) MaxSells = SellOrders;
               SellLots += OrderLots();

               SellProfit += Profit;
            }
         }
      }
   }

   ArraySort(BuyProfits, WHOLE_ARRAY, 0, MODE_DESCEND);
   ArraySort(SellProfits, WHOLE_ARRAY, 0, MODE_DESCEND);
      
   if (OrdersToClose > 0)
      Orders = MathMin(ArraySize(BuyProfits) / 2, OrdersToClose);
   else
      Orders = ArraySize(BuyProfits) / 2;

   for (Order = 0; Order < Orders; Order++)
   {
      if (BuyProfits[Order][0] > 0) PosBuyProfit += BuyProfits[Order][0];
      if (SellProfits[Order][0] > 0) PosSellProfit += SellProfits[Order][0];
   }

   if (AccountEquity() < AccountMargin() * SafetyLevelPercentage / 100)
   {
      BuyPipTarget = ProfitTarget * SafetyProfitTargetPercent / 100;
      SellPipTarget = ProfitTarget * SafetyProfitTargetPercent / 100;
   }
   else
   {
      BuyPipTarget = ProfitTarget;
      SellPipTarget = ProfitTarget;
   }

   HighPoint = MathMax(HighestBuy, HighestSell);
   LowPoint = MathMin(LowestBuy, LowestSell);
   MidPoint = (HighPoint + LowPoint) / 2;

   RefreshRates();

   if (BuyOrders + SellOrders > MinimumOrdersToCloseLosing)
   {
      if (Ask > MidPoint)
      {
         if (PosBuyProfit + LowestSellProfit >= ProfitTarget && LowestSell < LowestBuy)
         {
            OrderSelect(LowestSellTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing SELL order " + LowestSellTicket + ": " + ErrorDescription(Error) + " (E" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Ask, 5, Green);

            Error = GetLastError();
            if (Error != 0) Write("Error closing SELL order " + OrderTicket() + ": " + ErrorDescription(Error) + " (F" + Error + ")  Lots:" + OrderLots() + "  Ask:" + MarketInfo(OrderSymbol(), MODE_ASK));

            CloseBuysInProfit();

            LowestBuy = 1000;
            HighestBuy = 0;
            LowestSell = 1000;
            LowestSellTicket = 0;
         }
         else if (PosSellProfit + LowestSellProfit >= ProfitTarget && LowestSell < LowestBuy)
         {
            OrderSelect(LowestSellTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing SELL order " + LowestSellTicket + ": " + ErrorDescription(Error) + " (G" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Ask, 5, Red);

            Error = GetLastError();
            if (Error != 0) Write("Error closing SELL order " + OrderTicket() + ": " + ErrorDescription(Error) + " (H" + Error + ")  Lots:" + OrderLots() + "  Ask:" + MarketInfo(OrderSymbol(), MODE_ASK));

            CloseSellsInProfit();

            LowestSell = 1000;
            HighestSell = 0;
            LowestSellTicket = 0;
         }
         else if (PosBuyProfit + LowestBuyProfit >= ProfitTarget && LowestBuy < LowestSell)
         {
            OrderSelect(LowestBuyTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing BUY order " + LowestBuyTicket + ": " + ErrorDescription(Error) + " (I" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Bid, 5, Green);

            Error = GetLastError();
            if (Error != 0) Write("Error closing BUY order " + OrderTicket() + ": " + ErrorDescription(Error) + " (J" + Error + ")  Lots:" + OrderLots() + "  Bid:" + MarketInfo(OrderSymbol(), MODE_BID));

            CloseBuysInProfit();

            LowestBuy = 1000;
            HighestBuy = 0;
            LowestBuyTicket = 0;
         }
         else if (PosSellProfit + LowestBuyProfit >= ProfitTarget && LowestBuy < LowestSell)
         {
            OrderSelect(LowestBuyTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing BUY order " + LowestBuyTicket + ": " + ErrorDescription(Error) + " (K" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Bid, 5, Red);

            Error = GetLastError();
            if (Error != 0) Write("Error closing BUY order " + OrderTicket() + ": " + ErrorDescription(Error) + " (L" + Error + ")  Lots:" + OrderLots() + "  Bid:" + MarketInfo(OrderSymbol(), MODE_BID));

            CloseSellsInProfit();

            LowestSell = 1000;
            HighestSell = 0;
            LowestBuy = 1000;
            LowestBuyTicket = 0;
         }
      }
      else if (Bid < MidPoint)
      {
         if (PosBuyProfit + HighestBuyProfit >= ProfitTarget && HighestBuy > HighestSell)
         {
            OrderSelect(HighestBuyTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing BUY order " + HighestBuyTicket + ": " + ErrorDescription(Error) + " (M" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Bid, 5, Green);

            Error = GetLastError();
            if (Error != 0) Write("Error closing BUY order " + OrderTicket() + ": " + ErrorDescription(Error) + " (N" + Error + ")  Lots:" + OrderLots() + "  Bid:" + MarketInfo(OrderSymbol(), MODE_BID));

            CloseBuysInProfit();

            LowestBuy = 1000;
            HighestBuy = 0;
            HighestBuyTicket = 0;
         }
         else if (PosSellProfit + HighestBuyProfit >= ProfitTarget && HighestBuy > HighestSell)
         {
            OrderSelect(HighestBuyTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing BUY order " + HighestBuyTicket + ": " + ErrorDescription(Error) + " (O" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Bid, 5, Red);

            Error = GetLastError();
            if (Error != 0) Write("Error closing BUY order " + OrderTicket() + ": " + ErrorDescription(Error) + " (P" + Error + ")  Lots:" + OrderLots() + "  Bid:" + MarketInfo(OrderSymbol(), MODE_BID));

            CloseSellsInProfit();

            LowestSell = 1000;
            HighestSell = 0;
            HighestBuy = 0;
            HighestBuyTicket = 0;
         }
         else if (PosBuyProfit + HighestSellProfit >= ProfitTarget && HighestSell > HighestBuy)
         {
            OrderSelect(HighestSellTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing SELL order " + HighestSellTicket + ": " + ErrorDescription(Error) + " (Q" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Ask, 5, Green);

            Error = GetLastError();
            if (Error != 0) Write("Error closing SELL order " + OrderTicket() + ": " + ErrorDescription(Error) + " (R" + Error + ")  Lots:" + OrderLots() + "  Ask:" + MarketInfo(OrderSymbol(), MODE_ASK));

            CloseBuysInProfit();

            LowestBuy = 1000;
            HighestBuy = 0;
            HighestSell = 0;
            HighestSellTicket = 0;
         }
         else if (PosSellProfit + HighestSellProfit >= ProfitTarget && HighestSell > HighestBuy)
         {
            OrderSelect(HighestSellTicket, SELECT_BY_TICKET);

            Error = GetLastError();
            if (Error != 0) Write("Error accessing SELL order " + HighestSellTicket + ": " + ErrorDescription(Error) + " (S" + Error + ")");

            OrderClose(OrderTicket(), OrderLots(), Ask, 5, Red);

            Error = GetLastError();
            if (Error != 0) Write("Error closing SELL order " + OrderTicket() + ": " + ErrorDescription(Error) + " (T" + Error + ")  Lots:" + OrderLots() + "  Ask:" + MarketInfo(OrderSymbol(), MODE_ASK));

            CloseSellsInProfit();

            LowestSell = 1000;
            HighestSell = 0;
            HighestSellTicket = 0;
         }
      }
   }
   else if (BuyOrders + SellOrders < MinimumOrdersToCloseLosing)
   {      
      if (PosBuyProfit >= TrendProfitTarget)
      {
         CloseBuysInProfit();
         
         LowestBuy = 1000;
         HighestBuy = 0;
      }
      else if (PosSellProfit >= TrendProfitTarget)
      {
         CloseSellsInProfit();

         LowestSell = 1000;
         HighestSell = 0;
      }
      Spacing2 = 0;
      TrendSpacing2 = 0;

   }

   RefreshRates();

   

   Trend = iMA(Symbol(), TrendTimeFrame, TrendPeriods2, 0, MODE_EMA, PRICE_CLOSE, 0);
   TrendPrev = iMA(Symbol(), TrendTimeFrame, TrendPeriods2, 0, MODE_EMA, PRICE_CLOSE, 1);
   
if (Trend == 0) return;
   // BUY Trade Criteria
   if (HighestBuy > 0 && LowestBuy < 1000)
   {
      if (Trending)
      {
         if (Ask < LowestBuy - ((Spacing2 / 2) * Point) || Ask > HighestBuy + ((TrendSpacing2 / 2) * Point))
         {
            BUYme = true;
   //          if (OpenOnTick && TickPrice > 0 && Close[0] < TickPrice) TradeAllowed = true;
            if (OpenOnTick == 1 && TickPrice > 0 && Close[0] < TickPrice) TradeAllowed = true;
         }
      }
      else
      {
         if (Ask < LowestBuy - (Spacing2 * Point) || Ask > HighestBuy + (TrendSpacing2 * Point))
         {
            BUYme = true;
   //          if (OpenOnTick && TickPrice > 0 && Close[0] < TickPrice) TradeAllowed = true;
            if (OpenOnTick == 1 && TickPrice > 0 && Close[0] < TickPrice) TradeAllowed = true;
         }
      }
//      if (-BuyProfit > (AccountEquity() * MaxMarginPercentage / 100) / 2) BUYme = false;
//      if (SafetyLevelPercentage > MarginPercent) BUYme = false;
      if (-BuyProfit > MaxBuyMoney) BUYme = false;
     
      if (CeaseTrading && BuyOrders == 0) BUYme = false;
//      if (Ask < Trend) BUYme = false;
      if (TrendPrev > Trend) BUYme = false;
      if (BUYme && Buy) PlaceBuyOrder();
   }

   // SELL Trade Criteria
   if (HighestSell > 0 && LowestSell < 1000)
   {
      if (Trending)
      {
         if (Bid > HighestSell + ((Spacing2 / 2) * Point) || Bid < LowestSell - ((TrendSpacing2 / 2) * Point))
         {
            SELLme = true;
   //          if (OpenOnTick && TickPrice > 0 && Close[0] > TickPrice) TradeAllowed = true;
            if (OpenOnTick == 1 && TickPrice > 0 && Close[0] > TickPrice) TradeAllowed = true;
         }
      }
      else
      {
         if (Bid > HighestSell + (Spacing2 * Point) || Bid < LowestSell - (TrendSpacing2 * Point))
         {
            SELLme = true;
   //          if (OpenOnTick && TickPrice > 0 && Close[0] > TickPrice) TradeAllowed = true;
            if (OpenOnTick == 1 && TickPrice > 0 && Close[0] > TickPrice) TradeAllowed = true;
         }
      }
//      if (-SellProfit > (AccountEquity() * MaxMarginPercentage / 100) / 2) SELLme = false;
//      if ((SafetyLevelPercentage > MarginPercent) && (MarginPercent > 0)) SELLme = false;
      if (-SellProfit > MaxSellMoney) SELLme = false;

      if (CeaseTrading && SellOrders == 0) SELLme = false;
//      if (Bid > Trend) SELLme = false;
      if (TrendPrev < Trend) SELLme = false;
      if (SELLme && Sell) PlaceSellOrder();
   }
   if (BuyOrders > 0 && SellOrders > 0) 
      {
         TrendPeriods2 = TrendPeriods;
         Spacing2 = Spacing;
         TrendSpacing2 = TrendSpacing;
      }
         
   if ((BuyOrders > 0 && SellOrders == 0) || (SellOrders > 0 && BuyOrders == 0)) TrendPeriods2 = TrendPeriods * TrendMultiplier;
         
   if ((BuyOrders < Speed && SellOrders == 0) || (SellOrders < Speed && BuyOrders == 0)) 
      {
         Spacing2 = Spacing / SpeedReduction;
         TrendSpacing2 = TrendSpacing / SpeedReduction;
      }
   if ((BuyOrders > Speed) || (SellOrders > Speed)) 
      {
         Spacing2 = Spacing;
         TrendSpacing2 = TrendSpacing;
      }

   MathRound(Spacing2);
   MathRound(TrendSpacing2);

   if (AccountMargin() != 0)
   {
      MarginPercent = MathRound((AccountEquity() / AccountMargin()) * 100);
      if (LowMarginPercent > MarginPercent) LowMarginPercent = MarginPercent;
   }
   else
      MarginPercent = 0;

   if (AccountEquity() < LowEquity) LowEquity = AccountEquity();
   if (AccountFreeMargin() < LowMargin) LowMargin = AccountFreeMargin();
   


   Message = "                    PipMaker v10" + NL +
             "                            TrendPeriods         " + DoubleToStr(TrendPeriods2, 0) + NL +
             "                            Spacing                " + DoubleToStr(Spacing2, 0) + NL +
             "                            TrendSpacing        " + DoubleToStr(TrendSpacing2, 0) + NL +
             "                            ProfitTarget           " + DoubleToStr(BuyPipTarget, 2) + NL +
             "                            Buys                    " + BuyOrders + "  Highest: " + MaxBuys + NL +
             "                            BuyLots                " + DoubleToStr(BuyLots, 2) + NL +
             "                            BuyProfit              " + DoubleToStr(BuyProfit, 2) + NL +
             "                            Highest Buy          " + DoubleToStr(HighestBuy, Digits) + "  #" + HighestBuyTicket + "  Profit: " + DoubleToStr(HighestBuyProfit, 2) + NL +
             "                            Lowest Buy           " + DoubleToStr(LowestBuy, Digits) + "  #" + LowestBuyTicket + "  Profit: " + DoubleToStr(LowestBuyProfit, 2) + NL + NL +
             "                            ProfitTarget           " + DoubleToStr(SellPipTarget, 2) + NL +
             "                            Sells                     " + SellOrders + "  Highest: " + MaxSells + NL +
             "                            SellLots                 " + DoubleToStr(SellLots, 2) + NL +
             "                            SellProfit               " + DoubleToStr(SellProfit, 2) + NL +
             "                            Highest Sell           " + DoubleToStr(HighestSell, Digits) + "  #" + HighestSellTicket + "  Profit: " + DoubleToStr(HighestSellProfit, 2) + NL +
             "                            Lowest Sell            " + DoubleToStr(LowestSell, Digits) + "  #" + LowestSellTicket + "  Profit: " + DoubleToStr(LowestSellProfit, 2) + NL + NL +
             "                            Balance                " + DoubleToStr(AccountBalance(), 2) + NL +
             "                            Equity                  " + DoubleToStr(AccountEquity(), 2) + "  Lowest: " + DoubleToStr(LowEquity, 2) + NL + NL +
             "                            Free Margin           " + DoubleToStr(AccountFreeMargin(), 2) + "  Lowest: " + DoubleToStr(LowMargin, 2) + NL +
             "                            Margin                  " + DoubleToStr(AccountMargin(), 2) + NL +
             "                            MarginPercent        " + DoubleToStr(MarginPercent, 2) + "  Lowest: " + DoubleToStr(LowMarginPercent, 2) + NL +
             "                            Current Time is      " +  TimeToStr(TimeCurrent(), TIME_SECONDS);
   Comment(Message);

   if (RightSideLabel)
   {
      string MarPercent = DoubleToStr(MarginPercent, 0);
      string LowMarPercent = DoubleToStr(LowMarginPercent, 0);
      string AcctBalance = DoubleToStr(AccountBalance(), 0);

      if (ObjectFind("MarginPercent") != 0)
      {
         ObjectCreate("MarginPercent", OBJ_LABEL, 0, 0, 0);
      	ObjectSet("MarginPercent", OBJPROP_CORNER, 3);
      	ObjectSet("MarginPercent", OBJPROP_XDISTANCE, 10);
         ObjectSet("MarginPercent", OBJPROP_YDISTANCE, 12);       
      }
      else
      {
         ObjectSetText("MarginPercent", MarPercent + "%  " + LowMarPercent + "%  $" + AcctBalance, 12, "Arial", White);
      }
   }
/*
   if (ObjectFind("MidPoint") != 0)
   {
      ObjectCreate("MidPoint", OBJ_HLINE, 0, Time[0], MidPoint);
      ObjectSet("MidPoint", OBJPROP_COLOR, Blue);
      ObjectSet("MidPoint", OBJPROP_WIDTH, 2);
   }
   else
   {
      ObjectMove("MidPoint", 0, Time[0], MidPoint);
   }
*/
   if (ObjectFind("TrendAxis") != 0)
   {
      ObjectCreate("TrendAxis", OBJ_HLINE, 0, Time[0], Trend);
      ObjectSet("TrendAxis", OBJPROP_COLOR, Red);
      ObjectSet("TrendAxis", OBJPROP_WIDTH, 2);
   }
   else
   {
      ObjectMove("TrendAxis", 0, Time[0], Trend);
   }
}


void Write(string String)
{
   int Handle;

   if (!Auditing) return;

   Handle = FileOpen(Filename, FILE_READ|FILE_WRITE|FILE_CSV, "/t");
   if (Handle < 1)
   {
      Print("Error opening audit file: Code ", GetLastError());
      return;
   }

   if (!FileSeek(Handle, 0, SEEK_END))
   {
      Print("Error seeking end of audit file: Code ", GetLastError());
      return;
   }

   if (FileWrite(Handle, TimeToStr(CurTime(), TIME_DATE|TIME_SECONDS) + "  " + String) < 1)
   {
      Print("Error writing to audit file: Code ", GetLastError());
      return;
   }

   FileClose(Handle);
}

