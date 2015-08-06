// THIS IS A DEPRECATED METHOD OF GETTING HOST NAMES
// use getaddrinfo() instead!

#include <stdio.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[])
{

	struct hostent *he;
	struct in_addr ipv4addr;

#if 1
	inet_pton(AF_INET, "127.0.0.1", &ipv4addr);
	he = gethostbyaddr(&ipv4addr, sizeof(ipv4addr), AF_INET);
	printf("Host name: %s\n", he->h_name);
#else
	struct in6_addr ipv6addr;
	inet_pton(AF_INET6, "2001:db8:63b3:1::beef", &ipv6addr);
	he = gethostbyaddr(&ipv6addr, sizeof(ipv6addr), AF_INET6);
	printf("Host name: %s\n", he->h_name);
#endif

//	char *myip;
//	myip = inet_ntoa(ipv4addr);
//	printf("myip: %s \n", myip);


	return 0;
}
