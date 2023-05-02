extern malloc
extern free

section .rodata
mascara_azul:
  db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F

section .text
	%define offset_pixels 4
	%define float_size 4
	

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
	mov r15, rcx ; r15 = height, guardamos en r15 la altura de la imagen


	; crear matriz[float] sharpen
	mov rdi, float_size*9 ;vamos a pedir 9 flotantes ya que es el tamano de la matriz
	call malloc

	xor rcx, rcx
	.llenarMatriz:
	cmp rcx, 9
	je .matrizLlena
	mov DWORD [rax + rcx*float_size], 0xBF800000 ; -1 en float
	inc rcx
	jmp .llenarMatriz

	.matrizLlena:
	mov DWORD [rax + 4*float_size], 0x40C00000 ; 9 en float

	; rax = direccion de memoria de sharpen
	; sharpen = | -1 | -1 | -1 |
	;		    | -1 |  9 | -1 |
	;		    | -1 | -1 | -1 |

	sub r8, 2*offset_pixels ; r8 = src_row_size - 2 pixels de borde

	add r12, offset_pixels; avanzo 1 pixeles de inicializacion
	add rbx, offset_pixels
	sub r15, 2 ; r15 = height - 2 pixeles, 1 arriba, 1 abajo


	pxor xmm0, xmm0 ; limpio xmm0 para usarlo como registro de tratamiento general

	.filtro:
	cmp r15, 0
	je .fin

	; procesamiento de a 1 pixel
	; azul = xmm1, verde = xmm2, rojo = xmm3
	pxor xmm1, xmm1
	pxor xmm2, xmm2
	pxor xmm3, xmm3

	mov rcx, 9
	.recorrerMatriz:
	movss xmm4, [rax + rcx*float_size] ; traemos valor de la matriz

	;AZUL
	movzx r14d, BYTE [rbx]
	cvtsi2ss xmm5, r14d ; pasamos a float
	mulss xmm5, xmm4 ; multiplicamos
	addss xmm1, xmm5

	;VERDE
	movzx r14d, BYTE [rbx+1]
	cvtsi2ss xmm5, r14d ; pasamos a float
	mulss xmm5, xmm4 ; multiplicamos
	addss xmm2, xmm5

	;ROJO
	movzx r14d, BYTE [rbx+2]
	cvtsi2ss xmm5, r14d ; pasamos a float
	mulss xmm5, xmm4 ; multiplicamos
	addss xmm3, xmm5
	loop .recorrerMatriz

	pslldq xmm1, 24
	pslldq xmm2, 16
	pslldq xmm3, 8
	por xmm0, xmm1
	por xmm0, xmm2
	por xmm0, xmm3

	packssdw xmm0, xmm0 ; pasamos a 16 bits
	packsswb xmm0, xmm0 ; pasamos a 8 bits
	pextrd r14d, xmm0, 0 ; guardamos en r14d el valor de la parte baja de xmm0
	mov r14b, BYTE [rbx + 3] ; guardamos el valor de alpha en r14b

	mov DWORD [r12 + r8 + 8 + 1], r14d ; guardo resultado en dst[i+1][j+1]

	
	add rbx, offset_pixels ; avanzamos 1 pixel de lectura en src
	add r12, offset_pixels ; avanzamos 1 pixel de escritura en dst

	add r13, offset_pixels ; sumamos 1 pixel al desplazamiento total en src

	cmp r13, r8 ; si nos desplazamos el ancho de la imagen hacemos .sigFila sino seguimos con .ciclo
	jl .filtro

	xor r13, r13 ; reiniciamos el desplazamiento en src
	dec r15	
	;acomodo borde
	add rbx, 2*offset_pixels ; avanzamos 2 pixeles de lectura en src, 1 para terminar la fila y 1 para empezar la siguiente
	add r12, 2*offset_pixels ; avanzamos 2 pixeles de escritura en dst
	jmp .filtro

	.fin:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
