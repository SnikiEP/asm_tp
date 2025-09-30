section .bss
    buffer_input resb 16

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer_input
    mov rdx, 16
    syscall
    mov r8, rax
    xor r9, r9
    xor r10, r10

parse_loop:
    cmp r10, r8
    je convert_done
    mov bl, [buffer_input + r10]
    cmp bl, 10
    je convert_done
    cmp bl, '0'
    jb bad_input
    cmp bl, '9'
    ja bad_input
    sub bl, '0'
    imul r9, r9, 10
    movzx r11, bl
    add r9, r11
    inc r10
    jmp parse_loop

convert_done:
    test r9, 1
    jz is_even
    mov rax, 60
    mov rdi, 1
    syscall

is_even:
    mov rax, 60
    xor rdi, rdi
    syscall

bad_input:
    mov rax, 60
    mov rdi, 2
    syscall
