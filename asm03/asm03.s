section .data
    msg_output db "1337", 10
    msg_length equ $ - msg_output

section .text
    global _start

_start:
    mov r10, rsp
    mov rax, [r10]
    cmp rax, 2
    jne fail_exit

    mov rbx, [r10+16]
    mov cl, byte [rbx]
    cmp cl, '4'
    jne fail_exit
    mov cl, byte [rbx+1]
    cmp cl, '2'
    jne fail_exit
    mov cl, byte [rbx+2]
    cmp cl, 0
    jne fail_exit

    mov rax, 1          
    mov rdi, 1          
    mov rsi, msg_output 
    mov rdx, msg_length 
    syscall

    mov rax, 60         
    xor rdi, rdi        
    syscall

fail_exit:
    mov rax, 60         
    mov rdi, 1          
    syscall
