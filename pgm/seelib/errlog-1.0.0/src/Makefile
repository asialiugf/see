#MAKEFILE************  
   
CC=cc
CCFLAGS =  -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g -pthread
   
LDFLAGS=-fPIC -shared  

build:all
   
all: liberrlog.a 
   
liberrlog.a: errlog.o
	ar r liberrlog.a errlog.o  
   
errlog.o: errlog.c
	$(CC) -c $(CCFLAGS) -o errlog.o errlog.c
