//-------自动加仓(对所有单有效）

void TrailPositions11()
{
	int cnt = OrdersTotal();
	for (int i=0; i<cnt; i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
			int type = OrderType();

		if (type == OP_SELL  )
		{
			if(CalculateSellOrders()<1  && CalculateSell()<10   && CalculateBuy()<1 && Close[0]<PJ1)
			{
				OrderSend(Symbol(),OP_SELLSTOP,LotSize() ,Bid-15*Point,3,Bid+15*Point,Bid-360*Point,"顺向挂STOP卖单",MAGICMA33,expire2,Green);
			}
			else
			{
				return (0);
			}
		}

	}
}


//-------自动加仓(对所有单有效）

void TrailPositions011()
{
	int cnt = OrdersTotal();
	for (int i = 0; i < cnt; i++)
	{
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
			int type = OrderType();

		if (type == OP_BUY )
		{
			if (CalculateBuyOrders()<1 && CalculateBuy()<10  && CalculateSell()<1   && Close[0]>PJ1)
			{
				OrderSend(Symbol(),OP_BUYSTOP,LotSize(),Ask+15*Point,3,Ask-15*Point,Ask+360*Point,"顺向挂STOP买单",MAGICMA33,expire2,Red);
			}
			else
			{
				return (0);
			}
		}
	}
}

//其中还有子函数限制开仓数：CalculateBuyOrders()买单挂仓单数，CalculateSellOrders()卖单挂仓单数；CalculateBuy()买单数，CalculateSell()卖单数；
//PJ1是一分钟平均线60；LotSize()按资金量开仓控制；
//1、CalculateBuyOrders()买单挂仓单数：

int CalculateBuyOrders()//计算STOP多挂单的张数
{
	int buys=0,sells=0;
	for(int i = 0; i<OrdersTotal(); i++)
	{
		if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) 
		{
			break;
		}
		if(OrderType()==OP_BUYSTOP && OrderSymbol() == Symbol())
		{
			buys++;
		}
	}
	return(buys);
}


//2、CalculateSellOrders()卖单挂仓单数；
int CalculateSellOrders()// 算STOP空挂单的张数
{
	int buys=0,sells=0;
	for(int i = 0;i < OrdersTotal();i++)
	{
		if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false)
		{
			break;
		}
		if(OrderType() == OP_SELLSTOP && OrderSymbol() == Symbol())
		{
			sells++;
		}
	}	
	return(sells);
}

//3、CalculateBuy()买单数；

int CalculateBuy()//计算多单的张数
{
	int buys=0,sells=0;
	for(int i = 0; i<OrdersTotal(); i++)
	{
		if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) 
		{
			break;
		}
		if(OrderType() == OP_BUY && OrderSymbol() == Symbol())    
		{
			buys++;
		}
	}
	return(buys);
}

//4、CalculateSell()卖单数；
int CalculateSell()// 算空单的张数
{
	int buys=0,sells=0;
	for(int i = 0; i < OrdersTotal(); i++)
	{
		if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false)
		{
			break;
		}
 		if(OrderType()==OP_SELL && OrderSymbol() == Symbol())
 		{
 			sells++;
 		}
	}
	return(sells);
}

 

//5、LotSize()按资金量开仓控制；
double LotSize() // 下单数量
{ 
	double lot=Lots;
	int orders=HistoryTotal(); // history orders total
	int losses=0; // number of losses orders without a break
	//MarketInfo(Symbol(),MODE_MINLOT); 相关信息
	//MarketInfo(Symbol(),MODE_MAXLOT);
	//MarketInfo(Symbol(),MODE_LOTSTEP);
	lot= AccountEquity()/2000; //开仓量计算
	if(lot<0.05)
	{
		lot=0.01;
	}
	if(lot>=0.05 && lot<0.07) 
	{
		lot=0.06;
	}
	if(lot>=0.07 && lot<0.09) 
		lot=0.08;
	if(lot>=0.09 && lot<0.2) 
		lot=0.1;
	if(lot>=0.2 && lot<0.3) 
		lot=0.2;
	if(lot>=0.3 && lot<0.5) 
		lot=0.4;
	if(lot>=0.5 && lot<0.7) 
		lot=0.6;
	if(lot>=0.7 && lot<0.9) 
		lot=0.8;
	if(lot>=0.9 && lot<2) 
		lot=1;
	if(lot>=2 && lot<3) 
		lot=2;
	if(lot>=3 && lot<5) 
		lot=4;
	if(lot>=5 && lot<7) 
		lot=6;
	if(lot>=7 && lot<9) 
		lot=8;
	if(lot>=9  ) 
		lot=10;

	return(lot);
}
  

 


 


