section .bss
    buf_out resb 65

section .data
    lf db 10
    digits db "0123456789ABCDEF"
    opt_bin db "-b", 0

section .text
    global _start

_start:
    mov r12, 16
    mov r13, [rsp+16]

    cmp qword [rsp], 3
    jne .args_check
    mov rdi, [rsp+16]
    mov rsi, opt_bin
    call str_cmp
    cmp rax, 0
    jne .args_check

    mov r12, 2
    mov r13, [rsp+24]

.args_check:
    cmp qword [rsp], 2
    jl exit_fail

    mov rsi, r13
    call str_to_num

    mov rdi, buf_out
    mov rsi, r12
    call num_to_base

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_out
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

exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall

str_cmp:
    push rsi
    push rdi
.loop:
    mov al, [rdi]
    mov ah, [rsi]
    cmp al, ah
    jne .ne
    cmp al, 0
    je .eq
    inc rsi
    inc rdi
    jmp .loop
.eq:
    pop rdi
    pop rsi
    xor rax, rax
    ret
.ne:
    pop rdi
    pop rsi
    mov rax, 1
    ret

str_to_num:
    xor rax, rax
    xor rbx, rbx
.loop:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    ret

num_to_base:
    mov r8, rdi
    mov r9, rsi
    add rdi, 64
    mov byte [rdi], 0
    dec rdi
.loop:
    xor rdx, rdx
    div r9
    lea r10, [digits]
    mov r10b, [r10+rdx]
    mov [rdi], r10b
    dec rdi
    test rax, rax
    jnz .loop
    inc rdi
    mov rdx, r8
    add rdx, 65
    sub rdx, rdi
    mov rax, rdx
    mov rcx, rax
    mov rsi, rdi
    mov rdi, r8
    rep movsb
    ret
