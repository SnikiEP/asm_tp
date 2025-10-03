section .bss
    buffer resb 16384

section .data
    old_pattern db "1337"
    new_pattern db "H4CK"

section .text
    global _start

_start:
    cmp     qword [rsp], 2
    jne     exit_failure

    mov     rax, 2
    mov     rdi, [rsp+16]
    mov     rsi, 2          ; O_RDWR
    syscall
    cmp     rax, 0
    jl      exit_failure
    mov     r12, rax

    mov     rax, 0
    mov     rdi, r12
    mov     rsi, buffer
    mov     rdx, 16384
    syscall
    mov     r13, rax

    mov     rdi, buffer
    mov     rsi, old_pattern
    mov     rcx, r13
    mov     rdx, 4
    call    find_sequence

    cmp     rax, 0
    je      close_and_exit

    mov     rdi, rax
    mov     rsi, new_pattern
    mov     rcx, 4
    rep     movsb

    mov     rax, 8          ; lseek(fd, 0, SEEK_SET)
    mov     rdi, r12
    xor     rsi, rsi
    xor     rdx, rdx
    syscall

    mov     rax, 1          ; write
    mov     rdi, r12
    mov     rsi, buffer
    mov     rdx, r13
    syscall

close_and_exit:
    mov     rax, 3          ; close
    mov     rdi, r12
    syscall

exit_success:
    mov     rax, 60
    xor     rdi, rdi
    syscall

exit_failure:
    mov     rax, 60
    mov     rdi, 1
    syscall

find_sequence:
    sub     rcx, rdx
    inc     rcx
.outer_loop:
    test    rcx, rcx
    jz      .not_found

    push    rdi
    push    rsi
    push    rcx
    mov     rcx, rdx
    repe    cmpsb
    pop     rcx
    pop     rsi
    pop     rdi
    je      .found

    inc     rdi
    dec     rcx
    jmp     .outer_loop

.found:
    mov     rax, rdi
    ret

.not_found:
    xor     rax, rax
    ret
