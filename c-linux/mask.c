#include <stdio.h>

#define MASK_CLEAN (0)
#define MASK_NUM1 (1 << 0)
#define MASK_NUM2 (1 << 1)
#define MASK_NUM3 (1 << 2)
#define MASK_NUM4 (1 << 3)

//recoment
#define COMPONENT_NO_MOTION 	(0x00)
#define COMPONENT_MOTION 		(0x01<<0)
#define COMPONENT_TEXTURE		(0x01<<1)
#define COMPONENT_SCALE			(0x01<<2)

int main ()
{
    printf("MASK_NUM1: %d \n", MASK_NUM1);
    printf("MASK_NUM2: %d \n", MASK_NUM2);
    printf("MASK_NUM3: %d \n", MASK_NUM3);
    printf("MASK_NUM4: %d \n", MASK_NUM4);


    printf("COMPONENT_NO_MOTION: %d \n", COMPONENT_NO_MOTION);
    printf("COMPONENT_MOTION: %d \n", COMPONENT_MOTION);
    printf("COMPONENT_TEXTURE: %d \n", COMPONENT_TEXTURE);
    printf("COMPONENT_SCALE: %d \n", COMPONENT_SCALE);

    unsigned char mask = 0;

    mask = mask&MASK_CLEAN;

    mask |=MASK_NUM1;
    mask |=MASK_NUM2;

    if(mask & MASK_NUM1){
        printf("MASK_NUM1 \n");
    }
    if(mask & MASK_NUM2){
        printf("MASK_NUM2 \n");
    }
    if(mask & MASK_NUM3){
        printf("MASK_NUM3 \n");
    }
    if(mask & MASK_NUM4){
        printf("MASK_NUM4 \n");
    }


	return 0;
}
