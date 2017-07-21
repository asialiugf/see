//
// Version: 2016-06-16 21:16 (mod4)
//
//+------------------------------------------------------------------+
//|                                               ilan_trio_v147.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                              Ilan-Trio V1.47.mq4 |
//|                                                            Night |
//|                                        http://alfonius@yandex.ru |
//+------------------------------------------------------------------+
// Dec 15 -2011 -- Add Timer for Loop and print to screen
// Sep 12 - 2016 -- exposed time frame for ilan1.5
// Sep 16 - 2016 -- Bug fix: If OrderModify retruns false, routine goes into infinite loop, causing EA to hang indefinitely

extern string  t1 = "General Settings";
extern bool    DisplayOnScreenText = true;
extern double  Lots = 0.10;          // Initial lot
extern double  LotExponent = 1.85;      // Exponent at which next trade will multiply
extern int     lotdecimal = 2;          // 2 - microlot 0.01, 1 - mini lot 0.1, 0 - standard lot 1.0
extern double  PipStep = 50.0;          // At what distance should next trade be taken
extern bool    Turbo = false;           // First 3 trades will be closer together
extern bool    MarioTurbo = true;       // Mario's adaptive turbo, fast in begining slower in the end
extern int     MarioTurboFactor = 5;    // 因子
extern bool    NewCycle = true;         // Start new cycles (running will continue to run)
extern bool    NewCycle15 = true;       // Start new cycles (running will continue to run)
extern bool    NewCycle16 = true;       // Start new cycles (running will continue to run)
extern bool    NewCycleHiLo = true;      // Start new cycles (running will continue to run)
extern int     PeriodRSI = 5;           // 1=M1, 2=M5, 3=M15, 4=M30, 5=H1, 6=H4, 7=D1, 8=W1, 9=MN1, 0=Current chart
int PerRSI;                            // Период RSI 周期
double MaxLots = 10;                   // Max allowed lot as start
extern bool   MM =FALSE;               // MM - money management
extern double TakeProfit = 100.0;      // points to take profit (average price plus/minus this value)
bool UseEquityStop = FALSE;            // Use equity stop
double TotalEquityRisk = 20.0;         // Max allowed equity risk (trades will close at this level)
bool UseTrailingStop = FALSE;          // Use traling stop  移动止损
double TrailStart = 100.0;             // Trailing start
double TrailStop = 10.0;               //Trailing stop
double slip = 5.0;                     // Slippage

//===================================================================
//-------------------Hilo_RSI--------------------------------------//
//===================================================================
extern string t3 = "Settings EA Ilan_Hilo";
double Lots_Hilo;                       // задание всех лотов через 1 переменную 在1个变量所有批次的分配
int OnScreenDelay = 0;
double LotExponent_Hilo;
int lotdecimal_Hilo, ord_Hilo;
double TakeProfit_Hilo;                 // тейк профит 获得利润
extern int MaxTrades = 10;         // максимально количество одновременно открытых ордеров 同时打开订单的最大数量
bool UseEquityStop_Hilo;                // использовать риск в процентах 使用风险百分比
double TotalEquityRisk_Hilo;            // риск в процентах от депозита 风险保证金的百分比
//=====================================================
bool UseTimeOut_Hilo = FALSE;           // использовать анулирование ордеров по времени 是否使用挂单超期
double MaxTradeOpenHours_Hilo = 48.0;   // через колько часов анулировать висячие ордера 取消挂单的小时数
//=====================================================
bool UseTrailingStop_Hilo;              // использовать трейлинг стоп 使用移动止损
extern double Stoploss_Hilo = 500.0;           // Эти параметра работают!!! 这些参数的工作？
double TrailStart_Hilo;
double TrailStop_Hilo;
//=====================================================
double PipStep_Hilo;                    // шаг колена- был 30  kolena-步骤为30
double slip_Hilo;                       // проскальзывание  滑动？
extern int g_magic_hilo = 11111;    // магик magic ?
//=====================================================
double PriceTarget_Hilo, StartEquity_Hilo, BuyTarget_Hilo, SellTarget_Hilo, Balans, Sredstva ;
double AveragePrice_Hilo, SellLimit_Hilo, BuyLimit_Hilo ;
double LastBuyPrice_Hilo, LastSellPrice_Hilo, Spread_Hilo;
bool flag_Hilo;
string EAName_Hilo = "Ilan_HiLo_RSI";
int timeprev_Hilo = 0;
int expiration_Hilo;
int NumOfTrades_Hilo = 0;
double iLots_Hilo;
int cnt_Hilo = 0, total_Hilo;
double Stopper_Hilo = 0.0;
bool TradeNow_Hilo = FALSE, LongTrade_Hilo = FALSE, ShortTrade_Hilo = FALSE;
int ticket_Hilo;
bool NewOrdersPlaced_Hilo = FALSE;
double AccountEquityHighAmt_Hilo, PrevEquity_Hilo;
//==============================
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//            ILAN 1.5                       //
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extern string t4 = "Settings EA Ilan 1.5";
double LotExponent_15;
double Lots_15;
int lotdecimal_15, ord_15;
double TakeProfit_15;
bool UseEquityStop_15;                   // использовать риск в процентах
double TotalEquityRisk_15;               // риск в процентах от депозита
//extern int MaxTrades = 10;
extern int OpenNewTF_15 = 60;            //When should 1.5 activate. Default is every 60 minutes, unless trades are already running
extern int TimeFrameCloseValue = 0; //What time fram to use for comparing close value. 1=M1, 2=M5, 3=M15, 4=M30, 5=H1, 6=H4, 7=D1, 8=W1, 9=MN1, 0=Current chart
int gi_unused_88_15;
//==============================================
bool UseTrailingStop_15;                 // использовать трейлинг стоп
extern double Stoploss_15 = 500.0;              // Эти параметры  не работают!!!
double TrailStart_15;
double TrailStop_15;
//==============================================
bool UseTimeOut_15 = FALSE;              // использовать анулирование ордеров по времени
double MaxTradeOpenHours_15 = 48.0;      // через колько часов анулировать висячие ордера
//===============================================
double PipStep_15; //30
double slip_15;
extern int g_magic_15 = 12324;
//===============================================
double g_price_180_15;
double gd_188_15;
double gd_unused_196_15;
double gd_unused_204_15;
double g_price_212_15;
double g_bid_220_15;
double g_ask_228_15;
double gd_236_15;
double gd_244_15;
double Spread_15;
bool gi_268_15;
string gs_ilan_272_15 = "Ilan 1.5";
int gi_280_15 = 0;
int gi_284_15;
int gi_288_15 = 0;
double gd_292_15;
int i = 0;
int gi_304_15;
double gd_308_15 = 0.0;
bool gi_316_15 = FALSE;
bool gi_320_15 = FALSE;
bool gi_324_15 = FALSE;
int gi_328_15;
bool gi_332_15 = FALSE;
double gd_336_15;
double gd_344_15;
datetime time_15=1;
//========================================================================
//                 ILAN 1.6                                             //
//========================================================================
extern string t5 = "Settings EA Ilan 1.6";
double LotExponent_16;
double Lots_16;
int lotdecimal_16, ord_16;
double TakeProfit_16;
//extern int MaxTrades = 10;
bool UseEquityStop_16;                    // использовать риск в процентах 使用风险百分比
double TotalEquityRisk_16;                // риск в процентах от депозита 风险保证金的百分比
int OpenNewTF_16 = 1;
//=========================================================
bool UseTrailingStop_16;
extern double Stoploss_16 = 500.0;               // Эти три параметра не работают!!! 这三个参数不工作
double TrailStart_16;
double TrailStop_16;
//=========================================================
bool UseTimeOut_16 = FALSE;
double MaxTradeOpenHours_16 = 48.0;
//=========================================================
double PipStep_16;//30
double slip_16;
extern int g_magic_16 = 16794;        //魔幻号，用于区别每个定单

/*
   这个用处太大了。你可以对这个编码，对每个号码标识一个意义，
   比如，magic > 10000, magic < 20000,代表欧元，
   10001，代表欧元的小时线的开仓，
   10002代表４小时线上的开仓,等等等。。。
   如果你想对一个交易做个标识的话，你可以用Magic 方便的标识出来
*/
//=========================================================

