#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	int a = alternate_sum_4(6,2,4,3);
	printf("alternate_sum_4: %d",a);
	printf("\n");

	int b = alternate_sum_4_using_c(10,3,4,5);
	printf("alternate_sum_4_using_c: %d",b);
	printf("\n");

	int c = alternate_sum_4_simplified(10,2,4,2);
	printf("alternate_sum_4_simplified: %d",c);
	printf("\n");

	int d = alternate_sum_8(10,2,4,2,10,2,4,2);
	printf("alternate_sum_8: %d",d);
	printf("\n");

	uint32_t m = -1;
	product_2_f(&m, 12,2.4);
	printf("multiplciacion flotante : %d",m);
	printf("\n");

	complex_item arr[4];
	arr[0].z = 1;
	arr[1].z = 1;
	arr[2].z = 1;
	arr[3].z = 1;
	int z = complex_sum_z(&arr[0], 4);
	printf("complex sum z : %d",z);
	printf("\n");

	return 0;    
}


