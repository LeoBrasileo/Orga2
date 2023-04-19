section .rodata
	ocho: times 4 dd 8
	unos: times 16 db 1

section .text

	%define offset 64

global checksum_asm

; uint8_t checksum_asm(void* array, uint32_t n)

checksum_asm:
	push rbp
	mov rsp, rbp

	mov ecx, esi ; ecx = n
	mov rbx, rdi ; pasamos la direccion de array a rbx
	movdqu xmm5, [ocho]
	movdqu xmm8, [unos]


	.ciclo:
	
	; partimos los Aij, Bij, Cij en dos partes

	pmovzxwd xmm0, [rbx] ; muevo la primera mitad de Aij a xmm0 extendiendola a 32 bits
	pmovzxwd xmm1, [rbx + 16]	; muevo la primera mitad de Bij a xmm1 extendiendola a 32 bits
	pmovzxwd xmm2, [rbx + 8] ; muevo la segunda mitad de Aij a xmm0 extendiendola a 32 bits
	pmovzxwd xmm3, [rbx + 24] ; muevo la segunda mitad de Bij a xmm0 extendiendola a 32 bits
	movdqu xmm6, [rbx + 32] ; muevo la primera mitad de Cij a xmm6
	movdqu xmm7, [rbx + 48] ; muevo la segunda mitad de Cij a xmm7

	; operaciones
	paddw xmm0, xmm1 ; sumo las primeras mitades
	paddw xmm2, xmm3 ; sumo las segundas mitades
	pmuldq xmm0, xmm5 ; primera mitad x 8
	pmuldq xmm1, xmm5 ; segunda mitad x 8

	; comparaciones
	pcmpeqd xmm6, xmm0 ; compara las operaciones de la primera mitad con la primera mitad de Cij
	pcmpeqd xmm7, xmm1 ; compara las operaciones de la segunda mitad con la segunda mitad de Cij
	pand xmm6, xmm7 ; chequea si ambas mitades son iguales
	ptest xmm8, xmm6 ; chequea si el resultado es 1

	; saltos
	jnz .fin ; si no es 1, salta a fin
	add rbx, offset ; desplazamiento a la proxima terna, rbx = rbx + 64
	loop .ciclo
	jmp .fin

	.fin:
	mov rsp, rbp
	pop rbp
	ret

