#include <stdlib.h>  
#include <string.h>  
#include <stdio.h>  
#include <zlib.h>  
  
typedef struct {
    double a;
    double b[10];
    char ca_oo[31];
    int   d[10];
    double km[20];
    char ca_y[9];
} my_t ;

int main(int argc, char* argv[])  
{  

    // my_t kkkk ;
    Byte * text ;

    //Byte text[] = "zlib rewqpqpreuqiuqwr  qwirqadfkadf dfdfjar  and uncompress test\nturingo@163.com\n2012-11-05\n";  

    text = (Byte *)malloc(sizeof(my_t) );
    
    // uLong tlen = strlen((char *)text) + 1;  /* 需要把字符串的结束符'\0'也一并处理 */  
    uLong tlen = sizeof(my_t) ;
    Byte * buf = NULL;  
    uLong blen;  
  
    /* 计算缓冲区大小，并为其分配内存 */  
    blen = compressBound(tlen); /* 压缩后的长度是不会超过blen的 */  
    blen = blen +1 ;


    printf( " tlen: %f\n",(double)tlen ) ;
    printf( " blen: %f\n",(double)blen ) ;

    if((buf = (Byte *)malloc(sizeof(Byte) * blen)) == NULL)  
    {  
        printf("no enough memory!\n");  
        return -1;  
    }  
  
    /* 压缩 */  
    if(compress(buf, &blen, text, tlen) != Z_OK)  
    {  
        printf("compress failed!\n");  
        return -1;  
    }  
    memset((char *)&buf[blen],'\0',1) ;
    printf( " blen: %f\n",(double)blen ) ;

    int tt = strlen((char *)buf) ;
    printf( " iiiiitttt: %d\n",tt ) ;

    printf("%s", (char *)buf);  
    /* 解压缩 */  
    if(uncompress(text, &tlen, buf, blen) != Z_OK)  
    {  
        printf("uncompress failed!\n");  
        return -1;  
    }  
  
    /* 打印结果，并释放内存 */  
    printf("%s", text);  
    if(buf != NULL)  
    {  
        free(buf);  
        buf = NULL;  
    }  
  
    return 0;  
}  
