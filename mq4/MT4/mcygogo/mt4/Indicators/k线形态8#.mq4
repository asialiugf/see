/*

*/
#property copyright "xxx"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red

extern bool Arrow = TRUE;
extern bool Name = TRUE;
extern int  log = 8;
double g_iBuf_1[];
double g_iBuf_2[];

int init() {
   ObjectCreate("June", OBJ_LABEL, 0, 0, 0);
   ObjectSet("June", OBJPROP_CORNER, 4);
   ObjectSet("June", OBJPROP_XDISTANCE, 0);
   ObjectSet("June", OBJPROP_YDISTANCE, 15);
   ObjectSet("June", OBJPROP_BACK, TRUE);
   ObjectSetText("June", "-", 12, "Verdana", Lime);
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 108);
   SetIndexBuffer(0, g_iBuf_1);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 108);
   SetIndexBuffer(1, g_iBuf_2);
   SetIndexEmptyValue(1, 0.0);
   ObjectsDeleteAll(0, OBJ_TEXT);
   ObjectsDeleteAll(0, OBJ_ARROW);
   return (0);
}

int deinit() {
   return (0);
}

void SetArrow(int ai_0, int a_datetime_4, double a_price_8, int ai_16, color a_color_20) {
   ObjectCreate("Arrow-" + ai_16 + "-" + ai_0, OBJ_ARROW, 0, a_datetime_4, a_price_8);
   ObjectSet("Arrow-" + ai_16 + "-" + ai_0, OBJPROP_ARROWCODE, ai_16);
   ObjectSet("Arrow-" + ai_16 + "-" + ai_0, OBJPROP_COLOR, a_color_20);
}

void SetText(int ai_0, int a_datetime_4, double a_price_8, string a_text_16, color a_color_24) {
   ObjectCreate(a_text_16 + "-" + ai_0, OBJ_TEXT, 0, a_datetime_4, a_price_8);
   ObjectSetText(a_text_16 + "-" + ai_0, a_text_16,log);
   ObjectSet(a_text_16 + "-" + ai_0, OBJPROP_COLOR, a_color_24);
}

