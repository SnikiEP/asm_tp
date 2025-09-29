global _start
section .rodata
msg: db "1337", 10
len: equ $ - msg
section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall
    xor rdi, rdi
    mov rax, 60
    syscall
