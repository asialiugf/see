#include <see_com_common.h>
/*
int see_file_to_json(char *filename, cJSON **json )
{
    FILE    *f = NULL;
    char    *buf ;
    long    len = 0;

    f = fopen(filename,"rb");
    if (f == NULL) {
        see_errlog(1000,"see_file_to_json open future table error!!",RPT_TO_LOG,0,0) ;
        return -1 ;
    }
    
    fseek(f, 0, SEEK_END);
    len = ftell(f);
    fseek(f, 0, SEEK_SET);

    buf = (char*)malloc(len + 1);
    if (buf == NULL)
    {
        printf("Failed to allocate memory.\n");
        exit(1);
    }
    fread(buf, 1, len, f);
    buf[len] = '\0';

    printf("%s",buf) ;

    printf( "kkkkk!!!111111111111i\n" ) ;

    fclose(f);
    printf( "kkkkk!!!111111111111i\n" ) ;
    *json = cJSON_Parse(buf);
    printf( "kkkkk!!!222222222222\n" ) ;
    if (!*json)
    {
        printf("Error before: [%s]\n", cJSON_GetErrorPtr());
    } 
    free(buf) ;
    printf( "kkkkk!!!!!!!!!!!!!\n" ) ;
    return 0 ;
}
*/

int see_file_to_json(char *filename, cJSON **json )
{
    FILE    *f = NULL;
    char    *buf ;
    long    len = 0;

    f = fopen(filename,"rb");
    if (f == NULL) {
        see_errlog(1000,"see_file_to_json open future table error!!",RPT_TO_LOG,0,0) ;
        return errno ;
    }
    
    fseek(f, 0, SEEK_END);
    len = ftell(f);
    fseek(f, 0, SEEK_SET);
    if( len==0 ){
        see_errlog(1000,"see_file_to_json(): file len is 0 !!",RPT_TO_LOG,0,0) ;
        return -2 ;
    }

    buf = (char*)malloc(len + 1);
    if (buf == NULL)
    {
        see_errlog(1000,"see_file_to_json(): Failed to allocate memory !!",RPT_TO_LOG,0,0) ;
        return errno ;
    }
    fread(buf, 1, len, f);
    buf[len] = '\0';
    fclose(f);

    *json = cJSON_Parse(buf);
    if (!*json)
    {
        see_errlog(1000,"see_file_to_json(): Failed to parse json file !!",RPT_TO_LOG,0,0) ;
        printf("Error before: [%s]\n", cJSON_GetErrorPtr());
        free(buf) ;
        return -3 ;
    }
    free(buf) ;
    return 0 ;
}
