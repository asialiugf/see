#include <see_com_common.h>

//char errmsg[1024] ;
//char tmpmsg[1024] ;

#define PREFLAG if( H[i]==L[i] ) { \
                    if( C[i]>=H[i-1] && C[i]>L[i-1] ) { *preF=1;  }else{ \
                    if( C[i]<=L[i-1] && C[i]<H[i-1] ) { *preF=-1; }else{ \
                    if( C[i]< H[i-1] && C[i]>L[i-1] ) { *preF=0;  }}} \
                }else{ *preF=0; }

#define R_VALUE     if ( Hest-Lest != 0 ) { R[i] = (C[i]-Lest)/(Hest-Lest)*100 ; }else{ \
                    if (*preF==1){R[i]=100;}else if(*preF==-1){R[i]=0;}else if(*preF==0){R[i]=R[i-1];}}


int SEE_EMA( int           start,
             int           end,
             const double  in[],        /* outReal index and inReal index must be the same */
             int           N,           /* From 0 to 100000          EMA(C,N)              */
             double        out[] )      /* out index and in index must be the same     */
                                        /* out 初始化为 SEE_NULL                       */
{
    if ( start<0 )  return -1 ;
    if ( end<0 )  return -1 ;
    if ( N<0 || N>100000 )  return -1 ;
    if ( end < start ) return -1 ;
    if ( SEE_LMA(start,end,&in[0],'E',N,2,&out[0]) != 0 ){ return -1; }
    return 0 ;
}


int SEE_SMA( int           start,
             int           end,
             const double  in[],        /* outReal index and inReal index must be the same */
             int           N,           /* From 0 to 100000                                */
             int           M,           /* SMA(C,N,M)                                      */
             double        out[] )      /* out index and in index must be the same     */
                                        /* out 初始化为 SEE_NULL                       */
{
    if ( start<0 )  return -1 ;
    if ( end<0 )  return -1 ;
    if ( M<0 || M>100000 )  return -1 ;
    if ( N<0 || N>100000 )  return -1 ;
    if ( M > N ) return -1 ;
    if ( end < start ) return -1 ;
    if ( SEE_LMA(start,end,&in[0],'S',N,M,&out[0]) != 0 ){ return -1; }
    return 0 ;
}

/*
 * 要注意：
 *  1、 N必须小于in[]数组的长度，程序内没有做检查，需要调用时注意。
 *  2、 in[]和out[]的长度必须一致。比如 in[]是从0到0到1000,那out[]也必须是从0到1000。
 *  3、 输入时，须写成&in[0],&out[0],是不是可以 &in[100],&out[100] 需要测试。
 *  4、 如果只需要计算第X的MA的话，输入的in[]只需要 从 X-N到X的值 就可以了，如果有out[X-1]的值，会加快计算。
 *  5、 out如果没有值的话，必须初始化为SEE_NULL 
 *  6、 如果要计算第888处的MA的话，一般情况start和end需输入为888，并且&in[0],和&out[0]开始。
 *      但是，如果N比较小，比如只有5，那可以输入为： N=5,start=5,end=5, &in[888-5],&out[888-5]即可。
 *      这样的话，只需要存储 in[X-N]到in[X]，共N+1个值即可。
*/


