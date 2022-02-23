%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR
	LOADDER_STACK_TOP equ LOADER_BASE_ADDR
	jmp loader_start

; GDT
GDT_BASE:			dd		0
					dd		0
CODE_DESC:			dd		0x0000ffff
					dd		DESC_CODE_HIGH4
DATA_STACK_DESC:	dd		0x0000ffff
					dd		DESC_DATA_HIGH4
VIDEO_DESC: 		dd		0x8000_0007		; limit = (0xbffff-0xb8000)/4k = 0x7
					dd		DESC_VIDEO_HIGH4

GDT_SIZE	equ		$ - GDT_BASE
GDT_LIMIT	equ		GDT_SIZE - 1
dq	60	dup(0)		; reserve 60 descriptors

; Selectors
SELECTOR_CODE	equ		(0x0001<<3) + TI_GDT + RPL0
SELECTOR_DATA	equ		(0x0002<<3) + TI_GDT + RPL0
SELECTOR_VIDEO	equ		(0x0003<<3) + TI_GDT + RPL0

loader_start:
	; mov bx, 0x0100
	; mov si, message
	; mov cx, [len]
	; call my_print

	; entering protection mode

	; 1. open A20 fast gate
	in al, 0x92
	or al, 0b10
	out 0x92, al

	; 2. load gdt info
	lgdt [gdt_ptr]

	; 3. set cr0
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	jmp dword SELECTOR_CODE:p_mode_start

	dd	16	dup(0)
[bits 32]
p_mode_start:
	; initialize sregs
	mov ax, SELECTOR_DATA
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov esp, LOADDER_STACK_TOP
	mov ax, SELECTOR_VIDEO
	mov gs, ax

	mov bx, 0x0100
	mov si, message
	mov cx, [len]
	call my_print
	jmp $
	
my_print:					; vesion 3.0
; print string with gpu
; param: bx: (bh, bl)=(row, col) offset on the screen
; param si: string address
; param cx: length
	; mov cx, dx
	mov ax, 0xa0
	mul bh
	add al, bl
	mov bx, ax
  loc_0x37:
	mov al, byte [si]
	mov byte [gs:bx], al
	add bx, 1
	mov byte [gs:bx], 0x0a		; color
	add si, 1
	add bx, 1
	loop loc_0x37
	retn
; my_print endp

; data
	gdt_ptr		dw	GDT_LIMIT
				dd	GDT_BASE
	message db "Loader ready in protection mode."
	len dw $ - message

