extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global alternate_sum_4_using_c

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4:
	;prologo
	push rbp
	mov rbp,rsp
	sub rsp, 8 ;reservo espacio para 2 enteros mas en la pila

	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8
	mov rax, rdi ; mover x1 a rax
	sub rax, rsi ; restar x2 a rax
	add rax, rdx ; sumar x3 a rax
	sub rax, rcx ; restar x4 a rax

	;epilogo
	mov rsp,rbp
	pop rbp
	ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_using_c:
	;obs: restar y sumar en C usan los registros rax = x1 y rdx = x2
	;prologo
	push rbp ; alineado a 16
	mov rbp, rsp
	sub rsp, 8

	mov r9, rdx ; guardo x3 en r9

	; llamamos a las funciones sumar_c y restar_c
	mov rax, rdi ; x1
	mov rdx, rsi ; x2
	call restar_c
	;queda guardado x1 - x2 en rax

	mov rdx, r9 ; x3
	call sumar_c

	mov rdx, rcx
	call restar_c


	;epilogo
	mov rsp,rbp
	pop rbp
	ret



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
alternate_sum_4_simplified:
	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
alternate_sum_8:
	;prologo

	; COMPLETAR

	;epilogo
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
product_2_f:
	ret

