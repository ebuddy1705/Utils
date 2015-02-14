#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>


struct
{
	char c;
	int i;
} bar;
    
struct
{
    struct
    {
        char c;
        int i;
    } bar;

    char c;
    int i;
} foo1;




int main(void)
{
	
	printf("size of char: %d \n", sizeof(char));
	printf("size of char: %d \n", sizeof(int));
	printf("size of char: %d \n", sizeof(float));
	printf("size of char: %d \n", sizeof(double));
	
	printf("size of bar: %d \n", sizeof(bar));
	printf("size of foo1: %d \n", sizeof(foo1));
	
	
	
	
	fd_set rfds;
	struct timeval tv;
	int retval;
	
	/* Watch stdin (fd 0) to see when it has input. */
	FD_ZERO(&rfds);
	FD_SET(0, &rfds);
	
	/* Wait up to five seconds. */
	tv.tv_sec = 5;
	tv.tv_usec = 0;
	
	retval = select(1, &rfds, NULL, NULL, &tv);
	/* Don't rely on the value of tv now! */
	
	if (retval == -1)
	perror("select()");
	else if (retval)
	printf("Data is available now.\n");
	/* FD_ISSET(0, &rfds) will be true. */
	else
	printf("No data within five seconds.\n");
	
	exit(EXIT_SUCCESS);
}
