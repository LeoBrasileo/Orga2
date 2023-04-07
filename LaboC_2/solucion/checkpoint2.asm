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
    ; prologo
    push rbp
    mov rbp, rsp
    sub rsp, 8

	call restar_c

	mov rdi, rax
	mov rsi, rdx
	call sumar_c ; sumar_c(x1-x2, x3)

	mov rdi, rax
	mov rsi, rcx
	call restar_c ; restar_c(x1-x2+x3, x4)

    
    ; epilogo
	mov rsp,rbp
    pop rbp
    ret



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
alternate_sum_4_simplified:
	mov rax, rdi ; mover x1 a rax
	sub rax, rsi ; restar x2 a rax
	add rax, rdx ; sumar x3 a rax
	sub rax, rcx ; restar x4 a rax
	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[rdi], x2[rsi], x3[rdx], x4[rcx], x5[r8], x6[r9], x7[rbp + 0x10], x8[rbp + 0x18]
alternate_sum_8:
	;prologo
	push rbp
	mov rbp,rsp
	sub rsp, 8 ;reservo espacio para 2 enteros mas en la pila

	mov rax, rdi ; mover x1 a rax
	sub rax, rsi ; restar x2 a rax
	add rax, rdx ; sumar x3 a rax
	sub rax, rcx ; restar x4 a rax

	add rax, r8
	sub rax, r9
	add rax, [rbp + 0x10]
	sub rax, [rbp + 0x18]


	;epilogo
	mov rsp,rbp
	pop rbp
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[rdi], x1[rsi], f1[xmm0]
product_2_f:
	;prologo
	push rbp
	mov rbp,rsp
	sub rsp, 4 ;reservo espacio para 1 entero en la pila

	cvtsi2ss xmm1, rsi ; convierto x1 a float y lo guardo en xmm1
	mulss xmm0, xmm1 ; f1 * x1
	cvtss2si rsi, xmm0 ; convierto el resultado a entero y lo guardo en rsi
	push rsi
	mov [rdi], rsi ; guardo el resultado en destination
	pop rsi

	;epilogo
	mov rsp,rbp
	pop rbp
    ret

