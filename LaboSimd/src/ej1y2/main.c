#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

#define ARR_LENGTH  4
#define ROLL_LENGTH 16

static uint32_t x[ROLL_LENGTH];
static double   f[ROLL_LENGTH];

void shuffle(uint32_t max){
	for (int i = 0; i < ROLL_LENGTH; i++) {
		x[i] = (uint32_t) rand() % max;
	}
}

uint32_t shuffle_int(uint32_t min, uint32_t max){
		return (uint32_t) (rand() % max) + min;
}

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	uint8_t* bytes_c = (uint8_t*) malloc(16);
	for (int k = 0; k < 16; k++)
            bytes_c[k] = k;

	invertirBytes_asm(bytes_c, 1, 10);

	for(uint32_t j = 0; j < 16; j++){
        printf("bytes_c[%2u] = %3u\t", j, bytes_c[j]);
		printf("\n");
    }

	uint32_t array_size = shuffle_int(1,20);
    data_t* test_data = (data_t*) malloc(sizeof(data_t)*array_size);
    for(uint32_t j = 0; j < array_size; j++){
        shuffle(1000);
        for (int k = 0; k < 8; k++){
            test_data[j].a[k] = x[k];
            test_data[j].b[k] = x[k+8];
            test_data[j].c[k] = ((uint32_t) test_data[j].a[k] + (uint32_t) test_data[j].b[k])*8;
        }
    }

	int res = checksum_asm(test_data, array_size);

	printf("checksum: %d ", res);
	printf("\n");
	
	free(bytes_c);
	free(test_data);

	return 0;    
}

