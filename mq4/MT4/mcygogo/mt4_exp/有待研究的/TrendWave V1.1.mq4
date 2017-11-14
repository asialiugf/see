//http://www.520fx.com/forum.php?mod=viewthread&tid=51567&extra=&page=1
#property indicator_separate_window
#property indicator_minimum -100.0
#property indicator_maximum 100.0
#property indicator_levelcolor SlateGray
#property indicator_levelstyle 1
#property indicator_buffers 8
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_color3 Black
#property indicator_color4 Black
#property indicator_color5 Black
#property indicator_color6 Black
#property indicator_color7 Black
#property indicator_color8 Black
#property indicator_width1 1
#property indicator_level1 60.0
#property indicator_width2 1
#property indicator_level2 53.0
#property indicator_level3 -50.0
#property indicator_level4 -60.0

extern int WavePeriod = 10;
extern int AvgPeriod = 21;
extern bool SoundAlert = FALSE;
extern bool EmailAlert = FALSE;
double BullLineBuffer[];
double BearLineBuffer[];
double ESABuffer[];
double DDBuffer[];
double CIBuffer[];
double DDValuesBuffer[];
double BuyDotBuffer[];
double SellDotBuffer[];
int gi_124 = -50;
int gi_128 = 53;
int gi_132;
/*int gi_136 = 7446125;//Account Number*/

int init() {
   /*if (gi_136 != AccountNumber()) {
      Comment("Trade on account :" + AccountNumber() + " is FORBIDDEN!");
      return (0);
   }*/
   Comment("");
   IndicatorShortName("TrendWave");
   SetIndexBuffer(0, ESABuffer);
   SetIndexLabel(0, "ESA");
   SetIndexStyle(0, DRAW_NONE);
   SetIndexDrawBegin(0, 0);
   SetIndexBuffer(1, DDValuesBuffer);
   SetIndexLabel(1, "DD Values");
   SetIndexStyle(1, DRAW_NONE);
   SetIndexDrawBegin(1, 0);
   SetIndexBuffer(2, DDBuffer);
   SetIndexLabel(2, "DD");
   SetIndexStyle(2, DRAW_NONE);
   SetIndexDrawBegin(2, 0);
   SetIndexBuffer(3, CIBuffer);
   SetIndexLabel(3, "CI");
   SetIndexStyle(3, DRAW_NONE);
   SetIndexDrawBegin(3, 0);
   SetIndexBuffer(4, BullLineBuffer);
   SetIndexLabel(4, "Bull");
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1, Lime);
   SetIndexDrawBegin(4, 0);
   SetIndexBuffer(5, BearLineBuffer);
   SetIndexLabel(5, "Bear");
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 1, Red);
   SetIndexDrawBegin(5, 0);
   SetIndexBuffer(6, BuyDotBuffer);
   SetIndexLabel(6, "Buy Dot");
   SetIndexStyle(6, DRAW_ARROW, STYLE_SOLID, 2, Aqua);
   SetIndexArrow(6, 108);
   SetIndexDrawBegin(6, 0);
   SetIndexBuffer(7, SellDotBuffer);
   SetIndexLabel(7, "Sell Dot");
   SetIndexStyle(7, DRAW_ARROW, STYLE_SOLID, 2, Yellow);
   SetIndexArrow(7, 108);
   SetIndexDrawBegin(7, 0);
   ArrayResize(ESABuffer, Bars);
   ArrayResize(DDValuesBuffer, Bars);
   ArrayResize(DDBuffer, Bars);
   ArrayResize(CIBuffer, Bars);
   ArrayResize(BullLineBuffer, Bars);
   ArrayResize(BearLineBuffer, Bars);
   ArrayResize(BuyDotBuffer, Bars);
   ArrayResize(SellDotBuffer, Bars);
   return (0);
}

int start() {
   double l_ima_on_arr_0;
   /*if (gi_136 != AccountNumber()) {
      Comment("Trade on account :" + AccountNumber() + " is FORBIDDEN!");
      return (0);
   }*/
   Comment("");
   int counted_bars = IndicatorCounted();
   if (counted_bars < 0) return (-1);
   //if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   for (int i = limit; i >= 0; i--) {
      ESABuffer[i] = iMA(NULL, 0, WavePeriod, 0, MODE_EMA, PRICE_TYPICAL, i);
      ArraySetAsSeries(ESABuffer, TRUE);
   }
   for (i = limit; i >= 0; i--) {
      DDValuesBuffer[i] = MathAbs((iHigh(NULL, 0, i) + iClose(NULL, 0, i) + iLow(NULL, 0, i)) / 3.0 - ESABuffer[i]);
      ArraySetAsSeries(DDValuesBuffer, TRUE);
   }
   for (i = limit; i >= 0; i--) {
      l_ima_on_arr_0 = iMAOnArray(DDValuesBuffer, 0, WavePeriod, 0, MODE_EMA, i);
      DDBuffer[i] = l_ima_on_arr_0;
      ArraySetAsSeries(DDBuffer, TRUE);
   }
   for (i = limit; i >= 0; i--) {
      if (DDBuffer[i] > 0.0) CIBuffer[i] = ((iHigh(NULL, 0, i) + iClose(NULL, 0, i) + iLow(NULL, 0, i)) / 3.0 - ESABuffer[i]) / (0.015 * DDBuffer[i]);
      else CIBuffer[i] = 0;
      ArraySetAsSeries(CIBuffer, TRUE);
   }
   for (i = limit; i >= 0; i--) {
      l_ima_on_arr_0 = iMAOnArray(CIBuffer, 0, AvgPeriod, 0, MODE_EMA, i);
      BullLineBuffer[i] = l_ima_on_arr_0;
      ArraySetAsSeries(BullLineBuffer, TRUE);
   }
   for (i = limit; i >= 0; i--) {
      l_ima_on_arr_0 = iMAOnArray(BullLineBuffer, 0, 4, 0, MODE_SMA, i);
      BearLineBuffer[i] = l_ima_on_arr_0;
      ArraySetAsSeries(BearLineBuffer, TRUE);
   }
   for (i = limit; i >= 0; i--) {
      if (BullLineBuffer[i] >= BearLineBuffer[i] && BullLineBuffer[i + 1] <= BearLineBuffer[i + 1] && BullLineBuffer[i] < gi_124) {
         BuyDotBuffer[i] = BullLineBuffer[i];
         SendAlert("buy");
      } else BuyDotBuffer[i] = -1000;
      if (BullLineBuffer[i] <= BearLineBuffer[i] && BullLineBuffer[i + 1] >= BearLineBuffer[i + 1] && BullLineBuffer[i] > gi_128) {
         SellDotBuffer[i] = BearLineBuffer[i];
         SendAlert("sell");
      } else SellDotBuffer[i] = -1000;
   }
   return (0);
}

void SendAlert(string as_0) {
   if (Time[0] != gi_132) {
      if (SoundAlert) {
         if (as_0 == "buy") Alert(Symbol() + " => " + TimeToStr(TimeCurrent()) + " buy");
         if (as_0 == "sell") Alert(Symbol() + " => " + TimeToStr(TimeCurrent()) + " sell");
      }
      if (EmailAlert) {
         if (as_0 == "buy") SendMail("TrendWave Alert", Symbol() + " => " + TimeToStr(TimeCurrent()) + " buy");
         if (as_0 == "sell") SendMail("TrendWave Alert", Symbol() + " => " + TimeToStr(TimeCurrent()) + " sell");
      }
      gi_132 = Time[0];
   }
}