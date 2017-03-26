#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <memory.h>
#include<unistd.h>

char filename[25600][256];
int len = 0;
int trave_dir(char* path)
{
    DIR *d; //声明一个句柄
    struct dirent *file; //readdir函数的返回值就存放在这个结构体中
    struct stat sb;    
    char ca_path[512] ;
    int n,i_len;
    
    if(!(d = opendir(path)))
    {
        printf("error opendir %s!!!/n",path);
        return -1;
    }



    struct dirent **namelist;
    n=scandir(path,&namelist,0,alphasort);
/*
    while(n--)
    {
        printf("%s\n",namelist[n]->d_name);
        free( namelist[n] ) ;
    }
*/


    while(n--)
    {
        if(strncmp(namelist[n]->d_name, ".", 1) == 0)
        {
            free( namelist[n] ) ;
            continue;
        }

        sprintf(ca_path,"%s/%s",path,namelist[n]->d_name) ;

        if(stat(ca_path, &sb) >= 0 && S_ISDIR(sb.st_mode))
        {
            //printf(":this is a dir:  %s\n", ca_path);
            trave_dir(ca_path);
        }else{
            i_len = strlen(ca_path) ;
            if( strncmp("bin", &ca_path[i_len-3],n) == 0 ) 
            {
            //    printf("kkkkkk: %c%c%c %d\n",ca_path[i_len-3],ca_path[i_len-2],ca_path[i_len-1],i_len) ;
                // printf(filename[len++],"%s\n",ca_path) ;
            } else {
                sprintf(filename[len++],"%s\n",ca_path) ;
            }
        }
        free( namelist[n] ) ;
    }
    closedir(d);
    return 0;
}



unsigned int introtate_right(unsigned int x, int n)  
{  
    int save;  
    int i;  
    for(i=0;i<n;i++)  
    {  
        save=x&0x00000001;  
        x=x>>1;  
        save=save<<7;  
        x+=save;  
    }  
    return x;  
} 

int main()
{
    int depth = 1;
    int i;
    trave_dir("/home/rabbit/see/dat/rcv_dat");
    for(i = 0; i < len; i++)
    {
    //    printf("%s", filename[i]);
    }
    printf("\n");

    int ret;  
    char *string;  
    double  digit;  
    char buf1[255];  
    char buf2[255];  
    char buf3[255];  
    char buf4[255];  
  
    /*1.最简单的用法*/  
    string = "china beijing 123";  
    ret = sscanf(string, "%s %s %lf", buf1, buf2, &digit);  
    printf("1.string=%s\n", string);  
    printf("1.ret=%d, buf1=%s, buf2=%s, digit=%lf \n\n", ret, buf1, buf2, digit);  


    unsigned int aaa,bbb;
    aaa = 2;
    printf( "------------ %d \n", aaa ) ;
    bbb = introtate_right( aaa,3 );
    bbb = aaa<<1 ;
    printf( "------------ %d \n", bbb ) ;

    


    unsigned int a, b, mask = 0x0000ff00;  
      
    /*取出8~15位*/  
    a = 0x12345678;  
    b = (a & mask) >> 8;    
    printf("%x\n",a);  
    printf("%x\n\n",b);  
      
    /*将8~15位清0*/  
    a = 0x12345678;  
    b = a & ~mask;  
    printf("%x\n",a);  
    printf("%x\n\n",b);  
      
    /*将8~15位置1*/  
    a = 0x12345678;  
    b = a | mask;  
    printf("%x\n",a);  
    printf("%x\n\n",b); 


    return 0;
}
