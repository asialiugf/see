
#property copyright "Copyright@laydy81�Ա����EA�з���һ��"
#property link      "http://shop57605532.taobao.com"

extern bool �൥���� = TRUE;
extern int ��ʼʱ�� = 0;
extern int ����ʱ�� = 24;
extern int ��ʼʱ��2 = 0;
extern int ����ʱ��2 = 24;
extern double lot = 0.2;
int gi_104 = 0;
extern int ����EMA�㿪�� = 10;
extern int EMA����ֹ��� = 20;
extern bool ƽ��ֿ��� = TRUE;
extern int ƽ��������� = 20;
extern int ƽ��15�� = 15;
extern int MA���� = 20;
extern int ��EMA = 12;
extern int ��EMA = 26;
extern int MacdSMA = 9;
extern int MAfast = 4;
extern int MAslow = 49;
extern double trigger = 0.07;
extern int maxbars = 500;
int gi_164 = 3;
string g_comment_168 = "";
int gi_176 = 1;
int gi_180 = 1;
int g_magic_184 = 2012;
int g_ticket_188 = -1;
int gi_192 = 0;
int gi_196 = 0;

int init() {
   if (Digits == 5 || Digits == 3) gi_176 = 10;
   ObjectCreate("logo1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("logo1", " EA���ܽ���ϵͳ", 16, "����", White);
   ObjectSet("logo1", OBJPROP_XDISTANCE, 300);
   ObjectSet("logo1", OBJPROP_YDISTANCE, 20);
   return (0);
}

int deinit() {
   ObjectDelete("logo1");
   return (0);
}

int runtime() {
   int li_4 = ��ʼʱ��;
   int li_8 = ����ʱ��;
   int l_hour_0 = TimeHour(TimeCurrent());
   if (li_4 > li_8) {
      if (li_4 <= l_hour_0 || l_hour_0 <= li_8) return (1);
      return (-1);
   }
   if (li_4 < li_8) {
      if (li_4 <= l_hour_0 && l_hour_0 <= li_8) return (1);
      return (-1);
   }
   return (0);
}

int runtime2() {
   int li_4 = ��ʼʱ��2;
   int li_8 = ����ʱ��2;
   int l_hour_0 = TimeHour(TimeCurrent());
   if (li_4 > li_8) {
      if (li_4 <= l_hour_0 || l_hour_0 <= li_8) return (1);
      return (-1);
   }
   if (li_4 < li_8) {
      if (li_4 <= l_hour_0 && l_hour_0 <= li_8) return (1);
      return (-1);
   }
   return (0);
}

int start() {
   if (Digits == 5 || Digits == 3) gi_176 = 10;
   double l_icustom_0 = iCustom(NULL, 0, "RAVI FX Fisher", MAfast, MAslow, trigger, maxbars, 0, 0);
   double l_icustom_8 = iCustom(NULL, 0, "RAVI FX Fisher", MAfast, MAslow, trigger, maxbars, 2, 0);
   double l_icustom_16 = iCustom(NULL, 0, "RAVI FX Fisher", MAfast, MAslow, trigger, maxbars, 1, 0);
   double l_ima_24 = iMA(NULL, 0, MA����, 0, MODE_EMA, PRICE_CLOSE, 0);
   double l_imacd_32 = iMACD(NULL, 0, ��EMA, ��EMA, MacdSMA, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_40 = iMACD(NULL, 0, ��EMA, ��EMA, MacdSMA, PRICE_CLOSE, MODE_MAIN, 1);
   double l_imacd_48 = iMACD(NULL, 0, ��EMA, ��EMA, MacdSMA, PRICE_CLOSE, MODE_MAIN, 2);
   double l_imacd_56 = iMACD(NULL, 0, ��EMA, ��EMA, MacdSMA, PRICE_CLOSE, MODE_MAIN, 3);
   double l_imacd_64 = iMACD(NULL, 0, ��EMA, ��EMA, MacdSMA, PRICE_CLOSE, MODE_MAIN, 4);
   double l_imacd_72 = iMACD(NULL, 0, ��EMA, ��EMA, MacdSMA, PRICE_CLOSE, MODE_MAIN, 5);
   if (runtime() == 1 || runtime2() == 1) {
      if (�൥���� == FALSE) {
         if (l_icustom_0 > l_icustom_8 || l_icustom_0 < l_icustom_16 && Close[0] > l_ima_24 + ����EMA�㿪�� * Point * gi_176 && (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 > 0.0 &&
            l_imacd_56 > 0.0 && l_imacd_64 > 0.0 && l_imacd_72 < 0.0) || (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 > 0.0 && l_imacd_56 > 0.0 && l_imacd_64 < 0.0) || (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 > 0.0 && l_imacd_56 < 0.0) ||
            (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 < 0.0) || (l_imacd_32 > 0.0 && l_imacd_40 < 0.0)) OpenOrder(0);
         if (l_icustom_0 > l_icustom_8 || l_icustom_0 < l_icustom_16 && Close[0] < l_ima_24 - ����EMA�㿪�� * Point * gi_176 && (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 < 0.0 &&
            l_imacd_56 < 0.0 && l_imacd_64 < 0.0 && l_imacd_72 > 0.0) || (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 < 0.0 && l_imacd_56 < 0.0 && l_imacd_64 > 0.0) || (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 < 0.0 && l_imacd_56 > 0.0) ||
            (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 > 0.0) || (l_imacd_32 < 0.0 && l_imacd_40 > 0.0)) OpenOrder(1);
      }
      if (�൥���� == TRUE) {
         if (l_imacd_32 < 0.0 && gi_192 != FALSE) gi_192 = FALSE;
         if (l_imacd_32 > 0.0 && gi_196 != FALSE) gi_196 = FALSE;
         if (l_icustom_0 > l_icustom_8 || l_icustom_0 < l_icustom_16 && Close[0] > l_ima_24 + ����EMA�㿪�� * Point * gi_176 && (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 > 0.0 &&
            l_imacd_56 > 0.0 && l_imacd_64 > 0.0 && l_imacd_72 < 0.0) || (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 > 0.0 && l_imacd_56 > 0.0 && l_imacd_64 < 0.0) || (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 > 0.0 && l_imacd_56 < 0.0) ||
            (l_imacd_32 > 0.0 && l_imacd_40 > 0.0 && l_imacd_48 < 0.0) || (l_imacd_32 > 0.0 && l_imacd_40 < 0.0)) OpenOrder2(0);
         if (l_icustom_0 > l_icustom_8 || l_icustom_0 < l_icustom_16 && Close[0] < l_ima_24 - ����EMA�㿪�� * Point * gi_176 && (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 < 0.0 &&
            l_imacd_56 < 0.0 && l_imacd_64 < 0.0 && l_imacd_72 > 0.0) || (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 < 0.0 && l_imacd_56 < 0.0 && l_imacd_64 > 0.0) || (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 < 0.0 && l_imacd_56 > 0.0) ||
            (l_imacd_32 < 0.0 && l_imacd_40 < 0.0 && l_imacd_48 > 0.0) || (l_imacd_32 < 0.0 && l_imacd_40 > 0.0)) OpenOrder2(1);
      }
   }
   if (CheckOrders2(OP_BUY) > 0 && Close[0] < l_ima_24 - ƽ��15�� * Point * gi_176) CloseOrders(OP_BUY);
   if (CheckOrders2(OP_SELL) > 0 && Close[0] > l_ima_24 + ƽ��15�� * Point * gi_176) CloseOrders(OP_SELL);
   MoveStopLoss();
   ScanSetSLTP();
   return (0);
}

int OpenOrder(int ai_0) {
   double l_price_12;
   double l_price_20;
   double l_price_28;
   double l_price_36;
   double l_ima_4 = iMA(NULL, 0, MA����, 0, MODE_EMA, PRICE_CLOSE, 0);
   if (ai_0 == 0 && CheckOrders(OP_BUY) == 0 && gi_180 != Time[0]) {
      g_ticket_188 = -1;
      g_ticket_188 = OrderSend(Symbol(), OP_BUY, lot, Ask, gi_164 * gi_176, 0, 0, g_comment_168, g_magic_184, 0, Green);
      if (g_ticket_188 > 0) {
         if (OrderSelect(g_ticket_188, SELECT_BY_TICKET, MODE_TRADES)) {
            l_price_12 = l_ima_4 - EMA����ֹ��� * Point * gi_176;
            l_price_20 = OrderOpenPrice() + gi_104 * Point * gi_176;
            if (EMA����ֹ��� == 0) l_price_12 = 0;
            if (gi_104 == 0) l_price_20 = 0;
            Print("BUY order opened : ", OrderOpenPrice());
            OrderModify(OrderTicket(), 0, l_price_12, l_price_20, 0, Orange);
            gi_180 = Time[0];
            gi_192 = TRUE;
            gi_196 = FALSE;
         }
      } else {
         Print("Error opening BUY order : ", GetLastError());
         return (0);
      }
   }
   if (ai_0 == 1 && CheckOrders(OP_SELL) == 0 && gi_180 != Time[0]) {
      g_ticket_188 = -1;
      g_ticket_188 = OrderSend(Symbol(), OP_SELL, lot, Bid, gi_164 * gi_176, 0, 0, g_comment_168, g_magic_184, 0, Red);
      if (g_ticket_188 > 0) {
         if (OrderSelect(g_ticket_188, SELECT_BY_TICKET, MODE_TRADES)) {
            l_price_28 = l_ima_4 + EMA����ֹ��� * Point * gi_176;
            l_price_36 = OrderOpenPrice() - gi_104 * Point * gi_176;
            if (EMA����ֹ��� == 0) l_price_28 = 0;
            if (gi_104 == 0) l_price_36 = 0;
            Print("SELL order opened : ", OrderOpenPrice());
            OrderModify(OrderTicket(), 0, l_price_28, l_price_36, 0, Orange);
            gi_180 = Time[0];
            gi_192 = FALSE;
            gi_196 = TRUE;
         }
      } else {
         Print("Error opening SELL order : ", GetLastError());
         return (0);
      }
   }
   return (0);
}

int OpenOrder2(int ai_0) {
   double l_price_12;
   double l_price_20;
   double l_price_28;
   double l_price_36;
   double l_ima_4 = iMA(NULL, 0, MA����, 0, MODE_EMA, PRICE_CLOSE, 0);
   if (ai_0 == 0 && gi_180 != Time[0] && gi_192 == FALSE) {
      g_ticket_188 = -1;
      g_ticket_188 = OrderSend(Symbol(), OP_BUY, lot, Ask, gi_164 * gi_176, 0, 0, g_comment_168, g_magic_184, 0, Green);
      if (g_ticket_188 > 0) {
         if (OrderSelect(g_ticket_188, SELECT_BY_TICKET, MODE_TRADES)) {
            l_price_12 = l_ima_4 - EMA����ֹ��� * Point * gi_176;
            l_price_20 = OrderOpenPrice() + gi_104 * Point * gi_176;
            if (EMA����ֹ��� == 0) l_price_12 = 0;
            if (gi_104 == 0) l_price_20 = 0;
            Print("BUY order opened : ", OrderOpenPrice() + "B=[" + gi_192 + "]");
            OrderModify(OrderTicket(), 0, l_price_12, l_price_20, 0, Orange);
            gi_180 = Time[0];
            gi_192 = TRUE;
            gi_196 = FALSE;
         }
      } else {
         Print("Error opening BUY order : ", GetLastError());
         return (0);
      }
   }
   if (ai_0 == 1 && gi_180 != Time[0] && gi_196 == FALSE) {
      g_ticket_188 = -1;
      g_ticket_188 = OrderSend(Symbol(), OP_SELL, lot, Bid, gi_164 * gi_176, 0, 0, g_comment_168, g_magic_184, 0, Red);
      if (g_ticket_188 > 0) {
         if (OrderSelect(g_ticket_188, SELECT_BY_TICKET, MODE_TRADES)) {
            l_price_28 = l_ima_4 + EMA����ֹ��� * Point * gi_176;
            l_price_36 = OrderOpenPrice() - gi_104 * Point * gi_176;
            if (EMA����ֹ��� == 0) l_price_28 = 0;
            if (gi_104 == 0) l_price_36 = 0;
            Print("SELL order opened : ", OrderOpenPrice() + "S=[" + gi_196 + "]");
            OrderModify(OrderTicket(), 0, l_price_28, l_price_36, 0, Orange);
            gi_180 = Time[0];
            gi_192 = FALSE;
            gi_196 = TRUE;
         }
      } else {
         Print("Error opening SELL order : ", GetLastError());
         return (0);
      }
   }
   return (0);
}

int CheckOrders(int a_cmd_0) {
   int l_count_4 = 0;
   for (int l_pos_8 = 0; l_pos_8 < OrdersTotal(); l_pos_8++) {
      OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderType() == a_cmd_0 && OrderMagicNumber() == g_magic_184) l_count_4++;
   }
   return (l_count_4);
}

int CheckOrders2(int a_cmd_0) {
   int l_count_4 = 0;
   for (int l_pos_8 = 0; l_pos_8 < OrdersTotal(); l_pos_8++) {
      OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderType() == a_cmd_0 && OrderMagicNumber() == g_magic_184 && OrderComment() != "") l_count_4++;
   }
   return (l_count_4);
}

