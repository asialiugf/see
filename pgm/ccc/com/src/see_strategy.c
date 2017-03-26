#include <see_com_common.h>

int see_stt_load() 
{
    return 0;
}

int see_stt_blocks_init ( see_config_t *p_conf )
{
    int u;
    int i;
    for( u=0; u<p_conf->i_future_num; u++ )
    {
        see_node *node;
        see_kkone_t *p_kkone ;
        node = p_conf->pt_stt_blks[u]->list ;
        while( node != NULL ){
            p_kkone = (see_kkone_t *)malloc(sizeof(see_kkone_t)) ; 
            if( p_kkone == NULL ){
                return -1 ;
            }
            for(i=0;i<10000;i++){
                p_kkone->oo[i] = SEE_NULL ;
                p_kkone->hh[i] = SEE_NULL ;
                p_kkone->ll[i] = SEE_NULL ;
                p_kkone->cc[i] = SEE_NULL ;
                p_kkone->vv[i] = SEE_NULL ;
                memset( p_kkone->ca_TradingDays[i],'\0',9 ) ;
                memset( p_kkone->ca_ActionDays[i],'\0',9 ) ;
                memset( p_kkone->ca_UpdateTimes[i],'\0',9 ) ;
            }
            p_kkone->i_cur=0;
            p_conf->pt_stt_blks[u]->pt_kkall[node->period] = p_kkone;
            node = node->next ;
        }
        see_stt_blk_init( p_conf,p_conf->pt_stt_blks[u],u );
    }
    return 0;
}


int see_stt_blk_init ( see_config_t *p_conf, see_stt_block_t *p_stt_blk, int i_idx )
{
    see_node *node;
    node = p_stt_blk->list ;
    while( node != NULL ){
        see_kkone_init( p_conf, 
                        p_conf->pt_fut_blks[i_idx]->bar_block[node->period].ca_table,
                        10000, p_stt_blk->pt_kkall[node->period] );
        node = node->next ;
    }    
    return 0 ;
}

int see_kkone_init ( see_config_t *p_conf, char *pc_table, int num, see_kkone_t *p_kkone )
{
    see_zdb_open( p_conf );
    see_zdb_get_data(   p_conf,
                        pc_table,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        num,
                        p_kkone );
    /*
    see_zdb_get_data(   p_conf,
                        pc_table,
                        "20161108",
                        "20161110",
                        "09:00:01",
                        "14:30:45",
                        num,
                        p_kkone );
    */

    see_zdb_close( p_conf );
    return 0 ; 
}

int see_update_kkall( see_config_t *p_conf, int i_idx ) 
{
    see_node            *node;
    see_kkone_t         *kkone ;
    see_fut_block_t     *p_fut_blk ;
    see_stt_block_t     *p_stt_blk ;
    see_bar_t           *p_bar0 ;
    see_bar_t           *p_bar1 ;

    p_fut_blk =     p_conf->pt_fut_blks[i_idx] ;
    p_stt_blk =     p_conf->pt_stt_blks[i_idx] ;
    node =          p_stt_blk->list ;

    while( node != NULL ){
        kkone   =   p_stt_blk->pt_kkall[node->period] ;
        p_bar0  =  &p_fut_blk->bar_block[node->period].bar0 ;
        p_bar1  =  &p_fut_blk->bar_block[node->period].bar1 ;

        if ( p_fut_blk->bar_block[node->period].c_save == 's' ){
            memcpy( kkone->ca_TradingDays   [kkone->i_cur], p_bar0->TradingDay, 8 ) ;
            memcpy( kkone->ca_ActionDays    [kkone->i_cur], p_bar0->ActionDay,  8 ) ;
            memcpy( kkone->ca_UpdateTimes   [kkone->i_cur], p_bar0->ca_btime,   8 ) ;
            kkone->oo[kkone->i_cur] = p_bar0->o ;
            kkone->hh[kkone->i_cur] = p_bar0->h ;
            kkone->ll[kkone->i_cur] = p_bar0->l ;
            kkone->cc[kkone->i_cur] = p_bar0->c ;
            kkone->vv[kkone->i_cur] = p_bar0->v ;
            kkone->i_cur++ ;
            memcpy( kkone->ca_TradingDays   [kkone->i_cur], p_bar1->TradingDay, 8 ) ;
            memcpy( kkone->ca_ActionDays    [kkone->i_cur], p_bar1->ActionDay,  8 ) ;
            memcpy( kkone->ca_UpdateTimes   [kkone->i_cur], p_bar1->ca_btime,   8 ) ;
            kkone->oo[kkone->i_cur] = p_bar1->o ;
            kkone->hh[kkone->i_cur] = p_bar1->h ;
            kkone->ll[kkone->i_cur] = p_bar1->l ;
            kkone->cc[kkone->i_cur] = p_bar1->c ;
            kkone->vv[kkone->i_cur] = p_bar1->v ;
        }else{
            memcpy( kkone->ca_TradingDays   [kkone->i_cur], p_bar1->TradingDay, 8 ) ;
            memcpy( kkone->ca_ActionDays    [kkone->i_cur], p_bar1->ActionDay,  8 ) ;
            memcpy( kkone->ca_UpdateTimes   [kkone->i_cur], p_bar1->ca_btime,   8 ) ;
            kkone->oo[kkone->i_cur] = p_bar1->o ;
            kkone->hh[kkone->i_cur] = p_bar1->h ;
            kkone->ll[kkone->i_cur] = p_bar1->l ;
            kkone->cc[kkone->i_cur] = p_bar1->c ;
            kkone->vv[kkone->i_cur] = p_bar1->v ;
        }
        node = node->next ;
    }
    return 0;
}

