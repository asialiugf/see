
CC =    cc   
CFLAGS =  -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g -pthread
CPP =   cc -E
LINK =  $(CC)

BINEXE = ../bin/exe/

COMSRC = ccc/com/src/
COMOBJ = ccc/com/obj/

STTSRC = ccc/stt/src/
STTOBJ = ccc/stt/obj/
STTLIB = ccc/stt/lib/

ALL_INCS = -I ccc/com/inc \
       -I ccc/ios/inc \
       -I ccc/stt/inc \
       -I /usr/local/include/nanomsg \
       -I /usr/local/include/zdb \
       -I /usr/local/include/errlog


ALL_DEPS = ccc/com/inc/see_com_auto.h \
		ccc/com/inc/see_com_common.h \
		ccc/com/inc/see_com_linux.h \
		ccc/com/inc/see_errlog.h \
		ccc/com/inc/see_signal.h \
		ccc/com/inc/see_daemon.h \
		ccc/com/inc/see_future.h \
		ccc/com/inc/see_iofile.h \
		ccc/com/inc/see_bars.h \
		ccc/com/inc/see_cjson.h \
		ccc/com/inc/see_config.h \
		ccc/com/inc/see_zmq.h \
		ccc/com/inc/see_pubsub.h

STT_DEPS = ccc/stt/inc/see_stt01.h \
		ccc/stt/inc/see_stt02.h

build:  binary

binary: objs exes sttobjs

exes: \
	$(BINEXE)rrr.x \
	$(BINEXE)maria.x \
	$(BINEXE)kdj.x

objs: ccc/com/obj/see_errlog.o \
	ccc/com/obj/see_signal.o \
	ccc/com/obj/see_daemon.o \
	ccc/com/obj/see_bars.o \
	ccc/com/obj/see_pubsub.o \
	ccc/com/obj/see_future.o \
	ccc/com/obj/see_iofile.o \
	ccc/com/obj/see_recieve.o \
	ccc/com/obj/see_cjson.o \
	ccc/com/obj/see_mariadb.o \
	ccc/com/obj/see_strategy.o \
	ccc/com/obj/see_config.o \
	ccc/com/obj/see_zdbfun.o \
	ccc/com/obj/see_zmq.o \
	ccc/com/obj/see_testkdj.o

CCCOBJS:= \
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
	 ccc/com/obj/see_recieve.o \
     ccc/com/obj/see_future.o

COMOBJS:= \
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
     ccc/com/obj/see_future.o


sttobjs: \
	ccc/stt/obj/see_stt01.o \
	ccc/stt/obj/see_stt02.o


$(BINEXE)rrr.x: $(CCCOBJS)
	$(CC) $(CFLAGS) -o $(BINEXE)rrr.x $(CCCOBJS) -lzdb -lnanomsg -lta_lib -lerrlog -lcjson -lzmq

$(BINEXE)kdj.x: $(objs)
	$(CC) $(CFLAGS) -o $(BINEXE)kdj.x $(COMOBJS) ccc/com/obj/see_testkdj.o -lzdb -lnanomsg -lerrlog -lsee_talib -lcjson -lzmq 

$(BINEXE)maria.x: $(objs)
	$(CC) $(CFLAGS) -o $(BINEXE)maria.x $(objs) ccc/com/obj/see_signal.o ccc/com/obj/see_daemon.o ccc/com/obj/see_errlog.o \
			ccc/com/obj/see_bars.o ccc/com/obj/see_pubsub.o ccc/com/obj/see_mariadb.o ccc/com/obj/see_config.o ccc/com/obj/see_cjson.o \
			ccc/com/obj/see_future.o ccc/com/obj/see_iofile.o ccc/com/obj/see_strategy.o ccc/com/obj/see_zdbfun.o ccc/com/obj/see_zmq.o \
			-lzdb -lnanomsg -lerrlog -lsee_talib -lcjson -lzmq

$(COMOBJ)see_cjson.o: $(ALL_DEPS) $(COMSRC)see_cjson.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_cjson.o  $(COMSRC)see_cjson.c

$(COMOBJ)see_zmq.o: $(ALL_DEPS) $(COMSRC)see_zmq.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_zmq.o  $(COMSRC)see_zmq.c

$(COMOBJ)see_errlog.o: $(ALL_DEPS) $(COMSRC)see_errlog.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_errlog.o  $(COMSRC)see_errlog.c

$(COMOBJ)see_pubsub.o: $(ALL_DEPS) $(COMSRC)see_pubsub.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_pubsub.o  $(COMSRC)see_pubsub.c

$(COMOBJ)see_signal.o: $(ALL_DEPS) $(COMSRC)see_signal.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_signal.o  $(COMSRC)see_signal.c

$(COMOBJ)see_bars.o: $(ALL_DEPS) $(COMSRC)see_bars.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_bars.o  $(COMSRC)see_bars.c

$(COMOBJ)see_daemon.o: $(ALL_DEPS) $(COMSRC)see_daemon.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_daemon.o  $(COMSRC)see_daemon.c

$(COMOBJ)see_future.o: $(ALL_DEPS) $(COMSRC)see_future.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_future.o  $(COMSRC)see_future.c

$(COMOBJ)see_iofile.o: $(ALL_DEPS) $(COMSRC)see_iofile.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_iofile.o  $(COMSRC)see_iofile.c

$(COMOBJ)see_recieve.o: $(ALL_DEPS) $(COMSRC)see_recieve.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_recieve.o  $(COMSRC)see_recieve.c

$(COMOBJ)see_testkdj.o: $(ALL_DEPS) $(COMSRC)see_testkdj.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_testkdj.o  $(COMSRC)see_testkdj.c

$(COMOBJ)see_mariadb.o: $(ALL_DEPS) $(COMSRC)see_mariadb.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_mariadb.o  $(COMSRC)see_mariadb.c

$(COMOBJ)see_strategy.o: $(ALL_DEPS) $(COMSRC)see_strategy.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_strategy.o  $(COMSRC)see_strategy.c

$(COMOBJ)see_config.o: $(ALL_DEPS) $(COMSRC)see_config.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_config.o  $(COMSRC)see_config.c

$(COMOBJ)see_zdbfun.o: $(ALL_DEPS) $(COMSRC)see_zdbfun.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(COMOBJ)see_zdbfun.o  $(COMSRC)see_zdbfun.c

$(STTOBJ)see_stt01.o: $(STT_DEPS) $(STTSRC)see_stt01.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(STTOBJ)see_stt01.o  $(STTSRC)see_stt01.c

$(STTOBJ)see_stt02.o: $(STT_DEPS) $(STTSRC)see_stt02.c
	$(CC) -c $(CFLAGS) $(ALL_INCS) -o $(STTOBJ)see_stt02.o  $(STTSRC)see_stt02.c
