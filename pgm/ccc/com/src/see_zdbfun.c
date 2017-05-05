#include <see_com_common.h>

int see_zdb_open(see_config_t *p_conf)
{
    p_conf->z_url = URL_new(p_conf->ca_db_url);
    if(p_conf->z_url==NULL) {
        see_errlog(1000,(char *)p_conf->ca_db_url,RPT_TO_LOG,0,0) ;
        return -1 ;
    }
    p_conf->z_pool = ConnectionPool_new(p_conf->z_url);                             // create pool
    ConnectionPool_setInitialConnections(p_conf->z_pool,20);              // 设置初始化连接数目
    ConnectionPool_start(p_conf->z_pool);                                 // 开启线程池
    p_conf->z_con  = ConnectionPool_getConnection(p_conf->z_pool);                  // 从线程池中取出连接（活动连接数＋1）
    if( p_conf->z_con == NULL ) {
        see_err_log(0,0,"ConnectionPool_getConnection() error!!");
        return -1;
    }
    return 0;
}

int see_get_connection()
{
    return 0;
}

int see_zdb_close(see_config_t *p_conf)
{
    see_err_log(0,0,"befor Connection_close()");
    Connection_close(p_conf->z_con);
    see_err_log(0,0,"befor ConnectionPool_stop()");
    ConnectionPool_stop(p_conf->z_pool);
    see_err_log(0,0,"befor ConnectionPool_free()");
    ConnectionPool_free(&p_conf->z_pool);
    see_err_log(0,0,"befor URL_free()");
    URL_free(&p_conf->z_url);
    see_err_log(0,0,"after URL_free()");
    return 0;
}

int see_zdb_insert_line(see_config_t *p_conf, char *pc_line, char *pc_table)
{
    char                    InstrumentID[31] ;
    char                    TradingDay[9] ;
    char                    ActionDay[9] ;
    char                    UpdateTime[9] ;
    double                  OpenPrice;
    double                  HighestPrice;
    double                  LowestPrice;
    double                  ClosePrice;
    int                     Volume;

    char                    ca_state[1024] ;

    memset(InstrumentID,'\0',31) ;
    memset(TradingDay,'\0',9) ;
    memset(ActionDay,'\0',9) ;
    memset(UpdateTime,'\0',9) ;


    memset(ca_state,'\0',1024) ;
    sprintf(ca_state,"INSERT INTO %s( InstrumentID, TradingDay, ActionDay, UpdateTime, OpenPrice, HighestPrice, \
            LowestPrice, ClosePrice, Volume) VALUES(?,?,?,?,?,?,?,?,?)",pc_table) ;
    p_conf->z_statement = Connection_prepareStatement(p_conf->z_con,ca_state) ;

    //printf( ca_line ) ;
    //printf ("\n") ;
    sscanf(pc_line, "%s %s %s %s %lf %lf %lf %lf %d", InstrumentID, TradingDay, ActionDay, UpdateTime, &OpenPrice, &HighestPrice,
           &LowestPrice, &ClosePrice, &Volume);
    //memcpy(ActionDay,TradingDay,8) ;

    PreparedStatement_setString(p_conf->z_statement,1,(char *)InstrumentID) ;
    PreparedStatement_setString(p_conf->z_statement,2,(char *)TradingDay) ;
    PreparedStatement_setString(p_conf->z_statement,3,(char *)ActionDay) ;
    PreparedStatement_setString(p_conf->z_statement,4,(char *)UpdateTime) ;
    PreparedStatement_setDouble(p_conf->z_statement,5,OpenPrice) ;
    PreparedStatement_setDouble(p_conf->z_statement,6,HighestPrice) ;
    PreparedStatement_setDouble(p_conf->z_statement,7,LowestPrice) ;
    PreparedStatement_setDouble(p_conf->z_statement,8,ClosePrice) ;
    PreparedStatement_setInt(p_conf->z_statement,9,Volume) ;

    TRY {
        PreparedStatement_execute(p_conf->z_statement);
    }
    CATCH(SQLException) {
        sprintf(ca_errmsg,"see_zdb_insert_file SQL error: %s\n", Connection_getLastError(p_conf->z_con));
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }
    END_TRY;
    return 0;
}

