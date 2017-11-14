//+------------------------------------------------------------------+
//|                                                   Copyright 2010 |
//|                                                 steadywinner.com |
//|                                           steadywinner@gmail.com |
//|                                       SteadyWinner   Version 5.0 |
//|                                        Pair:EURUSD Any timeframe |
//|                                        http://www.eajiaoyi.cn/EANEWS/News_35.html
//+------------------------------------------------------------------+

#property copyright "SteadyWinner"
#property link      "steadywinner@gmail.com"

string sNameExpert = "SteadyWinner V5.0";
int    nAccount =0;

double dBuyStopLossPips;
double dSellStopLossPips;
double dBuyTakeProfitPips;
double dSellTakeProfitPips;
double dBuyTrailingStopPips;
double dSellTrailingStopPips;
double dBuyTrailingReservePips;
double dSellTrailingReservePips;

double timeclose1 = 900;  //60= 1 minute
double timeclose2 = 3600;  //60= 1 minute

extern string NoteRisk = "Trade Lot Risk %: 0.50 - 6.00";
extern double PercentToRisk = 2.00;
extern string NoteScale = "Test Lot Scaling: 0.00 - 1.00";
extern double TestLotScale = 0.00;
extern string NoteSpread = "Max Spreads: 2.0 - 4.0";
extern double MaxSpread = 4.0;
extern string NoteFri = "Trade after Friday Cut Hour";
extern bool   TradeLateFri = False;
extern int    FridayCutHour = 15;
extern string NoteDec = "Trade on December Cut Date (15)";
int           DecCutDate = 15;   // This parameter is not open (for now)
extern bool   TradeLateDec = False;
extern string NoteBroker = "Broker Friendly Settings";
extern bool   PipStepping = False;
extern bool   FXOpenECN = False;
extern string NoteEA = "Magic No.& Comments, pls change it";
extern int    MagicNo = 338833;
extern string CommentTxt = "SW-V5"; 
// ----- Professional Settings - We recommend you leave them untouched -----
string NotePro = "Professional Settings";
double d1StopLossPips = 110;
double d1TakeProfitPips = 55;
double d1TrailingStopPips = 22;
double d1TrailingReservePips = 5;
double d1StepPips = 0;


double dLots =0.1;
double dStepPips = 0;

double mmTradeLots = 0.1;
double mmTestLots = 0.1;
double CurSpread;
double HistoryOrderProfit = 0;

double MinLots = 0;
double MaxLots = 0;
double LotStep = 0;
double PipSize = 0;  // Original "point" in SW V3 and V4
int    nSlippage = 3;
bool   lFlagUseHourTrade = True;
int    nFromHourTrade = 0;
int    nToHourTrade = 23;
int    dTrailingStatus = -1;
bool   lFlagUseSound = True;
string sSoundFileName = "alert.wav";
color  colorOpenBuy = Blue;
color  colorCloseBuy = Aqua;
color  colorOpenSell = Red;
color  colorCloseSell = Aqua;
string Please_Enter_Password = "0";
string password;

string mmMessage = "Smart MM finds nothing wrong.";
color  mmMessageColor = LightGreen;



//--------------------------------------------------------------------------------