int SEE_MA(  int           start,
             int           end,
             const double  in[],        /* outReal index and inReal index must be the same */
             int           N,           /* From 0 to 100000                                */
             double        out[] )      /* out index and in index must be the same     */
                                        /* out 初始化为 SEE_NULL                       */
{
    int     i ;
    double  preMA ;

    if ( start<0 )  return -1 ;
    if ( end<0 )  return -1 ;
    if ( N<0 || N>100000 )  return -1 ;
    if ( end < start ) return -1 ;

    if ( N == 0 )
    {
        for ( i=start;i<=end;i++ )
        {
            out[i] = (double) 0 ;
        }
        return 0 ;
    }

    if ( N == 1 )
    {
        for ( i=start;i<=end;i++ )
        {
            out[i] = in[i] ;
        }
        return 0 ;
    }

    if ( end <= N-1 )
    {
        for( i=start; i<=end; i++ )
        {
            out[i] = (double) 0 ;
        }
        if ( end == N-1 )
        {
            preMA = (double) 0 ;
            for( i=0; i<=end; i++ )
            {
                preMA = preMA+in[i] ;
            }
            out[end] = preMA/N ;
        }
        return 0;
    } else {
        if ( start < N-1 ) 
        {
            for( i=start; i<N-1; i++ )
            {
                out[i] = (double) 0 ;
            }
            preMA = (double) 0 ;
            for( i=0; i<=N-1; i++ )
            {
                preMA = preMA+in[i] ;
            }

            out[N-1] = preMA/N ;
            for( i=N; i<=end; i++ )
            {
                preMA = preMA+in[i]-in[i-N] ;
                out[i] = preMA/N ;
            }

        } else {
            if ( out[start-1] == SEE_NULL ) {
                preMA = (double) 0 ;
                for( i=start-N; i<start; i++ )
                {
                    preMA = preMA+in[i] ;
                }
            }else{
                preMA = out[start-1]*N ;
            }
            for( i=start; i<=end; i++ )
            {
                preMA = preMA+in[i]-in[i-N] ;
                out[i] = preMA/N ;
            }
        }
    }
    return 0;
}


int SEE_LMA( int           start,
             int           end,
             const double  in[],        /* outReal index and inReal index must be the same */
             char          F,           /*  F='E':EMA,       F='S':SMA,                    */ 
             int           N,           /* From 0 to 100000                                */
             int           M,           /* M for  M/(N+1)                                  */
                                        /*  M must less than N:optInTimePeriod         */
             double        out[] )      /* out index and in index must be the same     */
                                        /* out 初始化为 SEE_NULL                       */
{
    int    i ;
    double R ;
    double preMA ;

    if ( start<0 )  return -1 ;
    if ( end<0 )  return -1 ;
    if ( M<0 || M>100000 )  return -1 ;
    if ( N<0 || N>100000 )  return -1 ;
    if ( M > N ) return -1 ;
    if ( end < start ) return -1 ;

    if ( F == 'E' ) {
        R = (double) 2 / (double) (N+1) ;
    }else if ( F == 'S' ) {
        R = (double) M / (double) N ;
    } else { return -1; }
    
/*
    if ( M ==2 ) {
        R = (double) M / (double) (N+1) ;
    }else{
        R = (double) M / (double) N ;
    }
*/
    
    if ( N == 0 )
    {
        for ( i=start;i<=end;i++ )
        {
            out[i] = (double) 0 ;
        }
        return 0 ;
   }

   if ( N == 1 )
   {
        for ( i=start;i<=end;i++ )
        {
            out[i] = in[i] ;
        }
        return 0 ;
   }    

   if ( start == 0 )
   {
        preMA = in[0] ; 
        out[0] = in[0] ;
        for( i=1; i<=end; i++)       
        {
            preMA =( R*( in[i]-preMA ) ) + preMA ;
            out[i] = preMA ; 
        }
    } else {
        if ( out[start-1] == SEE_NULL ) {
            preMA = in[0] ;
            out[0] = in[0] ;
            for( i=1; i<=end; i++)       
            {
                preMA =( R*( in[i]-preMA ) ) + preMA ;   
                out[i] = preMA ; 
            }   
        }else{
            preMA = out[start-1] ;
            for( i=start; i<=end; i++)
            {
                preMA =( R*( in[i]-preMA ) ) + preMA ;
                out[i] = preMA ; 
            }
        }
    }

    return 0 ;
}

/*
R:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100;
K:=SMA(R,M1,1);
D:=SMA(K,M2,1);
J:=3*K-2*D;
*/


