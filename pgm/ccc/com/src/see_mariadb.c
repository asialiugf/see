#include <see_com_common.h>

const char          ca_mysql_url[]  = "mysql://127.0.0.1/test?user=root&password=123ok" ;
char                ca_files[200][512];
//see_config_t        t_conf ;
//see_config_t        *gp_conf ;
char                ca_dirs[53][256] = \
        {"/home/rabbit/see/dat/rcv_dat/a",
        "/home/rabbit/see/dat/rcv_dat/ag",
        "/home/rabbit/see/dat/rcv_dat/al",
        "/home/rabbit/see/dat/rcv_dat/au",
        "/home/rabbit/see/dat/rcv_dat/b",
        "/home/rabbit/see/dat/rcv_dat/bb",
        "/home/rabbit/see/dat/rcv_dat/bu",
        "/home/rabbit/see/dat/rcv_dat/c",
        "/home/rabbit/see/dat/rcv_dat/CF",
        "/home/rabbit/see/dat/rcv_dat/cs",
        "/home/rabbit/see/dat/rcv_dat/cu",
        "/home/rabbit/see/dat/rcv_dat/fb",
        "/home/rabbit/see/dat/rcv_dat/FG",
        "/home/rabbit/see/dat/rcv_dat/fu",
        "/home/rabbit/see/dat/rcv_dat/hc",
        "/home/rabbit/see/dat/rcv_dat/i",
        "/home/rabbit/see/dat/rcv_dat/IC",
        "/home/rabbit/see/dat/rcv_dat/IF",
        "/home/rabbit/see/dat/rcv_dat/IH",
        "/home/rabbit/see/dat/rcv_dat/j",
        "/home/rabbit/see/dat/rcv_dat/jd",
        "/home/rabbit/see/dat/rcv_dat/jm",
        "/home/rabbit/see/dat/rcv_dat/JR",
        "/home/rabbit/see/dat/rcv_dat/l",
        "/home/rabbit/see/dat/rcv_dat/LR",
        "/home/rabbit/see/dat/rcv_dat/m",
        "/home/rabbit/see/dat/rcv_dat/MA",
        "/home/rabbit/see/dat/rcv_dat/ME",
        "/home/rabbit/see/dat/rcv_dat/ni",
        "/home/rabbit/see/dat/rcv_dat/OI",
        "/home/rabbit/see/dat/rcv_dat/p",
        "/home/rabbit/see/dat/rcv_dat/pb",
        "/home/rabbit/see/dat/rcv_dat/PM",
        "/home/rabbit/see/dat/rcv_dat/pp",
        "/home/rabbit/see/dat/rcv_dat/rb",
        "/home/rabbit/see/dat/rcv_dat/RI",
        "/home/rabbit/see/dat/rcv_dat/RM",
        "/home/rabbit/see/dat/rcv_dat/RS",
        "/home/rabbit/see/dat/rcv_dat/ru",
        "/home/rabbit/see/dat/rcv_dat/SF",
        "/home/rabbit/see/dat/rcv_dat/SM",
        "/home/rabbit/see/dat/rcv_dat/sn",
        "/home/rabbit/see/dat/rcv_dat/SR",
        "/home/rabbit/see/dat/rcv_dat/T",
        "/home/rabbit/see/dat/rcv_dat/TA",
        "/home/rabbit/see/dat/rcv_dat/TC",
        "/home/rabbit/see/dat/rcv_dat/TF",
        "/home/rabbit/see/dat/rcv_dat/v",
        "/home/rabbit/see/dat/rcv_dat/WH",
        "/home/rabbit/see/dat/rcv_dat/wr",
        "/home/rabbit/see/dat/rcv_dat/y",
        "/home/rabbit/see/dat/rcv_dat/ZC",
        "/home/rabbit/see/dat/rcv_dat/zn"};


int
main(int iArgCnt, char *pcaArgVec[])
{
    volatile int            i,j,k;
    int                     i_num ;
    char                    ca_files[200][512];
    char                    ca_state[512];
    char                    ca_filename[512];


    see_config_init();
    see_zdb_open( gp_conf );

        /*
        volatile see_node *node;
        for ( i=0;i<gp_conf->i_future_num;i++ ){
            memset(ca_state,'\0',512) ;
            memset(ca_filename,'\0',512) ;
            node = gp_conf->pt_stt_blks[i]->list ;
            while( node != NULL ){
                // gp_conf->pt_fut_blks[i].bar_block[node->period].ca_table ;
                printf(gp_conf->pt_fut_blks[i]->bar_block[node->period].ca_table) ;
                printf("\n");
                //memcpy(ca_filename,"%s/%s",gp_conf->pt_fut_blks[i].bar_block[node->period].ca_home

                see_trave_dir(gp_conf->pt_fut_blks[i]->bar_block[node->period].ca_home,&i_num, ca_files) ;
                see_zdb_create_table( gp_conf, gp_conf->pt_fut_blks[i]->bar_block[node->period].ca_table );
                for( j=0;j<i_num;j++ ){
                    see_zdb_insert_file( gp_conf, ca_files[j], gp_conf->pt_fut_blks[i]->bar_block[node->period].ca_table );
                }
                node = node->next ;
            }
        }
        */

        for( i=0;i<gp_conf->i_future_num;i++ ){
            memset(ca_state,'\0',512) ;
            memset(ca_filename,'\0',512) ;
            int len2 = strlen( gp_conf->pt_fut_blks[i]->InstrumentID );
            for( j=0;j<31;j++ ){
                //printf( gp_conf->pt_fut_blks[i]->bar_block[j].ca_home ) ;
                //printf( "\n\n\n") ;
                int len1 = strlen( gp_conf->pt_fut_blks[i]->bar_block[j].ca_home );
                see_trave_dir(gp_conf->pt_fut_blks[i]->bar_block[j].ca_home,&i_num, ca_files) ;
                see_zdb_create_table( gp_conf, gp_conf->pt_fut_blks[i]->bar_block[j].ca_table );
                /*
                for( k=0;k<i_num;k++ ){
                    printf( ca_files[k] ) ;
                    printf( "----------\n") ;
                }*/
                int nn = 0;
                for( k=0;k<i_num;k++ ){
                    /*
                    printf( ca_files[k] ) ;
                    printf( "\n") ;
                    printf( &ca_files[k][len1+1] ) ;
                    printf( "\n") ;
                    */
                    if( memcmp( (char*)&ca_files[k][len1+1], (char*)(gp_conf->pt_fut_blks[i]->InstrumentID), len2 )==0 ){
                        see_zdb_insert_file( gp_conf, ca_files[k], gp_conf->pt_fut_blks[i]->bar_block[j].ca_table );
                        nn++ ;
                    }
                    if( nn >=2 ){
                        break ;
                    }
                }
            }
        }

    see_zdb_close( gp_conf );

    return 0;
}

/*
create table j1705_1s(
    TradingDay              CHAR(8),
    UpdateTime              CHAR(8),
    o                       DOUBLE,
    h                       DOUBLE,
    l                       DOUBLE,
    c                       DOUBLE,
    v                       INT,
    PRIMARY KEY ( TradingDay,UpdateTime )
);
select * from j1705_1s  where TradingDay='20170117' and UpdateTime>'23:29:16' and UpdateTime<'23:29:50' ;
*/
