/*
 * Copyright (C) AsiaLine
 * Copyright (C) kkk, Inc.
*/


#ifndef _SEE_TALIB_H_INCLUDED_
#define _SEE_TALIB_H_INCLUDED_


#define SEE_NULL -2147483648
/*
#define PREFLAG if( H[i]==L[i] ) { \
                    if( C[i]>=H[i-1] && C[i]>L[i-1] ) { *preF=1;  }else{ \
                    if( C[i]<=L[i-1] && C[i]<H[i-1] ) { *preF=-1; }else{ \
                    if( C[i]< H[i-1] && C[i]>L[i-1] ) { *preF=0;  }}} \
                }else{ *preF=0; }

#define R_VALUE     if ( Hest-Lest != 0 ) { R[i] = (C[i]-Lest)/(Hest-Lest)*100 ; }else{ \
                    if (*preF==1){R[i]=100;}else if(*preF==-1){R[i]=0;}else if(*preF==0){R[i]=R[i-1];}}
*/
int SEE_EMA( int start, int end, const double in[], int N, double out[] ) ;
int SEE_SMA( int start, int end, const double in[], int N, int M, double out[] ) ;
int SEE_LMA( int start, int end, const double in[], char F, int N, int M, double out[] ) ;
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
             double        R[],          /* R:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100; */
             double        K[],          /*    */
             double        D[],
             double        J[] ) ;

int SEE_MA(  int           start,
             int           end,
             const double  in[],        /* outReal index and inReal index must be the same */
             int           N,           /* From 0 to 100000                                */
             double        out[] ) ;    /* out index and in index must be the same         */
                                        /* out 初始化为 SEE_NULL                           */


#endif /* _SEE_TALIB_H_INCLUDED_ */
