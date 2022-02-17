global _start

section .text
_start:
	mov eax, 0x04
	mov ebx, 0
	mov ecx, mes
	mov edx, [len]
	int 0x80
	
	; if you want use syscall, must push args in stack, like call in x86
	;syscall

	mov eax, 1
	mov ebx, 0
	int 0x80
	syscall

section .data
mes	db "Hello, world", 0x0a
len	dw $ - $$