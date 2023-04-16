section .rodata
mascara_1:
  db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15

section .text

global invertirBytes_asm

; void invertirBytes_asm(uint8_t* p, uint8_t n, uint8_t m)

invertirBytes_asm:
	movdqa xmm0, [rdi]      ; xmmo = p[0] | p[1] | p[2] | p[3] ...
    pxor xmm1, xmm1       	; xmm1 = 0 | 0 | 0 | 0 ...
	por xmm1, [mascara_1]   ; xmm1 = 0 | 1 | 2 | 3 ...
    mov eax, esi            ; eax = n
    mov ebx, edx            ; ebx = m
	;intercambio n por m en xmm1
	movdqa xmm2, xmm1
	

    pshufb xmm0, xmm1
    movdqa [rdi], xmm0
	ret