void init() {

   //--- Check for user input outside range ------------------------------
   //--------------------------------Input Val-----Min----Max----Digits---
   PercentToRisk = getInRangeValue (PercentToRisk, 0.50,  6.00,  2);
   TestLotScale  = getInRangeValue (TestLotScale,  0.00,  1.00,  2);
   MaxSpread     = getInRangeValue (MaxSpread,     2.0,   4.0,   1);
   FridayCutHour = getInRangeValue (FridayCutHour, 0,     23,    0);
   //---------------------------------------------------------------------

   // These assignment values allow for future asymetric parameter setting (ie different value for Buy/Sell)
   dBuyStopLossPips = d1StopLossPips;
   dSellStopLossPips = d1StopLossPips;
   dBuyTakeProfitPips = d1TakeProfitPips;
   dSellTakeProfitPips = d1TakeProfitPips;
   dBuyTrailingStopPips = d1TrailingStopPips;
   dSellTrailingStopPips = d1TrailingStopPips;
   dBuyTrailingReservePips = d1TrailingReservePips;
   dSellTrailingReservePips = d1TrailingReservePips;
   
   if (PipStepping)
      d1StepPips = 1;
   
   PipSize = getPipSize(Symbol());

   Set_SmartMM_Lots();

   //----- On Screen Display Line Number Y-Distance) -----
   int yLine1=20,
       yLine2=40,
       yLine3=60,
       yLine4=80,
       yLine5=100, 
       yLine6=120,
       yLine7=140,
       yLine8=160,
       yLine9=180,
       yLine10=200, 
       yLine11=220,
       yLine12=240;

   //----- On Screen Display Column Number X-Distance -----
   int xCol1=10,
       xCol2=200,
       xCol3=380;

   // On Screen Display Message texts
   string txtTradeLateFri, 
          txtTradeLateDec,
          txtPipStepping,
          txtFXOpenECN;

   //----- Display Line 1 -----
   DisplayText("Title1", yLine1-5, xCol1, "SteadyWinner V5.0 - Place on EURUSD(H1) ", 13, "Verdana", MediumSeaGreen);
   
   //----- Display Line 2 -----
   DisplayText("Title2", yLine2, xCol1, "http://steadywinner.com    steadywinner@gmail.com", 9, "Verdana", White);

   //----- Display Line 3 -----
   DisplayText("Line1a", yLine3, xCol1, "---------------------------", 10, "Verdana", Goldenrod);
   DisplayText("Line1b", yLine3, xCol2, "--- EA Settings ------------------------------", 10, "Verdana", Goldenrod);
 
   //----- Display Line 4 -----
   DisplayText("txtRisk", yLine4, xCol1, "Trade Lot Risk%:  "+DoubleToStr(PercentToRisk, 2), 9, "Verdana", Gold);
   DisplayText("txtScale", yLine4, xCol2, "Test Lot Scale:     " + DoubleToStr(TestLotScale, 2), 9, "Verdana", Gold);
   DisplayText("txtMaxSpread", yLine4, xCol3, "Max Spread:    " + DoubleToStr(MaxSpread, 1), 9, "Verdana", Gold);

   //----- Display Line 5 -----
   DisplayText("TxtTradeLots", yLine5, xCol1, "Trade Lot Size:     " + DoubleToStr(mmTradeLots,2), 9, "Verdana", Gold);
   DisplayText("TxtTestLots", yLine5, xCol2, "Test Lot Size:       " + DoubleToStr(mmTestLots,2), 9, "Verdana", Gold);
   DisplayText("TxtCurSpread", yLine5, xCol3, "Now Spread:   " + DoubleToStr(CurSpread, 1), 9, "Verdana", Gold);

   //----- Display Line 6 -----
   DisplayText("TxtMaxLot", yLine6, xCol1, "Max Lots:             " + DoubleToStr(MaxLots,2), 9, "Verdana", Silver);
   DisplayText("TxtMinLot", yLine6, xCol2, "Min Lots:              " + DoubleToStr(MinLots,2), 9, "Verdana", Silver);
   DisplayText("TxtLotStep", yLine6, xCol3, "Lot Step:         " + DoubleToStr(LotStep, 2), 9, "Verdana", Silver);

   //----- Display Line 7 ------
   // 2010/9/18 Change (5) - Screen display now show values from variables instead of hard coded values
   DisplayText("TxtSL", yLine7, xCol1, "Stop Loss:           " + DoubleToStr(d1StopLossPips,0), 9, "Verdana", Silver);
   DisplayText("TxtTP", yLine7, xCol2, "Take Profit:          " + DoubleToStr(d1TakeProfitPips,0), 9, "Verdana", Silver);
   
   //----- Display Line 8 ------
   // 2010/9/18 Change (5) - Screen display now show values from variables instead of hard coded values
   DisplayText("TxtTS", yLine8, xCol1, "Trailing Stop:       " + DoubleToStr(d1TrailingStopPips,0), 9, "Verdana", Silver);
   DisplayText("TxtTR", yLine8, xCol2, "Trailing Reserve:  " + DoubleToStr(d1TrailingReservePips,0), 9, "Verdana", Silver);

   //----- Display Line 9 -----
   if (TradeLateFri)
      txtTradeLateFri = "Trade after Friday "+DoubleToStr(FridayCutHour,0)+":00:        TEST LOT ONLY";
   else
      txtTradeLateFri = "Trade after Friday "+DoubleToStr(FridayCutHour,0)+":00:        NO";
   DisplayText("TxtFri", yLine9, xCol1, txtTradeLateFri, 9, "Verdana", Gold);
   if (PipStepping)
      txtPipStepping = "YES";
   else
      txtPipStepping = "NO";
   DisplayText("TxtPipStepping", yLine9, xCol3, "Pip Stepping:  " + txtPipStepping, 9, "Verdana", Gold);

   //----- Display Line 10 -----
   if (TradeLateDec)
      txtTradeLateDec = "Trade after December "+DoubleToStr(DecCutDate,0)+"th:    TEST LOT ONLY";
   else
      txtTradeLateDec = "Trade after December "+DoubleToStr(DecCutDate,0)+"th:    NO";
   DisplayText("TxtDec", yLine10, xCol1, txtTradeLateDec, 9, "Verdana", Gold);
   if (FXOpenECN)
      txtFXOpenECN = "YES";
   else
      txtFXOpenECN = "NO";
   DisplayText("TxtFXOpenECN", yLine10, xCol3, "FXOpen ECN:  " + txtFXOpenECN, 9, "Verdana", Gold);

   //----- Display Line 11 -----
   DisplayText("Line2a", yLine11, xCol1, "---------------------------", 10, "Verdana", Goldenrod);
   DisplayText("Line2b", yLine11, xCol2, "---------------------------------------------", 10, "Verdana", Goldenrod);
   
   //----- Display Line 12 -----
   DisplayText("TxtSmartMM", yLine12, xCol1, mmMessage, 9, "Verdana", mmMessageColor);      
}