double g_price_180_16;
double gd_188_16;
double gd_unused_196_16;
double gd_unused_204_16;
double g_price_212_16;
double g_bid_220_16;
double g_ask_228_16;
double gd_236_16;
double gd_244_16;
double Spread_16;
bool gi_268_16;
string gs_ilan_272_16 = "Ilan 1.6";
int gi_280_16 = 0;
int gi_284_16;
int gi_288_16 = 0;
double gd_292_16;
//int i = 0;
int gi_304_16;
double gd_308_16 = 0.0;
bool gi_316_16 = FALSE;
bool gi_320_16 = FALSE;
bool gi_324_16 = FALSE;
int gi_328_16;
bool gi_332_16 = FALSE;
double gd_336_16;
double gd_344_16;
datetime time_16=1;

//==============================
//==============================
string    txt,txt1;
string    txt2="";
string    txt3="";
color col = ForestGreen;
//---------------------------------------------------------
datetime lastcheck;
int  begin, end, max, current;
//-------------------------------------------------------- Loop Speed variables
//==============================
int init()
{
    Spread_Hilo = MarketInfo(Symbol(), MODE_SPREAD) * Point;
    Spread_15   = MarketInfo(Symbol(), MODE_SPREAD) * Point;
    Spread_16   = MarketInfo(Symbol(), MODE_SPREAD) * Point;
    if(Turbo == true && MarioTurbo == true) {
        return (ERR_COMMON_ERROR);
    }
    return (0);
}// end init
//==============================
int deinit()
{
    ObjectDelete("Lable");
    ObjectDelete("Lable1");
    ObjectDelete("Lable2");
    ObjectDelete("Lable3");
    ObjectDelete("pipHiLo");
    ObjectDelete("pip15");
    ObjectDelete("pip16");
    return (0);
}
//========================================================================
//========================================================================
int start()
{

    begin=GetTickCount();                     // 用于统计 运行一次start()所需要的时间
    int counted_bars=IndicatorCounted();      // 没有用到！
    if(Lots > MaxLots) Lots = MaxLots;        //ограничение лотов  很多限制
    if(DisplayOnScreenText) {
        if(OnScreenDelay >= 100) {
            Comment(""
                    + "\n"
                    + "Ilan-Trio V 1.47 mod 4" + "\n"
                    + "________________________________"   + "\n"
                    + "Broker:         " + AccountCompany() + "\n"
                    + "LOOP Speed  " + max + "\n"
                    + "________________________________"  + "\n"
                    + "所有者:             " + AccountName() + "\n"
                    + "Acc number        " + AccountNumber()+ "\n"
                    + "Acc currency  :   " + AccountCurrency()   + "\n"
                    + "_______________________________" + "\n"
                    + "Open trades Ilan_Hilo: " + CountTrades(g_magic_hilo) + "\n"
                    + "Open trades Ilan_1.5 : " + CountTrades(g_magic_15) + "\n"
                    + "Open trades Ilan_1.6 : " + CountTrades(g_magic_16) + "\n"
                    + "Total trades         : " + OrdersTotal() + "\n"
                    + "Total lots           : " + DoubleToStr(CountTotalLots(), 2) + "\n"
                    + "_______________________________" + "\n"
                    + "Balance              : " + DoubleToStr(AccountBalance(), 2) + "\n"
                    + "Equity               : " + DoubleToStr(AccountEquity(), 2) + "\n"
                    + "Margin:            " + DoubleToStr(AccountMargin(), 2) + "\n"
                    + "Profit:            " + DoubleToStr(AccountProfit(), 2) + "\n"
                    + "_______________________________");

            Balans = NormalizeDouble(AccountBalance(),2);      // AccountBalance()返回当前账户的结余值
            Sredstva = NormalizeDouble(AccountEquity(),2);     // AccountEquity()返回当前账户的净值
            if(Sredstva >= Balans/6*5)  col = DodgerBlue;
            if(Sredstva >= Balans/6*4 && Sredstva < Balans/6*5)  col = DeepSkyBlue;
            if(Sredstva >= Balans/6*3 && Sredstva < Balans/6*4)  col = Gold;
            if(Sredstva >= Balans/6*2 && Sredstva < Balans/6*3)  col = OrangeRed;
            if(Sredstva >= Balans/6   && Sredstva < Balans/6*2)  col = Crimson;
            if(Sredstva <  Balans/5)  col = Red;
            //-------------------------
            ObjectDelete("Lable2");
            ObjectCreate("Lable2",OBJ_LABEL,0,0,1.0);
            ObjectSet("Lable2", OBJPROP_CORNER, 3);
            ObjectSet("Lable2", OBJPROP_XDISTANCE, 153);
            ObjectSet("Lable2", OBJPROP_YDISTANCE, 31);
            txt2=(DoubleToStr(AccountBalance(), 2));
            ObjectSetText("Lable2","Balance 余额     "+txt2+"",16,"Times New Roman",DodgerBlue);

            //-------------------------
            ObjectDelete("Lable3");
            ObjectCreate("Lable3",OBJ_LABEL,0,0,1.0);
            ObjectSet("Lable3", OBJPROP_CORNER, 3);
            ObjectSet("Lable3", OBJPROP_XDISTANCE, 153);
            ObjectSet("Lable3", OBJPROP_YDISTANCE, 11);
            txt3=(DoubleToStr(AccountEquity(), 2));
            ObjectSetText("Lable3","Equity 净值    "+txt3+"",16,"Times New Roman",col);

            //-------------------------
            ObjectDelete("pipHiLo");
            ObjectCreate("pipHiLo",OBJ_LABEL,0,0,1.0);
            ObjectSet("pipHiLo", OBJPROP_CORNER, 1);
            ObjectSet("pipHiLo", OBJPROP_XDISTANCE, 20);
            ObjectSet("pipHiLo", OBJPROP_YDISTANCE, 20);
            txt3=(DoubleToStr(AccountEquity(), 2));
            ObjectSetText("pipHiLo","PipStepHilo "+PipStep_Hilo+"",12,"Times New Roman",Gold);

            //-------------------------
            ObjectDelete("pip15");
            ObjectCreate("pip15",OBJ_LABEL,0,0,1.0);
            ObjectSet("pip15", OBJPROP_CORNER, 1);
            ObjectSet("pip15", OBJPROP_XDISTANCE, 20);
            ObjectSet("pip15", OBJPROP_YDISTANCE, 40);
            txt3=(DoubleToStr(AccountEquity(), 2));
            ObjectSetText("pip15","PipStep15    "+PipStep_15+"",12,"Times New Roman",Gold);

            //-------------------------
            ObjectDelete("pip16");
            ObjectCreate("pip16",OBJ_LABEL,0,0,1.0);
            ObjectSet("pip16", OBJPROP_CORNER, 1);
            ObjectSet("pip16", OBJPROP_XDISTANCE, 20);
            ObjectSet("pip16", OBJPROP_YDISTANCE, 60);
            txt3=(DoubleToStr(AccountEquity(), 27));
            ObjectSetText("pip16","PipStep16   "+PipStep_16+"",12,"Times New Roman",Gold);

            OnScreenDelay = 0;
        } else {
            OnScreenDelay += 1;
        }
    } // end of DisplayOnScreenText();

    //=================
    if(PeriodRSI == 1) PerRSI =PERIOD_M1;
    if(PeriodRSI == 2) PerRSI =PERIOD_M5;
    if(PeriodRSI == 3) PerRSI =PERIOD_M15;
    if(PeriodRSI == 4) PerRSI =PERIOD_M30;
    if(PeriodRSI == 5) PerRSI =PERIOD_H1;
    if(PeriodRSI == 6) PerRSI =PERIOD_H4;
    if(PeriodRSI == 7) PerRSI =PERIOD_D1;
    if(PeriodRSI == 8) PerRSI =PERIOD_W1;
    if(PeriodRSI == 9) PerRSI =PERIOD_MN1;
    if(PeriodRSI == 0) PerRSI =Period();

    //================= ForestGreen' YellowGreen' Yellow' OrangeRed' Red

//    {

    //=======================================================================//
    //                 Программный код 代码 Ilan_Hilo_RSI                         //
    //=======================================================================//
//    {
    double PrevCl_Hilo; //переменная 变量 Hilo
    double CurrCl_Hilo; //переменная 变量 Hilo
    double l_iclose_8;  //переменная 变量 Ilan_1.5
    double l_iclose_16; //переменная 变量 Ilan_1.6
    //=======================
    double   LotExponent_Hilo = LotExponent;
    int      lotdecimal_Hilo = lotdecimal;
    double   TakeProfit_Hilo = TakeProfit;
    bool     UseEquityStop_Hilo = UseEquityStop;
    double   TotalEquityRisk_Hilo = TotalEquityRisk; // риск в процентах от депозита
    bool     UseTrailingStop_Hilo = UseTrailingStop;
    double   TrailStart_Hilo = TrailStart;
    double   TrailStop_Hilo = TrailStop;
    //double    PipStep_Hilo = PipStep;   //30
    double   slip_Hilo = slip;            // проскальзывание

    //=========
    ord_Hilo = CountTrades(g_magic_hilo);         //有多少单
    if(Turbo) {
        if(ord_Hilo == 1) PipStep_Hilo = PipStep/3;        // 50/3*1
        if(ord_Hilo == 2) PipStep_Hilo = PipStep/3*2;      // 50/3*2
        if(ord_Hilo >= 3) PipStep_Hilo = PipStep;          // 50/3*3?  用于调整加仓 间隔 频率
    } else PipStep_Hilo = PipStep;

    if(MarioTurbo) {
        PipStep_Hilo = NormalizeDouble((PipStep/MarioTurboFactor)*ord_Hilo,0);
        //Print("HiLoPip: " + DoubleToString(PipStep_Hilo,0));
    }


    //=======================内存管理
    if(MM==true) {
        if(MathCeil(AccountBalance()) < 2000) {       // MM = если депо меньше 2000, то лот = Lots (0.01), иначе- % от депо
            Lots_Hilo = Lots;
        } else {
            Lots_Hilo = 0.00001 * MathCeil(AccountBalance());
        }
    } else {
        Lots_Hilo = Lots;
    }

    //======================移动止损
    if(UseTrailingStop_Hilo) TrailingAlls_Hilo(TrailStart_Hilo, TrailStop_Hilo, AveragePrice_Hilo);
    if(UseTimeOut_Hilo) {
        if(TimeCurrent() >= expiration_Hilo) {
            CloseThisSymbolAll_Hilo();
            Print("Closed All due_Hilo to TimeOut");
        }
    }

    if(timeprev_Hilo == Time[0]) return (0);
    timeprev_Hilo = Time[0];
    double CurrentPairProfit_Hilo = CalculateProfit_Hilo();

    //=======================使用风险百分比
    if(UseEquityStop_Hilo) {
        if(CurrentPairProfit_Hilo < 0.0 && MathAbs(CurrentPairProfit_Hilo) > TotalEquityRisk_Hilo / 100.0 * AccountEquityHigh_Hilo()) {
            CloseThisSymbolAll_Hilo();
            Print("Closed All due_Hilo to Stop Out");
            NewOrdersPlaced_Hilo = FALSE;
        }
    }

    total_Hilo = CountTrades(g_magic_hilo);
    if(total_Hilo == 0) flag_Hilo = FALSE;

    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_hilo) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_hilo) {
            if(OrderType() == OP_BUY) {
                LongTrade_Hilo = TRUE;
                ShortTrade_Hilo = FALSE;
                break;
            }
            if(OrderType() == OP_SELL) {
                LongTrade_Hilo = FALSE;
                ShortTrade_Hilo = TRUE;
                break;
            }
        }
    }

    if(total_Hilo > 0 && total_Hilo < MaxTrades) {
        RefreshRates();
        LastBuyPrice_Hilo = FindLastBuyPrice(g_magic_hilo);
        LastSellPrice_Hilo = FindLastSellPrice(g_magic_hilo);
        if(LongTrade_Hilo && LastBuyPrice_Hilo - Ask >= PipStep_Hilo * Point) TradeNow_Hilo = TRUE;
        if(ShortTrade_Hilo && Bid - LastSellPrice_Hilo >= PipStep_Hilo * Point) TradeNow_Hilo = TRUE;
    }

    if(total_Hilo < 1) {
        ShortTrade_Hilo = FALSE;
        LongTrade_Hilo = FALSE;
        TradeNow_Hilo = TRUE;
        StartEquity_Hilo = AccountEquity();
    }

    if(TradeNow_Hilo) {
        LastBuyPrice_Hilo = FindLastBuyPrice(g_magic_hilo);
        LastSellPrice_Hilo = FindLastSellPrice(g_magic_hilo);
        if(ShortTrade_Hilo) {
            NumOfTrades_Hilo = total_Hilo;
            iLots_Hilo = NormalizeDouble(Lots_Hilo * MathPow(LotExponent_Hilo, NumOfTrades_Hilo), lotdecimal_Hilo);
            RefreshRates();
            ticket_Hilo = OpenPendingOrder_Hilo(1, iLots_Hilo, NormalizeDouble(Bid,Digits), slip_Hilo, NormalizeDouble(Ask,Digits), 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, g_magic_hilo, 0, HotPink);
            if(ticket_Hilo < 0) {
                Print("Error: ", GetLastError());
                return (0);
            }
            LastSellPrice_Hilo = FindLastSellPrice(g_magic_hilo);
            TradeNow_Hilo = FALSE;
            NewOrdersPlaced_Hilo = TRUE;
        } else {
            if(LongTrade_Hilo) {
                NumOfTrades_Hilo = total_Hilo;
                iLots_Hilo = NormalizeDouble(Lots_Hilo * MathPow(LotExponent_Hilo, NumOfTrades_Hilo), lotdecimal_Hilo);
                ticket_Hilo = OpenPendingOrder_Hilo(0, iLots_Hilo, NormalizeDouble(Ask,Digits), slip_Hilo, NormalizeDouble(Bid,Digits), 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, g_magic_hilo, 0, Lime);
                if(ticket_Hilo < 0) {
                    Print("Error: ", GetLastError());
                    return (0);
                }
                LastBuyPrice_Hilo = FindLastBuyPrice(g_magic_hilo);
                TradeNow_Hilo = FALSE;
                NewOrdersPlaced_Hilo = TRUE;
            }
        }
    }

    if(TradeNow_Hilo && total_Hilo < 1) {
        PrevCl_Hilo = iHigh(Symbol(), 0, 1);
        CurrCl_Hilo =  iLow(Symbol(), 0, 2);
        SellLimit_Hilo = NormalizeDouble(Bid,Digits);
        BuyLimit_Hilo = NormalizeDouble(Ask,Digits);
        if(!ShortTrade_Hilo && !LongTrade_Hilo) {
            NumOfTrades_Hilo = total_Hilo;
            iLots_Hilo = NormalizeDouble(Lots_Hilo * MathPow(LotExponent_Hilo, NumOfTrades_Hilo), lotdecimal_Hilo);

            //=============ограничения на работу утром понедельника и вечер пятницы========================//
            //if(
            //    (CloseFriday==true&&DayOfWeek()==5&&TimeCurrent()>=StrToTime(CloseFridayHour+":00"))
            //  ||(OpenMondey ==true&&DayOfWeek()==1&&TimeCurrent()<=StrToTime(OpenMondeyHour +":00"))
            //  ) return(0);
            //=============================================================================================//

            if(NewCycle && NewCycleHiLo) {
                if(PrevCl_Hilo > CurrCl_Hilo) {

                    //HHHHHHHH~~~~~~~~~~~~~ Индюк RSI ~~~~~~~~~~HHHHHHHHH~~~~~~~~~~~~~~~//
                    if(iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) > 30.0) {
                        ticket_Hilo = OpenPendingOrder_Hilo(1, iLots_Hilo, SellLimit_Hilo, slip_Hilo, SellLimit_Hilo, 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, g_magic_hilo, 0, HotPink);
                        if(ticket_Hilo < 0) {
                            Print("Error: ", GetLastError());
                            return (0);
                        }
                        LastBuyPrice_Hilo = FindLastBuyPrice(g_magic_hilo);
                        NewOrdersPlaced_Hilo = TRUE;
                    }
                } else {

                    //HHHHHHHH~~~~~~~~~~~~~ Индюк RSI ~~~~~~~~~HHHHHHHHHH~~~~~~~~~~~~~~~~~
                    if(iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) < 70.0) {
                        ticket_Hilo = OpenPendingOrder_Hilo(0, iLots_Hilo, BuyLimit_Hilo, slip_Hilo, BuyLimit_Hilo, 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, g_magic_hilo, 0, Lime);
                        if(ticket_Hilo < 0) {
                            Print("Error: ", GetLastError());
                            return (0);
                        }
                        LastSellPrice_Hilo = FindLastSellPrice(g_magic_hilo);
                        NewOrdersPlaced_Hilo = TRUE;
                    }
                }
            }
            //=====================================================
            if(ticket_Hilo > 0) expiration_Hilo = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_Hilo);
            TradeNow_Hilo = FALSE;
        }
    }
    total_Hilo = CountTrades(g_magic_hilo);
    AveragePrice_Hilo = 0;
    double Count_Hilo = 0;

    //--------------------   COUNT -----------------------------

    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_hilo) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_hilo) {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL) {
                AveragePrice_Hilo += OrderOpenPrice() * OrderLots();
                Count_Hilo += OrderLots();
            }
        }
    }// end for

    if(total_Hilo > 0) AveragePrice_Hilo = NormalizeDouble(AveragePrice_Hilo / Count_Hilo, Digits);
    if(NewOrdersPlaced_Hilo) {
        for(i = OrdersTotal() - 1; i >= 0; i--) {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_hilo) continue;
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_hilo) {
                if(OrderType() == OP_BUY) {
                    PriceTarget_Hilo = AveragePrice_Hilo + TakeProfit_Hilo * Point;
                    BuyTarget_Hilo = PriceTarget_Hilo;
                    Stopper_Hilo = AveragePrice_Hilo - Stoploss_Hilo * Point;
                    flag_Hilo = TRUE;
                }
                if(OrderType() == OP_SELL) {
                    PriceTarget_Hilo = AveragePrice_Hilo - TakeProfit_Hilo * Point;
                    SellTarget_Hilo = PriceTarget_Hilo;
                    Stopper_Hilo = AveragePrice_Hilo + Stoploss_Hilo * Point;
                    flag_Hilo = TRUE;
                }
            }
        }
    }// end  - if (NewOrdersPlaced_Hilo)

    //----------------------------------------------------------------------------------
    if(NewOrdersPlaced_Hilo) {
        if(flag_Hilo == TRUE) {
            for(i = OrdersTotal() - 1; i >= 0; i--) {
                OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_hilo) continue;
                if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_hilo) // OrderModify(OrderTicket(), AveragePrice_Hilo, OrderStopLoss(), PriceTarget_Hilo, 0, Yellow);
                    int NumberOfTries_Hilo = 10;
                for(int i = 0; i < NumberOfTries_Hilo; i++) {
                    bool res=OrderModify(OrderTicket(), AveragePrice_Hilo, OrderStopLoss(), PriceTarget_Hilo, 0, Yellow);
                    if(res) break;
                    if(!res) {
                        Print("Error in OrderModify HiLo. Error code=",GetLastError());
                        Sleep(500);
                        RefreshRates();
                    }
                }
                NewOrdersPlaced_Hilo = FALSE;
            }
        }
    }// end if (NewOrdersPlaced_Hilo)

    //========================================================================//
    //                       ПРОГРАМНЫЙ КОД Ilan 1.5                          //
    //========================================================================//
    //double l_iclose_8;
    //double l_iclose_16;
    //=======================
    double   LotExponent_15 = LotExponent;
    int      lotdecimal_15 = lotdecimal;
    double   TakeProfit_15 = TakeProfit;
    bool     UseEquityStop_15 = UseEquityStop;
    double   TotalEquityRisk_15 = TotalEquityRisk;// риск в процентах от депозита
    bool     UseTrailingStop_15 = UseTrailingStop;
    double   TrailStart_15 = TrailStart;
    double   TrailStop_15 = TrailStop;
    //double PipStep_15 = PipStep;//30
    double   slip_15 = slip;                      // проскальзывание

    //=================
    int _TimeFrameCloseValue = 0;
    if(TimeFrameCloseValue == 1) _TimeFrameCloseValue =PERIOD_M1;
    if(TimeFrameCloseValue == 2) _TimeFrameCloseValue =PERIOD_M5;
    if(TimeFrameCloseValue == 3) _TimeFrameCloseValue =PERIOD_M15;
    if(TimeFrameCloseValue == 4) _TimeFrameCloseValue =PERIOD_M30;
    if(TimeFrameCloseValue == 5) _TimeFrameCloseValue =PERIOD_H1;
    if(TimeFrameCloseValue == 6) _TimeFrameCloseValue =PERIOD_H4;
    if(TimeFrameCloseValue == 7) _TimeFrameCloseValue =PERIOD_D1;
    if(TimeFrameCloseValue == 8) _TimeFrameCloseValue =PERIOD_W1;
    if(TimeFrameCloseValue == 9) _TimeFrameCloseValue =PERIOD_MN1;
    if(TimeFrameCloseValue == 0) _TimeFrameCloseValue =Period();


    //=========
    ord_15 = CountTrades(g_magic_15);
    if(Turbo) {
        if(ord_15 == 1) PipStep_15 = PipStep/3;
        if(ord_15 == 2) PipStep_15 = PipStep/3*2;
        if(ord_15 >= 3) PipStep_15 = PipStep;
    } else PipStep_15 = PipStep;

    if(MarioTurbo) {
        PipStep_15 = NormalizeDouble(PipStep*ord_15/MarioTurboFactor,0);
    }

    //=======================
    if(MM==true) {
        if(MathCeil(AccountBalance()) < 2000) {
            // MM = если депо меньше 2000, то лот = Lots (0.01), иначе- % от депо
            double Lots_15 = Lots;
        } else {
            Lots_15 = 0.00001 * MathCeil(AccountBalance());
        }
    } else Lots_15 = Lots;


    //=============ограничения на работу утром понедельника и вечер пятницы========================//

    //if(
    //    (CloseFriday==true&&DayOfWeek()==5&&TimeCurrent()>=StrToTime(CloseFridayHour+":00"))
    //  ||(OpenMondey ==true&&DayOfWeek()==1&&TimeCurrent()<=StrToTime(OpenMondeyHour +":00"))
    //  ) return(0);

    //=============================================================================================//

    if(UseTrailingStop_15) TrailingAlls_15(TrailStart_15, TrailStop_15, g_price_212_15);
    if(UseTimeOut_15) {
        if(TimeCurrent() >= gi_284_15) {
            CloseThisSymbolAll_15();
            Print("Closed All due to TimeOut");
        }
    }

    if(gi_280_15 != Time[0]) {
        gi_280_15 = Time[0];
        double ld_0_15 = CalculateProfit_15();
        if(UseEquityStop_15) {
            if(ld_0_15 < 0.0 && MathAbs(ld_0_15) > TotalEquityRisk_15 / 100.0 * AccountEquityHigh_15()) {
                CloseThisSymbolAll_15();
                Print("Closed All due to Stop Out");
                gi_332_15 = FALSE;
            }
        }

        gi_304_15 = CountTrades(g_magic_15);
        if(gi_304_15 == 0) gi_268_15 = FALSE;
        for(i = OrdersTotal() - 1; i >= 0; i--) {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_15) continue;
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
                if(OrderType() == OP_BUY) {
                    gi_320_15 = TRUE;
                    gi_324_15 = FALSE;
                    break;
                }
            }
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
                if(OrderType() == OP_SELL) {
                    gi_320_15 = FALSE;
                    gi_324_15 = TRUE;
                    break;
                }
            }
        }

        if(gi_304_15 > 0 && gi_304_15 < MaxTrades) {
            RefreshRates();
            gd_236_15 = FindLastBuyPrice(g_magic_15);
            gd_244_15 = FindLastSellPrice(g_magic_15);
            if(gi_320_15 && gd_236_15 - Ask >= PipStep_15 * Point) gi_316_15 = TRUE;
            if(gi_324_15 && Bid - gd_244_15 >= PipStep_15 * Point) gi_316_15 = TRUE;
        }

        if(gi_304_15 < 1) {
            gi_324_15 = FALSE;
            gi_320_15 = FALSE;
            gi_316_15 = TRUE;
            gd_188_15 = AccountEquity();
        }

        if(gi_316_15) {
            gd_236_15 = FindLastBuyPrice(g_magic_15);
            gd_244_15 = FindLastSellPrice(g_magic_15);
            if(gi_324_15) {
                gi_288_15 = gi_304_15;
                gd_292_15 = NormalizeDouble(Lots_15 * MathPow(LotExponent_15, gi_288_15), lotdecimal_15);
                RefreshRates();
                gi_328_15 = OpenPendingOrder_15(1, gd_292_15, NormalizeDouble(Bid,Digits), slip_15, NormalizeDouble(Ask,Digits), 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_15, 0, HotPink);
                if(gi_328_15 < 0) {
                    Print("Error: ", GetLastError());
                    return (0);
                }
                gd_244_15 = FindLastSellPrice(g_magic_15);
                gi_316_15 = FALSE;
                gi_332_15 = TRUE;
            } else {
                if(gi_320_15) {
                    gi_288_15 = gi_304_15;
                    gd_292_15 = NormalizeDouble(Lots_15 * MathPow(LotExponent_15, gi_288_15), lotdecimal_15);
                    gi_328_15 = OpenPendingOrder_15(0, gd_292_15, NormalizeDouble(Ask,Digits), slip_15, NormalizeDouble(Bid,Digits), 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_15, 0, Lime);
                    if(gi_328_15 < 0) {
                        Print("Error: ", GetLastError());
                        return (0);
                    }
                    gd_236_15 = FindLastBuyPrice(g_magic_15);
                    gi_316_15 = FALSE;
                    gi_332_15 = TRUE;
                }
            }
        }
    }
    if(time_15!=iTime(NULL,OpenNewTF_15,0)) {
        int totals_15=OrdersTotal();
        int orders_15=0;
        for(int total_15=totals_15; total_15>=1; total_15--) {
            OrderSelect(total_15-1,SELECT_BY_POS,MODE_TRADES);
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_15) continue;
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
                orders_15++;
            }
        }// for
        if(totals_15==0 || orders_15 < 1) {
            l_iclose_8 = iClose(Symbol(), _TimeFrameCloseValue, 2);
            l_iclose_16 = iClose(Symbol(), _TimeFrameCloseValue, 1);
            g_bid_220_15 = NormalizeDouble(Bid,Digits);
            g_ask_228_15 = NormalizeDouble(Ask,Digits);
            if(!gi_324_15 && !gi_320_15) {
                gi_288_15 = gi_304_15;
                gd_292_15 = NormalizeDouble(Lots_15 * MathPow(LotExponent, gi_288_15), lotdecimal_15);
                if(l_iclose_8 > l_iclose_16) {
                    if(NewCycle && NewCycle15) {
                        gi_328_15 = OpenPendingOrder_15(1, gd_292_15, g_bid_220_15, slip_15, g_bid_220_15, 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_15, 0, HotPink);
                        if(gi_328_15 < 0) {
                            Print("Error: ", GetLastError());
                            return (0);
                        }// if
                        gd_236_15 = FindLastBuyPrice(g_magic_15);
                        gi_332_15 = TRUE;
                    }// if newcycle
                }
            }// if (!gi_324_15 && !gi_320_15)
            else {
                if(NewCycle && NewCycle15) {
                    gi_328_15 = OpenPendingOrder_15(0, gd_292_15, g_ask_228_15, slip_15, g_ask_228_15, 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_15, 0, Lime);
                    if(gi_328_15 < 0) {
                        Print("Error: ", GetLastError());
                        return (0);
                    }
                    gd_244_15 = FindLastSellPrice(g_magic_15);
                    gi_332_15 = TRUE;
                }//end  if newcycle
            }// end  else if
            if(gi_328_15 > 0) gi_284_15 = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_15);
            gi_316_15 = FALSE;

        }// end - if (totals_15==0 || orders_15 < 1) {
        time_15=iTime(NULL,OpenNewTF_15,0);
    }// end  ---  if(time_15!=iTime(NULL,OpenNewTF_15,0)){


    gi_304_15 = CountTrades(g_magic_15);
    g_price_212_15 = 0;
    double ld_24_15 = 0;

    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_15) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL) {
                g_price_212_15 += OrderOpenPrice() * OrderLots();
                ld_24_15 += OrderLots();
            }
        }
    }// end  for

    if(gi_304_15 > 0) g_price_212_15 = NormalizeDouble(g_price_212_15 / ld_24_15, Digits);
    if(gi_332_15) {
        for(i = OrdersTotal() - 1; i >= 0; i--) {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_15) continue;
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
                if(OrderType() == OP_BUY) {
                    g_price_180_15 = g_price_212_15 + TakeProfit_15 * Point;
                    gd_unused_196_15 = g_price_180_15;
                    gd_308_15 = g_price_212_15 - Stoploss_15 * Point;
                    gi_268_15 = TRUE;
                }
            } // end  -- if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
                if(OrderType() == OP_SELL) {
                    g_price_180_15 = g_price_212_15 - TakeProfit_15 * Point;
                    gd_unused_204_15 = g_price_180_15;
                    gd_308_15 = g_price_212_15 + Stoploss_15 * Point;
                    gi_268_15 = TRUE;
                }
            }
        }// end  - for
    }// end  - if (gi_332_15)
    if(gi_332_15) {
        if(gi_268_15 == TRUE) {
            for(i = OrdersTotal() - 1; i >= 0; i--) {
                OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_15) continue;
                if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15)
                    //OrderModify(OrderTicket(), g_price_212_15, OrderStopLoss(), g_price_180_15, 0, Yellow);
                    //===
                    int NumberOfTries_15 = 10;
                for(int _i = 0; _i < NumberOfTries_15; _i++) {
                    bool res_15 = OrderModify(OrderTicket(), g_price_212_15, OrderStopLoss(), g_price_180_15, 0, Yellow);
                    if(res_15) break;
                    if(!res_15) {
                        Print("Error in OrderModify 1.5. Error code=",GetLastError());
                        {
                            Sleep(500);
                            RefreshRates();
                        }
                    }
                }
                //===
                gi_332_15 = FALSE;
            }
        }
    }// end - if (gi_332_15)
    //========================================================================//
    //                       ПРОГРАМНЫЙ КОД Ilan 1.6                          //
    //========================================================================//
    //   double l_iclose_8;
    //   double l_iclose_16;
    //=======================
    double   LotExponent_16 = LotExponent;
    int      lotdecimal_16 = lotdecimal;
    double   TakeProfit_16 = TakeProfit;
    bool     UseEquityStop_16 = UseEquityStop;
    double   TotalEquityRisk_16 = TotalEquityRisk;// риск в процентах от депозита
    bool     UseTrailingStop_16 = UseTrailingStop;
    double   TrailStart_16 = TrailStart;
    double   TrailStop_16 = TrailStop;
    //double PipStep_16 = PipStep;//30
    double   slip_16 = slip;                      // проскальзывание

    //=========
    ord_16 = CountTrades(g_magic_16);
    if(Turbo) {
        if(ord_16 == 1) PipStep_16 = PipStep/3;
        if(ord_16 == 2) PipStep_16 = PipStep/3*2;
        if(ord_16 >= 3) PipStep_16 = PipStep;
    } else PipStep_16 = PipStep;

    if(MarioTurbo) {
        PipStep_16 = NormalizeDouble(PipStep*ord_16/MarioTurboFactor,0);
    }

    //=========

    //=======================
    // манименеджмент      //
    //=======================
    if(MM==true) {
        if(MathCeil(AccountBalance()) < 2000) {    // MM = если депо меньше 2000, то лот = Lots (0.01), иначе- % от депо
            double Lots_16 = Lots;
        } else {
            Lots_16 = 0.00001 * MathCeil(AccountBalance());
        }
    } else Lots_16 = Lots;

    //=============ограничения на работу утром понедельника и вечер пятницы========================//
    //if(
    //    (CloseFriday==true&&DayOfWeek()==5&&TimeCurrent()>=StrToTime(CloseFridayHour+":00"))
    //  ||(OpenMondey ==true&&DayOfWeek()==1&&TimeCurrent()<=StrToTime(OpenMondeyHour+ ":00"))
    //  ) return(0);

    //=============================================================================================//

    if(UseTrailingStop_16) TrailingAlls_16(TrailStart_16, TrailStop_16, g_price_212_16);
    if(UseTimeOut_16) {
        if(TimeCurrent() >= gi_284_16) {
            CloseThisSymbolAll_16();
            Print("Closed All due to TimeOut");
        }
    }
    if(gi_280_16 != Time[0]) {
        gi_280_16 = Time[0];
        double ld_0_16 = CalculateProfit_16();
        if(UseEquityStop_16) {
            if(ld_0_16 < 0.0 && MathAbs(ld_0_16) > TotalEquityRisk_16 / 100.0 * AccountEquityHigh_16()) {
                CloseThisSymbolAll_16();
                Print("Closed All due to Stop Out");
                gi_332_16 = FALSE;
            }
        }
        gi_304_16 = CountTrades(g_magic_16);

        Print("这里会执行吗这里会执行吗这里会执行吗?");

        if(gi_304_16 == 0) gi_268_16 = FALSE;

        for(i = OrdersTotal() - 1; i >= 0; i--) {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_16) continue;
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16) {
                if(OrderType() == OP_BUY) {
                    gi_320_16 = TRUE;
                    gi_324_16 = FALSE;
                    break;
                }
            }
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16) {
                if(OrderType() == OP_SELL) {
                    gi_320_16 = FALSE;
                    gi_324_16 = TRUE;
                    break;
                }
            }
        }// end  - for

        if(gi_304_16 > 0 && gi_304_16 < MaxTrades) {
            RefreshRates();
            gd_236_16 = FindLastBuyPrice(g_magic_16);
            gd_244_16 = FindLastSellPrice(g_magic_16);
            if(gi_320_16 && gd_236_16 - Ask >= PipStep_16 * Point) gi_316_16 = TRUE;
            if(gi_324_16 && Bid - gd_244_16 >= PipStep_16 * Point) gi_316_16 = TRUE;
        }

        if(gi_304_16 < 1) {
            gi_324_16 = FALSE;
            gi_320_16 = FALSE;
            gi_316_16 = TRUE;
            gd_188_16 = AccountEquity();
        }

        if(gi_316_16) {
            gd_236_16 = FindLastBuyPrice(g_magic_16);
            gd_244_16 = FindLastSellPrice(g_magic_16);
            if(gi_324_16) {
                gi_288_16 = gi_304_16;
                gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
                RefreshRates();
                gi_328_16 = OpenPendingOrder_16(1, gd_292_16, NormalizeDouble(Bid,Digits), slip_16, NormalizeDouble(Ask,Digits), 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_16, 0, HotPink);
                if(gi_328_16 < 0) {
                    Print("Error: ", GetLastError());
                    return (0);
                }
                gd_244_16 = FindLastSellPrice(g_magic_16);
                gi_316_16 = FALSE;
                gi_332_16 = TRUE;
            } else {
                if(gi_320_16) {
                    gi_288_16 = gi_304_16;
                    gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
                    gi_328_16 = OpenPendingOrder_16(0, gd_292_16, NormalizeDouble(Ask,Digits), slip_16, NormalizeDouble(Bid,Digits), 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_16, 0, Lime);
                    if(gi_328_16 < 0) {
                        Print("Error: ", GetLastError());
                        return (0);
                    }
                    gd_236_16 = FindLastBuyPrice(g_magic_16);
                    gi_316_16 = FALSE;
                    gi_332_16 = TRUE;
                }
            }// end else
        }//
    }// end -- if (gi_316_16) {

    if(time_16!=iTime(NULL,OpenNewTF_16,0)) {
        int totals_16=OrdersTotal();
        int orders_16=0;
        for(int total_16=totals_16; total_16>=1; total_16--) {
            OrderSelect(total_16-1,SELECT_BY_POS,MODE_TRADES);
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_16) continue;
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16) {
                orders_16++;
            }
        }// end - for
        if(totals_16==0 || orders_16 < 1) {
            l_iclose_8/*_16*/ = iClose(Symbol(), 0, 2);
            l_iclose_16/*_16*/ = iClose(Symbol(), 0, 1);
            g_bid_220_16 = NormalizeDouble(Bid,Digits);
            g_ask_228_16 = NormalizeDouble(Ask,Digits);
            if(!gi_324_16 && !gi_320_16) {
                gi_288_16 = gi_304_16;
                gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
                if(NewCycle && NewCycle16) {
                    if(l_iclose_8/*_16*/ > l_iclose_16/*_16*/) {
                        if(iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) > 30.0) {
                            gi_328_16 = OpenPendingOrder_16(1, gd_292_16, g_bid_220_16, slip_16, g_bid_220_16, 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_16, 0, HotPink);
                            if(gi_328_16 < 0) {
                                Print("Error: ", GetLastError());
                                return (0);
                            }
                            gd_236_16 = FindLastBuyPrice(g_magic_16);
                            gi_332_16 = TRUE;
                        }// end
                    } // end  -- if (!gi_324_16 && !gi_320_16) {
                    else {
                        if(iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) < 70.0) {
                            gi_328_16 = OpenPendingOrder_16(0, gd_292_16, g_ask_228_16, slip_16, g_ask_228_16, 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_16, 0, Lime);
                            if(gi_328_16 < 0) {
                                Print("Error: ", GetLastError());
                                return (0);
                            }
                            gd_244_16 = FindLastSellPrice(g_magic_16);
                            gi_332_16 = TRUE;
                        }
                    }// end - else
                }//end - if (totals_16==0 || orders_16 < 1) {
                if(gi_328_16 > 0) gi_284_16 = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_16);
                gi_316_16 = FALSE;
            }
        }
        time_16=iTime(NULL,OpenNewTF_16,0);
    }//  end  if(time_16!=iTime(NULL,OpenNewTF_16,0)){

    gi_304_16 = CountTrades(g_magic_16);
    g_price_212_16 = 0;
    double ld_24_16 = 0;
    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_16) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16) {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL) {
                g_price_212_16 += OrderOpenPrice() * OrderLots();
                ld_24_16 += OrderLots();
            }
        }
    }// end  -  for

    if(gi_304_16 > 0) g_price_212_16 = NormalizeDouble(g_price_212_16 / ld_24_16, Digits);

    if(gi_332_16) {
        for(i = OrdersTotal() - 1; i >= 0; i--) {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_16) continue;
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16) {
                if(OrderType() == OP_BUY) {
                    g_price_180_16 = g_price_212_16 + TakeProfit_16 * Point;
                    gd_unused_196_16 = g_price_180_16;
                    gd_308_16 = g_price_212_16 - Stoploss_16 * Point;
                    gi_268_16 = TRUE;
                }
            }
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16) {
                if(OrderType() == OP_SELL) {
                    g_price_180_16 = g_price_212_16 - TakeProfit_16 * Point;
                    gd_unused_204_16 = g_price_180_16;
                    gd_308_16 = g_price_212_16 + Stoploss_16 * Point;
                    gi_268_16 = TRUE;
                }
            }
        }
    }// end  - if (gi_332_16) {

    if(gi_332_16) {
        if(gi_268_16 == TRUE) {
            for(i = OrdersTotal() - 1; i >= 0; i--) {
                OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
                if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_16) continue;
                if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16)
                    //OrderModify(OrderTicket(), g_price_212_16, OrderStopLoss(), g_price_180_16, 0, Yellow);
                    //===
                    int NumberOfTries_16 = 10;
                for(int __i = 0; __i < NumberOfTries_16; __i++) {
                    bool res_16 = OrderModify(OrderTicket(), g_price_212_16, OrderStopLoss(), g_price_180_16, 0, Yellow);
                    if(res_16) break;
                    if(!res_16) {
                        Print("Error in OrderModify 1.6. Error code=",GetLastError());
                        {
                            Sleep(500);
                            RefreshRates();
                        }
                    }
                }

                //===
                gi_332_16 = FALSE;
            }// end  - for
        }// end  -- if
    }// end - if (gi_332_16) {
