section .bss
    output_buffer resb 32

section .data
    newline db 10

section .text
    global _start

_start:
    mov rax, [rsp]          
    cmp rax, 4
    jne exit_fail           

    mov rsi, [rsp+16]       
    call parse_str_to_int
    mov rbx, rax            

    mov rsi, [rsp+24]       
    call parse_str_to_int
    cmp rax, rbx
    jle .skip_second
    mov rbx, rax
.skip_second:

    mov rsi, [rsp+32]       
    call parse_str_to_int
    cmp rax, rbx
    jle .skip_third
    mov rbx, rax
.skip_third:

    mov rax, rbx
    mov rdi, output_buffer
    mov rdx, 10             
    call convert_int_to_base

    mov rdx, rax            
    mov rax, 1
    mov rdi, 1
    mov rsi, output_buffer
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall

parse_str_to_int:
    xor rax, rax
    xor rcx, rcx
    mov dl, [rsi]
    cmp dl, '-'
    jne .parse
    mov rcx, 1
    inc rsi
.parse:
    mov dl, [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .parse
.done:
    test rcx, rcx
    jz .ret
    neg rax
.ret:
    ret

convert_int_to_base:
    mov rcx, rdi
    mov r8, rdx
    xor r10b, r10b
    test rax, rax
    jns .continue
    neg rax
    mov r10b, 1
.continue:
    add rdi, 31
    mov byte [rdi], 0
    dec rdi
.loop_convert:
    xor rdx, rdx
    div r8
    mov r9b, dl
    cmp r9b, 10
    jb .digit
    add r9b, 'A' - 10
    jmp .store
.digit:
    add r9b, '0'
.store:
    mov [rdi], r9b
    dec rdi
    test rax, rax
    jnz .loop_convert
    inc rdi
    cmp r10b, 0
    je .no_sign
    dec rdi
    mov byte [rdi], '-'
.no_sign:
    mov rsi, rdi
    mov rdi, rcx
    mov rcx, 32
    rep movsb
    mov rax, rsi
    sub rax, rdi
    ret
