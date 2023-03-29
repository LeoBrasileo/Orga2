#include "stack.h"
#include <stdlib.h>

/* Desapila el último elemento (i.e. lo devuelve y lo elimina de la pila)
*/
uint64_t pop(stack_t *stack)
{
    uint64_t ult = *(stack->esp);
    stack->esp = stack->esp + 1;
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
    stack->esp = stack->esp - 1;
    *stack->esp = data;
}

stack_t * createStack(size_t size)
{
    stack_t *stack = malloc(size);

    stack->_stackMem = size;

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
    for (uint16_t i = act; act != stack->ebp; i++)
    {
        free(act);
    }
    free(stack->_stackMem);
    free(stack);
}