//    }
//    }

//=============================  END OF START FUNCTION
//=============================
    end=GetTickCount();
    if(end-begin>0) {
        current = (end-begin);

        if(max<current) {
            max = (end-begin);
        }
    }

    //------------------------ Check Loop speed

    return (0);
}

//============================= 计算下单数量
int CountTrades(int magic_number)
{
    int count = 0;
    int i = 0;
    Print("tttttttttttttttttttttt: ",OrdersTotal());
    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        Print("OrderSymbol,Symbol:    ",OrderSymbol(),"   ",Symbol(),"  OrderMagicNumber:   ",OrderMagicNumber());
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic_number) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic_number) {
            if(OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
        }
    }
    return (count);
}

//=============================

void CloseThisSymbolAll_Hilo()
{
    for(int trade_Hilo = OrdersTotal() - 1; trade_Hilo >= 0; trade_Hilo--) {
        OrderSelect(trade_Hilo, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() == Symbol()) {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_hilo) {
                if(OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, slip_Hilo, Blue);
                if(OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, slip_Hilo, Red);
            }
            Sleep(1000);
        }
    }
}

//=============================
int OpenPendingOrder_Hilo(int pType_Hilo, double pLots_Hilo, double pPrice_Hilo, int pSlippage_Hilo, double pr_Hilo, int sl_Hilo, int tp_Hilo, string pComment_Hilo, int pMagic_Hilo, int pDatetime_Hilo, color pColor_Hilo)
{
    int ticket_Hilo = 0;
    int err_Hilo = 0;
    int c_Hilo = 0;
    int NumberOfTries_Hilo = 100;
    switch(pType_Hilo) {
    case 0:
        for(c_Hilo = 0; c_Hilo < NumberOfTries_Hilo; c_Hilo++) {
            RefreshRates();
            ticket_Hilo = OrderSend(Symbol(), OP_BUY, pLots_Hilo, NormalizeDouble(Ask,Digits), pSlippage_Hilo, NormalizeDouble(StopLong_Hilo(Bid, sl_Hilo),Digits), NormalizeDouble(TakeLong_Hilo(Ask, tp_Hilo),Digits), pComment_Hilo, pMagic_Hilo, pDatetime_Hilo, pColor_Hilo);
            err_Hilo = GetLastError();
            if(err_Hilo == 0/* NO_ERROR */) break;
            if(!(err_Hilo == 4/* SERVER_BUSY */ || err_Hilo == 137/* BROKER_BUSY */ || err_Hilo == 146/* TRADE_CONTEXT_BUSY */ || err_Hilo == 136/* OFF_QUOTES */)) break;
            Sleep(5000);
        }
        break;
    case 1:
        for(c_Hilo = 0; c_Hilo < NumberOfTries_Hilo; c_Hilo++) {
            ticket_Hilo = OrderSend(Symbol(), OP_SELL, pLots_Hilo, NormalizeDouble(Bid,Digits), pSlippage_Hilo, NormalizeDouble(StopShort_Hilo(Ask, sl_Hilo),Digits), NormalizeDouble(TakeShort_Hilo(Bid, tp_Hilo),Digits), pComment_Hilo, pMagic_Hilo, pDatetime_Hilo, pColor_Hilo);
            err_Hilo = GetLastError();
            if(err_Hilo == 0/* NO_ERROR */) break;
            if(!(err_Hilo == 4/* SERVER_BUSY */ || err_Hilo == 137/* BROKER_BUSY */ || err_Hilo == 146/* TRADE_CONTEXT_BUSY */ || err_Hilo == 136/* OFF_QUOTES */)) break;
            Sleep(5000);
        }
    }
    return (ticket_Hilo);
}