//--------------------------------------------------------------------------------

void deinit() {
   // 2010/9/18 Change (3) - Delete only objects created from this EA
   //    Will not harm objects created by users or other EA scripts

   ObjectDelete("Title1");
   ObjectDelete("Title2");
   ObjectDelete("Line1a");        ObjectDelete("Line1b");         
   ObjectDelete("TxtRisk");       ObjectDelete("TxtScale");     ObjectDelete("TxtMaxSpread");
   ObjectDelete("TxtTradeLots");  ObjectDelete("TxtTestLots");  ObjectDelete("TxtCurSpread");  
   ObjectDelete("TxtMaxLot");     ObjectDelete("TxtMinLot");    ObjectDelete("TxtLotStep");
   ObjectDelete("TxtSL");         ObjectDelete("TxtTP");        
   ObjectDelete("TxtTS");         ObjectDelete("TxtTR");
   ObjectDelete("TxtFri");        ObjectDelete("TxtPipStepping");
   ObjectDelete("TxtDec");        ObjectDelete("TxtFXOpenECN");
   ObjectDelete("Line2a");        ObjectDelete("Line2b");           
   ObjectDelete("TxtSmartMM");
}

//--------------------------------------------------------------------------------

int start(){
   // 2010/9/18 Change (2) - Unified and Simplified Lot Size Display
   // 2010/9/18 Change (5) - Screen display now show values from variables instead of hard coded values

   // Update Display Line - Current Trading parameters that change
   Set_SmartMM_Lots();
   ObjectSetText("TxtTradeLots", "Trade Lot Size:     " + DoubleToStr(mmTradeLots,2), 9, "Verdana", Gold);
   ObjectSetText("TxtTestLots", "Test Lot Size:       " + DoubleToStr(mmTestLots,2), 9, "Verdana", Gold);
   ObjectSetText("TxtCurSpread", "Now Spread:   " + DoubleToStr(CurSpread, 1), 9, "Verdana", Gold);
   ObjectSetText("TxtSmartMM", mmMessage, 9, "Verdana", mmMessageColor);      


   if (lFlagUseHourTrade){
      if (!(Hour()>=nFromHourTrade && Hour()<=nToHourTrade)) {
         Comment("Time for trade has not come else!");
         return(0);
      }
   }
   
   if(Bars < 100){
      Print("bars less than 100");
      return(0);
   }
      
   if (nAccount > 0 && nAccount != AccountNumber()){
      Comment("Trade on account :"+AccountNumber()+" FORBIDDEN!");
      return(0);
   }

   // indicators
   double diMA0=iMA(NULL,15,50,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA1=iMA(NULL,15,100,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA2=iMA(NULL,15,200,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA3=iMA(NULL,15,300,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA4=iMA(NULL,15,400,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA5=iMA(NULL,15,500,0,MODE_EMA,PRICE_CLOSE,0);
   double diWPR10=iWPR(NULL,60,5,0);
   double diMFI11=iMFI(NULL,30,1,0);
   double diClose12=iClose(NULL,1,0);
   double diMA13=iMA(NULL,1,700,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA14=iMA(NULL,5,700,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA15=iMA(NULL,15,700,0,MODE_EMA,PRICE_CLOSE,0);
   double diMA16=iMA(NULL,30,700,0,MODE_EMA,PRICE_CLOSE,0);
   double diAO17=iAC(NULL,1,0);


   bool lFlagBuyOpen = false, lFlagSellOpen = false, lFlagBuyClose = false, lFlagSellClose = false;

  
   // operaton codes
   if (!ExistPositions()) {
      if (HistoryOrderProfit >=0) {  
         lFlagBuyOpen =  (diAO17<0) && (diMFI11<0.1) && (diWPR10<-99.99)&&  
                         (diMA13 < diClose12) && (diMA14 < diClose12) && (diMA15 < diClose12) && (diMA16 < diClose12) 
                         && (diMA1>diMA2)&&(diMA2>diMA3)&&(diMA3>diMA4)&&(diMA4>diMA5);

         lFlagSellOpen = (diAO17>0) && (diMFI11>99.9) && (diWPR10>-0.01)&& 
                         (diMA13 > diClose12) && (diMA14 > diClose12) && (diMA15 > diClose12) && (diMA16 > diClose12)
                         && (diMA1<diMA2)&&(diMA2<diMA3)&&(diMA3<diMA4)&&(diMA4<diMA5);
      }

      if (HistoryOrderProfit <0) {  
         lFlagBuyOpen =  (diAO17<0) && (diWPR10<-50) && (diMA1<diMA2);
         lFlagSellOpen = (diAO17>0) && (diWPR10>-50 ) && (diMA1>diMA2);
      }

      dTrailingStatus = -1;
      if (lFlagBuyOpen) {
         Set_SmartMM_Lots();   // new function to set dLots using smart MM
         dTrailingStatus = 0;  // Init - Trailing Not Started Yet
         dStepPips = 0;        // Init - Trailing Step Not Active until First Trailing Start 
         OpenBuy();
         return(0);
      }

      if (lFlagSellOpen) {
         Set_SmartMM_Lots();   // new function to set dLots using smart MM
         dTrailingStatus = 0;  // Init - Trailing Not Started Yet
         dStepPips = 0;        // Init - Trailing Step Not Active until First Trailing Start
         OpenSell();
         return(0);
      }
   }

   if (ExistPositions()){
      // When Trailing Step is working, disable indicator close 
      if (dTrailingStatus < 1) {
         if ((OrderProfit() >= 0) && (CurTime()-OrderOpenTime()>timeclose2)) {
            lFlagBuyClose  =  (diAO17>0) && (diWPR10>-50) && (diMA1>diMA2);
            lFlagSellClose =  (diAO17<0) && (diWPR10<-50) && (diMA1<diMA2);
         }   
         if ((OrderProfit() < 0) && (CurTime()-OrderOpenTime()>timeclose1)) {
            lFlagBuyClose  =  (diAO17>0) && (diWPR10>-15) && (diMA1>diMA2);
            lFlagSellClose =  (diAO17<0) && (diWPR10<-85) && (diMA1<diMA2);
         }
      }

      // Handle Indicator Controlled Order Close Below
      if(OrderType()==OP_BUY){
         if (lFlagBuyClose){
            bool flagCloseBuy = OrderClose(OrderTicket(), OrderLots(), Bid, nSlippage, colorCloseBuy); 
            if (flagCloseBuy && lFlagUseSound) 
               PlaySound(sSoundFileName); 
            return(0);
         }
      }
      if(OrderType()==OP_SELL){
         if (lFlagSellClose){
            bool flagCloseSell = OrderClose(OrderTicket(), OrderLots(), Ask, nSlippage, colorCloseSell); 
            if (flagCloseSell && lFlagUseSound) 
               PlaySound(sSoundFileName); 
            return(0);
         }
      }
   }
   
   if (dBuyTrailingStopPips > 0 || dSellTrailingStopPips > 0){
      for (int i=0; i<OrdersTotal(); i++) { 
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { 
            bool lMagic = true;
            if (MagicNo > 0 && OrderMagicNumber() != MagicNo)
               lMagic = false;
            
            if (OrderSymbol()==Symbol() && lMagic) { 
               if (OrderType()==OP_BUY && dBuyTrailingStopPips > 0) { 
                  if (Bid-OrderOpenPrice() > dBuyTrailingStopPips*PipSize) { 
                     if (OrderStopLoss()<Bid-(dBuyTrailingStopPips+dStepPips)*PipSize) {
                        if (dTrailingStatus == 0) {
                           ModifyStopLoss(Bid-NormalizeDouble((dBuyTrailingStopPips-dBuyTrailingReservePips)*PipSize,5));
                           dTrailingStatus = 1;     // Trailing Triggered - Set Status Flag
                           dStepPips = d1StepPips;  // Trailing Triggered - Activate Stepping if User enabled it
                        }
                        else
                        {
                           ModifyStopLoss(Bid-NormalizeDouble(dBuyTrailingStopPips*PipSize,5)); 
                        }
                     }   
                  } 
               } 
               if (OrderType()==OP_SELL) { 
                  if (OrderOpenPrice()-Ask>dSellTrailingStopPips*PipSize) { 
                     if (OrderStopLoss()>Ask+(dSellTrailingStopPips+dStepPips)*PipSize || OrderStopLoss()==0) {
                        if (dTrailingStatus == 0) {
                           ModifyStopLoss(Ask+NormalizeDouble((dSellTrailingStopPips-dSellTrailingReservePips)*PipSize,5));
                           dTrailingStatus = 1;     // Trailing Triggered - Set Status Flag
                           dStepPips = d1StepPips;  // Trailing Triggered - Activate Stepping if User enabled it
                        }   
                        else
                        {
                           ModifyStopLoss(Ask+NormalizeDouble(dSellTrailingStopPips*PipSize,5));
                        }
                     }    
                  } 
               } 
            } 
         } 
      } 
   }
   return (0);
}

//--------------------------------------------------------------------------------


bool ExistPositions() {
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         bool lMagic = true;
         
         if (MagicNo > 0 && OrderMagicNumber() != MagicNo)
            lMagic = false;

			if (OrderSymbol()==Symbol() && lMagic) {
				return(True);
			}
		} 
	} 
	return(false);
}

//--------------------------------------------------------------------------------

void ModifyStopLoss(double ldStopLoss) { 
   bool lFlagModify = OrderModify(OrderTicket(), NormalizeDouble(OrderOpenPrice(),5), NormalizeDouble(ldStopLoss,5), NormalizeDouble(OrderTakeProfit(),5), 0, CLR_NONE); 
   if (lFlagModify && lFlagUseSound) 
      PlaySound(sSoundFileName); 
} 

//--------------------------------------------------------------------------------

void OpenBuy() { 
   if (dLots == 0)
      return(0);

   double dStopLoss = 0, dTakeProfit = 0;
   int numorder = OrderSend(Symbol(), OP_BUY, dLots, Ask, nSlippage, 0, 0, CommentTxt, MagicNo, 0, colorOpenBuy); 
   // fdrATR();

   if (numorder > -1) {
      OrderSelect(numorder, SELECT_BY_TICKET);
      if (dBuyStopLossPips > 0)
         dStopLoss = NormalizeDouble(OrderOpenPrice() - dBuyStopLossPips * PipSize, Digits);
      if (dBuyTakeProfitPips > 0)
         dTakeProfit = NormalizeDouble(OrderOpenPrice() + dBuyTakeProfitPips * PipSize, Digits);
      OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
   }
   
   if (numorder > -1 && lFlagUseSound) 
      PlaySound(sSoundFileName);
} 

//--------------------------------------------------------------------------------

void OpenSell() { 
   if (dLots == 0)
      return(0);

   double dStopLoss = 0, dTakeProfit = 0;
   int numorder = OrderSend(Symbol(),OP_SELL, dLots, Bid, nSlippage, 0, 0, CommentTxt, MagicNo, 0, colorOpenSell); 
   // fdrATR();
   
   if (numorder > -1) {
      OrderSelect(numorder, SELECT_BY_TICKET);
      if (dSellStopLossPips > 0)
         dStopLoss = NormalizeDouble(OrderOpenPrice() + dSellStopLossPips * PipSize, Digits);
      if (dSellTakeProfitPips > 0)
         dTakeProfit = NormalizeDouble(OrderOpenPrice() - dSellTakeProfitPips * PipSize, Digits);
      OrderModify(OrderTicket(), OrderOpenPrice(), dStopLoss, dTakeProfit, 0, Green);
   }
   
   if (numorder > -1 && lFlagUseSound) 
      PlaySound(sSoundFileName); 
}

//--------------------------------------------------------------------------------

void Set_SmartMM_Lots() {

// Smart MM - Update MM dLots and EA Meter Display

   double RiskEquity;

   MinLots = MarketInfo(Symbol(), MODE_MINLOT);
   MaxLots = MarketInfo(Symbol(), MODE_MAXLOT);
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   CurSpread = getSpreadPips(Symbol());   

   if (FXOpenECN && (StringFind(AccountServer(),"FXOpen-ECN",0) >= 0))
      MinLots = 0.1;

   RiskEquity = AccountFreeMargin() * (PercentToRisk/100);
   mmTradeLots = RiskEquity / (d1StopLossPips * getPipValue(Symbol()));
   mmTradeLots = getWorkingLots(mmTradeLots);

   if (TestLotScale > 0) {
      mmTestLots = mmTradeLots * TestLotScale;
      mmTestLots = getWorkingLots(mmTestLots);
   }
   else
      mmTestLots = MinLots;

   // Set Default SmartMM message
   mmMessage = "Margin level is healthy, SW is running in full mode";
   mmMessageColor = LightGreen;

   // Warn for Low margin if EA can only open MinLots
   if (mmTradeLots == MinLots) {
      mmMessage = "Free margin / risk% is too low, SW can open MinLot orders only";
      mmMessageColor = Pink;
   }

   for (int ioht=OrdersHistoryTotal() -1; ioht >= 0; ioht--) { 
	   OrderSelect(ioht, SELECT_BY_POS, MODE_HISTORY);
	   if (OrderMagicNumber() == MagicNo) {
	      HistoryOrderProfit = OrderProfit();
	      ioht = 0;
	   }
   }

   if (HistoryOrderProfit == 0) {
      dLots = mmTestLots;
   }

   if (HistoryOrderProfit > 0) {
       dLots = mmTradeLots;
   }

   // if lose, use smallest lot to test the market before resume full lots
   if (HistoryOrderProfit < 0) {
       dLots = mmTestLots;
   }   


   // ********** special days - trade min lot / stop trading to avoid risk *******
   if ((DayOfWeek() == 5) && (Hour() > FridayCutHour)) {
      mmMessage = "It's Friday after "+DoubleToStr(FridayCutHour,0)+":00, "; 
      mmMessageColor = Silver;
      if (!TradeLateFri) {
         dLots = 0;
         mmMessage = mmMessage + "SW will not open new orders";
      }
      else {
         dLots = mmTestLots;
         mmMessage = mmMessage + "SW will open new TestLot orders only"; 
      }
   }

   if ((Month() == 12) && (Day() > DecCutDate)) {
      mmMessage = "It's December after "+DoubleToStr(DecCutDate,0)+"th, "; 
      mmMessageColor = Silver;
      if (!TradeLateDec) {
         dLots = 0;
         mmMessage = mmMessage + "SW will not open new orders";
      }
      else {
         dLots = mmTestLots;
         mmMessage = mmMessage + "SW will open new TestLot orders only"; 
      }   
   }

   // Stop Trading if spreads are too high
   if (CurSpread > MaxSpread) { 
      mmMessage = "Spread is too high, SW will not open new orders";
      mmMessageColor = Silver;
      dLots = 0;
   }

   // Stop SteadyWinner from trading if capital is danger low, less than 100
   if (AccountFreeMargin() < 110) {
      mmMessage = "Free Margin is dangerously low, SW will not open new orders";
      mmMessageColor = HotPink;
      dLots = 0;
   }
   
      
   // *******************************************************************

}

//--------------------------------------------------------------------------------

double getInRangeValue(double eVal, double eMin, double eMax, int eDigits) {
   double iVal = eVal;
   if (iVal < eMin)
      iVal = eMin;
   else if (iVal > eMax)
      iVal = eMax;

   NormalizeDouble(iVal, eDigits);

   return (iVal);
}

//--------------------------------------------------------------------------------

double getWorkingLots(double eLots) {
   double iLots;

   if (eLots < MinLots)
      iLots = MinLots;
   else {
      iLots = MinLots + NormalizeDouble((eLots - MinLots) / LotStep,0) * LotStep;
      if (iLots > MaxLots)
         iLots = MaxLots;
   }

   return(iLots);
}

//--------------------------------------------------------------------------------

double getPipSize(string eSymbol) {
  	double iPipSize;
   	int iDigits;

	iDigits = MarketInfo(eSymbol, MODE_DIGITS);
   	iPipSize = 0.0001;   // For most European / American Currency pairs

   	// Special Case Here
	if (iDigits == 2 || iDigits == 3) // Like case JPY
	   iPipSize = 0.01;

	return(iPipSize);
}

//--------------------------------------------------------------------------------

double getPipValue(string eSymbol) {
   double iPipValue, iPipSize;
   double iTickSize, iTickValue;

	iTickValue = MarketInfo(eSymbol, MODE_TICKVALUE);
   iTickSize = MarketInfo(eSymbol, MODE_TICKSIZE);
   iPipSize = getPipSize(eSymbol);
   
   iPipValue = iTickValue * (iPipSize / iTickSize);

	return(iPipValue);
}

//--------------------------------------------------------------------------------

double getSpreadPips(string eSymbol) {
   double iSpreadPips, iPipSize;
   double iTickSize, iTickValue;

   iTickSize = MarketInfo(eSymbol, MODE_TICKSIZE);
   iPipSize = getPipSize(eSymbol);

   iSpreadPips = MarketInfo(eSymbol, MODE_SPREAD) * (iTickSize / iPipSize);

	return(iSpreadPips);
}

//--------------------------------------------------------------------------------

void DisplayText(string eName, int eYD, int eXD, string eText, int eSize, string eFont, color eColor) {
   ObjectCreate(eName, OBJ_LABEL, 0, 0, 0);
   ObjectSet(eName, OBJPROP_CORNER, 0);
   ObjectSet(eName, OBJPROP_XDISTANCE, eXD);
   ObjectSet(eName, OBJPROP_YDISTANCE, eYD);
   ObjectSetText(eName, eText, eSize, eFont, eColor);
}

