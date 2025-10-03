section .data
    ref_input db "42", 0x0A
    ref_input_len equ $ - ref_input

    output_msg db "1337", 0x0A
    output_len equ $ - output_msg

section .bss
    input_buffer resb 64

section .text
    global _start

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, input_buffer
    mov     rdx, 64
    syscall
    mov     rbx, rax

    mov     rcx, rbx
    mov     rdi, input_buffer
find_newline:
    cmp     rcx, 0
    je      no_newline
    mov     al, byte [rdi]
    cmp     al, 0x0A
    je      truncate_line
    inc     rdi
    dec     rcx
    jmp     find_newline

truncate_line:
    mov     byte [rdi+1], 0
    mov     rbx, rdi
    sub     rbx, input_buffer
    add     rbx, 1

no_newline:
    mov     rcx, ref_input_len
    cmp     rbx, rcx
    jne     exit_fail

    mov     rsi, input_buffer
    mov     rdi, ref_input
    mov     rcx, ref_input_len
    repe    cmpsb
    jne     exit_fail

exit_success:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, output_msg
    mov     rdx, output_len
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

exit_fail:
    mov     rax, 60
    mov     rdi, 1
    syscall