//=============================
double StopLong_Hilo(double price_Hilo, int stop_Hilo)
{
    if(stop_Hilo == 0) return (0);
    else return (price_Hilo - stop_Hilo * Point);
}
//=============================
double StopShort_Hilo(double price_Hilo, int stop_Hilo)
{
    if(stop_Hilo == 0) return (0);
    else return (price_Hilo + stop_Hilo * Point);
}
//=============================
double TakeLong_Hilo(double price_Hilo, int stop_Hilo)
{
    if(stop_Hilo == 0) return (0);
    else return (price_Hilo + stop_Hilo * Point);
}
//=============================
double TakeShort_Hilo(double price_Hilo, int stop_Hilo)
{
    if(stop_Hilo == 0) return (0);
    else return (price_Hilo - stop_Hilo * Point);
}

//=============================
double CalculateProfit_Hilo()
{
    int i=0;
    double dProfit = 0;
    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_hilo) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_hilo)
            if(OrderType() == OP_BUY || OrderType() == OP_SELL) dProfit += OrderProfit();
    }
    return (dProfit);
}

//=============================

void TrailingAlls_Hilo(int pType_Hilo, int stop_Hilo, double AvgPrice_Hilo)
{
    int profit_Hilo;
    double stoptrade_Hilo;
    double stopcal_Hilo;
    if(stop_Hilo != 0) {
        for(int trade_Hilo = OrdersTotal() - 1; trade_Hilo >= 0; trade_Hilo--) {
            if(OrderSelect(trade_Hilo, SELECT_BY_POS, MODE_TRADES)) {
                if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_hilo) continue;
                if(OrderSymbol() == Symbol() || OrderMagicNumber() == g_magic_hilo) {
                    if(OrderType() == OP_BUY) {
                        profit_Hilo = NormalizeDouble((Bid - AvgPrice_Hilo) / Point, 0);
                        if(profit_Hilo < pType_Hilo) continue;
                        stoptrade_Hilo = OrderStopLoss();
                        stopcal_Hilo = Bid - stop_Hilo * Point;
                        if(stoptrade_Hilo == 0.0 || (stoptrade_Hilo != 0.0 && stopcal_Hilo > stoptrade_Hilo)) OrderModify(OrderTicket(), AvgPrice_Hilo, stopcal_Hilo, OrderTakeProfit(), 0, Aqua);
                    }
                    if(OrderType() == OP_SELL) {
                        profit_Hilo = NormalizeDouble((AvgPrice_Hilo - Ask) / Point, 0);
                        if(profit_Hilo < pType_Hilo) continue;
                        stoptrade_Hilo = OrderStopLoss();
                        stopcal_Hilo = Ask + stop_Hilo * Point;
                        if(stoptrade_Hilo == 0.0 || (stoptrade_Hilo != 0.0 && stopcal_Hilo < stoptrade_Hilo)) OrderModify(OrderTicket(), AvgPrice_Hilo, stopcal_Hilo, OrderTakeProfit(), 0, Red);
                    }
                }
                Sleep(1000);
            }
        }
    }
} //end of TrailingAlls_Hilo()

