#include <see_com_common.h>


int see_save_line(char *pc_file_name, char *pc_line )
{
    int i_rtn = 0 ;
    int i_file_id ;
    int i_retry;

    i_retry=0;
    while((i_file_id=open(pc_file_name,O_WRONLY | O_CREAT | O_APPEND,0660)) == -1){
        sleep(1);
        if ( (i_retry ++) > 10) {
            printf("iofile.c: fatal error occured !!! error_no is %d\n",errno);
            i_rtn = SEE_ERROR ; 
        }
    }
    i_retry=0;
    while (lockf(i_file_id,F_LOCK,0) == -1) {
        sleep(1);
        if ( (i_retry ++) > 10) {
            printf("iofile.c: fatal error occured !!! error_no is %d\n",errno);
            i_rtn = SEE_ERROR ; 
        }
    }
    write(i_file_id,pc_line,strlen(pc_line));
    close(i_file_id) ;
    return i_rtn ;
}


int see_update_line(char *pc_file_name, char *pc_line )
{
    FILE *f;
    char ch;
    int len = 0;
    int i ;

    //没有写好！！！！
 
    if ((f = fopen(pc_file_name, "a+")) == NULL)
    {
        printf("error!");
        return -1;
    }
    fseek(f, 0, SEEK_END);
    len = ftell(f);
    if ( len ==0 ) {
        fprintf(f,"%s",pc_line);      
    }

    sprintf(ca_errmsg," update line: file len: %d",len) ;
    see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
 

    i = -2000 ;
    fseek(f, i, SEEK_END);             //移动指针离文件结尾 1 字节处
    len = ftell(f);

    sprintf(ca_errmsg," update line: file len1111: %d",len) ;
    see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;

    ch = fgetc(f);                     //读取一个字符
 
    while (ch != '\n' && ch!=EOF )
    {
        sprintf(ca_errmsg," update line: file len: ch:::::::::: %c",ch) ;
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
        fseek(f, -2, SEEK_CUR);
        ch = fgetc(f);
    }
    if( ch == '\n' )
    {
        fseek(f, 1, SEEK_CUR);
        fprintf(f,"%s",pc_line);
    }
    if ( ch==EOF )
    {
        fprintf(f,"%s",pc_line);
    }
 
    fclose(f);
 
    return 0;
}


int
see_save_bin(char * pc_file_name,char *buf, int len )
{
  int i_rtn = 0 ;
  int i_file_id ; 
  int i_retry;

  i_retry=0;
  while((i_file_id=open(pc_file_name,O_WRONLY | O_CREAT | O_APPEND,0660)) == -1){
      sleep(1);
      if ( (i_retry ++) > 10) {
          printf("iofile.c: fatal error occured !!! error_no is %d\n",errno); 
          i_rtn = SEE_ERROR ;
      }
  }
  i_retry=0;
  while (lockf(i_file_id,F_LOCK,0) == -1) {
      sleep(1);
      if ( (i_retry ++) > 10) {
          printf("iofile.c: fatal error occured !!! error_no is %d\n",errno); 
          i_rtn = SEE_ERROR ;
      }
  }

  write(i_file_id,buf,len ) ;
  close(i_file_id); 
  return i_rtn ;
} 

int
see_save_tick(char *buf, int len )
{
  int       i_rtn = 0 ;
  int       i_file_id ;
  int       i_retry ;
  char      ca_tick_file[1024] ;
  struct CThostFtdcDepthMarketDataField * market_data ;

  //see_errlog(1000,"buf",RPT_TO_LOG,buf,len) ;

  market_data = (struct CThostFtdcDepthMarketDataField *)buf ;
  //memset( ca_tmp,'\0',3 ) ;
  //memcpy( ca_tmp,market_data->UpdateTime,2 );
  memset( ca_tick_file,'\0',1024 ) ;
  sprintf( ca_tick_file, "../../dat/rcv_dat/tick-%s-%s-%s.bin",market_data->InstrumentID, \
                                                   market_data->TradingDay, \
                                                   market_data->ActionDay ) ;

  //see_errlog(1000,ca_tick_file,RPT_TO_LOG,0,0) ;

  i_retry=0;
  while((i_file_id=open(ca_tick_file,O_WRONLY | O_CREAT | O_APPEND,0660)) == -1){
      sleep(1);
      if ( (i_retry ++) > 10) {
          printf("see)iofile.c: fatal error occured !!! error_no is %d\n",errno);
      }
  }
  i_retry=0;
  while (lockf(i_file_id,F_LOCK,0) == -1) {
      sleep(1);
      if ( (i_retry ++) > 10) {
          printf("see_iofile.c: fatal error occured !!! error_no is %d\n",errno);
      }
  }

  write(i_file_id,buf,len ) ;
  close(i_file_id);
  return i_rtn ;
}