int see_zdb_insert_file(see_config_t *p_conf, char *pc_filename, char *pc_table)
{
    char                    InstrumentID[31] ;
    char                    TradingDay[9] ;
    char                    ActionDay[9] ;
    char                    UpdateTime[9] ;
    double                  OpenPrice;
    double                  HighestPrice;
    double                  LowestPrice;
    double                  ClosePrice;
    int                     Volume;

    FILE                   *pf ;
    char                    ca_line[1024] ;
    char                    ca_state[1024] ;

    memset(InstrumentID,'\0',31) ;
    memset(TradingDay,'\0',9) ;
    memset(ActionDay,'\0',9) ;
    memset(UpdateTime,'\0',9) ;

    pf = fopen(pc_filename,"r");
    if(pf == NULL) {
        printf("open file %s error !! errno: %d \n",pc_filename,errno) ;
        return -1;
    }

    printf(pc_filename) ;
    printf("\n") ;
    memset(ca_line,'\0',1024) ;

    memset(ca_state,'\0',1024) ;
    sprintf(ca_state,"INSERT INTO %s( InstrumentID, TradingDay, ActionDay, UpdateTime, OpenPrice, HighestPrice, \
            LowestPrice, ClosePrice, Volume) VALUES(?,?,?,?,?,?,?,?,?)",pc_table) ;
    p_conf->z_statement = Connection_prepareStatement(p_conf->z_con,ca_state) ;

    while(fgets(ca_line,1024, pf) != NULL) {
        //printf( ca_line ) ;
        //printf ("\n") ;
        sscanf(ca_line, "%s %s %s %s %lf %lf %lf %lf %d", InstrumentID, TradingDay, ActionDay, UpdateTime, &OpenPrice, &HighestPrice,
               &LowestPrice, &ClosePrice, &Volume);
        //memcpy(ActionDay,TradingDay,8) ;

        PreparedStatement_setString(p_conf->z_statement,1,(char *)InstrumentID) ;
        PreparedStatement_setString(p_conf->z_statement,2,(char *)TradingDay) ;
        PreparedStatement_setString(p_conf->z_statement,3,(char *)ActionDay) ;
        PreparedStatement_setString(p_conf->z_statement,4,(char *)UpdateTime) ;
        PreparedStatement_setDouble(p_conf->z_statement,5,OpenPrice) ;
        PreparedStatement_setDouble(p_conf->z_statement,6,HighestPrice) ;
        PreparedStatement_setDouble(p_conf->z_statement,7,LowestPrice) ;
        PreparedStatement_setDouble(p_conf->z_statement,8,ClosePrice) ;
        PreparedStatement_setInt(p_conf->z_statement,9,Volume) ;

        TRY {
            PreparedStatement_execute(p_conf->z_statement);
        }
        CATCH(SQLException) {
            sprintf(ca_errmsg,"see_zdb_insert_file SQL error: %s\n", Connection_getLastError(p_conf->z_con));
            see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
        }
        END_TRY;
        memset(ca_line,'\0',1024) ;
    }
    fclose(pf) ;
    return 0;
}

int see_zdb_insert_future(see_config_t *p_conf, char *pc_future, char *pc_table)
{
    return 0;
}

int see_zdb_create_table(see_config_t *p_conf, char *pc_table)
{
    char       ca_state[1024];
    memset(ca_state,'\0',1024);

    sprintf(ca_state,"create table %s(InstrumentID CHAR(8),TradingDay CHAR(8),ActionDay CHAR(8),UpdateTime CHAR(8), \
    OpenPrice DOUBLE,HighestPrice DOUBLE,LowestPrice DOUBLE,ClosePrice DOUBLE,Volume INT, \
    PRIMARY KEY ( ActionDay,UpdateTime ));",pc_table);

    printf(ca_state) ;
    printf("\n") ;
    p_conf->z_statement = Connection_prepareStatement(p_conf->z_con,ca_state) ;

    TRY {
        PreparedStatement_execute(p_conf->z_statement);
    }
    CATCH(SQLException) {
        sprintf(ca_errmsg,"SQL error: %s\n", Connection_getLastError(p_conf->z_con));
        see_errlog(1000,ca_errmsg,RPT_TO_LOG,0,0) ;
    }
    END_TRY;
    return 0 ;
}

