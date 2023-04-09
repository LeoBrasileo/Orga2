
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global complex_sum_z
global packed_complex_sum_z
global product_9_f

%define off_z 24
%define size_complex_item 32
%define off_z_packed 20
%define size_complex_item_packed 24

;########### DEFINICION DE FUNCIONES
;extern uint32_t complex_sum_z(complex_item *arr, uint32_t arr_length);
;registros: arr[rdi], arr_length[rsi]
;z esta en el byte 24 de la estructura
complex_sum_z:
    mov rax, 0; res = suma = 0
    mov rcx, rsi; contador = 0
    
loop_start:

    mov rdx, [rdi+off_z] ; Cargar el atributo z del complex_item actual
    add rax, rdx     ; Sumar el atributo z al acumulador
    add rdi , size_complex_item; avanzar al siguiente elemento

	; loop decrementa rcx y salta a loop_start si rcx != 0
	loop loop_start

loop_end:
    ret

;extern uint32_t packed_complex_sum_z(packed_complex_item *arr, uint32_t arr_length);
;registros: arr[?], arr_length[?]
packed_complex_sum_z:
    mov rax, 0; res = suma = 0
    mov rcx, rsi; contador = 0
    
pack_loop_start:

    mov rdx, [rdi+off_z_packed] ; Cargar el atributo z del complex_item actual
    add rax, rdx     ; Sumar el atributo z al acumulador
    add rdi , size_complex_item_packed; avanzar al siguiente elemento

	loop pack_loop_start

    ret


; extern void product_9_f(uint32_t * destination
; , uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
; , uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
; , uint32_t x9, float f9);
; registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r8], f4[xmm3]
; 	, x5[r9], f5[xmm4], x6[rbp+0x10], f6[xmm5], x7[rbp+0x18], f7[xmm6], x8[rbp+0x20], f8[xmm7],
; 	, x9[rbp+0x28], f9[rbp+0x32]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp
	sub rsp, 32 ; reservamos espacio para los parametros restantes

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm2, xmm2
	cvtss2sd xmm3, xmm3
	cvtss2sd xmm4, xmm4
	cvtss2sd xmm5, xmm5
	cvtss2sd xmm6, xmm6
	cvtss2sd xmm7, xmm7

	movd xmm8, [rbp+0x32] ; cargamos f9 en xmm8
	cvtss2sd xmm8, xmm8

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	mulsd xmm0, xmm8

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd xmm1, rsi
	cvtsi2sd xmm2, rdx
	cvtsi2sd xmm3, rcx
	cvtsi2sd xmm4, r8
	cvtsi2sd xmm5, r9
	cvtsi2sd xmm6, [rbp+0x10]
	cvtsi2sd xmm7, [rbp+0x18]
	cvtsi2sd xmm8, [rbp+0x20]
	cvtsi2sd xmm9, [rbp+0x28]
	
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	mulsd xmm0, xmm8
	mulsd xmm0, xmm9

	; guardamos el resultado en el destino
	movd [rdi], xmm0

	; epilogo
	mov rsp, rbp
	pop rbp
	ret

