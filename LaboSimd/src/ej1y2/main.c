#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	uint8_t* bytes_c = (uint8_t*) malloc(16);
	for (int k = 0; k < 16; k++)
            bytes_c[k] = k+6;

	invertirBytes_asm(bytes_c, 0, 15);

	for(uint32_t j = 0; j < 16; j++){
        printf("bytes_c[%2u] = %3u\t", j, bytes_c[j]);
		printf("\n");
    }
	return 0;    
}


