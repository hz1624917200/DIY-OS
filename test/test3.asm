global _start

section .text
_start:
	mov eax, 0x10
	mov bx, 0x1234
	mul bx
	mov eax, 0x10
	mov edx, 1
	mul ebx