//=============================
double AccountEquityHigh_Hilo()
{
    if(CountTrades(g_magic_hilo) == 0) AccountEquityHighAmt_Hilo = AccountEquity();
    if(AccountEquityHighAmt_Hilo < PrevEquity_Hilo) AccountEquityHighAmt_Hilo = PrevEquity_Hilo;
    else AccountEquityHighAmt_Hilo = AccountEquity();
    PrevEquity_Hilo = AccountEquity();
    return (AccountEquityHighAmt_Hilo);
}

//=============================
double FindLastBuyPrice(int i_magic_number)
{
    double   old_order_open_price;
    int      old_ticket_number;
    double   tmp_price = 0;
    int      ticket_number = 0;
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != i_magic_number) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == i_magic_number && OrderType() == OP_BUY) {
            old_ticket_number = OrderTicket();
            if(old_ticket_number > ticket_number) {
                old_order_open_price = OrderOpenPrice();
                tmp_price = old_order_open_price;
                ticket_number = old_ticket_number;
            }
        }
    }
    return (old_order_open_price);
}

//=============================
double FindLastSellPrice(int i_magic_number)
{
    double   old_order_open_price;
    int      old_ticket_number;
    double   tmp_price = 0;
    int      ticket_number = 0;
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != i_magic_number) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == i_magic_number && OrderType() == OP_SELL) {
            old_ticket_number = OrderTicket();
            if(old_ticket_number > ticket_number) {
                old_order_open_price = OrderOpenPrice();
                tmp_price = old_order_open_price;
                ticket_number = old_ticket_number;
            }
        }
    }
    return (old_order_open_price);
}

