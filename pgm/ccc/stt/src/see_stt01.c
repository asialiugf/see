#include <see_com_common.h>
/*
 * stt01 data 
*/

static double   R1[100],      K1[100],    D1[100],     J1[100],      E1[100];
static double   R2[500],      K2[500],    D2[500],     J2[500],      E2[500];
static double   R3[2200],     K3[2200],   D3[2200],    J3[2200],     E3[2200];
static double   R4[10000],    K4[2200],   D4[2200],    J4[2200],     E4[2200];
static double   preH1,preH2,preH3;
static double   preL1,preL2,preL3;
static int      preF1,preF2,preF3;

int see_stt01_data_init()
{
    int i;
    for( i=0;i<100;i++ )
    {
        R1[i] = SEE_NULL ;
        R2[i] = SEE_NULL ;
        R3[i] = SEE_NULL ;
    }
    for( i=100;i<500;i++ )
    {
        R2[i] = SEE_NULL ;
        R3[i] = SEE_NULL ;
    }
    for( i=500;i<2200;i++ )
    {
        R3[i] = SEE_NULL ;
    }

    preH1 = SEE_NULL ;
    preH2 = SEE_NULL ;
    preH3 = SEE_NULL ;

    preL1 = SEE_NULL ;
    preL2 = SEE_NULL ;
    preL3 = SEE_NULL ;

    preF1 = SEE_NULL ;
    preF2 = SEE_NULL ;
    preF3 = SEE_NULL ;
    return 0;
}

int see_stt01 ( const double   H[],
                const double   L[],
                const double   C[],
                char            c_save,   
                int            *i_buysell )
{
    int i_len ;

    if (c_save == 's' )
    {
        i_len = sizeof(double)*99 ;
        memcpy( (char *)&R1[0], (char *)&R1[1], i_len ) ;
        memcpy( (char *)&K1[0], (char *)&K1[1], i_len ) ;
        memcpy( (char *)&D1[0], (char *)&D1[1], i_len ) ;
        memcpy( (char *)&J1[0], (char *)&J1[1], i_len ) ;
        memcpy( (char *)&E1[0], (char *)&E1[1], i_len ) ;
        i_len = sizeof(double)*499 ;
        memcpy( (char *)&R2[0], (char *)&R2[1], i_len ) ;
        memcpy( (char *)&K2[0], (char *)&K2[1], i_len ) ;
        memcpy( (char *)&D2[0], (char *)&D2[1], i_len ) ;
        memcpy( (char *)&J2[0], (char *)&J2[1], i_len ) ;
        memcpy( (char *)&E2[0], (char *)&E2[1], i_len ) ;
        i_len = sizeof(double)*2199 ;
        memcpy( (char *)&R3[0], (char *)&R3[1], i_len ) ;
        memcpy( (char *)&K3[0], (char *)&K3[1], i_len ) ;
        memcpy( (char *)&D3[0], (char *)&D3[1], i_len ) ;
        memcpy( (char *)&J3[0], (char *)&J3[1], i_len ) ;
        memcpy( (char *)&E3[0], (char *)&E3[1], i_len ) ;
    }

    SEE_KDJ( 99,99,    &H[0],&L[0],&C[0],&preH1,&preL1,&preF1,45,15,15,      &R1[0],&K1[0],&D1[0],&J1[0] ) ;      // 5
    SEE_KDJ( 499,499,  &H[0],&L[0],&C[0],&preH1,&preL1,&preF1,225,75,75,     &R2[0],&K2[0],&D2[0],&J2[0] ) ;      // 25
    SEE_KDJ( 2199,2199,&H[0],&L[0],&C[0],&preH1,&preL1,&preF1,1125,375,375,  &R3[0],&K3[0],&D3[0],&J3[0] ) ;      // 125
    SEE_KDJ( 9999,9999,&H[0],&L[0],&C[0],&preH1,&preL1,&preF1,5625,1875,1875,&R4[0],&K4[0],&D4[0],&J4[0] ) ;      // 625

    SEE_EMA( 99,99,    &J1[0],5,  &E1[0] ) ; 
    SEE_EMA( 499,499,  &J2[0],25, &E2[0] ) ; 
    SEE_EMA( 2199,2199,&J3[0],125,&E3[0] ) ; 
    SEE_EMA( 9999,9999,&J4[0],625,&E4[0] ) ; 

    return 0 ;
}
