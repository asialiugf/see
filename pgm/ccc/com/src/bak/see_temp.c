
    struct timeval start, end;
    gettimeofday( &start, NULL );
    gettimeofday( &end,NULL );
    memset( ca_errmsg,'\0',100 );
    sprintf( ca_errmsg,"==== calc-time =========: sec:%lu usec:%lu \n",end.tv_sec-start.tv_sec,end.tv_usec-start.tv_usec ) ;
    see_errlog( 1000,ca_errmsg,RPT_TO_LOG,0,0 ) ;

/* Generated */ TA_RetCode TA_STOCH( int    startIdx,
/* Generated */                      int    endIdx,
/* Generated */                      const double inHigh[],
/* Generated */                      const double inLow[],
/* Generated */                      const double inClose[],
/* Generated */                      int           optInFastK_Period, /* From 1 to 100000 */
/* Generated */                      int           optInSlowK_Period, /* From 1 to 100000 */
/* Generated */                      TA_MAType     optInSlowK_MAType,
/* Generated */                      int           optInSlowD_Period, /* From 1 to 100000 */
/* Generated */                      TA_MAType     optInSlowD_MAType,
/* Generated */                      int          *outBegIdx,
/* Generated */                      int          *outNBElement,
/* Generated */                      double        outSlowK[],
/* Generated */                      double        outSlowD[] )
/* Generated */ #endif

TA_Real   hh[10000] ;
TA_Real   ll[10000] ;
TA_Real   cc[10000] ;
TA_Real   oo[10000] ;


int       outBegIdx1 ;
int       outBegIdx2 ;
int       outBegIdx3 ;
int       outNBElement1 ;
int       outNBElement2 ;
int       outNBElement3 ;
double    outSlowK1[10000] ;
double    outSlowD1[10000] ;
double    J1[10000] ;
double    JE1[10000] ;
double    outSlowK2[10000] ;
double    outSlowD2[10000] ;
double    J2[10000] ;
double    JE2[10000] ;
double    outSlowK3[10000] ;
double    outSlowD3[10000] ;
double    J3[10000] ;
double    JE3[10000] ;


    TA_STOCH( 0,1000, &hh[0], &ll[0], &cc[0], 9*5, 3*5, TA_MAType_LMA,
        3*5,TA_MAType_LMA, &outBegIdx1,&outNBElement1,&outSlowK1[0], &outSlowD1[0] ) ;

当日指数平均值=平滑系数*（当日指数值-昨日指数平均值）+昨日指数平均值；
平滑系数=2/（周期单位+1）；
由以上指标推导开，得到：EMA(C,N)=2*C/(N+1)+(N-1)/(N+1)*昨天的指数收盘平均值；
由以上指标推导开，得到：EMA(C,N)=2*C/(N+1)+(N-1)/(N+1)*Y'
                        EMA(C,N)=(2/(N+1)) * (C-Y') + Y'
算法是：若Y=EMA(C,N)，则Y=[2*X+(N-1)*Y']/(N+1)，其中Y’表示上一周期的Y值。

Y=EMA(C,N) ==> Y = (  2/(N+1) ) * ( C-Y' ) + Y' ;
               Y = [ 2*C + (N-1)*Y' ] / (N+1) ;

Y = SMA(C,N,M) ;

SMA(X,N,M)=SMA(X,N*2/M,2)=EMA(X,(N*2/M)-1);

SMA(X,N,M)，求X的N日移动平均，M为权重。算法：若Y=SMA(X,N,M) 则 Y=(M*X+(N-M)*Y')/N，其中Y'表示上一周期Y值，N必须大于M。



            gettimeofday( &start, NULL );
            see_calc_k_bar(pt_blocks[idx],buf,BAR_1F) ;
            gettimeofday( &ed, NULL );
            cha2 = end.tv_usec-start.tv_usec ;
            cha1 = end.tv_sec-start.tv_sec ;


            gettimeofday( &start, NULL );
            memset( ca_errmsg,'\0',100 );
            sprintf( ca_errmsg,"==== see_calc_k_bar  =========: sec:%lu usec:%lu \n",cha1,cha2 ) ;
            see_errlog( 1000,ca_errmsg,RPT_TO_LOG,0,0 ) ;
            gettimeofday( &end, NULL );
            cha2 = end.tv_usec-start.tv_usec ;
            cha1 = end.tv_sec-start.tv_sec ;


            memset( ca_errmsg,'\0',100 );
            sprintf( ca_errmsg,"==== errlog      =========: sec:%lu usec:%lu \n",cha1,cha2 ) ;
            see_errlog( 1000,ca_errmsg,RPT_TO_LOG,0,0 ) ;



            /* -----------------------  异常处理 ------------------------- */
            if( memcmp(ca_UpdateTime,"22:59",5) ==0 && memcmp(t_data->UpdateTime,"23:29",5) ==0  ) {continue;} //异常处理
            if( memcmp(t_data->TradingDay,ca_TradingDay,8) ==0 )
            {
                uiui = see_time_to_int(t_data->UpdateTime) ;
                mimi = see_time_to_int(ca_UpdateTime) ;
                if ( uiui < mimi ) { continue; }
            }  // 异常处理：下一个K的时间比前一个K的时间还早，那就直接返回。
            memcpy(ca_TradingDay,t_data->TradingDay,8);
            memcpy(ca_UpdateTime,t_data->UpdateTime,8);
            /* -----------------------  异常处理 ------------------------- */





