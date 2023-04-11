extern malloc
extern free
extern fprintf
extern esMenorChar
extern esMayorChar
extern freeC
extern fprintfC

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	mov r8, rdi
	mov WORD r9, rsi

	mov r10, 0 ; contador
	
	; guardo en rcx tamaño de a
	call strLen
	mov rcx, rax

	; guardo en r11 tamaño de b
	mov WORD rdi, r9
	call strLen
	mov r11, rax

	jmp max

	loopCmp:
	cmp r10, rcx
	je finCmp
	mov byte rdi, [r8 + r10]
	mov byte rsi, [r9 + r10]
	inc r10
	call esMenorChar
	;si es menor
	cmp rax, 1
	je aMenor
	;si es mayor
	call esMayorChar
	cmp rax, 1
	je aMayor
	;si son iguales
	jmp loopCmp

	finCmp:
	mov rax, 0
	ret

	aMenor:
	mov rax, 1
	ret
	aMayor:
	mov rax, -1
	ret

	max:
    cmp rcx, r11
    jg loopCmp     ; saltar si a > b
    mov rcx, r11   ; si a < b, mover b a rcx
    jmp loopCmp

; char* strClone(char* a)
strClone:
	mov r9, rdi
	;reservo memoria
	call strLen
	mov rdi, rax
	syscall

	mov rdi, r9
	mov r10, 0 ;contador

	loop_clone:
	mov byte r11, [rdi + r10]
	cmp byte r11, 0
	je fin_clone
	mov [rax + r10], r11
	inc r10
	jmp loop_clone
	
	fin_clone:
	ret

; void strDelete(char* a)
strDelete:
	; Esto no funciona porque copia el puntero al string
	; pero no el string en sí mismo
	mov r9, rdi
	mov rax, 0 ;contador
	mov r8, r9
	loop_del:
	add r8, rax
	mov rdi, r8
	call freeC
	cmp byte [rdi], 0
	je fin_del
	inc rax
	mov r8, r9
	jmp loop_del
	
	fin_del:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	mov r9, rdi
	mov rdi, rsi
	mov rsi, r9
	call fprintfC
	ret

; uint32_t strLen(char* a)
strLen:
	mov rax, 0 ;contador
	loop_len:
	cmp byte [rdi + rax], 0
	je fin_len
	inc rax
	jmp loop_len
	
	fin_len:
	ret


