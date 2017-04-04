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
    int kk ;
    
    if(!(d = opendir(path)))
    {
        printf("error opendir %s!!!/n",path);
        return -1;
    }


/*
    int n;
    struct dirent **namelist;
    n=scandir(path,&namelist,0,alphasort);
    while(n--)
    {
        printf("%s\n",namelist[n]->d_name);
        free( namelist[n] ) ;
    }
*/


    char ca_path[512] ;
    while((file = readdir(d)) != NULL)
    {
        if(strncmp(file->d_name, ".", 1) == 0)
            continue;

        sprintf(ca_path,"%s/%s",path,file->d_name) ;

        if(stat(ca_path, &sb) >= 0 && S_ISDIR(sb.st_mode))
        {
            //printf(":this is a dir:  %s\n", ca_path);
            trave_dir(ca_path);
        }else{
            sprintf(filename[len++],"%s\n",ca_path) ;
        }
    }
    closedir(d);
    return 0;
}
int main()
{
    int depth = 1;
    int i;
    trave_dir("/home/rabbit/see/dat/rcv_dat");
    for(i = 0; i < len; i++)
    {
        printf("%s", filename[i]);
    }
    printf("\n");
    return 0;
}