//==========================================================================
//                   пользовательские ф-ции 1.5_1.6                       //
//==========================================================================



void CloseThisSymbolAll_15()
{
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() == Symbol()) {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15) {
                if(OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, slip_15, Blue);
                if(OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, slip_15, Red);
            }
            Sleep(1000);
        }
    }
}

int OpenPendingOrder_15(int ai_0_15, double a_lots_4_15, double a_price_12_15, int a_slippage_20_15, double ad_24_15, int ai_32_15, int ai_36_15, string a_comment_40_15, int a_magic_48_15, int a_datetime_52_15, color a_color_56_15)
{
    int l_ticket_60_15 = 0;
    int l_error_64_15 = 0;
    int i = 0;
    int li_72_15 = 100;
    switch(ai_0_15) {
    case 0:
        for(i = 0; i < li_72_15; i++) {
            RefreshRates();
            l_ticket_60_15 = OrderSend(Symbol(), OP_BUY, a_lots_4_15, NormalizeDouble(Ask,Digits), a_slippage_20_15, NormalizeDouble(StopLong_Hilo(Bid, ai_32_15),Digits), NormalizeDouble(TakeLong_Hilo(Ask, ai_36_15),Digits), a_comment_40_15, a_magic_48_15, a_datetime_52_15, a_color_56_15);
            l_error_64_15 = GetLastError();
            if(l_error_64_15 == 0/* NO_ERROR */) break;
            if(!(l_error_64_15 == 4/* SERVER_BUSY */ || l_error_64_15 == 137/* BROKER_BUSY */ || l_error_64_15 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_15 == 136/* OFF_QUOTES */)) break;
            Sleep(5000);
        }
        break;
    case 1:
        for(i = 0; i < li_72_15; i++) {
            l_ticket_60_15 = OrderSend(Symbol(), OP_SELL, a_lots_4_15, NormalizeDouble(Bid,Digits), a_slippage_20_15, NormalizeDouble(StopShort_Hilo(Ask, ai_32_15),Digits), NormalizeDouble(TakeShort_Hilo(Bid, ai_36_15),Digits), a_comment_40_15, a_magic_48_15, a_datetime_52_15, a_color_56_15);
            l_error_64_15 = GetLastError();
            if(l_error_64_15 == 0/* NO_ERROR */) break;
            if(!(l_error_64_15 == 4/* SERVER_BUSY */ || l_error_64_15 == 137/* BROKER_BUSY */ || l_error_64_15 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_15 == 136/* OFF_QUOTES */)) break;
            Sleep(5000);
        }
    }
    return (l_ticket_60_15);
}


