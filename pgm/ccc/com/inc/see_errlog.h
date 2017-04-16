/*
 *  * Copyright (C) AsiaLine
 *   * Copyright (C) kkk, Inc.
 *   */

#ifndef _SEE_ERRLOG_H_INCLUDED_
#define _SEE_ERRLOG_H_INCLUDED_

#include <see_com_common.h>

extern char ca_errmsg[] ;

#define LOG_STDERR            0
#define LOG_EMERG             1
#define LOG_ALERT             2
#define LOG_CRIT              3
#define LOG_ERR               4
#define LOG_WARN              5
#define LOG_NOTICE            6
#define LOG_INFO              7
#define LOG_DEBUG             8

int see_chglog(char cChgCode,char *pcChgStr);
int see_errlog(int iErrCode,char *pcaDispMsg,char cDumpDev,char *pcaDumpAddr,long llen);
int see_err_log( char *add, long len, const char *fmt, ... );
void see_disp_errmsg(int iFileId,char *pcaMsgStr,char *pcaDumpAddr,long llen);
void see_mem_dump(int iFileId,char *pucaAddr,long llen);
void see_DumpHex(int ifile,unsigned char *buf, int len) ;
void see_DumpLine(int ifile,int addr, unsigned char *buf, int len) ;


#define  LOG_CHG_LOG	'1'	/* change LOG_MODE */
#define  LOG_CHG_MODE	'2'	/* change LOG_FILE_NAME */
#define  LOG_CHG_SIZE	'3'	/* change LOG_FILE_SIZE */

#define  RPT_TO_LOG	    	1          /* 00000001 */
#define  RPT_TO_TTY	    	2          /* 00000010 */
#define  RPT_TO_CON   		4          /* 00000100 */
#define  RPT_TO_TTY_DUMP	8          /* 00001000 */

#define  TTY_DEV        ttyname(1)
#define  CONSOLE        "/dev/console"
#define  LOG_MSG_SEPERATE	"\n"
#define  LOG_SEPERATE_LEN	1
#define  LOG_NO_OF_ITEM	6

#define  MAX_PRT_LEN    256	
#define  MAX_LEVEL	40
#define  MAX_PARA	30	/* max. number of parameters */
#define  MAX_OPEN_RETRY	256	/* max retry open log file */

#define  NO_ERR		0
#define  RCVR_ERR	10000
#define  NORCVR_CHK_ERR	40000
#define  LOG_CHGCODE_ERROR	1
#define  LOG_CHGMODE_ERROR	2
#define  LOG_CHGLOG_ERROR	3

#endif
