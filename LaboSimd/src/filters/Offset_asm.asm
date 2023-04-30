section .rodata
mascara_1:
  db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F

; la mascara se define de a 4 bytes, en orden blue, red, green, alpha
solo_alpha:
	db 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF

section .data
	%define blue 0
	%define red 1
	%define green 2
	%define alpha 3
	%define pixel_size 4
	%define offset_pixels 16

section .text

global Offset_asm

; *src uint_8[rdi], *dst uint_8[rsi], width uint_32[rdx], height uint_32[rcx],
; src_row_size uint_32[r8], dst_row_size uint_32[r9]
Offset_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15

	.todoNegro:

	lea rbx, [rdi] ; rbx = src
	lea r12, [rsi] ; r12 = dst
	xor r13, r13 ; r13 = 0, guardamos en r13 el desplazamiento en src
	xor r14, r14 ; r14 = 0, guardamos en r14 el desplazamiento en dst
	mov r15, rcx ; r15 = height, guardamos en r15 la altura de la imagen
	push rcx

	xor rcx, rcx
	mov rcx, r8 ; rcx = src_row_size

	movdqu xmm15, [solo_alpha] ; pasamos la mascara a xmm15

	.cicloNegro:
	cmp r15, 0 ; si r15 = 0 terminamos
	je .filtro

	movdqu xmm0, [rbx] ; traemos 4 pixeles
	pand xmm0, xmm15 ; AND con la mascara
	movdqu [r12], xmm0 ; guardamos los 4 pixeles en dst
	
	add rbx, offset_pixels ; avanzamos 4 pixeles de lectura en src
	add r12, offset_pixels ; avanzamos 4 pixeles de escritura en dst

	add r13, offset_pixels ; sumamos 4 pixeles al desplazamiento total en src
	add r14, offset_pixels ; sumamos 4 pixeles al desplazamiento total en dst

	cmp r13, rcx ; si nos desplazamos el ancho de la imagen hacemos .sigFila sino seguimos con .ciclo
	jl .cicloNegro
	
	.sigFilaNegro:
	xor r13, r13 ; reiniciamos el desplazamiento en src
	xor r14, r14 ; reiniciamos el desplazamiento en dst
	dec r15	
	jmp .cicloNegro

	.filtro:
	imul r9, 8 ; r9 = dst_row_size * 8

	lea rbx, [rdi] ; rbx = src
	lea r12, [rsi] ; r12 = dst
	xor r13, r13 ; r13 = 0, guardamos en r13 el desplazamiento en src
	xor r14, r14 ; r14 = 0, guardamos en r14 el desplazamiento en dst
	pop rcx
	mov r15, rcx ; r15 = height, guardamos en r15 la altura de la imagen

	xor rcx, rcx
	mov rcx, r8 ; rcx = src_row_size
	sub rcx, offset_pixels*4 ; rcx = src_row_size - 8 pixels

	add r12, r9 ; r12 = dst + dst_row_size * 8
	add rbx, r9 ; rbx = src + dst_row_size * 8
	add r12, offset_pixels*2 ; avanzo 8 pixeles
	add rbx, offset_pixels*2
	sub r15, 16 ; r15 = height - 16 pixeles, 8 arriba, 8 abajo

	.cicloFiltro:
	cmp r15, 0 ; si r15 = 0 terminamos
	je .fin

	movdqu xmm0, [rbx] ; traemos 4 pixeles
	movdqu [r12], xmm0 ; guardamos los 4 pixeles en dst
	
	add rbx, offset_pixels ; avanzamos 4 pixeles de lectura en src
	add r12, offset_pixels ; avanzamos 4 pixeles de escritura en dst

	add r13, offset_pixels ; sumamos 4 pixeles al desplazamiento total en src
	add r14, offset_pixels ; sumamos 4 pixeles al desplazamiento total en dst

	cmp r13, rcx ; si nos desplazamos el ancho de la imagen hacemos cambio de fila sino seguimos con .ciclo
	jl .cicloFiltro
	
	xor r13, r13 ; reiniciamos el desplazamiento en src
	xor r14, r14 ; reiniciamos el desplazamiento en dst
	dec r15
	;acomodo borde
	add rbx, offset_pixels*4 ; avanzamos 8 pixeles de lectura en src
	add r12, offset_pixels*4 ; avanzamos 8 pixeles de escritura en dst
	jmp .cicloFiltro

	
	.fin:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp
	ret
