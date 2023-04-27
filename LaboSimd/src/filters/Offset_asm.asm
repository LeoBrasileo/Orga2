section .rodata
mascara_1:
  db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
solo_alpha:
	db 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0

section .data
	%define blue 0
	%define red 1
	%define green 2
	%define alpha 3
	%define pixel_size 4
	%define offset_pixels 16

section .text

global Offset_asm

; *src uint_8[rdi], *dst uint_8[rsi], width uint_32[edx], height uint_32[ecx],
; src_row_size uint_32[r8d], dst_row_size uint_32[r9d]
Offset_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8

	lea rbx, [rdi] ; rbx = src
	lea r12, [rsi] ; r12 = dst
	xor r13, r13 ; r13 = 0, guardamos en r13 el desplazamiento en src
	xor r14, r14 ; r14 = 0, guardamos en r14 el desplazamiento en dst
	mov r15, rcx ; r15 = height, guardamos en r15 la altura de la imagen

	xor rcx, rcx
	mov ecx, r8d ; rcx = src_row_size

	movdqu xmm15, [solo_alpha] ; pasamos la mascara a xmm15

	.ciclo:
	movdqu xmm0, [rbx] ; traemos 4 pixeles
	pand xmm0, xmm15 ; AND con la mascara
	movdqu [r12], xmm0 ; guardamos los 4 pixeles en dst
	add rbx, offset_pixels ; avanzamos 4 pixeles en src
	add r12, offset_pixels ; avanzamos 4 pixeles en dst
	add r13d, offset_pixels ; sumamos 4 pixeles al desplazamiento total en src
	add r14d, offset_pixels ; sumamos 4 pixeles al desplazamiento total en dst
	cmp r13, rcx ; si nos desplazamos el ancho de la imagen saltamos a .sigFila
	je .sigFila
	loop .ciclo
	
	.sigFila:
	lea rbx, [rdi] 
	lea r12, [rsi]
	add rbx, r8 ; avanzamos src_row_size (sig fila en src)
	add r12, r9 ; avanzamos dst_row_size (sig fila en dst)
	xor r13, r13 ; reiniciamos el desplazamiento en src
	xor r14, r14 ; reiniciamos el desplazamiento en dst
	dec r15
	jz .fin
	jmp .ciclo
	
	.fin:
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp
	ret
