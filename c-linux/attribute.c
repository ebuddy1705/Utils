
#include <stdio.h>


struct Normal_t
{
	char Data1; //4
	int Data3; //4
	char Data4; //4
	float da; //4
	float da2; //4
};//20

struct Aligned_t
{
	char Data1;
	int Data3;
	char Data4;
	float da;
	float da2;
}__attribute__ ((aligned (8))); //20 ==align 8 ==> 24



struct Packed_t
{
	char Data1; //1
	int Data3; //4
	char Data4; //1
	float da; //4
	float da2; //4
}__attribute__((packed));//14



int main(int argc, char **argv)
{
	printf("sizeof(char): %d\n", (int)sizeof(char));
	printf("sizeof(int): %d\n", (int)sizeof(int));
	printf("sizeof(float): %d\n", (int)sizeof(float));
	printf("sizeof(long): %d\n", (int)sizeof(long));
	printf("................... \n");



	struct Normal_t m1;
	struct Aligned_t m2;
	struct Packed_t m3;

	printf("sizeof(Normal_t): %d\n", (int)sizeof(m1));
	printf("sizeof(Aligned_t): %d\n", (int)sizeof(m2));
	printf("sizeof(Packed_t): %d\n", (int)sizeof(m3));

	return 0;
}	
