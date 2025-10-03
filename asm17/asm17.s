section .bss
    buffer resb 1024

section .data
    newline db 10

section .text
    global _start

_start:
    cmp     qword [rsp], 2
    jne     exit_failure

    mov     rsi, [rsp+16]
    call    str_to_int
    mov     r12, rax          ; décalage

    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buffer
    mov     rdx, 1024
    syscall
    mov     r13, rax          ; longueur lue

    mov     r14, buffer
    lea     r15, [buffer + r13]

encode_loop:
    cmp     r14, r15
    jge     end_encode

    movzx   rax, byte [r14]

    cmp     al, 'a'
    jl      check_upper
    cmp     al, 'z'
    jg      check_upper

    add     al, r12b
    cmp     al, 'z'
    jle     apply_char
    sub     al, 26
    jmp     apply_char

check_upper:
    cmp     al, 'A'
    jl      next_char
    cmp     al, 'Z'
    jg      next_char

    add     al, r12b
    cmp     al, 'Z'
    jle     apply_char
    sub     al, 26

apply_char:
    mov     [r14], al

next_char:
    inc     r14
    jmp     encode_loop

end_encode:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buffer
    mov     rdx, r13
    syscall

exit_success:
    mov     rax, 60
    xor     rdi, rdi
    syscall

exit_failure:
    mov     rax, 60
    mov     rdi, 1
    syscall

str_to_int:
    xor     rax, rax
    xor     rbx, rbx
.str_loop:
    mov     bl, [rsi]
    cmp     bl, 0
    je      .done
    sub     bl, '0'
    imul    rax, 10
    add     rax, rbx
    inc     rsi
    jmp     .str_loop
.done:
    ret
