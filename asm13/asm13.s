section .bss
    buffer resb 1024

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall

    mov r12, rax
    test r12, r12
    jz label_palindrome
    
    dec r12
.trim_nl:
    cmp r12, 0
    jl label_palindrome
    mov al, [buffer+r12]
    cmp al, 10
    je .dec_next
    cmp al, 13
    je .dec_next
    jmp .verify_start
.dec_next:
    dec r12
    jmp .trim_nl

.verify_start:
    mov rsi, buffer
    mov rdi, buffer
    add rdi, r12

.check_loop:
    cmp rsi, rdi
    jge label_palindrome

    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne label_non_palindrome

    inc rsi
    dec rdi
    jmp .check_loop

label_palindrome:
    mov rax, 60
    xor rdi, rdi
    syscall

label_non_palindrome:
    mov rax, 60
    mov rdi, 1
    syscall
