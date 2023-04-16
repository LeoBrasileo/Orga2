section .rodata
mascara_1:
  db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F

section .text

global invertirBytes_asm

; void invertirBytes_asm(uint8_t* p, uint8_t n, uint8_t m)

invertirBytes_asm:
    push rbp
    mov rbp, rsp

    movdqu xmm0, [rdi]      ; xmmo = p[0] | p[1] | p[2] | p[3] ...
    movdqu xmm1, [mascara_1]   ; xmm1 = 0 | 1 | 2 | 3 ...

    pxor xmm2, xmm2 
    pxor xmm4, xmm4
    pinsrb xmm2, sil, 0 ; inserto n en el byte 0 de xmm2
    pinsrb xmm4, dl, 0 ; inserto m en el byte 0 de xmm4
    mov r8b, sil ; r8b = n

    .shift1: ; desplazo a n y m, n bytes a la izquierda
    cmp r8b, 0
    je .break1
    pslldq xmm2, 1 ;shift left 1 byte
    pslldq xmm4, 1 ; idem
    dec r8b
    jmp .shift1
    .break1:

    pxor xmm5, xmm5
    pxor xmm3, xmm3
    pinsrb xmm3, dl , 0 ; inserto m en el byte 0 de xmm3
    pinsrb xmm5, sil, 0 ; inserto n en el byte 0 de xmm5
    mov r8b, dl ; r8b = m

    .shift2: ; desplazo a n y m, m bytes a la izquierda
    cmp r8b, 0
    je .break2
    pslldq xmm3, 1 ;shift left 1 byte
    pslldq xmm5, 1 ;idem
    dec r8b
    jmp .shift2
    .break2:

    pxor xmm1, xmm2 ; borro a n de la mascara
    pxor xmm1, xmm3 ; borro a m de la mascara
    por xmm1, xmm4 ; inserto a n en la posicion m en xmm3
    por xmm1, xmm5 ; inserto a m en la posicion n en xmm3

    pshufb xmm0, xmm1 ; shuffle con la mascara generada
    movdqu [rdi], xmm0 ; guardo el resultado en p

    mov rsp, rbp
    pop rbp
    ret