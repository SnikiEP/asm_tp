section .bss
    input_buf resb 32

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buf
    mov rdx, 32
    syscall

    xor r8, r8
    mov r9, input_buf
parse_num:
    mov al, [r9]
    cmp al, 10
    je num_ready
    cmp al, '0'
    jb bad_input
    cmp al, '9'
    ja bad_input
    sub al, '0'
    imul r8, r8, 10
    add r8, rax
    inc r9
    jmp parse_num

num_ready:
    cmp r8, 2
    jb not_prime

    mov r10, 2
check_div:
    mov rax, r8
    xor rdx, rdx
    div r10
    cmp rdx, 0
    je not_prime

    inc r10
    mov rax, r10
    imul rax, rax
    cmp rax, r8
    jbe check_div

    mov rax, 60
    xor rdi, rdi
    syscall

not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

bad_input:
    mov rax, 60
    mov rdi, 2
    syscall
