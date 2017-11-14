
#property copyright "Copyright Sep,2008, Abin"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Gold

double g_ibuf_76[];
double g_ibuf_80[];
double g_ibuf_84[];
extern bool 提醒 = TRUE;
extern bool 组合框开启 = TRUE;
extern bool 标记开启 = TRUE;
extern bool 组合框背景 = TRUE;
extern color 看跌标记 = Red;
extern color 看涨标记 = Lime;
extern bool 乌云盖顶 = TRUE;
extern bool 看跌吞没 = TRUE;
bool gi_120 = TRUE;
extern bool 看涨刺透 = TRUE;
extern bool 看涨吞没 = TRUE;
bool gi_132 = TRUE;
extern bool 孕线 = TRUE;
extern bool 星线 = TRUE;
extern string 附加功能说明 = "附加功能只对应4小时图表";
extern bool 附加功能 = FALSE;
extern int NewYork_open_time_in_4H = 16;
string gsa_160[5000];
string gsa_164[5000];
string gsa_168[5000];
int gi_172 = 0;
int gi_unused_180 = 16;
int gi_184;
int gi_188;
int g_time_192 = 0;

int init() {
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexShift(0, 1);
   SetIndexArrow(0, 159);
   SetIndexBuffer(0, g_ibuf_76);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexShift(1, 1);
   SetIndexArrow(1, 159);
   SetIndexBuffer(1, g_ibuf_80);
   SetIndexStyle(2, DRAW_ARROW, EMPTY);
   SetIndexShift(2, 1);
   SetIndexArrow(2, 159);
   SetIndexBuffer(2, g_ibuf_84);
   return (0);
}

int deinit() {
   ObjectsDeleteAll(0, OBJ_TEXT);
   ObjectsDeleteAll(0, OBJ_RECTANGLE);
   ObjectsDeleteAll(0, OBJ_ARROW);
   return (0);
}

