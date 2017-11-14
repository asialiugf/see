int iBarStyle(int barShift)
{
	int ret = 0;
	double open, close, high, low;
	open  = iOpen(NULL, 0, barShift);
	close = iClose(NULL, 0, barShift);
	high  = iHigh(NULL, 0, barShift);
	low   = iLow(NULL, 0, barShift);

	if (open< close && open==low && close == high)
	{
		ret = 1;
	}
	if (open < close && open == high && close == low)
	{
		ret = -1;
	}
	if (open < close && open > low && close == high)
	{
		ret = 2;
	}
	if (open > close && open == high && close > low)
	{
		ret = -2;
	}
	if (open < close && open == low && close < high)
	{
		ret = 3;
	}
	if (open > close && open < high && close == low)
	{
		ret = -3;
	}
	if (open > close && open > low && close < high)
	{
		ret = 4;
	}
	if (open > close && open < high && close > low)
	{
		ret = -4;
	}
	if (open == close && open == low && close < high)
	{
		ret = 5;
	}
	if (open == close && open == high && close > low)
	{
		ret = -5;
	}
	if (open == close && open > low && close < high)
	{
		ret = 6;
	}
	if (open == close && open == high && close == low)
	{
		ret = -6;
	}
   return (ret);
}

int start()
{
	return (0);
}

int init()
{
	int i = 0;
	for (;i < Bars;i++)
	{
		Print("Bars "+i+": "+ iBarStyle(i));
	}
	return (0);
}

int deinit()
{
	return (0);
}