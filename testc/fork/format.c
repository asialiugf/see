#include <unistd.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
int test(int i, const char *fmt, ...)
{
    char *p;
    char buf[1000];

    va_list ap;
    p = buf;

    va_start(ap, fmt);
    vsprintf(p, fmt, ap);
    va_end(ap);
    printf(p) ;


    /* */
    double * oo;
    double kk[100];
    kk[10] = 111;
    kk[20] = 444;
    oo = kk;
    oo[78] = 3456;
    printf( "\n %lf \n", oo[10] );
    printf( "\n %lf \n", kk[78] );
    /* */

    return 0;
}
int main()
{
    test(1,"%s","kkkk");
}
