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
	push r11
	push r10

	lea rbx, [rdi] ; rbx = src
	lea r12, [rsi] ; r12 = dst
	xor r11, r11 ; r11 = 0, guardamos en r11 el desplazamiento en src
	xor r10, r10 ; r10 = 0, guardamos en r10 el desplazamiento en dst

	mov ecx, edx ; rcx = width

	movdqu xmm15, [solo_alpha] ; pasamos la mascara a xmm15

	.ciclo:
	movdqu xmm0, [rbx] ; traemos 4 pixeles
	pand xmm0, xmm15 ; AND con la mascara
	movdqu [r12], xmm0 ; guardamos los 4 pixeles en dst
	add rbx, offset_pixels ; avanzamos 4 pixeles en src
	add r12, offset_pixels ; avanzamos 4 pixeles en dst
	add r11d, offset_pixels ; sumamos 4 pixeles al desplazamiento total en src
	add r10d, offset_pixels ; sumamos 4 pixeles al desplazamiento total en dst
	cmp r11d, ecx ; si nos desplazamos el ancho de la imagen saltamos a .sigFila
	je .sigFila
	jmp .ciclo
	
	.sigFila:
	lea rbx, [rdi] 
	lea r12, [rsi]
	add ebx, r8d ; avanzamos src_row_size (sig fila en src)
	add r12d, r9d ; avanzamos dst_row_size (sig fila en dst)
	movdqu xmm0, [rbx]
	pand xmm0, xmm15
	movdqu [r12], xmm0
	; cmp r10d, r8d
	; je .fin
	; mov ecx, r8d
	; jmp .ciclo
	
	.fin:
	pop r10
	pop r11
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp
	ret