int see_zdb_get_data(see_config_t   *p_conf,
                     char           *pc_table,
                     char           *pc_actionday_s,
                     char           *pc_actionday_e,
                     char           *pc_updatetime_s,
                     char           *pc_updatetime_e,
                     int             num,
                     stt_kkone_t    *p_kkone)
{
    int        i_cur ;
    char       ca_state[1024];
    char       ca_cond[1024];
    //zee_memzero(ca_state,1024);
    //zee_memzero(ca_cond,1024);
    memset(ca_state,'\0',1024);
    memset(ca_cond,'\0',1024);


    if(p_conf->i_log_level==LOG_INFO) {
        see_err_log(0,0,"<IN>: see_zdb_get_data() : pc_table: %s, \
                                        pc_actionday_s: %s, pc_updatetime_s: %s, \
                                        pc_actionday_e: %s, pc_updatetime_e: %s, \
                                        number: %d num",
                    pc_table,
                    pc_actionday_s, pc_updatetime_s,
                    pc_actionday_e, pc_updatetime_e,
                    num);
    }

    //memset( ca_state,'\0',1024 );
    //memset( ca_cond,'\0',1024 );

    see_err_log(0,0,":  ",ca_state);

    if(pc_actionday_s!=NULL) {
        sprintf(ca_cond,"ActionDay>=\"%s\"",pc_actionday_s) ;
        strcat(ca_state,ca_cond);
    }
    memset(ca_cond,'\0',1024);
    if(pc_actionday_e!=NULL) {
        sprintf(ca_cond," AND ActionDay<=\"%s\"",pc_actionday_e) ;
        strcat(ca_state,ca_cond);
    }
    memset(ca_cond,'\0',1024);
    if(pc_updatetime_s!=NULL) {
        sprintf(ca_cond," AND UpdateTime>=\"%s\"",pc_updatetime_s) ;
        strcat(ca_state,ca_cond);
    }
    memset(ca_cond,'\0',1024);
    if(pc_actionday_e!=NULL) {
        sprintf(ca_cond," AND UpdateTime<=\"%s\"",pc_updatetime_e) ;
        strcat(ca_state,ca_cond);
    }

    if(strlen(ca_state)!=0) {
        memset(ca_cond,'\0',1024);
        sprintf(ca_cond,"%s",ca_state) ;
        memset(ca_state,'\0',1024);
        if(num<=0) {
            sprintf(ca_state,"SELECT * FROM %s WHERE %s ORDER BY ActionDay desc,UpdateTime desc LIMIT 10000;",pc_table,ca_cond) ;
        } else {
            sprintf(ca_state,"SELECT * FROM %s WHERE %s ORDER BY ActionDay desc,UpdateTime desc LIMIT %d;",pc_table,ca_cond,num) ;
        }
    } else {
        if(num<=0) {
            sprintf(ca_state,"SELECT * FROM %s ORDER BY ActionDay desc,UpdateTime desc;",pc_table) ;
        } else {
            sprintf(ca_state,"SELECT * FROM %s ORDER BY ActionDay desc,UpdateTime desc LIMIT %d;",pc_table,num) ;
        }
    }

    see_err_log(0,0,":  ",ca_state);

    /*
     SELECT * FROM TA701_1s
          where ActionDay>"20161109"
            and ActionDay<"20161111"
            and UpdateTime>"20:00:00"
            and UpdateTime<"22:00:00"
            ORDER BY  TradingDay desc,UpdateTime desc limit 10;
    */

    //ResultSet_T result = Connection_executeQuery(p_conf->z_con, "select * from j1705_1s");  //输出全部连接数目
    i_cur =9999;
    ResultSet_T result = Connection_executeQuery(p_conf->z_con, ca_state);  //输出全部连接数目
    //printf("ALL NUMBE:%d\n",ConnectionPool_size(p_conf->z_pool));                         //输出活动连接数目
    //printf("ACTIVE NUMBER:%d\n",ConnectionPool_active(p_conf->z_pool));
    while(ResultSet_next(result)) {                                             //游标滑到下一行
        printf("column: %s\n",ResultSet_getColumnName(result,2));               //根据列名获取值ResultSet_getStringByName
        printf("%s ",ResultSet_getStringByName(result,"TradingDay"));           //根据列索引获取列值 ［注意索引是从1开始不是0］
        printf("%s ",ResultSet_getStringByName(result,"UpdateTime"));           //根据列索引获取列值 ［注意索引是从1开始不是0］
        printf("o %s ",ResultSet_getString(result,1));
        printf("o %s ",ResultSet_getString(result,2));
        printf("o %s ",ResultSet_getString(result,3));
        printf("o %s ",ResultSet_getString(result,4));
        printf("o %lf ",ResultSet_getDouble(result,5));
        printf("h %lf ",ResultSet_getDouble(result,6));
        printf("l %lf ",ResultSet_getDouble(result,7));
        printf("c %lf ",ResultSet_getDouble(result,8));
        printf("v %d ",ResultSet_getInt(result,9));
        printf("i_cur: %d \n",i_cur) ;
        // if( i_count >=20 ) { break; }

        memcpy(p_kkone->ca_TradingDays   [i_cur], ResultSet_getString(result,2), 8) ;
        memcpy(p_kkone->ca_ActionDays    [i_cur], ResultSet_getString(result,3), 8) ;
        memcpy(p_kkone->ca_UpdateTimes   [i_cur], ResultSet_getString(result,4), 8) ;
        p_kkone->oo[i_cur] = ResultSet_getDouble(result,5) ;
        p_kkone->hh[i_cur] = ResultSet_getDouble(result,6) ;
        p_kkone->ll[i_cur] = ResultSet_getDouble(result,7) ;
        p_kkone->cc[i_cur] = ResultSet_getDouble(result,8) ;
        p_kkone->vv[i_cur] = ResultSet_getInt(result,9) ;
        i_cur-- ;
    }
    p_kkone->i_cur = 9999 ;
    //p_kkone->i_cur = i_cur ;

    if(p_conf->i_log_level==LOG_INFO) {
        see_err_log(0,0,"<OUT>: see_zdb_get_data()");
    }
    return 0 ;
}
