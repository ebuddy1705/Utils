	
.PHONY: all, clean

TARGET	:= MainApp

#-----------------------------------------------

INCDIR=-I./
LIBS=

CFLAGS =  -Wall -g
LDFLAGS = -L/usr/lib
INCDIR += -I/usr/include
LIBS+= -lstdc++

CC=gcc
CXX=g++


#-----------------------------------------------

CPP_SRCS	:= 
           
C_SRCS		:=./Slist.c \
			  ./main-ex.c


				
C_OBJS		:= $(subst .c,.o,$(C_SRCS))
CPP_OBJS	:= $(subst .cpp,.o,$(CPP_SRCS))
OBJS		:= $(C_OBJS) $(CPP_OBJS) 


#-----------------------------------------------
all: $(TARGET)
	
%.o: %.cpp
	$(CXX) -c $(CFLAGS) ${INCDIR} $(LDFLAGS) ${LIBS} $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) ${INCDIR} $(LDFLAGS) ${LIBS} $< -o $@

$(TARGET): $(OBJS)
	$(CXX) $^ $(CFLAGS) ${INCDIR} $(LDFLAGS) ${LIBS} -o $@
	chmod a+x $@
		
install: all
	cp -f $(TARGET) ../bin

clean:
	rm -f *.o
	rm -f $(TARGET)	




	