void CloseOrders(int a_cmd_0) {
   while (CheckOrders2(a_cmd_0) != 0) {
      for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
         OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_184 && OrderType() == a_cmd_0 && OrderComment() != "") {
            if (OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 3, CLR_NONE) == 1) {
               if (a_cmd_0 == OP_BUY) Print("buy�������ţ�" + OrderTicket() + "�������ˣ�");
               if (a_cmd_0 == OP_SELL) Print("sell�����ţ�" + OrderTicket() + "�������ˣ�");
            }
         }
      }
   }
}

void MoveStopLoss() {
   int li_0 = 1;
   if (Digits == 3 || Digits == 5) li_0 = 10;
   int li_4 = ƽ���������;
   for (int l_pos_8 = 0; l_pos_8 < OrdersTotal(); l_pos_8++) {
      OrderSelect(l_pos_8, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() <= OP_SELL && OrderSymbol() == Symbol() && ƽ��ֿ��� == TRUE) {
         if (OrderType() == OP_BUY) {
            if (li_4 > 0 && OrderComment() == "" && Bid - OrderOpenPrice() > Point * li_0 * li_4) OrderClose(OrderTicket(), NormalizeDouble(OrderLots() / 2.0, 2), MarketInfo(OrderSymbol(), MODE_BID), 500);
         } else
            if (li_4 > 0 && OrderComment() == "" && OrderOpenPrice() - Ask > Point * li_0 * li_4) OrderClose(OrderTicket(), NormalizeDouble(OrderLots() / 2.0, 2), MarketInfo(OrderSymbol(), MODE_ASK), 500);
      }
   }
}

void ScanSetSLTP() {
   int li_unused_0 = 1;
   if (Digits == 3 || Digits == 5) li_unused_0 = 10;
   for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
      OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY && OrderComment() != "")
            if (OrderStopLoss() != OrderOpenPrice()) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice(), OrderTakeProfit(), 0, Green);
         if (OrderType() == OP_SELL && OrderComment() != "")
            if (OrderStopLoss() != OrderOpenPrice()) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice(), OrderTakeProfit(), 0, Red);
      }
   }
}
