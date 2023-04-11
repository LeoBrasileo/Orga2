#include "checkpoints.h"

bool esMenorChar(char a, char b){
    return a < b;
}

bool esMayorChar(char a, char b){
    return a > b;
}

void freeC(char* a){
    free(a);
}

void fprintfC(char* a, FILE* pFile){
    fprintf(a, pFile);
}

/* Pueden programar alguna rutina auxiliar del checkpoint 4 acá */

