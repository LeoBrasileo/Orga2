#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	int a = alternate_sum_4(8,2,5,1);
	printf("alternate_sum_4: %d",a);
	printf("\n");

	int b = alternate_sum_4_using_c(6,2,4,3);
	printf("alternate_sum_4_using_c: %d",b);
	printf("\n");

	return 0;    
}


