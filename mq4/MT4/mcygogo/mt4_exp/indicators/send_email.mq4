#property  indicator_chart_window
extern int �������=1;
datetime NextTime=0;
int start()   
{
   string subject;
   string text;
   subject = "�˻���"+AccountName()+" ��Ϣ";
   //text = "�˻����:"+AccountBalance()+" �˻���ֵ:"+AccountEquity()+" �˻���֤��:"+AccountMargin()+" �˻�����"+AccountProfit();
   text = collect_onHoldOrder();
   //Print(subject+" "+text);
	if( TimeLocal()>NextTime)         
	{
		SendMail(subject, text);
         NextTime=TimeLocal()+�������*60;
    }
    return(0);
}

string collect_onHoldOrder(){
   int i=OrdersHistoryTotal();
   string tmp="";
   tmp=StringConcatenate(tmp,"\n","OrderClosePrice,OrderCloseTime,OrderComment,OrderCommission,OrderExpiration,OrderLots,OrderMagicNumber, OrderOpenPrice, OrderOpenTime, OrderProfit, OrderStopLoss, OrderSwap, OrderSymbol, OrderTakeProfit, OrderTicket, OrderType,AccountServer,AccountCompany,AccountNumber,AccountName,AccountCurrency,AccountLeverage,AccountBalance,AccountEquity,AccountMargin,AccountFreeMargin");
   for (;i>=0;i--) 
   {
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES ))
      {
         tmp=StringConcatenate(tmp,"\n",OrderClosePrice(),",",OrderCloseTime(),",",OrderComment(),",",OrderCommission(),",",OrderExpiration(),",",OrderLots(),",",OrderMagicNumber(),",", OrderOpenPrice(),",", OrderOpenTime(),",", OrderProfit(),",", OrderStopLoss(),",", OrderSwap(),",", OrderSymbol(),",", OrderTakeProfit(),",", OrderTicket(),",", OrderType(),",",AccountServer(),",",AccountCompany(),",",AccountNumber(),",",AccountName(),",",AccountCurrency(),",",AccountLeverage(),",",AccountBalance(),",",AccountEquity(),",",AccountMargin(),",",AccountFreeMargin()); 
      }
   }
   return(tmp);
}