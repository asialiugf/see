
CC:=g++
CCFLAGS := -g -Wall -O3 -pthread 

ALLINC = -I ccc/com/inc \
		 -I ccc/unx/inc \
		 -I cpp/pro/inc \
		-I /usr/local/include/nanomsg \
		-I /usr/local/include/zdb \
		-I /usr/local/include/ta-lib \
		-I ./ctp

CTPINC:= ./ctp/
CTPLIB:= ./ctp/
CTPLIBS:= ./ctp/thostmduserapi.so \
		./ctp/thosttraderapi.so


COMINC:= ./com/inc/
COMOBJ:= ./com/obj/
COMSRC:= ./com/src/

DBSINC:= ./dbs/inc/
DBSOBJ:= ./dbs/obj/
DBSSRC:= ./dbs/src/

FSSINC:= ./fss/inc/
FSSOBJ:= ./fss/obj/
FSSSRC:= ./fss/src/

IOSINC:= ./ios/inc/
IOSOBJ:= ./ios/obj/
IOSSRC:= ./ios/src/

INDINC:= ./ind/inc/
INDOBJ:= ./ind/obj/
INDSRC:= ./ind/src/

STGINC:= ./stg/inc/
STGOBJ:= ./stg/obj/
STGSRC:= ./stg/src/

MDSINC:= cpp/mds/inc/
MDSOBJ:= cpp/mds/obj/
MDSSRC:= cpp/mds/src/

PROINC:= cpp/pro/inc/
PROOBJ:= cpp/pro/obj/
PROSRC:= cpp/pro/src/

TDSINC:= ./tds/inc/
TDSOBJ:= ./tds/obj/
TDSSRC:= ./tds/src/

ETCTBL= ../etc/tbl/
BINEXE= ../bin/exe/
BINOBJ= ../bin/obj/

FILES = $(MDSSRC)see_sndtst.cpp \
		$(MDSSRC)MdSpi.cpp

CCCOBJ:= \
     ccc/com/obj/see_errlog.o \
     ccc/com/obj/see_signal.o \
     ccc/com/obj/see_daemon.o \
     ccc/com/obj/see_bars.o \
     ccc/com/obj/see_pubsub.o \
     ccc/com/obj/see_iofile.o \
     ccc/com/obj/see_cjson.o \
     ccc/com/obj/see_config.o \
     ccc/com/obj/see_strategy.o \
     ccc/com/obj/see_zdbfun.o \
     ccc/com/obj/see_zmq.o \
     ccc/com/obj/see_future.o \
	 ccc/unx/obj/see_setproctitle.o \
	 ccc/unx/obj/see_process.o \
	 ccc/unx/obj/see_shmem.o

TSTOBJS = $(MDSOBJ)see_sndtst.o \
		  $(MDSOBJ)MdSpi.o

CTPOBJS = $(MDSOBJ)MdSpi.o \
		  $(MDSOBJ)see_ctpget.o

FUTOBJS = $(MDSOBJ)MdSpi.o \
		  $(MDSOBJ)see_ctpget.o \
		  $(PROOBJ)see_master.o \
		  $(MDSOBJ)future.o

#all: \
#	$(BINEXE)ctpget.x \
#	$(BINEXE)sss.x

all: \
	$(BINEXE)future.x \
	$(BINEXE)sss.x

$(BINEXE)future.x: $(FUTOBJS) \
					$(COMOBJS)
		$(CC) -o $(BINEXE)future.x $(FUTOBJS) $(CCCOBJ) $(CTPLIBS) -lzdb -lnanomsg -lerrlog -lcjson -lpthread -lzmq

$(BINEXE)sss.x: $(TSTOBJS) \
					$(COMOBJS)
		$(CC) -o $(BINEXE)sss.x $(TSTOBJS) $(CCCOBJ) $(CTPLIBS) -lzdb -lnanomsg -lerrlog -lcjson -lpthread -lzmq

$(MDSOBJ)see_ctpget.o: $(MDSSRC)see_ctpget.cpp
		$(CC) $(CCFLAGS) $(ALLINC) -I$(MDSINC) -c $(MDSSRC)see_ctpget.cpp
		mv see_ctpget.o $(MDSOBJ)

$(MDSOBJ)future.o: $(MDSSRC)future.cpp
		$(CC) $(CCFLAGS) $(ALLINC) -I$(MDSINC) -c $(MDSSRC)future.cpp
		mv future.o $(MDSOBJ)

$(MDSOBJ)see_sndtst.o: $(MDSSRC)see_sndtst.cpp
		$(CC) $(CCFLAGS) $(ALLINC) -I$(MDSINC) -c $(MDSSRC)see_sndtst.cpp
		mv see_sndtst.o $(MDSOBJ)

$(MDSOBJ)MdSpi.o: $(MDSSRC)MdSpi.cpp
		$(CC) $(CCFLAGS) $(ALLINC) -I$(MDSINC) -c $(MDSSRC)MdSpi.cpp
		mv MdSpi.o $(MDSOBJ)

$(PROOBJ)see_master.o: $(PROSRC)see_master.cpp
		$(CC) $(CCFLAGS) $(ALLINC) -I$(PROINC) -c $(PROSRC)see_master.cpp
		mv see_master.o $(PROOBJ)

