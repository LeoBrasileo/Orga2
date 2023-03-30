#include "student.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>


void printStudent(student_t *stud){
    printf("nombre del estudiante: %s\n", stud->name);
    printf("dni del estudiante: %u\n", stud->dni);
    printf("calificaciones: ");
    for(uint8_t i = 0; i < NUM_CALIFICATIONS; i++){
        printf("%hhu ", stud->califications[i]);
    }
    printf("\n");
    printf("Concepto: %hd\n", stud->concept);
    printf("--------------\n");
}

void printStudentp(studentp_t *stud){
    printf("nombre del estudiante: %s\n", stud->name);
    printf("dni del estudiante: %u\n", stud->dni);
    printf("calificaciones: ");
    for(uint8_t i = 0; i < NUM_CALIFICATIONS; i++){
        printf("%hhu ", stud->califications[i]);
    }
    printf("\n");
    printf("Concepto: %hd\n", stud->concept);
    printf("--------------\n");
}

//https://stackoverflow.com/questions/26362386/why-is-the-format-specifier-for-uint8-t-and-uint16-t-the-same-u
