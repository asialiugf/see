/*
 *  * Copyright (C) AsiaLine
 *   * Copyright (C) kkk, Inc.
 *   */

#ifndef _ERRLOG_H_INCLUDED_
#define _ERRLOG_H_INCLUDED_


int chglog(char cChgCode,char *pcChgStr);
int errlog(int iErrCode,char *pcaDispMsg,char cDumpDev,char *pcaDumpAddr,long llen);
void disp_errmsg(int iFileId,char *pcaMsgStr,char *pcaDumpAddr,long llen);
void mem_dump(int iFileId,char *pucaAddr,long llen);
void DumpHex(int ifile,unsigned char *buf, int len) ;
void DumpLine(int ifile,int addr, unsigned char *buf, int len) ;

//#include <stdio.h>
//#include <unistd.h> 
//#include <fcntl.h>
//#include <signal.h>
//#include <termio.h>

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

#define  MAX_PRT_LEN	256
#define  MAX_LEVEL	40
#define  MAX_PARA	30	/* max. number of parameters */
#define  MAX_OPEN_RETRY	256	/* max retry open log file */

#define  NO_ERR		0
#define  RCVR_ERR	10000
#define  NORCVR_CHK_ERR	40000
#define  LOG_CHGCODE_ERROR	1
#define  LOG_CHGMODE_ERROR	2
#define  LOG_CHGLOG_ERROR	3

// #ifdef _MAIN_PROGRAM
//    #define EXTERN
//    int g_iRtnIdx = 0;
//    int g_iRtnErrno = 0;
// #else
//    #define EXTERN extern
//    extern int g_iRtnIdx;
//    extern int g_iRtnErrno;
// #endif

// extern int g_iaRtnPath[MAX_LEVEL];
// extern char g_caMsg[MAX_PRT_LEN];

#endif
