#include <stdio.h>

//###################################
#define MAX_ARRAY_LENGTH 20

//###################################
#undef  FILE_SIZE
#define FILE_SIZE 45

//###################################
//#define MESSAGE "ff"
#ifndef MESSAGE
   #define MESSAGE "I wish!"
#endif


#if !defined (MESSAGE)
   #define MESSAGE "You wish!"
#endif


//###################################
#define  message_for(a, b)  \
    printf(#a " and " #b ": We love you!\n")

//###################################
#ifdef DEBUG
   /* Your debugging statements here */
#endif


//###################################
#define MAX(x,y) ((x) > (y) ? (x) : (y))

//###################################
#define tokenpaster(n) printf ("token" #n " = %d \n", token##n)







//###################################
int main(void)
{
	printf("define MESSAGE: %s \n", MESSAGE); 
	printf("MAX(3, 4): %d \n", MAX(3, 4));

	message_for(Carole, Debra);



	int token34 = 40;
	tokenpaster(34);

	return 0;
}