double CalculateProfit_15()
{
    double ld_ret_0_15 = 0;
    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_15) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_15)
            if(OrderType() == OP_BUY || OrderType() == OP_SELL) ld_ret_0_15 += OrderProfit();
    }
    return (ld_ret_0_15);
}

void TrailingAlls_15(int ai_0_15, int ai_4_15, double a_price_8_15)
{
    int l_ticket_16_15;
    double l_ord_stoploss_20_15;
    double l_price_28_15;
    if(ai_4_15 != 0) {
        for(int l_pos_36_15 = OrdersTotal() - 1; l_pos_36_15 >= 0; l_pos_36_15--) {
            if(OrderSelect(l_pos_36_15, SELECT_BY_POS, MODE_TRADES)) {
                if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_15) continue;
                if(OrderSymbol() == Symbol() || OrderMagicNumber() == g_magic_15) {
                    if(OrderType() == OP_BUY) {
                        l_ticket_16_15 = NormalizeDouble((Bid - a_price_8_15) / Point, 0);
                        if(l_ticket_16_15 < ai_0_15) continue;
                        l_ord_stoploss_20_15 = OrderStopLoss();
                        l_price_28_15 = Bid - ai_4_15 * Point;
                        if(l_ord_stoploss_20_15 == 0.0 || (l_ord_stoploss_20_15 != 0.0 && l_price_28_15 > l_ord_stoploss_20_15)) OrderModify(OrderTicket(), a_price_8_15, l_price_28_15, OrderTakeProfit(), 0, Aqua);
                    }
                    if(OrderType() == OP_SELL) {
                        l_ticket_16_15 = NormalizeDouble((a_price_8_15 - Ask) / Point, 0);
                        if(l_ticket_16_15 < ai_0_15) continue;
                        l_ord_stoploss_20_15 = OrderStopLoss();
                        l_price_28_15 = Ask + ai_4_15 * Point;
                        if(l_ord_stoploss_20_15 == 0.0 || (l_ord_stoploss_20_15 != 0.0 && l_price_28_15 < l_ord_stoploss_20_15)) OrderModify(OrderTicket(), a_price_8_15, l_price_28_15, OrderTakeProfit(), 0, Red);
                    }
                }
                Sleep(1000);
            }
        }
    }
}