int start() {
   int l_ind_counted_0 = IndicatorCounted();
   bool l_bars_4 = FALSE;
   int li_8 = 0;
   int li_12 = 0;
   int li_16 = 0;
   int li_20 = 0;
   int li_24 = 0;
   bool li_28 = FALSE;
   bool li_32 = FALSE;
   bool li_36 = FALSE;
   bool li_40 = FALSE;
   bool li_44 = FALSE;
   bool li_48 = FALSE;
   bool li_52 = FALSE;
   bool li_56 = FALSE;
   int li_unused_60 = 0;
   if (l_bars_4 != Bars) l_bars_4 = Bars;
   int li_64 = Bars - l_ind_counted_0;
   for (li_12 = li_64; li_12 >= 0; li_12--) {
      li_16 = li_12 + 1;
      li_20 = li_12 + 2;
      li_24 = li_12 + 3;
      if (Close[li_20] < Open[li_20] && Open[li_16] < Close[li_20] && Close[li_16] > Open[li_20]) li_28 = TRUE;
      else li_28 = FALSE;
      if (!li_28) {
         if (Close[li_20] < Open[li_20] && Close[li_16] > Open[li_16] && Open[li_16] < Close[li_20] || Low[li_16] < Low[li_20] && Close[li_16] > Close[li_20] + (Open[li_20] - Close[li_20]) / 2.0) li_36 = TRUE;
         else li_36 = FALSE;
      } else li_36 = FALSE;
      if (Close[li_24] < Open[li_24] && Open[li_20] < Close[li_24] && Close[li_20] < Close[li_24] && Open[li_16] > Close[li_20] || High[li_16] > High[li_20] && Close[li_16] >= Close[li_24]) li_32 = TRUE;
      else li_32 = FALSE;
      if (Close[li_16] > Open[li_16] && Open[li_16] - Low[li_16] > 3.0 * MathMax(High[li_16] - Close[li_16], Close[li_16] - Open[li_16])) li_40 = TRUE;
      else li_40 = FALSE;
      if (Close[li_20] > Open[li_20] && Close[li_16] < Open[li_16] && Open[li_16] > Close[li_20] && Close[li_16] < Open[li_20] || Low[li_16] < Low[li_20]) li_44 = TRUE;
      else li_44 = FALSE;
      if (!li_44) {
         if (Close[li_20] > Open[li_20] && Open[li_16] > Close[li_20] || High[li_16] > High[li_20] && Close[li_16] < Close[li_20] - (Close[li_20] - Open[li_20]) / 2.0) li_52 = TRUE;
         else li_52 = FALSE;
      } else li_52 = FALSE;
      if (Close[li_24] > Open[li_24] && Open[li_20] > Close[li_24] && Close[li_20] > Close[li_24] && Open[li_16] < Close[li_20] || Low[li_16] < Low[li_20] && Close[li_16] < Close[li_24]) li_48 = TRUE;
      else li_48 = FALSE;
      if (Close[li_16] < Open[li_16] && High[li_16] - Open[li_16] > 3.0 * MathMax(Close[li_16] - Low[li_16], Open[li_16] - Close[li_16])) li_56 = TRUE;
      else li_56 = FALSE;
      if (li_28) {
         if (Name) SetText(li_12, Time[li_16], Low[li_16] - 450.0 * Point, "看涨吞没", White);
         if (Arrow) SetArrow(li_16, Time[li_16], Low[li_16] - 200.0 * Point, 225, White);
      } else {
         if (li_36) {
            if (Name) SetText(li_16, Time[li_16], Low[li_16] - 370.0 * Point, "刺透形态", Yellow);
            if (Arrow) SetArrow(li_16, Time[li_16], Low[li_16] - 100.0 * Point, 225, Yellow);
         }
      }
      if (li_32) {
         if (Name) SetText(li_20, Time[li_20], Low[li_20] - 320.0 * Point, "黎明之星", Fuchsia);
         if (Arrow) SetArrow(li_20, Time[li_20], Low[li_20] - 100.0 * Point, 225, Fuchsia);
      }
      if (li_40) {
         if (Name) SetText(li_16, Time[li_16], Low[li_16] - 300.0 * Point, "锤子线", Aqua);
         if (Arrow) SetArrow(li_16, Time[li_16], Low[li_16] - 100.0 * Point, 225, Aqua);
      }
      if (li_44) {
         if (Name) SetText(li_16, Time[li_16], High[li_16] + 450.0 * Point, "看跌吞没", White);
         if (Arrow) SetArrow(li_16, Time[li_16], High[li_16] + 300.0 * Point, 226, White);
      } else {
         if (li_52) {
            if (Name) SetText(li_16, Time[li_16], High[li_16] + 450.0 * Point, "乌云盖顶", DodgerBlue);
            if (Arrow) SetArrow(li_16, Time[li_16], High[li_16] + 150.0 * Point, 226, DodgerBlue);
         }
      }
      if (li_48) {
         if (Name) SetText(li_20, Time[li_20], High[li_20] + 250.0 * Point, "黄昏之星", DarkOrange);
         if (Arrow) SetArrow(li_20, Time[li_20], High[li_20] + 150.0 * Point, 226, DarkOrange);
      }
      if (li_56) {
         if (Name) SetText(li_16, Time[li_16], High[li_16] + 300.0 * Point, "上吊线", Aqua);
         if (Arrow) SetArrow(li_16, Time[li_16], High[li_16] + 150.0 * Point, 226, Aqua);
      }
      if (li_28 || li_36 || li_32 || li_40 && Close[li_12] > Open[li_12]) g_iBuf_1[li_12] = Low[li_12] - 7.0 * Point;
      else g_iBuf_1[li_12] = 0.0;
      if (li_44 || li_52 || li_48 || li_56 && Close[li_12] < Open[li_12]) g_iBuf_2[li_12] = High[li_12] + 7.0 * Point;
      else g_iBuf_2[li_12] = 0.0;
      li_8 -= 1;
   }
   return (0);
}