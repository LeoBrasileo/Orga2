#include "student.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>


void printStudent(student_t *stud){
    printf("nombre del estudiante: %s\n", stud->name);
    printf("dni del estudiante: %u\n", stud->dni);
    printf("calificaciones: ");
    for(size_t i = 0; i < NUM_CALIFICATIONS; i++){
        printf("%hnu ", stud->califications);
    }
    printf("\n");
    printf("Concepto: %hd\n", stud->concept);
}

void printStudentp(studentp_t *stud){
    printf("nombre del estudiante: %s\n", stud->name);
    printf("dni del estudiante: %u\n", stud->dni);
    printf("calificaciones: ");
    for(size_t i = 0; i < NUM_CALIFICATIONS; i++){
        printf("%hnu ", stud->califications);
    }
    printf("\n");
    printf("Concepto: %hd\n", stud->concept);

}
