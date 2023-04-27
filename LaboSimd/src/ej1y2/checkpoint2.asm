extern malloc
extern free
 
 section .rodata
	ocho: times 4 dd 8
	unos: times 16 db 1

section .text

	%define offset 64

global checksum_asm

; uint8_t checksum_asm(void* array, uint32_t n)

checksum_asm:
	push rbp
	mov rbp, rsp

	push rbx
	push r12

	mov ecx, esi ; ecx = n
	mov rbx, rdi ; pasamos la direccion de array a rbx
	movdqu xmm5, [ocho]
	movdqu xmm8, [unos]

	mov rax, 1

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
	pmuldq xmm2, xmm5 ; segunda mitad x 8

	; comparaciones
	pcmpeqd xmm6, xmm0 ; compara las operaciones de la primera mitad con la primera mitad de Cij
	pcmpeqd xmm7, xmm2 ; compara las operaciones de la segunda mitad con la segunda mitad de Cij
	;si son iguales, xmm6 y xmm7 tienen 0xFFFFFFFFFFFFFFFF, sino 0x0000000000000000

	pand xmm6, xmm7

	movd r12d, xmm6 ; muevo el resultado a r12
	movsxd r12, r12d
	
	cmp DWORD r12, 0xFFFFFFFF
	je .vale

	.noVale:
	xor rax, rax
	jmp .fin

	.vale:
	add rbx, offset ; desplazamiento a la proxima terna, rbx = rbx + 64
	loop .ciclo

	
	.fin:
	pop r12
	pop rbx
	pop rbp
	ret