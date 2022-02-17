global _start
section .data
    hello db "Hello world!", 0x0a, 0x0
    len db $ - hello

section .text
_start:
    mov rdi, 1
    mov rsi, hello
    mov rdx, [len]
    mov rax, 1
    syscall

    mov rdi, 0
    mov rax, 60
    syscall