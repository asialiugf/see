#!/bin/sh
# cat see_future_time | while read LINE
#do
#   $kk =  `echo $LINE | awk "{print $2}"`
#    echo $kk
#done
kk="mm" ;
if [ "$kk" != "#" ]; then
    echo $kk
fi

mkdir $HOME/see/dat
mkdir $HOME/see/dat/ctp_dat
mkdir $HOME/see/dat/rcv_dat
mkdir $HOME/see/dat/tst_dat

mkdir $HOME/see/bin
mkdir $HOME/see/bin/exe

awk '{print $1}' $HOME/see/etc/tbl/see_future_time | while read kk
do
#    echo $kk
    if [ "$kk" != "#" ]; then
        echo $kk
        mkdir $HOME/see/dat/ctp_dat/$kk
        cd $HOME/see/dat/ctp_dat/$kk
            mkdir tick
            mkdir 1s
            mkdir 2s
            mkdir 3s
            mkdir 5s
            mkdir 10s
            mkdir 15s
            mkdir 20s
            mkdir 30s
            mkdir 1f
            mkdir 2f
            mkdir 3f
            mkdir 5f
            mkdir 10f
            mkdir 15f
            mkdir 20f
            mkdir 30f
            mkdir 1h
            mkdir 2h
            mkdir 3h
            mkdir 4h
            mkdir 5h
            mkdir 6h
            mkdir 8h
            mkdir 10h
            mkdir 12h
            mkdir 1d
            mkdir 1w
            mkdir 1m
            mkdir 1j
            mkdir 1y
        mkdir $HOME/see/dat/tst_dat/$kk
        cd $HOME/see/dat/tst_dat/$kk
            mkdir tick
            mkdir 1s
            mkdir 2s
            mkdir 3s
            mkdir 5s
            mkdir 10s
            mkdir 15s
            mkdir 20s
            mkdir 30s
            mkdir 1f
            mkdir 2f
            mkdir 3f
            mkdir 5f
            mkdir 10f
            mkdir 15f
            mkdir 20f
            mkdir 30f
            mkdir 1h
            mkdir 2h
            mkdir 3h
            mkdir 4h
            mkdir 5h
            mkdir 6h
            mkdir 8h
            mkdir 10h
            mkdir 12h
            mkdir 1d
            mkdir 1w
            mkdir 1m
            mkdir 1j
            mkdir 1y
        mkdir $HOME/see/dat/rcv_dat/$kk
        cd $HOME/see/dat/rcv_dat/$kk
            mkdir tick
            mkdir 1s
            mkdir 2s
            mkdir 3s
            mkdir 5s
            mkdir 10s
            mkdir 15s
            mkdir 20s
            mkdir 30s
            mkdir 1f
            mkdir 2f
            mkdir 3f
            mkdir 5f
            mkdir 10f
            mkdir 15f
            mkdir 20f
            mkdir 30f
            mkdir 1h
            mkdir 2h
            mkdir 3h
            mkdir 4h
            mkdir 5h
            mkdir 6h
            mkdir 8h
            mkdir 10h
            mkdir 12h
            mkdir 1d
            mkdir 1w
            mkdir 1m
            mkdir 1j
            mkdir 1y
    fi
done
