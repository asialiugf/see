#property copyright "2007"
#property link "http://www.billionmeter.com"
#property indicator_chart_window

//+------------------------------------------------------------------+

int abadi()
{
ObjectsDeleteAll(0,OBJ_LABEL);
ObjectCreate("expired",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("expired",OBJPROP_XDISTANCE,3);
ObjectSet("expired",OBJPROP_YDISTANCE,20);
ObjectSetText("expired","'需要更新到新版本.....! '",12,"Arial",Yellow);
ObjectSet("expired",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectDelete("valueprice");
ObjectCreate("web",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("web",OBJPROP_XDISTANCE,6);
ObjectSet("web",OBJPROP_YDISTANCE,1);
ObjectSet("web",OBJPROP_CORNER,3);
ObjectSetText("web","http://www.billionmeter.com",12,"Arial Narrow",Teal);
ObjectSet("web",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("running",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("running",OBJPROP_XDISTANCE,300);
ObjectSet("running",OBJPROP_YDISTANCE,240);
ObjectSet("running",OBJPROP_TIMEFRAMES,507);
ObjectSetText("running","只能运行在M15时间段 !!",20,"Arial Narrow",Red);
}

//+------------------------------------------------------------------+

int start()
{
double var_start_0;
double var_start_8;
double var_start_16;
double var_start_24;
double var_start_32;
double var_start_40;
double var_start_48;
double var_start_56;
int var_start_64;
int var_start_68;
int var_start_72;
int var_start_76;
int var_start_80;
int var_start_84;
int var_start_88;
int var_start_92;
double var_start_96;
double var_start_104;
double var_start_112;
double var_start_120;
double var_start_128;
double var_start_136;
double var_start_144;
double var_start_152;
double var_start_160;
int var_start_168;
int var_start_172;
double var_start_176;
double var_start_184;
double var_start_192;
double var_start_200;
double var_start_208;
double var_start_216;
double var_start_224;
double var_start_232;
double var_start_240;
double var_start_248;
double var_start_256;
double var_start_264;
double var_start_272;
double var_start_280;
double var_start_288;
double var_start_296;
double var_start_304;
double var_start_312;
double var_start_320;
double var_start_328;
double var_start_336;
double var_start_344;
double var_start_352;
double var_start_360;
double var_start_368;
double var_start_376;
double var_start_384;
double var_start_392;
double var_start_400;
double var_start_408;
double var_start_416;
double var_start_424;
int var_start_432;
int var_start_436;
int var_start_440;
int var_start_444;
int var_start_448;
int var_start_452;
double var_start_456;
double var_start_464;
double var_start_472;
double var_start_480;
double var_start_488;
double var_start_496;
double var_start_504;
double var_start_512;
double var_start_520;
double var_start_528;
double var_start_536;
double var_start_544;
double var_start_552;
double var_start_560;
int var_start_568;
int var_start_572;
int var_start_576;
int var_start_580;
int var_start_584;
int var_start_588;
double var_start_592;
double var_start_600;
double var_start_608;
double var_start_616;
double var_start_624;
double var_start_632;
double var_start_640;
double var_start_648;
double var_start_656;
double var_start_664;
double var_start_672;
double var_start_680;
double var_start_688;
double var_start_696;
double var_start_704;
double var_start_712;
double var_start_720;
double var_start_728;
double var_start_736;
double var_start_744;
double var_start_752;
double var_start_760;
double var_start_768;
double var_start_776;
double var_start_784;
double var_start_792;
double var_start_800;
double var_start_808;
double var_start_816;
double var_start_824;
double var_start_832;
double var_start_840;
double var_start_848;
double var_start_856;
double var_start_864;
double var_start_872;
double var_start_880;
double var_start_888;
double var_start_896;
double var_start_904;
double var_start_912;
double var_start_920;
double var_start_928;
double year;
double month;
double day;
double month2;

var_start_0 = 0;
var_start_8 = 0;
var_start_16 = 0;
var_start_176 = 10000;
var_start_184 = 100;
var_start_24 = iOpen("GBPUSD",PERIOD_D1,1);
var_start_40 = iLow("GBPUSD",0,1);
var_start_32 = iHigh("GBPUSD",0,1);
var_start_48 = iClose("GBPUSD",0,1);
var_start_56 = (var_start_40 + var_start_32 + var_start_48 + var_start_48) / 4;
var_start_112 = iHigh("GBPUSD",PERIOD_M30,1);
var_start_0 = iOpen("GBPUSD",PERIOD_D1,0);
var_start_8 = iClose("GBPUSD",PERIOD_D1,0);

if ((Symbol() != "GBPJPY") && (Symbol() != "USDJPY") && (Symbol() != "EURJPY") && (Symbol() != "AUDJPY") && (Symbol() != "CADJPY"))
var_start_16 = (var_start_8 - var_start_0) * 10000.0;
else
var_start_16 = (var_start_8 - var_start_0) * 100.0;

var_start_120 = iRSI("GBPUSD",0,3,PRICE_CLOSE,0);
var_start_128 = iRSI("GBPUSD",0,3,PRICE_CLOSE,1);
var_start_136 = iMA("GBPUSD",0,1,0,MODE_EMA,PRICE_TYPICAL,1);
var_start_144 = (var_start_40 + var_start_32 + var_start_48) / 3;
var_start_152 = (var_start_48 - var_start_144) * 10000.0;
var_start_160 = High[iHighest("GBPUSD",PERIOD_H4,MODE_HIGH,3,1)];
var_start_192 = iCCI("GBPUSD",0,14,PRICE_CLOSE,0);
var_start_200 = iCCI("GBPUSD",0,14,PRICE_CLOSE,1);
var_start_208 = iWPR(NULL,0,14,0);
var_start_232 = iMACD("GBPUSD",PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
var_start_240 = iMACD("GBPUSD",PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,3);
var_start_248 = iMACD("GBPUSD",PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
var_start_256 = iMACD("GBPUSD",PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
var_start_264 = iMACD("GBPUSD",PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
var_start_272 = iMACD("GBPUSD",PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,3);
var_start_280 = iMACD("GBPUSD",PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
var_start_288 = iMACD("GBPUSD",PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
var_start_296 = iMACD("GBPUSD",PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
var_start_304 = iMACD("GBPUSD",PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,3);
var_start_312 = iMACD("GBPUSD",PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
var_start_320 = iMACD("GBPUSD",PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
var_start_600 = 7.7;

ObjectCreate("running",OBJ_LABEL,0,var_start_96,0,var_start_104,0);
ObjectSet("running",OBJPROP_XDISTANCE,300);
ObjectSet("running",OBJPROP_YDISTANCE,240);
ObjectSet("running",OBJPROP_TIMEFRAMES,507);
ObjectSetText("running","只能运行在M15时间段 !!",20,"Arial Narrow",Red);
ObjectCreate("web",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("web",OBJPROP_XDISTANCE,6);
ObjectSet("web",OBJPROP_YDISTANCE,1);
ObjectSet("web",OBJPROP_CORNER,3);
ObjectSetText("web","http://www.billionmeter.com",12,"Arial Narrow",Teal);
ObjectSet("web",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectDelete("expired");
ObjectCreate("bilio",OBJ_LABEL,0,var_start_96,0,var_start_104,0);
ObjectSet("bilio",OBJPROP_XDISTANCE,37);
ObjectSet("bilio",OBJPROP_YDISTANCE,203);
ObjectSet("bilio",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectSetText("bilio","BILLION METER SYSTEM",10,"Arial Narrow",DarkSlateGray);
ObjectCreate("garup",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("garup",OBJPROP_XDISTANCE,3);
ObjectSet("garup",OBJPROP_YDISTANCE,75);
ObjectSetText("garup","___________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("garup",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("garup1",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("garup1",OBJPROP_XDISTANCE,3);
ObjectSet("garup1",OBJPROP_YDISTANCE,77);
ObjectSetText("garup1","___________________________________",10,"Arial Narrow",Cyan);
ObjectSet("garup1",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("garup2",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("garup2",OBJPROP_XDISTANCE,3);
ObjectSet("garup2",OBJPROP_YDISTANCE,79);
ObjectSetText("garup2","___________________________________",10,"Arial Narrow",Red);
ObjectSet("garup2",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("prog",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("prog",OBJPROP_XDISTANCE,8);
ObjectSet("prog",OBJPROP_YDISTANCE,95);
ObjectSetText("prog","BILLION METER SYSTEM VERSION 9.0 ",10,"Arial Narrow",SteelBlue);
ObjectSet("prog",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar",OBJPROP_XDISTANCE,3);
ObjectSet("gar",OBJPROP_YDISTANCE,100);
ObjectSetText("gar","___________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("gar",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar1",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar1",OBJPROP_XDISTANCE,3);
ObjectSet("gar1",OBJPROP_YDISTANCE,102);
ObjectSetText("gar1","___________________________________",10,"Arial Narrow",Cyan);
ObjectSet("gar1",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar2",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar2",OBJPROP_XDISTANCE,3);
ObjectSet("gar2",OBJPROP_YDISTANCE,104);
ObjectSetText("gar2","___________________________________",10,"Arial Narrow",Red);
ObjectSet("gar2",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("bil",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("bil",OBJPROP_XDISTANCE,23);
ObjectSet("bil",OBJPROP_YDISTANCE,125);
ObjectSetText("bil","BILLION METER",10,"Arial Narrow",LightSteelBlue);
ObjectSet("bil",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("bilvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("bilvalue",OBJPROP_XDISTANCE,117);
ObjectSet("bilvalue",OBJPROP_YDISTANCE,125);
ObjectSet("bilvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_152 > 0.0)
{
ObjectSetText("bilvalue","上升趋势",10,"Arial Narrow",White);
var_start_328 = var_start_600;
var_start_464 = 0;
}

if (var_start_152 == 0.0)
{
ObjectSetText("bilvalue","盘整趋势",10,"Arial Narrow",Yellow);
var_start_328 = 0;
var_start_464 = 0;
}

if (var_start_152 < 0.0)
{
ObjectSetText("bilvalue","下降趋势",10,"Arial Narrow",Orange);
var_start_464 = var_start_600;
var_start_328 = 0;
}

var_start_608 = iMA("GBPUSD",PERIOD_M15,30,0,MODE_EMA,PRICE_TYPICAL,0);
var_start_616 = iMA("GBPUSD",PERIOD_M15,30,0,MODE_EMA,PRICE_TYPICAL,2);
var_start_624 = (var_start_608 - var_start_616) * 10000.0;

ObjectCreate("maintrend",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("maintrend",OBJPROP_XDISTANCE,23);
ObjectSet("maintrend",OBJPROP_YDISTANCE,140);
ObjectSetText("maintrend","Main Trend",10,"Arial Narrow",CadetBlue);
ObjectSet("maintrend",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("maintrendvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("maintrendvalue",OBJPROP_XDISTANCE,117);
ObjectSet("maintrendvalue",OBJPROP_YDISTANCE,140);
ObjectSet("maintrendvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_624 > 0.0)
{
ObjectSetText("maintrendvalue","上升趋势",10,"Arial Narrow",White);
var_start_336 = var_start_600;
var_start_472 = 0;
}

if (var_start_624 < 0.0)
{
ObjectSetText("maintrendvalue","下降趋势",10,"Arial Narrow",Orange);
var_start_472 = var_start_600;
var_start_336 = 0;
}

if (var_start_624 == 0.0)
{
ObjectSetText("maintrendvalue","盘整趋势",10,"Arial Narrow",Yellow);
var_start_336 = 0;
var_start_472 = 0;
}

var_start_632 = iBullsPower("GBPUSD",0,13,PRICE_CLOSE,0);
var_start_640 = iBearsPower("GBPUSD",0,13,PRICE_CLOSE,0);

ObjectCreate("powertrend",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("powertrend",OBJPROP_XDISTANCE,23);
ObjectSet("powertrend",OBJPROP_YDISTANCE,155);
ObjectSetText("powertrend","POWER TREND",10,"Arial Narrow",OliveDrab);
ObjectSet("powertrend",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("powertrendvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("powertrendvalue",OBJPROP_XDISTANCE,117);
ObjectSet("powertrendvalue",OBJPROP_YDISTANCE,155);
ObjectSet("powertrendvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_640 > 0.0001)
{
ObjectSetText("powertrendvalue","牛市",10,"Arial Narrow",White);
var_start_344 = var_start_600;
var_start_480 = 0;
}

if (var_start_632 < -0.0001)
{
ObjectSetText("powertrendvalue","熊市",10,"Arial Narrow",Orange);
var_start_480 = var_start_600;
var_start_344 = 0;
}
else
{
ObjectSetText("powertrendvalue","盘整",10,"Arial Narrow",Yellow);
var_start_344 = 0;
var_start_480 = 0;
}

ObjectCreate("rec",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("rec",OBJPROP_XDISTANCE,20);
ObjectSet("rec",OBJPROP_YDISTANCE,180);
ObjectSetText("rec","<<<<<<<<<<<交易提示>>>>>>>>>>>",9,"Arial Narrow",LemonChiffon);
ObjectSet("rec",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar3",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar3",OBJPROP_XDISTANCE,3);
ObjectSet("gar3",OBJPROP_YDISTANCE,183);
ObjectSetText("gar3","___________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("gar3",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar4",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar4",OBJPROP_XDISTANCE,3);
ObjectSet("gar4",OBJPROP_YDISTANCE,185);
ObjectSetText("gar4","___________________________________",10,"Arial Narrow",Cyan);
ObjectSet("gar4",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar5",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar5",OBJPROP_XDISTANCE,3);
ObjectSet("gar5",OBJPROP_YDISTANCE,187);
ObjectSetText("gar5","___________________________________",10,"Arial Narrow",Red);
ObjectSet("gar5",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar6",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar6",OBJPROP_XDISTANCE,3);
ObjectSet("gar6",OBJPROP_YDISTANCE,240);
ObjectSetText("gar6","___________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("gar6",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar7",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar7",OBJPROP_XDISTANCE,3);
ObjectSet("gar7",OBJPROP_YDISTANCE,242);
ObjectSetText("gar7","___________________________________",10,"Arial Narrow",Cyan);
ObjectSet("gar7",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar8",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar8",OBJPROP_XDISTANCE,3);
ObjectSet("gar8",OBJPROP_YDISTANCE,244);
ObjectSetText("gar8","___________________________________",10,"Arial Narrow",Red);
ObjectSet("gar8",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("indic",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("indic",OBJPROP_XDISTANCE,40);
ObjectSet("indic",OBJPROP_YDISTANCE,259);
ObjectSetText("indic","... 指标状态 ...",10,"Arial Narrow",SlateGray);
ObjectSet("indic",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("RSI",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("RSI",OBJPROP_XDISTANCE,3);
ObjectSet("RSI",OBJPROP_YDISTANCE,274);
ObjectSetText("RSI","R.S.I",10,"Arial Narrow",Cyan);
ObjectSet("RSI",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("Rvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("Rvalue",OBJPROP_XDISTANCE,137);
ObjectSet("Rvalue",OBJPROP_YDISTANCE,276);
ObjectSet("Rvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_120 > 89.0)
{
ObjectSetText("Rvalue","超买",8,"Arial Narrow",Chartreuse);
var_start_352 = 0;
var_start_488 = 0;
}

if ((var_start_120 > 50) && (var_start_120 < 90))
{
ObjectSetText("Rvalue","上升趋势",8,"Arial Narrow",White);
var_start_352 = var_start_600;
var_start_488 = 0;
}

if (var_start_120 == 50.0)
{
ObjectSetText("Rvalue","盘整趋势",8,"Arial Narrow",Yellow);
var_start_352 = 0;
var_start_488 = 0;
}

if ((var_start_120 > 9) && (var_start_120 < 50))
{
ObjectSetText("Rvalue","下降趋势",8,"Arial Narrow",Orange);
var_start_488 = var_start_600;
var_start_352 = 0;
}

if (var_start_120 < 11.0)
{
ObjectSetText("Rvalue","超卖",8,"Arial Narrow",Red);
var_start_352 = 0;
var_start_488 = 0;
}

var_start_648 = iRVI("GBPUSD",0,10,MODE_MAIN,0);
var_start_656 = iRVI("GBPUSD",0,10,MODE_MAIN,1);
var_start_664 = iRVI("GBPUSD",0,10,MODE_SIGNAL,0);
var_start_672 = iRVI("GBPUSD",0,10,MODE_MAIN,1);

ObjectCreate("RVI",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("RVI",OBJPROP_XDISTANCE,3);
ObjectSet("RVI",OBJPROP_YDISTANCE,289);
ObjectSetText("RVI","R.V.I",10,"Arial Narrow",Green);
ObjectSet("RVI",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("RVIvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("RVIvalue",OBJPROP_XDISTANCE,137);
ObjectSet("RVIvalue",OBJPROP_YDISTANCE,291);
ObjectSet("RVIvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_648 > var_start_664)
{
ObjectSetText("RVIvalue","上升趋势",8,"Arial Narrow",White);
var_start_360 = var_start_600;
var_start_496 = 0;
}

if (var_start_648 < var_start_664)
{
ObjectSetText("RVIvalue","下降趋势",8,"Arial Narrow",Orange);
var_start_496 = var_start_600;
var_start_360 = 0;
}

if (var_start_648 == var_start_664)
{
ObjectSetText("RVIvalue","发生交叉",8,"Arial Narrow",SlateBlue);
var_start_360 = 0;
var_start_496 = 0;
}

ObjectCreate("cci",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("cci",OBJPROP_XDISTANCE,3);
ObjectSet("cci",OBJPROP_YDISTANCE,304);
ObjectSetText("cci","C.C.I",10,"Arial Narrow",Thistle);
ObjectSet("cci",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("ccicvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("ccicvalue",OBJPROP_XDISTANCE,137);
ObjectSet("ccicvalue",OBJPROP_YDISTANCE,306);
ObjectSet("ccicvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_192 > 99.0)
{
ObjectSetText("ccicvalue","上升趋势",8,"Arial Narrow",White);
var_start_368 = var_start_600;
var_start_504 = 0;
}

if ((var_start_192 < 100) && (var_start_192 > -100))
{
ObjectSetText("ccicvalue","盘整趋势",8,"Arial Narrow",Yellow);
var_start_368 = 0;
var_start_504 = 0;
}

if (var_start_192 < -99.0)
{
ObjectSetText("ccicvalue","下降趋势",8,"Arial Narrow",Orange);
var_start_504 = var_start_600;
var_start_368 = 0;
}

var_start_680 = iADX("GBPUSD",0,3,PRICE_CLOSE,MODE_MAIN,0);
var_start_688 = iADX("GBPUSD",0,3,PRICE_CLOSE,MODE_MAIN,1);
var_start_696 = iADX("GBPUSD",0,3,PRICE_CLOSE,MODE_PLUSDI,0);
var_start_704 = iADX("GBPUSD",0,3,PRICE_CLOSE,MODE_PLUSDI,1);
var_start_712 = iADX("GBPUSD",0,3,PRICE_CLOSE,MODE_MINUSDI,0);
var_start_720 = iADX("GBPUSD",0,3,PRICE_CLOSE,MODE_MINUSDI,1);

ObjectCreate("ADX",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("ADX",OBJPROP_XDISTANCE,3);
ObjectSet("ADX",OBJPROP_YDISTANCE,319);
ObjectSetText("ADX","ADX",10,"Arial Narrow",MediumSlateBlue);
ObjectSet("ADX",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("ADXvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("ADXvalue",OBJPROP_XDISTANCE,137);
ObjectSet("ADXvalue",OBJPROP_YDISTANCE,321);
ObjectSet("ADXvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if ((var_start_680 > var_start_696) && (var_start_680 > var_start_712) && (var_start_712 < var_start_696))
{
ObjectSetText("ADXvalue","上升趋势",8,"Arial Narrow",White);
var_start_376 = var_start_600;
var_start_512 = 0;
}

if ((var_start_680 > var_start_696) && (var_start_680 > var_start_712) && (var_start_712 > var_start_696))
{
ObjectSetText("ADXvalue","下降趋势",8,"Arial Narrow",Orange);
var_start_512 = var_start_600;
var_start_376 = 0;
}

if ((var_start_680 > var_start_696) && (var_start_680 > var_start_712) && (var_start_712 == var_start_696))
{
ObjectSetText("ADXvalue","发生交叉",8,"Arial Narrow",SlateBlue);
var_start_376 = 0;
var_start_512 = 0;
}

if (var_start_680 <= var_start_696)
{
ObjectSetText("ADXvalue","发生交叉",8,"Arial Narrow",SlateBlue);
var_start_376 = 0;
var_start_512 = 0;
}

if (var_start_680 <= var_start_712)
{
ObjectSetText("ADXvalue","发生交叉",8,"Arial Narrow",SlateBlue);
var_start_376 = 0;
var_start_512 = 0;
}

var_start_728 = iStochastic("GBPUSD",0,5,3,3,MODE_SMA,0,MODE_MAIN,0);
var_start_736 = iStochastic("GBPUSD",0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);

ObjectCreate("stoc",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("stoc",OBJPROP_XDISTANCE,3);
ObjectSet("stoc",OBJPROP_YDISTANCE,334);
ObjectSetText("stoc","Stochastic",10,"Arial Narrow",LightSeaGreen);
ObjectSet("stoc",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("stocvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("stocvalue",OBJPROP_XDISTANCE,137);
ObjectSet("stocvalue",OBJPROP_YDISTANCE,336);
ObjectSet("stocvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_728 > var_start_736)
{
ObjectSetText("stocvalue","上升趋势",8,"Arial Narrow",White);
var_start_384 = var_start_600;
var_start_520 = 0;
}

if (var_start_728 < var_start_736)
{
ObjectSetText("stocvalue","下降趋势",8,"Arial Narrow",Orange);
var_start_520 = var_start_600;
var_start_384 = 0;
}

if (var_start_728 == var_start_736)
{
ObjectSetText("stocvalue","发生交叉",8,"Arial Narrow",SlateBlue);
var_start_384 = 0;
var_start_520 = 0;
}

ObjectCreate("william",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("william",OBJPROP_XDISTANCE,3);
ObjectSet("william",OBJPROP_YDISTANCE,349);
ObjectSetText("william","Williams % ",10,"Arial Narrow",FireBrick);
ObjectSet("william",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("williamcvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("williamcvalue",OBJPROP_XDISTANCE,137);
ObjectSet("williamcvalue",OBJPROP_YDISTANCE,351);
ObjectSet("williamcvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_208 > -21.0)
{
ObjectSetText("williamcvalue","上升趋势",8,"Arial Narrow",White);
var_start_392 = var_start_600;
var_start_528 = 0;
}

if ((var_start_208 < -20) && (var_start_208 > -80))
{
ObjectSetText("williamcvalue","盘整趋势",8,"Arial Narrow",Yellow);
var_start_392 = 0;
var_start_528 = 0;
}

if (var_start_208 < -79.0)
{
ObjectSetText("williamcvalue","下降趋势",8,"Arial Narrow",Orange);
var_start_528 = var_start_600;
var_start_392 = 0;
}

var_start_216 = iMomentum("GBPUSD",0,12,PRICE_CLOSE,0);
var_start_224 = iMomentum("GBPUSD",0,12,PRICE_CLOSE,1);

ObjectCreate("mom",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("mom",OBJPROP_XDISTANCE,3);
ObjectSet("mom",OBJPROP_YDISTANCE,364);
ObjectSetText("mom","Momentum",10,"Arial Narrow",MediumPurple);
ObjectSet("mom",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("momcvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("momcvalue",OBJPROP_XDISTANCE,137);
ObjectSet("momcvalue",OBJPROP_YDISTANCE,366);
ObjectSet("momcvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_216 > 100.1999)
{
ObjectSetText("momcvalue","超买",8,"Arial Narrow",Chartreuse);
var_start_400 = 0;
var_start_536 = 0;
}

if ((var_start_216 > 99.9999) && (var_start_216 < 100.2))
{
ObjectSetText("momcvalue","上升趋势",8,"Arial Narrow",White);
var_start_400 = var_start_600;
var_start_536 = 0;
}

if ((var_start_216 > 99.6999) && (var_start_216 < 100))
{
ObjectSetText("momcvalue","下降趋势",8,"Arial Narrow",Orange);
var_start_536 = var_start_600;
var_start_400 = 0;
}

if (var_start_216 < 99.7)
{
ObjectSetText("momcvalue","超卖",8,"Arial Narrow",Red);
var_start_400 = 0;
var_start_536 = 0;
}

ObjectCreate("macd5",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("macd5",OBJPROP_XDISTANCE,3);
ObjectSet("macd5",OBJPROP_YDISTANCE,379);
ObjectSetText("macd5","MACD M5",10,"Arial Narrow",Sienna);
ObjectSet("macd5",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("macd5value",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("macd5value",OBJPROP_XDISTANCE,137);
ObjectSet("macd5value",OBJPROP_YDISTANCE,381);
ObjectSet("macd5value",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_248 > var_start_256)
{
ObjectSetText("macd5value","上升趋势",8,"Arial Narrow",White);
var_start_408 = var_start_600;
var_start_544 = 0;
}

if (var_start_248 < var_start_256)
{
ObjectSetText("macd5value","下降趋势",8,"Arial Narrow",Orange);
var_start_544 = var_start_600;
var_start_408 = 0;
}

if (var_start_248 == var_start_256)
{
ObjectSetText("macd5value","盘整趋势",8,"Arial Narrow",Yellow);
var_start_408 = 0;
var_start_544 = 0;
}

ObjectCreate("macd15",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("macd15",OBJPROP_XDISTANCE,3);
ObjectSet("macd15",OBJPROP_YDISTANCE,394);
ObjectSetText("macd15","MACD M15",10,"Arial Narrow",Brown);
ObjectSet("macd15",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("macd15value",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("macd15value",OBJPROP_XDISTANCE,137);
ObjectSet("macd15value",OBJPROP_YDISTANCE,396);
ObjectSet("macd15value",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_280 > var_start_288)
{
ObjectSetText("macd15value","上升趋势",8,"Arial Narrow",White);
var_start_416 = var_start_600;
var_start_552 = 0;
}

if (var_start_280 < var_start_288)
{
ObjectSetText("macd15value","下降趋势",8,"Arial Narrow",Orange);
var_start_552 = var_start_600;
var_start_416 = 0;
}

if (var_start_280 == var_start_288)
{
ObjectSetText("macd15value","盘整趋势",8,"Arial Narrow",Yellow);
var_start_416 = 0;
var_start_552 = 0;
}

ObjectCreate("macd30",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("macd30",OBJPROP_XDISTANCE,3);
ObjectSet("macd30",OBJPROP_YDISTANCE,409);
ObjectSetText("macd30","MACD M30",10,"Arial Narrow",DarkSeaGreen);
ObjectSet("macd30",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("macd30value",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("macd30value",OBJPROP_XDISTANCE,137);
ObjectSet("macd30value",OBJPROP_YDISTANCE,411);
ObjectSet("macd30value",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_312 > var_start_320)
{
ObjectSetText("macd30value","上升趋势",8,"Arial Narrow",White);
var_start_424 = var_start_600;
var_start_560 = 0;
}

if (var_start_312 < var_start_320)
{
ObjectSetText("macd30value","下降趋势",8,"Arial Narrow",Orange);
var_start_560 = var_start_600;
var_start_424 = 0;
}

if (var_start_312 == var_start_320)
{
ObjectSetText("macd30value","盘整趋势",8,"Arial Narrow",Yellow);
var_start_424 = 0;
var_start_560 = 0;
}

ObjectCreate("gar9",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar9",OBJPROP_XDISTANCE,3);
ObjectSet("gar9",OBJPROP_YDISTANCE,414);
ObjectSetText("gar9","_________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("gar9",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar10",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar10",OBJPROP_XDISTANCE,3);
ObjectSet("gar10",OBJPROP_YDISTANCE,416);
ObjectSetText("gar10","_________________________________",10,"Arial Narrow",Cyan);
ObjectSet("gar10",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar11",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar11",OBJPROP_XDISTANCE,3);
ObjectSet("gar11",OBJPROP_YDISTANCE,418);
ObjectSetText("gar11","_________________________________",10,"Arial Narrow",Red);
ObjectSet("gar11",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("custom",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("custom",OBJPROP_XDISTANCE,40);
ObjectSet("custom",OBJPROP_YDISTANCE,433);
ObjectSetText("custom","... 自定义指标 ...",10,"Arial Narrow",SlateGray);
ObjectSet("custom",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("RSIGO",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("RSIGO",OBJPROP_XDISTANCE,3);
ObjectSet("RSIGO",OBJPROP_YDISTANCE,448);
ObjectSetText("RSIGO","Twister",10,"Arial Narrow",Cyan);
ObjectSet("RSIGO",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("RGvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("RGvalue",OBJPROP_XDISTANCE,137);
ObjectSet("RGvalue",OBJPROP_YDISTANCE,451);
ObjectSet("RGvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_128 < var_start_120) ObjectSetText("RGvalue","上升趋势",8,"Arial Narrow",White);
if (var_start_120 == var_start_128) ObjectSetText("RGvalue","盘整趋势",8,"Arial Narrow",Yellow);
if (var_start_128 > var_start_120) ObjectSetText("RGvalue","下降趋势",8,"Arial Narrow",Orange);

var_start_744 = iADX("GBPUSD",PERIOD_M5,3,PRICE_CLOSE,MODE_MAIN,0);
var_start_752 = iADX("GBPUSD",PERIOD_M5,3,PRICE_CLOSE,MODE_MAIN,1);
var_start_760 = iADX("GBPUSD",PERIOD_M5,3,PRICE_CLOSE,MODE_PLUSDI,0);
var_start_768 = iADX("GBPUSD",PERIOD_M5,3,PRICE_CLOSE,MODE_PLUSDI,1);
var_start_776 = iADX("GBPUSD",PERIOD_M5,3,PRICE_CLOSE,MODE_MINUSDI,0);
var_start_784 = iADX("GBPUSD",PERIOD_M5,3,PRICE_CLOSE,MODE_MINUSDI,1);

ObjectCreate("STORM",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("STORM",OBJPROP_XDISTANCE,3);
ObjectSet("STORM",OBJPROP_YDISTANCE,463);
ObjectSetText("STORM","Storm",10,"Arial Narrow",Red);
ObjectSet("STORM",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("STORMvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("STORMvalue",OBJPROP_XDISTANCE,137);
ObjectSet("STORMvalue",OBJPROP_YDISTANCE,465);
ObjectSet("STORMvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if ((var_start_752 < var_start_744) && (var_start_768 < var_start_760) && (var_start_776 < var_start_760))
{
ObjectSetText("STORMvalue","上升趋势",8,"Arial Narrow",White);
}

if ((var_start_752 < var_start_744) && (var_start_784 < var_start_776) && (var_start_776 > var_start_760))
ObjectSetText("STORMvalue","下降趋势",8,"Arial Narrow",Orange);
else
ObjectSetText("STORMvalue","盘整趋势",8,"Arial Narrow",Yellow);

var_start_792 = iADX("GBPUSD",PERIOD_M15,3,PRICE_CLOSE,MODE_MAIN,0);
var_start_800 = iADX("GBPUSD",PERIOD_M15,3,PRICE_CLOSE,MODE_MAIN,1);
var_start_808 = iADX("GBPUSD",PERIOD_M15,3,PRICE_CLOSE,MODE_PLUSDI,0);
var_start_816 = iADX("GBPUSD",PERIOD_M15,3,PRICE_CLOSE,MODE_PLUSDI,1);
var_start_824 = iADX("GBPUSD",PERIOD_M15,3,PRICE_CLOSE,MODE_MINUSDI,0);
var_start_832 = iADX("GBPUSD",PERIOD_M15,3,PRICE_CLOSE,MODE_MINUSDI,1);

ObjectCreate("EARTHQUAKE",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("EARTHQUAKE",OBJPROP_XDISTANCE,3);
ObjectSet("EARTHQUAKE",OBJPROP_YDISTANCE,478);
ObjectSetText("EARTHQUAKE","Earthquake",10,"Arial Narrow",LightSalmon);
ObjectSet("EARTHQUAKE",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("EARTHQUAKEMvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("EARTHQUAKEMvalue",OBJPROP_XDISTANCE,137);
ObjectSet("EARTHQUAKEMvalue",OBJPROP_YDISTANCE,480);
ObjectSet("EARTHQUAKEMvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if ((var_start_800 < var_start_792) && (var_start_816 < var_start_808) && (var_start_824 < var_start_808))
{
ObjectSetText("EARTHQUAKEMvalue","上升趋势",8,"Arial Narrow",White);
}

if ((var_start_800 < var_start_792) && (var_start_832 < var_start_824) && (var_start_824 > var_start_808))
ObjectSetText("EARTHQUAKEMvalue","下降趋势",8,"Arial Narrow",Orange);
else
ObjectSetText("EARTHQUAKEMvalue","盘整趋势",8,"Arial Narrow",Yellow);

var_start_840 = iADX("GBPUSD",PERIOD_M30,3,PRICE_CLOSE,MODE_MAIN,0);
var_start_848 = iADX("GBPUSD",PERIOD_M30,3,PRICE_CLOSE,MODE_MAIN,1);
var_start_856 = iADX("GBPUSD",PERIOD_M30,3,PRICE_CLOSE,MODE_PLUSDI,0);
var_start_864 = iADX("GBPUSD",PERIOD_M30,3,PRICE_CLOSE,MODE_PLUSDI,1);
var_start_872 = iADX("GBPUSD",PERIOD_M30,3,PRICE_CLOSE,MODE_MINUSDI,0);
var_start_880 = iADX("GBPUSD",PERIOD_M30,3,PRICE_CLOSE,MODE_MINUSDI,1);

ObjectCreate("BRAIN",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("BRAIN",OBJPROP_XDISTANCE,3);
ObjectSet("BRAIN",OBJPROP_YDISTANCE,493);
ObjectSetText("BRAIN","Brain",10,"Arial Narrow",Tomato);
ObjectSet("BRAIN",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("BRAINvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("BRAINvalue",OBJPROP_XDISTANCE,137);
ObjectSet("BRAINvalue",OBJPROP_YDISTANCE,495);
ObjectSet("BRAINvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if ((var_start_848 < var_start_840) && (var_start_864 < var_start_856) && (var_start_872 < var_start_856))
{
ObjectSetText("BRAINvalue","上升趋势",8,"Arial Narrow",White);
}

if ((var_start_848 < var_start_840) && (var_start_880 < var_start_872) && (var_start_872 > var_start_856))
ObjectSetText("BRAINvalue","下降趋势",8,"Arial Narrow",Orange);
else
ObjectSetText("BRAINvalue","盘整趋势",8,"Arial Narrow",Yellow);

ObjectCreate("gcci",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gcci",OBJPROP_XDISTANCE,3);
ObjectSet("gcci",OBJPROP_YDISTANCE,508);
ObjectSetText("gcci","C.O.D",10,"Arial Narrow",Thistle);
ObjectSet("gcci",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gccicvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gccicvalue",OBJPROP_XDISTANCE,137);
ObjectSet("gccicvalue",OBJPROP_YDISTANCE,510);
ObjectSet("gccicvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_200 < var_start_192) ObjectSetText("gccicvalue","上升趋势",8,"Arial Narrow",White);
if (var_start_200 == var_start_192) ObjectSetText("gccicvalue","盘整趋势",8,"Arial Narrow",Yellow);
if (var_start_200 > var_start_192) ObjectSetText("gccicvalue","下降趋势",8,"Arial Narrow",Orange);

ObjectCreate("gmom",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gmom",OBJPROP_XDISTANCE,3);
ObjectSet("gmom",OBJPROP_YDISTANCE,523);
ObjectSetText("gmom","M.O.D",10,"Arial Narrow",MediumPurple);
ObjectSet("gmom",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gmomcvalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gmomcvalue",OBJPROP_XDISTANCE,137);
ObjectSet("gmomcvalue",OBJPROP_YDISTANCE,525);
ObjectSet("gmomcvalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_224 < var_start_216) ObjectSetText("gmomcvalue","上升趋势",8,"Arial Narrow",White);
if (var_start_224 > var_start_216) ObjectSetText("gmomcvalue","下降趋势",8,"Arial Narrow",Orange);
if (var_start_224 == var_start_216) ObjectSetText("gmomcvalue","盘整趋势",8,"Arial Narrow",Yellow);

ObjectCreate("gar12",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar12",OBJPROP_XDISTANCE,3);
ObjectSet("gar12",OBJPROP_YDISTANCE,529);
ObjectSetText("gar12","_________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("gar12",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar13",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar13",OBJPROP_XDISTANCE,3);
ObjectSet("gar13",OBJPROP_YDISTANCE,531);
ObjectSetText("gar13","_________________________________",10,"Arial Narrow",Cyan);
ObjectSet("gar13",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar14",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar14",OBJPROP_XDISTANCE,3);
ObjectSet("gar14",OBJPROP_YDISTANCE,533);
ObjectSetText("gar14","_________________________________",10,"Arial Narrow",Red);
ObjectSet("gar14",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("volatylity",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("volatylity",OBJPROP_XDISTANCE,65);
ObjectSet("volatylity",OBJPROP_YDISTANCE,549);
ObjectSetText("volatylity","... 波动 ...",10,"Arial Narrow",SlateGray);
ObjectSet("volatylity",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

var_start_888 = iHigh("GBPUSD",PERIOD_M5,0);
var_start_896 = iLow("GBPUSD",PERIOD_M5,0);
var_start_904 = iOpen("GBPUSD",PERIOD_M5,0);
var_start_912 = iClose("GBPUSD",PERIOD_M5,0);
var_start_920 = (var_start_912 - var_start_904) * 10000.0;
var_start_928 = (var_start_904 - var_start_912) * 10000.0;

if (var_start_912 > var_start_904)
{
ObjectDelete("bear");
ObjectCreate("bull",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("bull",OBJPROP_XDISTANCE,10);
ObjectSet("bull",OBJPROP_YDISTANCE,549);
ObjectSetText("bull","牛市",10,"Arial Narrow",Teal);
ObjectSet("bull",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_912 < var_start_904)
{
ObjectDelete("bull");
ObjectCreate("bear",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("bear",OBJPROP_XDISTANCE,10);
ObjectSet("bear",OBJPROP_YDISTANCE,549);
ObjectSetText("bear","熊市",10,"Arial Narrow",Orange);
ObjectSet("bear",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

ObjectCreate("volavalue",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("volavalue",OBJPROP_XDISTANCE,137);
ObjectSet("volavalue",OBJPROP_YDISTANCE,549);
ObjectSet("volavalue",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if ((var_start_912 > var_start_904) && (var_start_920 < 5)) ObjectSetText("volavalue"," 低",10,"Arial Narrow",DeepSkyBlue);
if ((var_start_912 > var_start_904) && (var_start_920 > 4) && (var_start_920 < 10)) ObjectSetText("volavalue"," 中",10,"Arial Narrow",Yellow);
if ((var_start_912 > var_start_904) && (var_start_920 > 9) && (var_start_920 < 16)) ObjectSetText("volavalue"," 高",10,"Arial Narrow",Lime);
if ((var_start_912 > var_start_904) && (var_start_920 > 15)) ObjectSetText("volavalue","极高",10,"Arial Narrow",Red);
if ((var_start_912 < var_start_904) && (var_start_928 < 5)) ObjectSetText("volavalue"," 低",10,"Arial Narrow",DeepSkyBlue);
if ((var_start_912 < var_start_904) && (var_start_928 > 4) && (var_start_928 < 10)) ObjectSetText("volavalue"," 中",10,"Arial Narrow",Yellow);
if ((var_start_912 < var_start_904) && (var_start_928 > 9) && (var_start_928 < 16)) ObjectSetText("volavalue"," 高",10,"Arial Narrow",Lime);
if ((var_start_912 < var_start_904) && (var_start_928 > 15)) ObjectSetText("volavalue","极高",10,"Arial Narrow",Red);

ObjectCreate("gar15",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar15",OBJPROP_XDISTANCE,3);
ObjectSet("gar15",OBJPROP_YDISTANCE,554);
ObjectSetText("gar15","_________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("gar15",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar16",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar16",OBJPROP_XDISTANCE,3);
ObjectSet("gar16",OBJPROP_YDISTANCE,556);
ObjectSetText("gar16","_________________________________",10,"Arial Narrow",Cyan);
ObjectSet("gar16",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar17",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar17",OBJPROP_XDISTANCE,3);
ObjectSet("gar17",OBJPROP_YDISTANCE,558);
ObjectSetText("gar17","_________________________________",10,"Arial Narrow",Red);
ObjectSet("gar17",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

var_start_456 = var_start_328 + var_start_336 + var_start_344 + var_start_352 + var_start_360 + var_start_368 + var_start_376 + var_start_384 + var_start_392 + var_start_400 + var_start_408 + var_start_416 + var_start_424;
var_start_592 = var_start_464 + var_start_472 + var_start_480 + var_start_488 + var_start_496 + var_start_504 + var_start_512 + var_start_520 + var_start_528 + var_start_536 + var_start_544 + var_start_552 + var_start_560;

ObjectCreate("meter",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("meter",OBJPROP_XDISTANCE,46);
ObjectSet("meter",OBJPROP_YDISTANCE,580);
ObjectSetText("meter"," 交易信号过滤 ",8,"Verdana",SlateGray);
ObjectSet("meter",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("ct",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("ct",OBJPROP_XDISTANCE,90);
ObjectSet("ct",OBJPROP_YDISTANCE,600);
ObjectSetText("ct","t",12,"Wingdings 3",Yellow);
ObjectSet("ct",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("cu",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("cu",OBJPROP_XDISTANCE,105);
ObjectSet("cu",OBJPROP_YDISTANCE,600);
ObjectSetText("cu","u",12,"Wingdings 3",Yellow);
ObjectSet("cu",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("etc",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("etc",OBJPROP_XDISTANCE,10);
ObjectSet("etc",OBJPROP_YDISTANCE,602);
ObjectSetText("etc","卖 买",9,"Tahoma",SkyBlue);
ObjectSet("etc",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

if (var_start_456 >= 55.0)
{
ObjectDelete("ct");
ObjectSet("panah",OBJPROP_XDISTANCE,115);
ObjectCreate("u1",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("u1",OBJPROP_XDISTANCE,118);
ObjectSet("u1",OBJPROP_YDISTANCE,600);
ObjectSetText("u1","u",12,"Wingdings 3",Yellow);
ObjectSet("u1",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_456 < 55.0) ObjectDelete("u1");

if (var_start_456 >= 60.0)
{
ObjectCreate("u2",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("u2",OBJPROP_XDISTANCE,132);
ObjectSet("u2",OBJPROP_YDISTANCE,600);
ObjectSetText("u2","u",12,"Wingdings 3",Blue);
ObjectSet("u2",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_456 < 60.0) ObjectDelete("u2");

if (var_start_456 >= 65.0)
{
ObjectCreate("u3",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("u3",OBJPROP_XDISTANCE,145);
ObjectSet("u3",OBJPROP_YDISTANCE,600);
ObjectSetText("u3","u",12,"Wingdings 3",Blue);
ObjectSet("u3",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_456 < 65.0) ObjectDelete("u3");

if (var_start_456 >= 70.0)
{
ObjectCreate("u4",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("u4",OBJPROP_XDISTANCE,158);
ObjectSet("u4",OBJPROP_YDISTANCE,600);
ObjectSetText("u4","u",12,"Wingdings 3",Blue);
ObjectSet("u4",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_456 < 70.0) ObjectDelete("u4");

if (var_start_592 >= 55.0)
{
ObjectDelete("cu");
ObjectCreate("d1",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("d1",OBJPROP_XDISTANCE,77);
ObjectSet("d1",OBJPROP_YDISTANCE,600);
ObjectSetText("d1","t",12,"Wingdings 3",Yellow);
ObjectSet("d1",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_592 < 55.0) ObjectDelete("d1");

if (var_start_592 >= 60.0)
{
ObjectCreate("d2",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("d2",OBJPROP_XDISTANCE,64);
ObjectSet("d2",OBJPROP_YDISTANCE,600);
ObjectSetText("d2","t",12,"Wingdings 3",Red);
ObjectSet("d2",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_592 < 60.0) ObjectDelete("d2");

if (var_start_592 >= 65.0)
{
ObjectCreate("d3",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("d3",OBJPROP_XDISTANCE,51);
ObjectSet("d3",OBJPROP_YDISTANCE,600);
ObjectSetText("d3","t",12,"Wingdings 3",Red);
ObjectSet("d3",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_592 < 65.0) ObjectDelete("d3");

if (var_start_592 >= 70.0)
{
ObjectCreate("d4",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("d4",OBJPROP_XDISTANCE,38);
ObjectSet("d4",OBJPROP_YDISTANCE,600);
ObjectSetText("d4","t",12,"Wingdings 3",Red);
ObjectSet("d4",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

if (var_start_592 < 70.0) ObjectDelete("d4");

ObjectCreate("gar18",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar18",OBJPROP_XDISTANCE,3);
ObjectSet("gar18",OBJPROP_YDISTANCE,615);
ObjectSetText("gar18","_________________________________",10,"Arial Narrow",SteelBlue);
ObjectSet("gar18",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar19",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar19",OBJPROP_XDISTANCE,3);
ObjectSet("gar19",OBJPROP_YDISTANCE,617);
ObjectSetText("gar19","_________________________________",10,"Arial Narrow",Cyan);
ObjectSet("gar19",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("gar20",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("gar20",OBJPROP_XDISTANCE,3);
ObjectSet("gar20",OBJPROP_YDISTANCE,619);
ObjectSetText("gar20","_________________________________",10,"Arial Narrow",Red);
ObjectSet("gar20",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);

year = 2050;
month = 6;
day = 11;
month2 = (month + 1.0);

if (Symbol() != "GBPUSD")
{
ObjectsDeleteAll(0,OBJ_LABEL);
ObjectDelete("valueprice");
ObjectCreate("web",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("web",OBJPROP_XDISTANCE,6);
ObjectSet("web",OBJPROP_YDISTANCE,1);
ObjectSet("web",OBJPROP_CORNER,3);
ObjectSetText("web","http://www.billionmeter.com",12,"Arial Narrow",Teal);
ObjectSet("web",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
ObjectCreate("pairs",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("pairs",OBJPROP_XDISTANCE,3);
ObjectSet("pairs",OBJPROP_YDISTANCE,10);
ObjectSetText("pairs","NO RECOMMENDATION FOR THIS PAIRS",12,"Arial Narrow",Yellow);
ObjectSet("pairs",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M15);
}

ObjectCreate("running",OBJ_LABEL,0,TimeCurrent(),0,0);
ObjectSet("running",OBJPROP_XDISTANCE,300);
ObjectSet("running",OBJPROP_YDISTANCE,240);
ObjectSet("running",OBJPROP_TIMEFRAMES,507);
ObjectSetText("running","智能运行在M15时间段 !!",20,"Arial Narrow",Red);

if ((TimeYear(TimeCurrent()) >= year) && (TimeMonth(TimeCurrent()) >= month) && (TimeDay(TimeCurrent()) >= day)) abadi();
if ((TimeYear(TimeCurrent()) >= year) && (TimeMonth(TimeCurrent()) >= month2) && (TimeDay(TimeCurrent()) >= 1)) abadi();
if (TimeYear(TimeCurrent()) > year) abadi();
}