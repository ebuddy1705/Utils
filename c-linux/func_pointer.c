#include <stdio.h>
#include <stdlib.h>

int release_data(int indata)
{
	printf("indata: %d \n", indata);
	return (indata*2);
}

void func_callback(int data, int (*release_data)(int indata))
{	
	int ret = release_data(data);
	printf("ret: %d \n", ret);	
}





typedef struct node_npc NPC;
struct node_npc
{
    int age;
    int (*put_age)(NPC *character, int age);
};


int set_age(NPC *character, int age){
  character->age = age;     
  return 0;
}


int main(){
	
	
	func_callback(10, release_data);
	
	
	
	
	
	NPC *zelda = (NPC*)malloc(sizeof(NPC));
	zelda->put_age = set_age;
	zelda->put_age(zelda, 25);
    printf("Zelda's age is %d\n", zelda->age);
	
	return 1;
}
