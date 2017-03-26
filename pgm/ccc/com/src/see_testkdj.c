#include <see_com_common.h>

char ca_errmsg[512] ;

char      tt[10000][9] ;
double   hh[10000] ;
double   ll[10000] ;
double   cc[10000] ;
double   oo[10000] ;
double    outLMA[10000] = {SEE_NULL} ;
double    R[10000] = {SEE_NULL} ;
double    K[10000] = {SEE_NULL} ;
double    D[10000] = {SEE_NULL};
double    J[10000] = {SEE_NULL};
double    preH = SEE_NULL ;
double    preL = SEE_NULL ;
int       preF = SEE_NULL ;

int bar_len ;

double       HighestPrice1 ;
double       HighestPrice2 ;
double       HighestPrice3 ;
double       LowestPrice1 ;
double       LowestPrice2 ;
double       LowestPrice3 ;

int       outBegIdx1 ;
int       outBegIdx2 ;
int       outBegIdx3 ;
int       outNBElement1 ;
int       outNBElement2 ;
int       outNBElement3 ;
double    outSlowK1[10000] ;
double    outSlowD1[10000] ;
double    outSlowJ1[10000] ;
double    J1[10000] ;
double    JE1[10000] ;
double    outSlowK2[10000] ;
double    outSlowD2[10000] ;
double    outSlowJ2[10000] ;
double    J2[10000] ;
double    JE2[10000] ;
double    outSlowK3[10000] ;
double    outSlowD3[10000] ;
double    outSlowJ3[10000] ;
double    J3[10000] ;
double    JE3[10000] ;