double AccountEquityHigh_15()
{
    if(CountTrades(g_magic_15) == 0) gd_336_15 = AccountEquity();
    if(gd_336_15 < gd_344_15) gd_336_15 = gd_344_15;
    else gd_336_15 = AccountEquity();
    gd_344_15 = AccountEquity();
    return (gd_336_15);
}




void CloseThisSymbolAll_16()
{
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() == Symbol()) {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16) {
                if(OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, slip_16, Blue);
                if(OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, slip_16, Red);
            }
            Sleep(1000);
        }
    }
}

int OpenPendingOrder_16(int ai_0_16, double a_lots_4_16, double a_price_12_16, int a_slippage_20_16, double ad_24_16, int ai_32_16, int ai_36_16, string a_comment_40_16, int a_magic_48_16, int a_datetime_52_16, color a_color_56_16)
{
    int l_ticket_60_16 = 0;
    int l_error_64_16 = 0;
    int l_count_68_16 = 0;
    int li_72_16 = 100;
    switch(ai_0_16) {
    case 0:
        for(l_count_68_16 = 0; l_count_68_16 < li_72_16; l_count_68_16++) {
            RefreshRates();
            l_ticket_60_16 = OrderSend(Symbol(), OP_BUY, a_lots_4_16, NormalizeDouble(Ask,Digits), a_slippage_20_16, NormalizeDouble(StopLong_Hilo(Bid, ai_32_16),Digits), NormalizeDouble(TakeLong_Hilo(Ask, ai_36_16),Digits), a_comment_40_16, a_magic_48_16, a_datetime_52_16, a_color_56_16);
            l_error_64_16 = GetLastError();
            if(l_error_64_16 == 0/* NO_ERROR */) break;
            if(!(l_error_64_16 == 4/* SERVER_BUSY */ || l_error_64_16 == 137/* BROKER_BUSY */ || l_error_64_16 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_16 == 136/* OFF_QUOTES */)) break;
            Sleep(5000);
        }
        break;
    case 1:
        for(l_count_68_16 = 0; l_count_68_16 < li_72_16; l_count_68_16++) {
            l_ticket_60_16 = OrderSend(Symbol(), OP_SELL, a_lots_4_16, NormalizeDouble(Bid,Digits), a_slippage_20_16, NormalizeDouble(StopShort_Hilo(Ask, ai_32_16),Digits), NormalizeDouble(TakeShort_Hilo(Bid, ai_36_16),Digits), a_comment_40_16, a_magic_48_16, a_datetime_52_16, a_color_56_16);
            l_error_64_16 = GetLastError();
            if(l_error_64_16 == 0/* NO_ERROR */) break;
            if(!(l_error_64_16 == 4/* SERVER_BUSY */ || l_error_64_16 == 137/* BROKER_BUSY */ || l_error_64_16 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_16 == 136/* OFF_QUOTES */)) break;
            Sleep(5000);
        }
    }
    return (l_ticket_60_16);
}



double CalculateProfit_16()
{
    double ld_ret_0_16 = 0;
    for(i = OrdersTotal() - 1; i >= 0; i--) {
        OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
        if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_16) continue;
        if(OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_16)
            if(OrderType() == OP_BUY || OrderType() == OP_SELL) ld_ret_0_16 += OrderProfit();
    }
    return (ld_ret_0_16);
}

void TrailingAlls_16(int ai_0_16, int ai_4_16, double a_price_8_16)
{
    int l_ticket_16_16;
    double l_ord_stoploss_20_16;
    double l_price_28_16;
    if(ai_4_16 != 0) {
        for(int l_pos_36 = OrdersTotal() - 1; l_pos_36 >= 0; l_pos_36--) {
            if(OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES)) {
                if(OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_16) continue;
                if(OrderSymbol() == Symbol() || OrderMagicNumber() == g_magic_16) {
                    if(OrderType() == OP_BUY) {
                        l_ticket_16_16 = NormalizeDouble((Bid - a_price_8_16) / Point, 0);
                        if(l_ticket_16_16 < ai_0_16) continue;
                        l_ord_stoploss_20_16 = OrderStopLoss();
                        l_price_28_16 = Bid - ai_4_16 * Point;
                        if(l_ord_stoploss_20_16 == 0.0 || (l_ord_stoploss_20_16 != 0.0 && l_price_28_16 > l_ord_stoploss_20_16)) OrderModify(OrderTicket(), a_price_8_16, l_price_28_16, OrderTakeProfit(), 0, Aqua);
                    }
                    if(OrderType() == OP_SELL) {
                        l_ticket_16_16 = NormalizeDouble((a_price_8_16 - Ask) / Point, 0);
                        if(l_ticket_16_16 < ai_0_16) continue;
                        l_ord_stoploss_20_16 = OrderStopLoss();
                        l_price_28_16 = Ask + ai_4_16 * Point;
                        if(l_ord_stoploss_20_16 == 0.0 || (l_ord_stoploss_20_16 != 0.0 && l_price_28_16 < l_ord_stoploss_20_16)) OrderModify(OrderTicket(), a_price_8_16, l_price_28_16, OrderTakeProfit(), 0, Red);
                    }
                }
                Sleep(1000);
            }
        }
    }
}

double CountTotalLots()
{
    double d_countlot = 0;
    for(int l_pos_4_15 = OrdersTotal() - 1; l_pos_4_15 >= 0; l_pos_4_15--) {
        OrderSelect(l_pos_4_15, SELECT_BY_POS, MODE_TRADES);
        if(OrderType() == OP_SELL || OrderType() == OP_BUY) d_countlot+=OrderLots();
    }
    return (d_countlot);
}

double AccountEquityHigh_16()
{
    if(CountTrades(g_magic_16) == 0) gd_336_16 = AccountEquity();
    if(gd_336_16 < gd_344_16) gd_336_16 = gd_344_16;
    else gd_336_16 = AccountEquity();
    gd_344_16 = AccountEquity();
    return (gd_336_16);
}


//----------------------------------  END oF ilan 1.6