int start() {
   double ld_8;
   double ld_16;
   int li_24;
   bool li_28;
   int li_36;
   int li_40;
   int li_44;
   int li_48;
   int li_52;
   string ls_56;
   string ls_64;
   double l_open_88;
   double l_open_96;
   double l_open_104;
   double l_close_112;
   double l_close_120;
   double l_close_128;
   double l_low_136;
   double l_low_144;
   double l_low_152;
   double l_high_160;
   double l_high_168;
   double l_high_176;
   double l_high_184;
   double l_low_192;
   double l_low_200;
   double l_high_208;
   gi_184 = NewYork_open_time_in_4H - 4;
   gi_188 = NewYork_open_time_in_4H;
   datetime lt_0 = D'11.01.20013 08:00';
   int l_datetime_4 = TimeCurrent();

   int li_unused_72 = 0;
   int li_unused_76 = 0;
   if (g_time_192 == Time[0]) return (0);
   g_time_192 = Time[0];
   for (int l_index_216 = 0; l_index_216 < Bars - 10; l_index_216++) {
      gsa_160[l_index_216] = "pat" + l_index_216;
      gsa_164[l_index_216] = "Rec" + l_index_216;
      gsa_168[l_index_216] = "Arr" + l_index_216;
   }
   for (int l_index_32 = 0; l_index_32 <= Bars - 10; l_index_32++) {
      li_28 = FALSE;
      li_24 = l_index_32;
      ld_8 = 0;
      ld_16 = 0;
      for (li_24 = l_index_32; li_24 <= l_index_32 + 9; li_24++) ld_16 += MathAbs(High[li_24] - Low[li_24]);
      ld_8 = ld_16 / 10.0;
      li_36 = l_index_32 + 1;
      li_40 = l_index_32 + 2;
      li_44 = l_index_32 + 3;
      li_48 = l_index_32 + 4;
      li_52 = l_index_32 + 5;
      l_open_88 = Open[li_36];
      l_open_96 = Open[li_40];
      l_open_104 = Open[li_44];
      l_high_160 = High[li_36];
      l_high_168 = High[li_40];
      l_high_176 = High[li_44];
      l_low_136 = Low[li_36];
      l_low_144 = Low[li_40];
      l_low_152 = Low[li_44];
      l_close_112 = Close[li_36];
      l_close_120 = Close[li_40];
      l_close_128 = Close[li_44];
      l_high_184 = High[iHighest(NULL, 0, MODE_HIGH, 5, li_36)];
      l_low_192 = Low[iLowest(NULL, 0, MODE_LOW, 5, li_36)];
      l_high_208 = High[iHighest(NULL, 0, MODE_CLOSE, 5, li_36)];
      l_low_200 = Low[iLowest(NULL, 0, MODE_CLOSE, 5, li_36)];
      if ((l_close_112 > l_open_88 && (l_high_160 - l_close_112) / 2.0 >= l_close_112 - l_open_88 && l_open_88 - l_low_136 <= 1.5 * (l_close_112 - l_open_88) && l_close_112 >= 0.999 * l_high_208) ||
         (l_close_112 < l_open_88 && (l_high_160 - l_open_88) / 2.0 >= l_open_88 - l_close_112 && l_close_112 - l_low_136 <= 1.5 * (l_open_88 - l_close_112) && l_open_88 >= 0.999 * l_high_208) && l_high_160 >= l_high_184) {
         if (星线 == TRUE) {
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], High[li_36] + ld_8 / 2.0);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看跌标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 181);
            }
         }
         if (li_28 == FALSE && 提醒 == TRUE) {
            ls_56 = "射击之星 ";
            li_28 = TRUE;
         }
      }
      if ((l_open_88 > l_close_112 && (l_close_112 - l_low_136) / 2.0 >= l_open_88 - l_close_112 && l_high_160 - l_open_88 <= 1.5 * (l_open_88 - l_close_112) && l_open_88 >= 0.999 * l_high_208) ||
         (l_close_112 > l_open_88 && (l_open_88 - l_low_136) / 2.0 >= l_close_112 - l_open_88 && l_high_160 - l_close_112 <= 1.5 * (l_close_112 - l_open_88) && l_close_112 >= 0.999 * l_high_208) && l_high_160 >= l_high_184) {
         if (星线 == TRUE) {
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], High[li_36] + ld_8 / 2.0);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看跌标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 86);
            }
         }
         if (li_28 == FALSE && 提醒 == TRUE) {
            ls_56 = "上吊线 ";
            li_28 = TRUE;
         }
      }
      if (l_close_120 > l_open_96 && l_open_88 > l_close_112 && l_open_88 >= 0.99 * l_close_120 && l_open_96 >= 0.99 * l_close_112 && l_open_88 - l_close_112 > l_close_120 - l_open_96 &&
         l_open_88 - l_close_112 >= 0.2 * ld_8 && l_high_168 >= l_high_184 || l_high_160 >= l_high_184) {
         if (看跌吞没 == TRUE) {
            if (组合框开启 == TRUE) {
               ObjectCreate(gsa_164[l_index_32], OBJ_RECTANGLE, 0, Time[l_index_32], (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8, Time[li_44], (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8);
               ObjectSet(gsa_164[l_index_32], OBJPROP_COLOR, HotPink);
               ObjectSet(gsa_164[l_index_32], OBJPROP_BACK, 组合框背景);
            }
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], (High[li_40] + Low[li_40]) / 2.0 + 1.0 * ld_8);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看跌标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 218);
            }
            if (TimeHour(Time[li_36]) == gi_184 || TimeHour(Time[li_36]) == gi_188 && 附加功能 == TRUE) {
               g_ibuf_76[li_36] = (High[li_40] + Low[li_40]) / 2.0;
               g_ibuf_80[li_36] = (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8;
               g_ibuf_84[li_36] = (High[li_40] + Low[li_40]) / 2.0 - 2.1 * ld_8;
            }
         }
         if (li_28 == FALSE && 提醒 == TRUE) {
            ls_56 = "看跌吞没";
            li_28 = TRUE;
         }
      }
      if (l_close_120 > l_open_96 && (l_close_120 + l_open_96) / 2.0 > l_close_112 && l_open_88 > l_close_112 && l_open_88 > l_close_120 && l_close_112 > l_open_96 && (l_open_88 - l_close_112) / (l_high_160 - l_low_136 +
         0.001) > 0.6 && l_high_168 >= l_high_184 || l_high_160 >= l_high_184) {
         if (乌云盖顶 == TRUE) {
            if (组合框开启 == TRUE) {
               ObjectCreate(gsa_164[l_index_32], OBJ_RECTANGLE, 0, Time[l_index_32], (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8, Time[li_44], (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8);
               ObjectSet(gsa_164[l_index_32], OBJPROP_COLOR, Red);
               ObjectSet(gsa_164[l_index_32], OBJPROP_BACK, 组合框背景);
            }
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], (High[li_40] + Low[li_40]) / 2.0 + 1.0 * ld_8);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看跌标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 155);
            }
            if (TimeHour(Time[li_36]) == gi_184 || TimeHour(Time[li_36]) == gi_188 && 附加功能 == TRUE) {
               g_ibuf_76[li_36] = (High[li_40] + Low[li_40]) / 2.0;
               g_ibuf_80[li_36] = (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8;
               g_ibuf_84[li_36] = (High[li_40] + Low[li_40]) / 2.0 - 2.1 * ld_8;
            }
         }
         if (li_28 == FALSE && 提醒 == TRUE) {
            ls_56 = "乌云盖顶";
            li_28 = TRUE;
         }
      }
      if (l_close_128 > l_open_104 && (l_close_128 - l_open_104) / (l_high_176 + 0.001 - l_low_152) > 0.6 && l_close_128 < l_open_96 && l_close_120 > l_open_96 && l_high_168 - l_low_144 > 3.0 * (l_close_120 - l_open_96) &&
         l_open_88 > l_close_112 && l_open_88 < l_open_96 && l_high_168 >= l_high_184 || l_high_160 >= l_high_184) {
         if (星线 == TRUE) {
         }
         if (li_28 == FALSE && 提醒 == TRUE) {
            ls_56 = "黄昏十字星";
            li_28 = TRUE;
         }
      }
      if (l_close_120 > l_open_96 && l_open_88 > l_close_112 && 0.99 * l_open_88 <= l_close_120 && 0.99 * l_open_96 <= l_close_112 && l_open_88 - l_close_112 < l_close_120 - l_open_96 &&
         l_close_120 - l_open_96 >= 0.2 * ld_8 && l_open_88 - l_close_112 >= (l_close_120 - l_open_96) / 2.0 && l_high_168 >= l_high_184 || l_high_160 >= l_high_184) {
         if (孕线 == TRUE) {
            if (组合框开启 == TRUE) {
               ObjectCreate(gsa_164[l_index_32], OBJ_RECTANGLE, 0, Time[l_index_32], (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8, Time[li_44], (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8);
               ObjectSet(gsa_164[l_index_32], OBJPROP_COLOR, Pink);
               ObjectSet(gsa_164[l_index_32], OBJPROP_BACK, 组合框背景);
            }
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], (High[li_40] + Low[li_40]) / 2.0 + 1.0 * ld_8);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看跌标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 222);
            }
            if (TimeHour(Time[li_36]) == gi_184 || TimeHour(Time[li_36]) == gi_188 && 附加功能 == TRUE) {
               g_ibuf_76[li_36] = (High[li_40] + Low[li_40]) / 2.0;
               g_ibuf_80[li_36] = (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8;
               g_ibuf_84[li_36] = (High[li_40] + Low[li_40]) / 2.0 - 2.1 * ld_8;
            }
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "看跌孕线";
            li_28 = TRUE;
         }
      }
      if (l_open_88 > 1.01 * l_close_112 && l_open_96 > 1.01 * l_close_120 && l_open_104 > 1.01 * l_close_128 && l_close_112 < l_close_120 && l_close_120 < l_close_128 &&
         l_open_88 > l_close_120 && l_open_88 < l_open_96 && l_open_96 > l_close_128 && l_open_96 < l_open_104 && (l_close_112 - l_low_136) / (l_high_160 - l_low_136 + 0.0001) < 0.2 && (l_close_120 - l_low_144) / (l_high_168 - l_low_144 +
         0.0001) < 0.2 && (l_close_128 - l_low_152) / (l_high_176 - l_low_152 + 0.0001) < 0.2 && l_high_168 >= l_high_184 || l_high_160 >= l_high_184) {
         if (gi_120 == TRUE) {
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "三只乌鸦";
            li_28 = TRUE;
         }
      }
      if (l_close_128 > l_open_104 && (l_close_128 - l_open_104) / (l_high_176 + 0.001 - l_low_152) > 0.6 && l_close_128 < l_open_96 && l_close_120 > l_open_96 && l_high_168 - l_low_144 > 3.0 * (l_close_120 - l_open_96) &&
         l_open_88 > l_close_112 && l_open_88 < l_open_96 && l_high_168 >= l_high_184 || l_high_160 >= l_high_184) {
         if (星线 == TRUE) {
            ObjectCreate(gsa_160[l_index_32], OBJ_TEXT, 0, Time[li_36], High[li_36] + 1.4 * ld_8);
            ObjectSetText(gsa_160[l_index_32], "黄昏之星", 9, "Times New Roman", Red);
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], High[li_36] + ld_8 / 2.0);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看跌标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 178);
            }
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "黄昏之星";
            li_28 = TRUE;
         }
      }
      if ((l_open_88 > l_close_112 && (l_close_112 - l_low_136) / 2.0 >= l_open_88 - l_close_112 && l_high_160 - l_open_88 <= 1.5 * (l_open_88 - l_close_112) && l_close_112 <= 1.001 * l_low_200) ||
         (l_close_112 > l_open_88 && (l_open_88 - l_low_136) / 2.0 >= l_close_112 - l_open_88 && l_high_160 - l_close_112 <= 1.5 * (l_close_112 - l_open_88) && l_open_88 <= 1.001 * l_low_200) && l_low_136 <= l_low_192) {
         if (星线 == TRUE) {
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], Low[li_36] - ld_8 / 2.0);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看涨标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 182);
            }
         }
         if (li_28 == FALSE && 提醒 == TRUE) {
            ls_56 = "锤子线";
            li_28 = TRUE;
         }
      }
      if ((l_close_112 > l_open_88 && (l_high_160 - l_close_112) / 2.0 >= l_close_112 - l_open_88 && l_open_88 - l_low_136 <= 1.5 * (l_close_112 - l_open_88) && l_open_88 <= 1.001 * l_low_200) ||
         (l_close_112 < l_open_88 && (l_high_160 - l_open_88) / 2.0 >= l_open_88 - l_close_112 && l_close_112 - l_low_136 <= 1.5 * (l_open_88 - l_close_112) && l_close_112 <= 1.001 * l_low_200) && l_low_136 <= l_low_192) {
         if (星线 == TRUE) {
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], Low[li_36] - ld_8 / 2.0);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看涨标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 85);
            }
         }
         if (li_28 == FALSE && 提醒 == TRUE) {
            ls_56 = "倒锤子";
            li_28 = TRUE;
         }
      }
      if (l_open_96 > l_close_120 && l_close_112 > l_open_88 && l_close_112 >= 0.99 * l_open_96 && l_close_120 >= 0.99 * l_open_88 && l_close_112 - l_open_88 > l_open_96 - l_close_120 &&
         l_close_112 - l_open_88 >= 0.2 * ld_8 && l_low_144 <= l_low_192 || l_low_136 <= l_low_192) {
         if (看涨吞没 == TRUE) {
            if (组合框开启 == TRUE) {
               ObjectCreate(gsa_164[l_index_32], OBJ_RECTANGLE, 0, Time[l_index_32], (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8, Time[li_44], (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8);
               ObjectSet(gsa_164[l_index_32], OBJPROP_COLOR, Lime);
               ObjectSet(gsa_164[l_index_32], OBJPROP_BACK, 组合框背景);
            }
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], (High[li_40] + Low[li_40]) / 2.0 - 1.0 * ld_8);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看涨标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 217);
            }
            if (TimeHour(Time[li_36]) == gi_184 || TimeHour(Time[li_36]) == gi_188 && 附加功能 == TRUE) {
               g_ibuf_76[li_36] = (High[li_40] + Low[li_40]) / 2.0;
               g_ibuf_80[li_36] = (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8;
               g_ibuf_84[li_36] = (High[li_40] + Low[li_40]) / 2.0 + 2.1 * ld_8;
            }
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "看涨吞没";
            li_28 = TRUE;
         }
      }
      if (l_open_96 > l_close_120 && l_close_112 > l_open_88 && 0.99 * l_close_112 <= l_open_96 && 0.99 * l_close_120 <= l_open_88 && l_close_112 - l_open_88 < l_open_96 - l_close_120 &&
         l_open_96 - l_close_120 >= 0.2 * ld_8 && l_close_112 - l_open_88 >= (l_open_96 - l_close_120) / 2.0 && l_low_144 <= l_low_192 || l_low_136 <= l_low_192) {
         if (孕线 == TRUE) {
            if (组合框开启 == TRUE) {
               ObjectCreate(gsa_164[l_index_32], OBJ_RECTANGLE, 0, Time[l_index_32], (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8, Time[li_44], (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8);
               ObjectSet(gsa_164[l_index_32], OBJPROP_COLOR, LightGreen);
               ObjectSet(gsa_164[l_index_32], OBJPROP_BACK, 组合框背景);
            }
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], (High[li_40] + Low[li_40]) / 2.0 - 1.0 * ld_8);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看涨标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 221);
            }
            if (TimeHour(Time[li_36]) == gi_184 || TimeHour(Time[li_36]) == gi_188 && 附加功能 == TRUE) {
               g_ibuf_76[li_36] = (High[li_40] + Low[li_40]) / 2.0;
               g_ibuf_80[li_36] = (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8;
               g_ibuf_84[li_36] = (High[li_40] + Low[li_40]) / 2.0 + 2.1 * ld_8;
            }
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "看涨孕线";
            li_28 = TRUE;
         }
      }
      if (l_close_120 < l_open_96 && (l_open_96 + l_close_120) / 2.0 < l_close_112 && l_open_88 < l_close_112 && l_open_88 < l_close_120 && l_close_112 < l_open_96 && (l_close_112 - l_open_88) / (l_high_160 - l_low_136 +
         0.001) > 0.6 && l_low_144 <= l_low_192 || l_low_136 <= l_low_192) {
         if (看涨刺透 == TRUE) {
            if (组合框开启 == TRUE) {
               ObjectCreate(gsa_164[l_index_32], OBJ_RECTANGLE, 0, Time[l_index_32], (High[li_40] + Low[li_40]) / 2.0 + 0.7 * ld_8, Time[li_44], (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8);
               ObjectSet(gsa_164[l_index_32], OBJPROP_COLOR, SpringGreen);
               ObjectSet(gsa_164[l_index_32], OBJPROP_BACK, 组合框背景);
            }
            if (标记开启 == TRUE) {
               ObjectCreate(gsa_168[l_index_32], OBJ_ARROW, 0, Time[li_36], (High[li_40] + Low[li_40]) / 2.0 - 1.0 * ld_8);
               ObjectSet(gsa_168[l_index_32], OBJPROP_COLOR, 看涨标记);
               ObjectSet(gsa_168[l_index_32], OBJPROP_ARROWCODE, 208);
            }
            if (TimeHour(Time[li_36]) == gi_184 || TimeHour(Time[li_36]) == gi_188 && 附加功能 == TRUE) {
               g_ibuf_76[li_36] = (High[li_40] + Low[li_40]) / 2.0;
               g_ibuf_80[li_36] = (High[li_40] + Low[li_40]) / 2.0 - 0.7 * ld_8;
               g_ibuf_84[li_36] = (High[li_40] + Low[li_40]) / 2.0 + 2.1 * ld_8;
            }
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "看涨刺透";
            li_28 = TRUE;
         }
      }
      if (l_close_112 > 1.01 * l_open_88 && l_close_120 > 1.01 * l_open_96 && l_close_128 > 1.01 * l_open_104 && l_close_112 > l_close_120 && l_close_120 > l_close_128 &&
         l_open_88 < l_close_120 && l_open_88 > l_open_96 && l_open_96 < l_close_128 && l_open_96 > l_open_104 && (l_high_160 - l_close_112) / (l_high_160 - l_low_136 + 0.0001) < 0.2 && (l_high_168 - l_close_120) / (l_high_168 - l_low_144 +
         0.0001) < 0.2 && (l_high_176 - l_close_128) / (l_high_176 - l_low_152 + 0.0001) < 0.2 && l_low_144 <= l_low_192 || l_low_136 <= l_low_192) {
         if (gi_132 == TRUE) {
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "白色三兵";
            li_28 = TRUE;
         }
      }
      if (l_open_104 > l_close_128 && (l_open_104 - l_close_128) / (l_high_176 + 0.001 - l_low_152) > 0.6 && l_close_128 > l_open_96 && l_open_96 > l_close_120 && l_high_168 - l_low_144 > 3.0 * (l_close_120 - l_open_96) &&
         l_close_112 > l_open_88 && l_open_88 > l_open_96 && l_low_144 <= l_low_192 || l_low_136 <= l_low_192) {
         if (星线 == TRUE) {
            ObjectCreate(gsa_160[l_index_32], OBJ_TEXT, 0, Time[li_36], Low[li_36] - 1.4 * ld_8);
            ObjectSetText(gsa_160[l_index_32], "黎明十字星", 9, "Times New Roman", Green);
         }
         if (l_index_32 == 0 && 提醒 == TRUE) {
            ls_56 = "黎明十字星";
            li_28 = TRUE;
         }
      }
      if (li_28 == TRUE && l_index_32 == 0) {
         Alert(Symbol(), " ", ls_64, " ", ls_56);
         li_28 = FALSE;
      }
   }
   return (0);
}