int
main(int iArgCnt, char *pcaArgVec[])
{
    int i_rtn =0 ;
    int i_count ;
    FILE *pf_file ;

    see_bar_t bar ;


    pf_file = fopen("../../dat/hloc.bin","rb");
    if (pf_file == NULL) {
        see_errlog(1000,(char *)"open ../../dat/hloc.bin error!!",RPT_TO_LOG,0,0) ;
        return -1 ;
    }

    for( i_count=0; i_count<10000; i_count++ )
    {
        outLMA[i_count] = SEE_NULL ; R[i_count] = SEE_NULL ; K[i_count] = SEE_NULL ; D[i_count] = SEE_NULL; J[i_count] = SEE_NULL;
    }

    i_count = 0 ;
    while ( (i_rtn = fread(&bar,sizeof(see_bar_t),1,pf_file)) != 0 )
    {
        memset(tt[i_count],'\0',9) ; 
        memcpy(tt[i_count],bar.ca_btime,8) ;
        hh[i_count] = bar.h ;
        ll[i_count] = bar.l ;
        oo[i_count] = bar.o ;
        cc[i_count] = bar.c ;
        i_count++ ;
        // see_errlog(1000,ca_errmsg,RPT_TO_LOG,(char*)&bar,sizeof(see_bar_t)) ;
    }
    
    bar_len = i_count ;
    usleep(1000) ;
    fclose(pf_file);
/*
    for( i_count=0; i_count<bar_len; i_count++ )
    {
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,
                    "hhhhhhhhhhh:\t %s \t %10.2f \t %10.2f \t %10.2f \t %10.2f ",
                    tt[i_count],hh[i_count],ll[i_count],oo[i_count],cc[i_count] ) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }

    for( i_count=0; i_count<bar_len; i_count++ )
    {
        SEE_LMA(i_count,i_count, &cc[0], 5, 2, &outLMA[0]) ;
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,"goodgood: \t %10.4f",outLMA[i_count]) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }

    SEE_LMA(0,bar_len, &cc[0], 3, 1, &outLMA[0]) ;
    for( i_count=0; i_count<bar_len; i_count++ )
    {
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,"hahahah: \t %10.4f",outLMA[i_count]) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }
*/

/*
    for( i_count=0; i_count<bar_len; i_count++ )
    {
        SEE_KDJ( i_count, i_count, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 9, 3, 3, &R[0], &K[0], &D[0], &J[0] ) ;
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,
                    "99999999:\t%s \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f ",
                    tt[i_count],oo[i_count],hh[i_count],ll[i_count],cc[i_count],R[i_count],K[i_count],D[i_count],J[i_count] ) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }
*/

    preH=SEE_NULL; preL=SEE_NULL; preF=SEE_NULL ;
    for( i_count=0; i_count<bar_len; i_count++ )
    {
        SEE_KDJ( i_count, i_count, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 45, 15, 15, &R[0], &K[0], &D[0], &J[0] ) ;
        SEE_EMA( i_count, i_count, &J[0], 5, &outLMA[0] ) ; 
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,
            "11111111:\t%s \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f ",
            tt[i_count],oo[i_count],hh[i_count],ll[i_count],cc[i_count],R[i_count],K[i_count],D[i_count],J[i_count],outLMA[i_count] ) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    } 

    for( i_count=0; i_count<bar_len; i_count++ )
    { R[i_count] = SEE_NULL; }

    for( i_count=0; i_count<bar_len; i_count++ ) {
                memset( ca_errmsg,'\0',512 );
                sprintf( ca_errmsg,"UUUUUUUU: %10.2f  %10.2f  %10.2f  ",K[i_count],D[i_count],J[i_count] );
                see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }

    for( i_count=0; i_count<10000; i_count++ )
    {
        outLMA[i_count] = SEE_NULL ; R[i_count] = SEE_NULL ; K[i_count] = SEE_NULL ; D[i_count] = SEE_NULL; J[i_count] = SEE_NULL;
    }

    preH=SEE_NULL; preL=SEE_NULL; preF=SEE_NULL ;
    SEE_KDJ( 0, 0, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 225, 75, 75, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_KDJ( 1, 30, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 225, 75, 75, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_KDJ( 31, 60, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 225, 75, 75, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_KDJ( 61, 999, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 225, 75, 75, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_KDJ( 1000, bar_len, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 225, 75, 75, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_EMA( 0, bar_len, &J[0], 25, &outLMA[0] ) ; 

    for( i_count=0; i_count<bar_len; i_count++ )
    {
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,
            "22222222:\t%s \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f ",
            tt[i_count],oo[i_count],hh[i_count],ll[i_count],cc[i_count],R[i_count],K[i_count],D[i_count],J[i_count],outLMA[i_count] ) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }


    for( i_count=0; i_count<bar_len; i_count++ )
    { R[i_count] = SEE_NULL; }

    for( i_count=0; i_count<10000; i_count++ )
    {
        outLMA[i_count] = SEE_NULL ; R[i_count] = SEE_NULL ; K[i_count] = SEE_NULL ; D[i_count] = SEE_NULL; J[i_count] = SEE_NULL;
    }
    preH=SEE_NULL; preL=SEE_NULL; preF=SEE_NULL ;
    SEE_KDJ( 0, bar_len, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 1125, 375, 375, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_EMA( 0, bar_len, &J[0], 125, &outLMA[0] ) ; 

    for( i_count=0; i_count<bar_len; i_count++ )
    {
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,
            "33333333:\t%s \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f ",
            tt[i_count],oo[i_count],hh[i_count],ll[i_count],cc[i_count],R[i_count],K[i_count],D[i_count],J[i_count],outLMA[i_count] ) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }



    for( i_count=0; i_count<bar_len; i_count++ )
    { R[i_count] = SEE_NULL; }
    for( i_count=0; i_count<10000; i_count++ )
    {
        outLMA[i_count] = SEE_NULL ; R[i_count] = SEE_NULL ; K[i_count] = SEE_NULL ; D[i_count] = SEE_NULL; J[i_count] = SEE_NULL;
    }
    preH=SEE_NULL; preL=SEE_NULL; preF=SEE_NULL ;
    SEE_KDJ( 0, 0, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 45, 15, 15, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_KDJ( 1, 30, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 45, 15, 15, &R[0], &K[0], &D[0], &J[0] ) ;
    preH=SEE_NULL; preL=SEE_NULL; preF=SEE_NULL ;
    SEE_KDJ( 30, 60, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 45, 15, 15, &R[0], &K[0], &D[0], &J[0] ) ;
    preH=SEE_NULL; preL=SEE_NULL; preF=SEE_NULL ;
    SEE_KDJ( 40, 999, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 45, 15, 15, &R[0], &K[0], &D[0], &J[0] ) ;
    SEE_KDJ( 1000, bar_len, &hh[0], &ll[0], &cc[0], &preH, &preL, &preF, 45, 15, 15, &R[0], &K[0], &D[0], &J[0] ) ;

    for( i_count=0; i_count<bar_len; i_count++ )
    {
        memset( ca_errmsg,'\0',512 );
        sprintf(ca_errmsg,
                    "44444444:\t%s \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f \t %10.2f ",
                    tt[i_count],oo[i_count],hh[i_count],ll[i_count],cc[i_count],R[i_count],K[i_count],D[i_count],J[i_count] ) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }

    return SEE_OK;
}
