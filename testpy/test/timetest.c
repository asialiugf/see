#include <sys/time.h>
#include <stdio.h>
#include <string.h> 
int main()
{
    int ia_kkk[10000] ;
    int i=0;
    struct timeval start, end;
    int cha2;
    int cha1;
    int i_len = sizeof(int)*9999 ;
    for ( i=0;i<10000;i++ )
    {
        ia_kkk[i] = i ;
    }

    gettimeofday( &start, NULL );
    for ( i=0;i<10000;i++ )
    {
        memcpy((char *)&ia_kkk[0],(char *)&ia_kkk[1],i_len) ;
    }

    gettimeofday( &end, NULL );
    printf( "kkk[0]:%d\n", ia_kkk[0] ) ;

    cha2 = end.tv_usec-start.tv_usec ;
    cha1 = end.tv_sec-start.tv_sec ;
    printf( "sec:%d usec:%d\n",cha1,cha2 );
}
