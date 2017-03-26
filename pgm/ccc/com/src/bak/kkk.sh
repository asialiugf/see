cc    -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I ../inc -o main.o main.c
cc    -c -pipe  -O -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g  -I ../inc -o see_talib.o see_talib.c
cc -o main.x main.o see_talib.o -lerrlog
