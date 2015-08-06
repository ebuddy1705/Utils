#include <stdio.h>

typedef struct persion_t persion_t;
struct persion_t{
	int age;
	
	void (*setage)(persion_t *this, int age);
	
};

int init_age()
{
	printf("init_age\n");
	return 10;
}
void setage(persion_t *this, int age){
	printf("setage\n");
	this->age = age;
}


int main ()
{
 
	persion_t persion = {
		.age = init_age(),
		.setage = setage,
	};


	persion.setage(&persion, 20);
	return 0;
}
