; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"
global start

extern A20_enable
extern GDT_DESC
extern screen_draw_layout
extern IDT_DESC
extern idt_init

extern pic_reset
extern pic_enable

extern mmu_init_kernel_dir
extern copy_page

%define CS_RING_0_SEL 0x08
%define DS_RING_0_SEL 0x18   
%define PAGE_DIRECTORY 0x25000


BITS 16
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida - MODO REAL
    ; (revisar las funciones definidas en print.mac y los mensajes se encuentran en la
    ; sección de datos)

    print_text_rm start_rm_msg, start_rm_len, 0x01, 0x00, 0x00

    ; Habilitar A20
    ; (revisar las funciones definidas en a20.asm)

    call A20_enable

    ; Cargar la GDT

    lgdt [GDT_DESC]

    ; Setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Saltar a modo protegido (far jump)

    jmp CS_RING_0_SEL:modo_protegido

BITS 32
modo_protegido:
    ; A partir de aca, todo el codigo se va a ejectutar en modo protegido
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    ; Pueden usar la constante DS_RING_0_SEL definida en este archivo
   
    mov ax, DS_RING_0_SEL
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax

    ; Establecer el tope y la base de la pila

    mov esp, 0x25000
    mov ebp, 0x25000


    ; Imprimir mensaje de bienvenida - MODO PROTEGIDO

    print_text_pm start_pm_msg, start_pm_len, 0x0004, 0x0000, 0x0000
    ; Inicializar pantalla
    call screen_draw_layout

    ; Inicializar la IDT
    call idt_init

    lidt [IDT_DESC]

    ; Inicializar los PIC
    call pic_reset
    call pic_enable


    call mmu_init_kernel_dir ; al terminar se carga en eax la direccion del directorio de paginas
    tlbflush

    ; Cargar direccion de directorio de paginas
    mov cr3, eax
    
    ; Activar paginado
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    ; Habilitar interrupciones
    sti

    ; syscall int 88
    int 88

    ; syscall int 98
    int 98

    ; probamos copiar 0x000000 a 0x400000
    push 0x000000
    push 0x400000
    call copy_page
    add esp, 8

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
