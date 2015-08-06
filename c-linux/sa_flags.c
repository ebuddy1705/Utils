#include <signal.h>
#include <stdio.h>

static void handler(int signum)
{
	/* Take appropriate actions for signal delivery */
	printf("handler processing \n");
}


int main()
{
	struct sigaction sa;


	sa.sa_handler = handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_RESTART; /* Restart functions if
								 interrupted by handler */
	if (sigaction(SIGINT, &sa, NULL) == -1) return -1;


	raise(SIGINT);

	printf("main processing \n");

	/* Further code */
}
