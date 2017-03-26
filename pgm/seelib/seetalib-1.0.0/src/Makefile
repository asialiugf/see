#MAKEFILE************  
   
CC=cc
CCFLAGS =  -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g -pthread
   
LDFLAGS=-fPIC -shared  

build:all
   
all: libsee_talib.a \
	libsee_talib.so
   
libsee_talib.a: see_talib.o
	ar r libsee_talib.a see_talib.o  

libsee_talib.so: see_talib.c
	$(CC) -o libsee_talib.so -shared -fPIC see_talib.c

see_talib.o: see_talib.c
	$(CC) -c $(CCFLAGS) -o see_talib.o see_talib.c
