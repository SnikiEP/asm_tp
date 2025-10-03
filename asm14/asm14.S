section .data
    message db "Hello Universe!", 10
    message_len equ $ - message

section .text
    global _start

_start:
    cmp     qword [rsp], 2
    jne     exit_fail

    mov     rax, 2
    mov     rdi, [rsp+16]
    mov     rsi, 65          ; O_CREAT | O_WRONLY
    mov     rdx, 0o644       ; permissions
    syscall

    cmp     rax, 0
    jl      exit_fail

    mov     rbx, rax

    mov     rax, 1
    mov     rdi, rbx
    mov     rsi, message
    mov     rdx, message_len
    syscall

    mov     rax, 3
    mov     rdi, rbx
    syscall

    jmp     exit_success

exit_fail:
    mov     rax, 60
    mov     rdi, 1
    syscall

exit_success:
    mov     rax, 60
    xor     rdi, rdi
    syscall
