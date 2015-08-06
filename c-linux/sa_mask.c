#include <stdio.h>
#include <unistd.h>
#include <signal.h>

void catcher( int sig ) {

	printf( "catcher() has gained control\n" );
}

int main( int argc, char *argv[] ) {

	struct sigaction sigact;
	sigset_t sigset;

	sigemptyset( &sigact.sa_mask );
	sigact.sa_flags = 0;
	sigact.sa_handler = catcher;
	sigaction( SIGUSR1, &sigact, NULL );

	printf( "before first kill()\n" );
	kill( getpid(), SIGUSR1 );

	/*
	 * Blocking SIGUSR1 signals prevents the signals
	 * from being delivered until they are unblocked,
	 * so the catcher will not gain control.
	 */

	sigemptyset( &sigact.sa_mask );
	sigaddset( &sigact.sa_mask, SIGUSR1 );
	sigprocmask( SIG_SETMASK, &sigact.sa_mask, NULL );

	printf( "before second kill()\n" );
	kill( getpid(), SIGUSR1 );
	printf( "after second kill()\n" );

	return( 0 );
}

/*
 before first kill()
	catcher() has gained control
	before second kill()
	after second kill()
*/
