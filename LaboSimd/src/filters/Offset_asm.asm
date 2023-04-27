section .rodata
mascara_1:
  db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F

section .data
	%define blue 0
	%define red 1
	%define green 2
	%define alpha 3
	%define pixel_size 4

section .text

global Offset_asm

; *src uint_8[rdi], *dst uint_8[rsi], width uint_32[edx], height uint_32[ecx], src_row_size uint_32[r8d], dst_row_size uint_32[r9d]
Offset_asm:
	push rbp
	mov rbp, rsp

	movdqu xmm0, [rdi]

	.ciclo: 
	mov

	mov rsp, rbp
	pop rbp
	ret