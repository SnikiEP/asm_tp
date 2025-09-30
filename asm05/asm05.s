section .text
    global _start

_start:
    mov r8, rsp
    mov rax, [r8]
    cmp rax, 2
    jne fail_exit
    mov r9, [r8 + 16]
    xor r10, r10

count_loop:
    cmp byte [r9 + r10], 0
    je count_done
    inc r10
    jmp count_loop

count_done:
    mov rax, 1
    mov rdi, 1
    mov rsi, r9
    mov rdx, r10
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

fail_exit:
    mov rax, 60
    mov rdi, 1
    syscall
