#include "stack.h"
#include <stdlib.h>

/* Desapila el último elemento (i.e. lo devuelve y lo elimina de la pila)
*/
uint64_t pop(stack_t *stack)
{
    uint64_t ult = *(stack->esp);
    stack->esp = stack->esp++;
    return ult;
}


/* Devuelve el contenido del tope de la pila (y lo mantiene).
*/
uint64_t top(stack_t *stack)
{
    uint64_t ult = *(stack->esp);
    return ult;
}

/* Apila el contenido de 'data'
*/
void push(stack_t *stack, uint64_t data)
{
    if (stack->esp >= stack->_stackMem){
        *(--stack->esp) = data;
    }
}

stack_t * createStack(size_t size)
{
    stack_t *stack = malloc(sizeof(stack_t));

    // Asignamos en stackMem toodos los espacios posibles de expansion del stack
    stack->_stackMem = malloc(size * sizeof(uint64_t));

    stack->ebp = stack->_stackMem + size - 1;  // La base del stack es la dirección numéricamente más grande.
    stack->esp = stack->ebp;  // Al comienzo, la base y el tope coinciden

    stack->pop = pop;
    stack->top = top;
    stack->push = push;

    return stack;
}

void deleteStack(stack_t *stack)
{
    uint64_t *act = stack->_stackMem;
    while(act != stack->ebp){
        free(act);
        act++;
    }
    free(stack->_stackMem);
    free(stack);
}
