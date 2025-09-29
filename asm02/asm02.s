section .data
    ref_input db "42", 0x0A
    ref_input_len equ $ - ref_input

    output_msg db "1337", 0x0A
    output_len equ $ - output_msg

section .bss
    input_buf resb 8

section .text
    global _start

_start:
    mov rax, 0            
    mov rdi, 0            
    mov rsi, input_buf    
    mov rdx, 8            
    syscall
    mov rbx, rax          

    mov rcx, ref_input_len
    cmp rbx, rcx
    jne exit_fail

    mov rsi, input_buf
    mov rdi, ref_input
    mov rcx, ref_input_len
    repe cmpsb
    jne exit_fail

exit_success:
    mov rax, 1            
    mov rdi, 1            
    mov rsi, output_msg
    mov rdx, output_len
    syscall

    xor rdi, rdi
    mov rax, 60           
    syscall

exit_fail:
    mov rdi, 1
    mov rax, 60           
    syscall
