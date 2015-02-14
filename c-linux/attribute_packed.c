#include <stdio.h>

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

struct __attribute__ ((__packed__))
{
    struct
    {
        char c;
        int i;
    } bar;

    char c;
    int i;
} foo2;

struct
{
    struct __attribute__ ((__packed__))
    {
        char c;
        int i;
    } bar;

    char c;
    int i;
} foo3;

struct __attribute__ ((__packed__))
{
    struct __attribute__ ((__packed__))
    {
        char c;
        int i;
    } bar;

    char c;
    int i;
} foo4;



typedef struct CarSigInputParams1{
	char signal;
	char reverseSensor;
	int fuelSensor;
	char  hwKeyStatus;
	char hwKeyName;
	char IGNStatus;
}CarSigInputParams1;


typedef struct CarSigInputParams2{
	char signal;
	char reverseSensor;
	int fuelSensor;
	char  hwKeyStatus;
	char hwKeyName;
	char IGNStatus;
}__attribute__((packed)) CarSigInputParams2;





//  __attribute__ ((packed)) tương đương với __attribute__ ((aligned (1))) 
//  Theo GNU nó là: packed attribute, attached to an enum, struct, or union type definition, specified that the minimum required memory be used to represent the type.


int main()
{
    printf("sizeof(foo1): %d\n", (int)sizeof(foo1));
    printf("sizeof(foo2): %d\n", (int)sizeof(foo2));
    printf("sizeof(foo3): %d\n", (int)sizeof(foo3));
    printf("sizeof(foo4): %d\n", (int)sizeof(foo4));
    
    CarSigInputParams1 myCarSig;
    
    printf("sizeof(CarSigInputParams1): %d\n", (int)sizeof(CarSigInputParams1));
    printf("sizeof(CarSigInputParams2): %d\n", (int)sizeof(CarSigInputParams2));

    return 0;
}
