#include <sys/time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <float.h>
#include <zlib.h>

int main()
{
    int ia_kkk[10000] ;
    int i=0;
    struct timeval start, end;
    int cha2;
    int cha1;
    // int i_len = sizeof(int)*9999 ;



    char ca_s1[256]; 
    char ca_s2[256]; 
    char ca_s3[256]; 
    char ca_s4[256]; 
    char ca_s5[1024]; 


    memset(ca_s1,'\0',256) ;
    memset(ca_s2,'\0',256) ;
    memset(ca_s3,'\0',256) ;
    memset(ca_s4,'\0',256) ;
    memset(ca_s5,'\0',1024) ;
    sprintf( ca_s1,"%s",(char *)"1111111111") ;
    sprintf( ca_s2,"%s",(char *)"1111111111") ;
    sprintf( ca_s3,"%s",(char *)"1111111111") ;
    sprintf( ca_s4,"%s",(char *)"1111111111") ;
    sprintf( ca_s5,"%s",(char *)"1111111111") ;

    

    for ( i=0;i<10000;i++ )
    {
        ia_kkk[i] = i ;
    }

    gettimeofday( &start, NULL );
    for ( i=0;i<10000;i++ )
    {
        sprintf( ca_s5,"%s",ca_s1) ;
    }

    gettimeofday( &end, NULL );
    printf( "kkk[0]:%d\n", ia_kkk[0] ) ;

    cha2 = end.tv_usec-start.tv_usec ;
    cha1 = end.tv_sec-start.tv_sec ;
    printf( "--------------------  sec:%d usec:%d\n",cha1,cha2 );

    // i = NULL ;
    double d_kk ;
    d_kk = DBL_MAX ;
    printf( "d_kk is 0!!%f \n",d_kk ) ;
    if ( DBL_MAX == d_kk )
    {
        printf( "d_kk is 0!!%f \n",d_kk ) ;
    }
    Bytef kk = 'a' ; 
    printf( "kkkkk %c \n",kk ) ;


   char *p;
   if((p = getenv("HOME")))
   printf("USER = %s\n", p);


    return 0 ;
}