int SEE_KDJ( int           start,
             int           end,
             const double  H[],          /* outReal index and inReal index must be the same */
             const double  L[],          /* outReal index and inReal index must be the same */
             const double  C[],          /* outReal index and inReal index must be the same */
             double        *preH,        /* pre highest price */
             double        *preL,        /* pre lowest price */
             int           *preF,        /* 记录是涨停还是跌停 */
             int           N,            /* R:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100; */
             int           M1,           /* K:=SMA(R,M1,1);                                     */
             int           M2,           /* D:=SMA(K,M2,1);                                     */
             double        R[],          /* R[] 必须初始化为 SEE_NULL ; !!!!!!!!!!!!!!!!!!!!!   */
             double        K[],          /* K[] 必须初始化为 SEE_NULL ; !!!!!!!!!!!!!!!!!!!!!   */
             double        D[],          /* D[] 必须初始化为 SEE_NULL ; !!!!!!!!!!!!!!!!!!!!!   */
             double        J[] )         /* K[] 必须初始化为 SEE_NULL ; !!!!!!!!!!!!!!!!!!!!!   */
{
    int    i ;
    int    k ;
	int    b ;
    double Hest ;
    double Lest ;

    if ( start<0 )  return -1 ;
    if ( end<0   )  return -1 ;
    if ( N<1 ||  N>100000 )  return -1 ;
    if ( M1<1 || M1>100000 )  return -1 ;
    if ( M2<1 || M2>100000 )  return -1 ;
    if ( end < start ) return -1 ;
/*
    R:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100;

    0 ........... N .....................
    s .. e ...... N .....................
    0 .. s ..e .. N .....................
    0 .. s .......N .. e ................
    0 ........... N ...s ... e ..........
*/
       
    /* 计算R[] */

    if( *preF != 1 && *preF != -1 && *preF != 0 ) { *preF=0; }

	if ( start>0 ) {
		if ( R[start-1] != SEE_NULL ) {b=0;} else {b=1;}
    } else {b=1;}
	
    if ( b==1 )  // ---need to calculate from 0 ------------------------------------------------------
    {
        Hest = H[0] ;
        Lest = L[0] ;
        if ( Hest-Lest != 0 ) { R[0] = (C[0]-Lest)/(Hest-Lest)*100 ; }else{
            if (*preF==1){R[0]=100;}else if(*preF==-1){R[0]=0;}else if(*preF==0){R[0]=50;}
        } // initial Hest and Lest from [0] .

        if( end < N ) {     
            for( i=1; i<=end; i++ ) {
                if( H[i]>Hest ) { Hest = H[i]; }
                if( L[i]<Lest ) { Lest = L[i]; }
                PREFLAG ;
                R_VALUE ;
            }
        }
        if ( end >= N ) {
            for( i=1; i<N; i++ )
            {
                if( H[i]>Hest ) { Hest = H[i]; }
                if( L[i]<Lest ) { Lest = L[i]; }
                PREFLAG ;
                R_VALUE ;
            }
            for( i=N; i<=end; i++ )
            {
                if ( H[i-N]<Hest ) {
                    if( H[i]>Hest ){ Hest = H[i]; }
                } else {
                    Hest = H[i-N+1] ; 
                    for ( k=1;k<=N;k++ )
                    {
                       if ( Hest<H[i-N+k] ) { Hest=H[i-N+k] ; } 
                    } 
                }
                if ( L[i-N]>Lest ) {
                    if( L[i]<Lest ){ Lest = L[i]; }
                } else {
                    Lest = L[i-N+1] ;
                    for ( k=1;k<=N;k++ )
                    {
                       if ( Lest>L[i-N+k] ) { Lest=L[i-N+k] ; }
                    }
                }
                PREFLAG ;
                R_VALUE ;
            }
        }
        *preH = Hest ;
        *preL = Lest ;

    } else {  // start>0 && R[start-1] 有数据 ----------------------------------------------------------- 
        if( end < N ) {
            if ( *preH == SEE_NULL || *preL == SEE_NULL ) {
                Hest = H[0] ;
                Lest = H[0] ;
                for ( k=1;k<=start-1;k++ ) {
                    if( H[k]>Hest ) { Hest = H[k]; }
                    if( L[k]<Lest ) { Lest = L[k]; }
                }
            } else { Hest = *preH ; Lest = *preL ; }

            for( i=start; i<=end; i++ ) {
                if( H[i]>Hest ) { Hest = H[i]; }
                if( L[i]<Lest ) { Lest = L[i]; }
                PREFLAG ;
                R_VALUE ;
            }
        }
        if( end >= N ) {
            if ( start < N ) {
                if ( *preH == SEE_NULL || *preL == SEE_NULL ) {
                    Hest = H[0] ;
                    Lest = H[0] ;
                    for ( k=1;k<=start-1;k++ ) {
                        if( H[k]>Hest ) { Hest = H[k]; }
                        if( L[k]<Lest ) { Lest = L[k]; }
                    }
                } else { Hest = *preH ; Lest = *preL ; }

                for( i=start; i<N; i++ ) {
                    if( H[i]>Hest ) { Hest = H[i]; }
                    if( L[i]<Lest ) { Lest = L[i]; }
                    PREFLAG ;
                    R_VALUE ;
                }
                for( i=N; i<=end; i++ )
                {
                    if ( H[i-N]<Hest ) {
                        if( H[i]>Hest ){ Hest = H[i]; }
                    } else {
                        Hest = H[i-N+1] ;
                        for ( k=1;k<=N;k++ )
                        {
                            if ( Hest<H[i-N+k] ) { Hest=H[i-N+k] ; }
                        }
                    }
                    if ( L[i-N]>Lest ) {
                        if( L[i]<Lest ){ Lest = L[i]; }
                    } else {
                        Lest = L[i-N+1] ;
                        for ( k=1;k<=N;k++ )
                        {
                            if ( Lest>L[i-N+k] ) { Lest=L[i-N+k] ; }
                        }
                    }
                    PREFLAG ;
                    R_VALUE ;
                }   
            }

            if ( start >=N ) {
                if ( *preH == SEE_NULL || *preL == SEE_NULL ) {
                    Hest = H[start-N] ;
                    Lest = H[start-N] ;
                    for ( k=start-N+1;k<=start-1;k++ ) {
                        if( H[k]>Hest ) { Hest = H[k]; }
                        if( L[k]<Lest ) { Lest = L[k]; }
                    }
                } else { Hest = *preH ; Lest = *preL ; }

                for( i=start; i<=end; i++ ) {
                    if ( H[i-N]<Hest ) {
                        if( H[i]>Hest ){ Hest = H[i]; }
                    } else {
                        Hest = H[i-N+1] ;
                        for ( k=1;k<=N;k++ )
                        {
                            if ( Hest<H[i-N+k] ) { Hest=H[i-N+k] ; }
                        }
                    }
                    if ( L[i-N]>Lest ) {
                        if( L[i]<Lest ){ Lest = L[i]; }
                    } else {
                        Lest = L[i-N+1] ;
                        for ( k=1;k<=N;k++ )
                        {
                            if ( Lest>L[i-N+k] ) { Lest=L[i-N+k] ; }
                        }
                    }
                    PREFLAG ;
                    R_VALUE ;
                }
            }
        }
        *preH = Hest ;
        *preL = Lest ;
    }
    SEE_SMA( start, end, &R[0], M1, 1, &K[0]) ;
    SEE_SMA( start, end, &K[0], M2, 1, &D[0]) ;
    for( i=start;i<=end;i++ ) { J[i]=3*K[i]-2*D[i]; }
    
    return 0 ;
}
