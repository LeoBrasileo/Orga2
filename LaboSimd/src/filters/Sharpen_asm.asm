extern malloc
extern free

section .rodata

sharpen: dd -1.0, -1.0, -1.0, -1.0, 9.0, -1.0, -1.0, -1.0, -1.0

todo_negro: db 0, 0, 0, 255, 0, 0, 0, 255, 0, 0, 0, 255, 0, 0, 0, 255

section .text
	%define offset_pixels 4
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
	lea rbx, [rdi] ; rbx = src
	lea r12, [rsi] ; r12 = dst
	xor r13, r13 ; r13 = 0, guardamos en r13 el desplazamiento en src
	xor r14, r14 ; r14 = 0, guardamos en r14 los valores de los pixeles en cada ciclo
	mov r15, rcx ; r15 = height, guardamos en r15 la altura de la imagen como contador
	;dec r15, 4

	.filtro:
	cmp r15, 0
	je .fin

	cmp r13, r8
	je .sigLinea
	cmp r13, 0
	je .pintarnegro
	cmp r15, rcx
	je .pintarnegro
	cmp r15, 1
	je .pintarnegro

	pxor xmm6, xmm6 ; limpio xmm6 para usarlo como registro de tratamiento general

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
	mov r11, r9
	imul r11, r8
	mov r14, r10
	imul r14, 4
	add r11, r14

	;cargo pixel en orden azul, verde, rojo como floats en xmm0
	movzx r14d, BYTE [rbx + r11] ; r14b = azul
	cvtsi2ss xmm2, r14d ; xmm2 = azul float
	movzx r14d, BYTE [rbx + r11 + 1] ; r14b = verde
	cvtsi2ss xmm3, r14d ; xmm2 = verde float
	movzx r14d, BYTE [rbx + r11 + 2] ; r14b = rojo
	cvtsi2ss xmm4, r14d ; xmm2 = rojo float

	mulps xmm2, xmm1 ; xmm2 = azul * a
	mulps xmm3, xmm1 ; xmm3 = verde * a
	mulps xmm4, xmm1 ; xmm4 = rojo * a

	; opero con los tres colores (floats) en xmm0
	pslldq xmm2, 12
	pslldq xmm3, 8
	pslldq xmm4, 4
	por xmm0, xmm2
	por xmm0, xmm3
	por xmm0, xmm4

	addps xmm6, xmm0 ; sumo el resultado al acumulador

	inc r10
	cmp r10, 3
	jne .loopColSharpen
	inc r9
	jmp .loopfilaSharpen

	.finSharpen:
	cvtps2dq xmm6, xmm6 ; float a int
	packssdw xmm6, xmm6 ; pasamos a 16 bits
	packsswb xmm6, xmm6 ; pasamos a 8 bits
	pextrd r14d, xmm6, 0 ; guardamos en r14d el valor de la parte baja de xmm0
	mov r14b, BYTE [rbx+3] ; guardamos el valor de alpha en r14b

	mov DWORD [r12 + r8 + 4], r14d ; guardo resultado en dst[i+1][j+1]

	jmp .seguirImagen

	.pintarnegro:
	mov DWORD [r12], 0

	.seguirImagen:	
	add rbx, offset_pixels ; avanzamos 1 pixel de lectura en src
	add r12, offset_pixels ; avanzamos 1 pixel de escritura en dst

	add r13, offset_pixels ; sumamos 1 pixel al desplazamiento total en src

	jmp .filtro

	.sigLinea:
	mov DWORD [r12-4], 0
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
