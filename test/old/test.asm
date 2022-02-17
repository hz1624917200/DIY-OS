global _start

section .text
_start:
    mov ax, 0x0601
    mov al, 0x02
    mov ah, 0x07
    mov rax, $$ 
    mov rax, $
    jmp $

section .data
    dq $
    dq $$
    dq $-$$