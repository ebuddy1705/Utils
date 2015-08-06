
#include <stdio.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main()
{
	struct servent* se = getservbyname("telnet", "tcp");
	printf("telnet: %d\n", ntohs(se->s_port));

	se = getservbyname("ftp", "tcp");
	printf("ftp: %d\n", ntohs(se->s_port));

	return 0;
}
