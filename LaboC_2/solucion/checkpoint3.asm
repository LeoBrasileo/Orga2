
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


;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[?], f1[?], x2[?], f2[?], x3[?], f3[?], x4[?], f4[?]
;	, x5[?], f5[?], x6[?], f6[?], x7[?], f7[?], x8[?], f8[?],
;	, x9[?], f9[?]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	; COMPLETAR

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	; COMPLETAR

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	; COMPLETAR

	; epilogo
	pop rbp
	ret

