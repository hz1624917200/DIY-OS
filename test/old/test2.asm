global _start

section .text follows=.data align=8
_start:
    mov ax, $$
    mov ax, section..data.start
    mov ax, section..data.vstart
    mov ax, [var1]
    mov ax, [var2]
label:
    jmp label

section .data vstart=0x8888
    var1 dd 0x4
    var2 dw 0x99