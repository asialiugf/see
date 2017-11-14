//+------------------------------------------------------------------+
//|                                               Daily_High_Low.mq4 |
//|                                       Copyright © Terry Nicholls |
//+------------------------------------------------------------------+
#property copyright "Copyright © Terry Nicholls"

// Parameters

#property indicator_chart_window

extern int TimeZoneOfData = -7; // GMT

double yesterday_high=0;
double yesterday_low=0;

double rates_d1[2][6];
double dlyh;
double dlyl;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
  {

// Indicators

dlyh=0; dlyl=0;

   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+

int deinit()
  {

ObjectDelete("dlyh Label");
ObjectDelete("dlyh Line");
ObjectDelete("dlyl Label");
ObjectDelete("dlyl Line");

   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
  {

// Get new Daily prices

ArrayCopyRates(rates_d1, Symbol(), PERIOD_D1);

yesterday_high = rates_d1[1][3];
yesterday_low = rates_d1[1][2];

// Calculate Daily High/Low lines

dlyh = yesterday_high;
dlyl = yesterday_low;

// Uncomment the line below to display the data at the top of your chart

// Comment ("Yesterday's High = ",yesterday_high,"  Yesterday's Low = ",yesterday_low);

// Set Daily High/Low line labels on chart window

      if(ObjectFind("dlyh label") != 0)
      {
      ObjectCreate("dlyh label", OBJ_TEXT, 0, Time[20], dlyh);
      ObjectSetText("dlyh label", "Yesterdays High", 10, "Veranda", DarkSlateGray);
      }
      else
      {
      ObjectMove("dlyh label", 0, Time[20], dlyh);
      }

      if(ObjectFind("dlyl label") != 0)
      {
      ObjectCreate("dlyl label", OBJ_TEXT, 0, Time[20], dlyl);
      ObjectSetText("dlyl label", "Yesterdays Low", 10, "Veranda", DarkSlateGray);
      }
      else
      {
      ObjectMove("dlyl label", 0, Time[20], dlyl);
      }

// Draw Yesterday's High/Low lines on chart

      if(ObjectFind("dlyh line") != 0)
      {
      ObjectCreate("dlyh line", OBJ_HLINE, 0, Time[40], dlyh);
      ObjectSet("dlyh line", OBJPROP_STYLE, STYLE_DASH);
      ObjectSet("dlyh line", OBJPROP_WIDTH,0 );
      ObjectSet("dlyh line", OBJPROP_COLOR, DarkSlateGray);
      //Alert("Daily Low" ,Symbol()," ",Period()," @ ",Bid);PlaySound("sound7.wav");
      }
      else
      {
      ObjectMove("dlyh line", 0, Time[40], dlyh);
      }

      if(ObjectFind("dlyl line") != 0)
      {
      ObjectCreate("dlyl line", OBJ_HLINE, 0, Time[40], dlyl);
      ObjectSet("dlyl line", OBJPROP_STYLE, STYLE_DASH);
      ObjectSet("dlyl line", OBJPROP_WIDTH, 0);
      ObjectSet("dlyl line", OBJPROP_COLOR, DarkSlateGray);
      //Alert("Daily High" ,Symbol()," ",Period()," @ ",Bid);PlaySound("sound7.wav");
      }
      else
      {
      ObjectMove("dlyl line", 0, Time[40], dlyl);
      }

   return(0); // End program

  }

//+------------------------------------------------------------------+

