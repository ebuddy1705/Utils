#include <signal.h>
#include <stdio.h>

void on_sigusr1(int sig)
{
	// Note: Normally, it's not safe to call almost all library functions in a
	// signal handler, since the signal may have been received in a middle of a
	// call to that function.
	printf("SIGUSR1 received!\n");
}

int main(void)
{
	// Set a signal handler for SIGUSR1
#ifdef CASE1
	signal(SIGUSR1, &on_sigusr1);
#else
	struct sigaction act;
	act.sa_handler = on_sigusr1;
	sigemptyset(&act.sa_mask);
	act.sa_flags = 0;
	sigaction(SIGUSR1, &act, 0);
#endif

	// At program startup, SIGUSR1 is neither blocked nor pending, so raising it
	// will call the signal handler
	raise(SIGUSR1);

	// Now let's block SIGUSR1
	sigset_t sigset;
	sigemptyset(&sigset);
	sigaddset(&sigset, SIGUSR1);
	sigprocmask(SIG_BLOCK, &sigset, NULL);

	// SIGUSR1 is now blocked, raising it will not call the signal handler
	printf("About to raise SIGUSR1\n");
	raise(SIGUSR1);
	printf("After raising SIGUSR1\n");

	// SIGUSR1 is now blocked and pending -- this call to sigwait will return
	// immediately
	int sig;
	int result = sigwait(&sigset, &sig);
	if(result == 0)
		printf("sigwait got signal: %d\n", sig);

	// SIGUSR1 is now no longer pending (but still blocked).  Raise it again and
	// unblock it
	raise(SIGUSR1);
	printf("About to unblock SIGUSR1\n");
	sigprocmask(SIG_UNBLOCK, &sigset, NULL);
	printf("Unblocked SIGUSR1\n");

	result = sigwait(&sigset, &sig);
	if(result == 0)
		printf("sigwait got signal: %d\n", sig);

	return 0;
}
