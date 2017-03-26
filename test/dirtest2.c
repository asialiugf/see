#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<dirent.h>
 
 
int  main()
{
     struct dirent **d;
     int r,i;
     r=scandir("./",&d,NULL,NULL);
     printf("子目录个数：%d\n",r);
     //遍历子目录
/*    for(i=0;i<r;i++)
     {
         printf("%s\n",d[i]->d_name);
     }
*/
 
     while(*d)
     {
         printf("%s\n",(*d)->d_name);
         d++;
     }
}
