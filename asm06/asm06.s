section .bss
    buf_result resb 20

section .data
    lf db 10

section .text
    global _start

_start:
    cmp byte [rsp], 3
    jne exit_err

    mov rsi, [rsp+16]
    call parse_int
    mov r8, rax

    mov rsi, [rsp+24]
    call parse_int
    mov r9, rax

    add r8, r9

    mov rax, r8
    mov rdi, buf_result
    call int_to_ascii

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_result
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, lf
    mov rdx, 1
    syscall

exit_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_err:
    mov rax, 60
    mov rdi, 1
    syscall

parse_int:
    xor rax, rax
    xor rcx, rcx
    mov rbx, 1
    cmp byte [rsi], '-'
    jne .loop
    mov rbx, -1
    inc rsi
.loop:
    mov cl, [rsi]
    cmp cl, 0
    je .done
    sub cl, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .loop
.done:
    imul rax, rbx
    ret

int_to_ascii:
    mov r10, rdi
    mov r11, 10
    mov r12, 0
    test rax, rax
    jns .conv
    neg rax
    mov r12, 1
.conv:
    add rdi, 19
    mov byte [rdi], 0
    dec rdi
.digits:
    xor rdx, rdx
    div r11
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .digits
    cmp r12, 1
    jne .copy
    mov byte [rdi], '-'
    dec rdi
.copy:
    inc rdi
    mov rdx, r10
    add rdx, 20
    sub rdx, rdi
    mov rax, rdx
    mov rcx, rax
    mov rsi, rdi
    mov rdi, r10
    rep movsb
    ret