int see_disp_tick(char *buf)
{
    struct CThostFtdcDepthMarketDataField * market_data ;
    double dd ;
    int    ii ;
    char ca_Volume[100] ;
    char ca_PreClosePrice[100] ;
    char ca_OpenPrice[100] ;
    char ca_HighestPrice[100] ;
    char ca_LowestPrice[100] ;
    char ca_ClosePrice[100] ;
    char ca_AveragePrice[100] ;
    char ca_LastPrice[100] ;
    char ca_BidPrice1[100] ;
    char ca_BidVolume1[100] ;
    char ca_AskPrice1[100] ;
    char ca_AskVolume1[100] ;
    char ca_UpdateMillisec[100] ;

    char ca_errtmp[1024] ;
    char ca_errmsg[1024] ;

    market_data = (struct CThostFtdcDepthMarketDataField *)buf ;

        ii = market_data->Volume ;
        if (ii < 10000000 && ii > -10000000 ) { memset( ca_Volume,'\0',100 );
            sprintf ( ca_Volume,"%d",ii ) ;
        }else { sprintf( ca_Volume,"%s",(char *)"NULL" ) ; }

        dd = market_data->PreClosePrice ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_PreClosePrice,'\0',100 );
            sprintf ( ca_PreClosePrice,"%10.2f",dd ) ;
        }else { sprintf( ca_PreClosePrice,"%s",(char *)"NULL" ) ; }

        dd = market_data->OpenPrice ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_OpenPrice,'\0',100 );
            sprintf ( ca_OpenPrice,"%10.2f",dd ) ;
        }else { sprintf( ca_OpenPrice,"%s",(char *)"NULL" ) ; }

        dd = market_data->HighestPrice ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_HighestPrice,'\0',100 );
            sprintf ( ca_HighestPrice,"%10.2f",dd ) ;
        }else { sprintf( ca_HighestPrice,"%s",(char *)"NULL" ) ; }

        dd = market_data->LowestPrice ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_LowestPrice,'\0',100 );
            sprintf ( ca_LowestPrice,"%10.2f",dd ) ;
        }else { sprintf( ca_LowestPrice,"%s",(char *)"NULL" ) ; }

        dd = market_data->ClosePrice ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_ClosePrice,'\0',100 );
            sprintf ( ca_ClosePrice,"%10.2f",dd ) ;
        }else { sprintf( ca_ClosePrice,"%s",(char *)"NULL" ) ; }

        dd = market_data->AveragePrice ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_AveragePrice,'\0',100 );
            sprintf ( ca_AveragePrice,"%10.2f",dd ) ;
        }else { sprintf( ca_AveragePrice,"%s",(char *)"NULL" ) ; }

        dd = market_data->LastPrice ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_LastPrice,'\0',100 );
            sprintf ( ca_LastPrice,"%10.2f",dd ) ;
        }else { sprintf( ca_LastPrice,"%s",(char *)"NULL" ) ; }

        dd = market_data->BidPrice1 ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_BidPrice1,'\0',100 );
            sprintf ( ca_BidPrice1,"%10.2f",dd ) ;
        }else { sprintf( ca_BidPrice1,"%s",(char *)"NULL" ) ; }

        ii = market_data->BidVolume1 ;
        if (ii < 10000000 && ii > -10000000 ) { memset( ca_BidVolume1,'\0',100 );
            sprintf ( ca_BidVolume1,"%d",ii ) ;
        }else { sprintf( ca_BidVolume1,"%s",(char *)"NULL" ) ; }

        dd = market_data->AskPrice1 ;
        if (dd < 10000000000 && dd > -10000000000 ) { memset( ca_AskPrice1 ,'\0',100 );
            sprintf ( ca_AskPrice1 ,"%10.2f",dd ) ;
        }else { sprintf( ca_AskPrice1 ,"%s",(char *)"NULL" ) ; }

        ii = market_data->AskVolume1 ;
        if (ii < 10000000 && ii > -10000000 ) { memset( ca_AskVolume1,'\0',100 );
            sprintf ( ca_AskVolume1,"%d",ii ) ;
        }else { sprintf( ca_AskVolume1,"%s",(char *)"NULL" ) ; }



        ii = market_data->UpdateMillisec ;
        if (ii < 10000000 && ii > -10000000 ) { memset( ca_UpdateMillisec,'\0',100 );
            sprintf ( ca_UpdateMillisec,"%d",ii ) ;
        }else { sprintf( ca_UpdateMillisec,"%s",(char *)"NULL" ) ; }

        memset( ca_errtmp,'\0',1024 );
        sprintf ( ca_errtmp,"recv: %s----%s %s----%s----Msec:%s ---- %d ----  ",market_data->InstrumentID, \
                                                market_data->TradingDay, \
                                                market_data->ActionDay, \
                                                market_data->UpdateTime, \
                                                ca_UpdateMillisec, \
                                                market_data->BidVolume5 ) ;

        memset( ca_errmsg,'\0',1024 );
        sprintf ( ca_errmsg,"%s  H:%s  L:%s  LPrice:%s  B1:%s  BV1:%s  A1:%s  AV1:%s  V:%s", \
                                                ca_errtmp, \
                                                ca_HighestPrice,ca_LowestPrice,ca_LastPrice, \
                                                ca_BidPrice1,ca_BidVolume1,ca_AskPrice1,ca_AskVolume1, \
                                                ca_Volume ) ;
        see_errlog( 1000,ca_errmsg,RPT_TO_LOG,0,0 ) ;
    return 0;
}
