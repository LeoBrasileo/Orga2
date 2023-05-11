extern malloc
extern free

section .rodata
pixel_1: db 0x0F, 0x0F, 0x0F, 0x0F 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x03, 0x02, 0x01, 0x00
pixel_2: db 0x0F, 0x0F, 0x0F, 0x0F 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x07, 0x06, 0x05, 0x04
pixel_3: db 0x0F, 0x0F, 0x0F, 0x0F 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x08, 0x07, 0x06, 0x05
pixel_4: db 0x0F, 0x0F, 0x0F, 0x0F 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0C, 0x0B, 0x0A, 0x09

sharpen: dd -1.0, -1.0, -1.0, -1.0, 9.0, -1.0, -1.0, -1.0, -1.0

solo_alpha: db 0, 0, 0, 255, 0, 0, 0, 255, 0, 0, 0, 255, 0, 0, 0, 255

section .text
	%define offset_pixels 16
	%define float_size 4
	%define pixel_size 4
	

global Sharpen_asm


; *src uint_8[rdi], *dst uint_8[rsi], width uint_32[rdx], height uint_32[rcx],
; src_row_size uint_32[r8], dst_row_size uint_32[r9]
Sharpen_asm:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15

	; cargada de registros iniciales
	xor r13, r13 ; r13 = 0, guardamos en r13 el desplazamiento en src
	xor r14, r14 ; r14 = 0, guardamos en r14 los valores de los pixeles en cada ciclo
	mov r15, rcx ; r15 = height, guardamos en r15 la altura de la imagen como contador
	movdqu xmm10, [solo_alpha]

	xor rcx, rcx
	mov rcx, r9
	sub rcx, 16 ; rcx = src_row_size - 16 pixels de borde

	.filtro:
	cmp r15, 0
	je .fin

	pxor xmm6, xmm6 ; pixel 1
	pxor xmm7, xmm7 ; pixel 2
	pxor xmm8, xmm8 ; pixel 3
	pxor xmm9, xmm9 ; pixel 4

	xor r9, r9 ; r9 = ii
	.loopfilaSharpen:
	cmp r9, 3
	je .finSharpen
	xor r10, r10 ; r10 = jj
	.loopColSharpen:
	mov r11, 12
	imul r11, r9
	movdqu xmm1, [sharpen + r11 + r10*4]
	shufps xmm1, xmm1, 0x00 ; xmm1 = [a, a, a, a]

	;calculo en r11 el offset
	mov r11, r8
	imul r11, r9
	mov r12, r10
	imul r12, 4
	add r11, r12

	movdqu xmm0, [rdi + r11] ; cargo 4 pixeles

	pmovzxbd xmm2, xmm0 ; extiendo el primer pixel de byte a double word (empaquetados)
	psrldq xmm0, 4 ; shift xmm0 4 bytes a la derecha
	pmovzxbd xmm3, xmm0 ; extiendo el segundo pixel de byte a double word (empaquetados)
	psrldq xmm0, 4 ; shift xmm0 4 bytes a la derecha
	pmovzxbd xmm4, xmm0 ; extiendo el tercer pixel de byte a double word (empaquetados)
	psrldq xmm0, 4 ; shift xmm0 4 bytes a la derecha
	pmovzxbd xmm5, xmm0 ; extiendo el cuarto pixel de byte a double word (empaquetados)

	cvtdq2ps xmm2, xmm2 ; convierto el primer pixel de int a float
	cvtdq2ps xmm3, xmm3 ; convierto el segundo pixel de int a float
	cvtdq2ps xmm4, xmm4 ; convierto el tercer pixel de int a float
	cvtdq2ps xmm5, xmm5 ; convierto el cuarto pixel de int a float

	mulps xmm2, xmm1
	mulps xmm3, xmm1
	mulps xmm4, xmm1
	mulps xmm5, xmm1

	; acmulo resultados
	addps xmm6, xmm2
	addps xmm7, xmm3
	addps xmm8, xmm4
	addps xmm9, xmm5

	inc r10
	cmp r10, 3
	jne .loopColSharpen
	inc r9
	jmp .loopfilaSharpen

	.finSharpen:
	cvtps2dq xmm6, xmm6 ; float a int
	cvtps2dq xmm7, xmm7
	cvtps2dq xmm8, xmm8
	cvtps2dq xmm9, xmm9

	; empaquetado
	packssdw xmm6, xmm7
	packssdw xmm8, xmm9
	packuswb xmm6, xmm8
	por xmm6, xmm10 ; alpha en 255

	movdqu [rsi + r8 + 4], xmm6 ; guardo resultado en dst[i+1][j+1]

	add rdi, offset_pixels ; avanzamos 4 pixel de lectura en src
	add rsi, offset_pixels ; avanzamos 4 pixel de escritura en dst

	add r13, offset_pixels ; sumamos 4 pixel al desplazamiento total en src

	cmp r13, rcx ; si nos desplazamos el ancho de la imagen hacemos cambio de fila sino seguimos con .ciclo
	jl .filtro

	.sigLinea:
	xor r13, r13 ; reiniciamos el desplazamiento en src
	dec r15	
	jmp .filtro

	.fin:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
