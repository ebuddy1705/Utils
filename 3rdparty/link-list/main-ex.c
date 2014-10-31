#include <stdio.h>
#include "Slist.h"


int main (void)
{
	int i=0, length=0;
	slist *mylist = NULL; //NOTE: always equas NULL at declare
	slist *walk=NULL;
	
	for(i=0; i<10; i++){
		int *newint = (int *)malloc(sizeof(int));
		printf("Number \n");
		*newint = i;
		
		mylist = slist_append(mylist, (void*)newint);
			
	}
	
	
	length = slist_size(mylist);
	printf("Number of element: %d \n", length);
	
	
	walk = mylist;
	
	while(walk){
		printf("data: %d \n", *((int*)walk->data));
		
		walk=walk->next;
		
	}
	
	
	
	
		
	
	return 0;	
}
