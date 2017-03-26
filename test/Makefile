PROJECT := timetest.x \
		   zip.x

CC := gcc
CPP := g++

IDIR   := $(CPPUTEST_HOME)/include
CFLAGS := -I$(IDIR) -Wall

LDIR := -L$(CPPUTEST_HOME)/lib
UNITTESTEXE := test.x


C_SRC = zip.c \
	    timetest.c

OBJS := zip.o \
        timetest.o

all: $(PROJECT)

$(PROJECT): $(C_SRC)
	$(RM) $(OBJS) $(PROJECT) $(UNITTESTEXE)
	$(CC) -c $(C_SRC) $(CFLAGS)
	$(CC) -o timetest.x timetest.o
	$(CC) -o zip.x zip.o -lz

.PHONY: clean
clean:
	$(RM) $(OBJS) $(PROJECT) $(UNITTESTEXE)
