# Straight forward Makefile to compile all examples in a row

INCDIR=-I./
LIBS= -lpthread



# new add
CFLAGS =  -Wall -g
LDFLAGS = -L/usr/lib
INCDIR += -I/usr/include
LIBS+= -lstdc++ -lpthread 
	
CC=gcc
CXX=g++
	
	
	

COMMONSRC=
COMMONHDR=

SEM-EX=./sem-ex.c


default: all

all: sem-ex
     
clean:
	find . -name "CH??_*" | xargs rm -f

sem-ex: ${COMMONSRC} ${SEM-EX}
	$(CC) ${COMMONSRC} ${SEM-EX} -o $@ $(CFLAGS) $(LDFLAGS) ${INCDIR} ${LIBS} 

	