/*
int see_update_kkone( see_config_t *p_conf, int period )    
{

}

int see_update_kkone ( see_kkone_t  *p_kkone, see_stt_data_t *p_stt_data ) 
{
    int         i_len ;
    if ( p_stt_data->c_save == 'n' ) {
        p_kkone->oo[10000] = p_stt_data->o ;
        p_kkone->hh[10000] = p_stt_data->h ;
        p_kkone->ll[10000] = p_stt_data->l ;
        p_kkone->cc[10000] = p_stt_data->c ;
        p_kkone->vv[10000] = p_stt_data->v ;
    } else {
        i_len = sizeof(double)*9999 ;
        memcpy( (char *)&(p_kkone->oo[0]), (char *)&(p_kkone->oo[1]), i_len ) ;
        memcpy( (char *)&(p_kkone->hh[0]), (char *)&(p_kkone->hh[1]), i_len ) ;
        memcpy( (char *)&(p_kkone->ll[0]), (char *)&(p_kkone->ll[1]), i_len ) ;
        memcpy( (char *)&(p_kkone->cc[0]), (char *)&(p_kkone->cc[1]), i_len ) ;
        i_len = sizeof(int)*9999 ;
        memcpy( (char *)&(p_kkone->vv[0]), (char *)&(p_kkone->vv[1]), i_len ) ;
        p_kkone->oo[10000] = p_stt_data->o ;
        p_kkone->hh[10000] = p_stt_data->h ;
        p_kkone->ll[10000] = p_stt_data->l ;
        p_kkone->cc[10000] = p_stt_data->c ;
        p_kkone->vv[10000] = p_stt_data->v ;
    }
}
*/

static int i_count ;
static char ca_files[200][512] ;

static int trave_dir(char* path)
{
    DIR             *d;
    struct stat     sb;
    int             n,i_len;
    struct dirent   **namelist;
    char            ca_path[512] ;

    if(!(d = opendir(path)))
    {
        printf("error opendir %s!!!/n",path);
        return -1;
    }

    memset( ca_path,'\0',512 );

    n = scandir(path,&namelist,0,alphasort);
    while(n--)
    {
        if(strncmp(namelist[n]->d_name, ".", 1) == 0)
        {
            free( namelist[n] ) ;
            continue;
        }

        sprintf(ca_path,"%s/%s",path,namelist[n]->d_name) ;

        if(stat(ca_path, &sb) >= 0 && S_ISDIR(sb.st_mode)) {
            trave_dir(ca_path);
        }else{
            i_len = strlen(ca_path) ;
            if( strncmp("bin", &ca_path[i_len-3],3) != 0 )
            {
                memset( ca_files[i_count],'\0',512 );
                sprintf(ca_files[i_count],"%s",ca_path) ;
                i_count++ ;
                if( i_count >=200 ) { return -1; } ;
            }
        }
        free( namelist[n] ) ;
    }
    closedir(d);
    return 0;
}

int see_trave_dir(char* path, int *p_count, char pc_files[][512])
{
    int i;
    i_count = 0;
    trave_dir(path) ;
    *p_count = i_count ;
    for(i=0;i<i_count;i++){
        memset(pc_files[i],'\0',512);
        memcpy( pc_files[i],ca_files[i],512 );
    }
    i_count = 0;
    return 0;
}
