section .bss
    buf_out resb 32

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne exit_fail

    mov rsi, [rsp+16]
    call to_int
    mov r10, rax

    mov rax, r10
    dec rax
    imul rax, r10
    shr rax, 1
    mov rdi, buf_out
    call to_str

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buf_out
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, br
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall

to_int:
    xor rax, rax
.next:
    mov dl, [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .next
.done:
    ret

to_str:
    mov r8, rdi
    add rdi, 31
    mov byte [rdi], 0
    dec rdi
.loop:
    xor rdx, rdx
    div qword [base10]
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .loop
    inc rdi
    mov rsi, rdi
    mov rdi, r8
    mov rcx, 32
    rep movsb
    mov rax, rsi
    sub rax, r8
    ret

section .data
    br db 10
    base10 dq 10
