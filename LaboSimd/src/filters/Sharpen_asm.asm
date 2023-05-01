extern malloc

section .text
	%define offset_pixels 16
	%define float_size 4
	

global Sharpen_asm


; *src uint_8[rdi], *dst uint_8[rsi], width uint_32[rdx], height uint_32[rcx],
; src_row_size uint_32[r8], dst_row_size uint_32[r9]
Sharpen_asm:
	push rbp
	mov rbp, rsp

	; cargada de registros iniciales
	lea rbx, [rdi] ; rbx = src
	lea r12, [rsi] ; r12 = dst
	xor r13, r13 ; r13 = 0, guardamos en r13 el desplazamiento en src
	xor r14, r14 ; r14 = 0, guardamos en r14 el desplazamiento en dst
	mov r15, rcx ; r15 = height, guardamos en r15 la altura de la imagen


	; crear matriz[float] sharpen
	mov rdi, float_size*9 ;vamos a pedir 9 flotantes ya que es el tamano de la matriz
	call malloc

	xor rcx, rcx
	.llenarMatriz:
	cmp rcx, 9
	je .matrizLlena
	mov DWORD [rax + rcx*float_size], -1
	inc rcx
	jmp .llenarMatriz

	.matrizLlena:
	mov DWORD [rax + 4*float_size], 9


	xor rcx, rcx
	mov rcx, r8 ; rcx = src_row_size

	.filtro:
	cmp r15, 0
	je .fin

	movdqu xmm0, [rbx] ; traemos 4 pixeles

	;aca va la logica del filtro

	movdqu [r12], xmm0 ; guardamos los 4 pixeles en dst
	
	add rbx, offset_pixels ; avanzamos 4 pixeles de lectura en src
	add r12, offset_pixels ; avanzamos 4 pixeles de escritura en dst

	add r13, offset_pixels ; sumamos 4 pixeles al desplazamiento total en src
	add r14, offset_pixels ; sumamos 4 pixeles al desplazamiento total en dst

	cmp r13, rcx ; si nos desplazamos el ancho de la imagen hacemos .sigFila sino seguimos con .ciclo
	jl .filtro

	xor r13, r13 ; reiniciamos el desplazamiento en src
	xor r14, r14 ; reiniciamos el desplazamiento en dst
	dec r15	
	jmp .filtro

	.fin:
	pop rbp
	ret
