#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	int a = alternate_sum_4(2,4,7,45);
	printf("alternate_sum_4: %d",a);
	printf("\n");
	return 0;    
}


