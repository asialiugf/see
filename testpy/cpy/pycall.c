#include <stdio.h>  
#include <stdlib.h>  
int foo(int a[], int b[])  
{  
  printf("you input %d and %d\n", a[0], b[0]);  
  a[0] = 1000 ;
  b[2] = 999 ;
  return a[0]+b[0];
}  
int moveint(int a[])
{
    int i=0;
    for ( i=0;i<999999;i++ )
    {
	a[i]=a[i+1];
    }
}
