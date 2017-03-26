#include <stdio.h>
#include <unistd.h> 
#include <errlog.h>
#include <see_com_common.h>


#define SEE_NULL -2147483648
double in[1000] ;
double out[1000] ;

char ca_msg[512];

int main( void )
{
    int itn = 0 ;
    int i ;

    for ( i = 0 ; i <1000 ; i++ )
    {
        out[i] = SEE_NULL ;
        in[i]=i;
    }
    for ( i = 0 ; i <1000 ; i++ )
    {
        //SEE_MA(i,i,&in[0],4,&out[0]);
    }
        SEE_MA(997,997,in,300,out);
        SEE_MA(998,999,&in[0],300,&out[0]);

        memset(ca_msg,'\0',512);
        sprintf(ca_msg,"iiiiiii: %10.4f, %10.4f ",in[0],out[0]);
        errlog(1000,ca_msg,RPT_TO_LOG,0,0);

    //SEE_MA(0,999,&in[0],2,&out[0]);
    for ( i = 0 ; i <1000 ; i++ )
    {
        memset(ca_msg,'\0',512);
        sprintf(ca_msg,"kkkkkkk: %10.4f, %10.4f ",in[i],out[i]);
        errlog(1000,ca_msg,RPT_TO_LOG,0,0);
    }
    return itn ;
}
