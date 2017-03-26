#include <stdio.h>
#include <dirent.h>
#include <stdlib.h>
#include <memory.h>
#include<unistd.h>

int read_tail_line(FILE *fd,char *buf){  //从后往前一行一行的读取  
        int c,ret;  
        long offset;  
        if(ftell(fd)==0){  
            return -1;  
        }  
        while(1){  
            c=fgetc(fd);
            if(c=='\n'){  
                offset=ftell(fd);  
                if(buf){  
                    fgets(buf,512,fd);  
                }  
                fseek(fd,offset-2,SEEK_SET);  
                ret=1;  
                break;  
            }else if(fseek(fd,-2,SEEK_CUR)==-1){  
                fseek(fd,0,SEEK_SET);  
                if(buf){  
                    fgets(buf,512,fd);  
                }  
                fseek(fd,0,SEEK_SET);  
                ret=0;  
                break;  
            }  
        }  
        return ret;  
}  



int read_tail(int index,int num){ //从文件末尾第index行开始，向上读取num行  
          
        int ret=0;  
        FILE*fd;  
        int i=0;  
        char buf[512]={0};  
        fd=fopen("./test.txt","rb"); //open file   
        fseek(fd,-1,SEEK_END);  
        i=index;  
        while(i){  
           // readline(fd,NULL);  
            read_tail_line(fd,NULL) ;
            i--;  
        }  
        i=num;  
        while(i){  
            memset(buf,0,512);  
            //ret=readline(fd,buf);  
            ret = read_tail_line(fd,buf) ;
            fgets (buf , 512 , fd) ;
            printf("%s\n",buf);  
            i--;  
            if(!ret)  
                break;  
        }  
        printf("retcode:%d\n",num-i);  
        fclose(fd);  
        return 0;  
}  


int main()
{
    int n;
    struct dirent **namelist;

    n=scandir("./",&namelist,0,alphasort);
    while(n--)
    {
        printf("%s\n",namelist[n]->d_name);
        free( namelist[n] ) ;
    }


    read_tail(3,3) ;



    return 0;
}  
