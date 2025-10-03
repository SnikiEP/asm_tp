section .bss
    file_header resb 5

section .data
    elf_signature db 0x7F, "ELF"

section .text
    global _start

_start:
    cmp     qword [rsp], 2
    jne     exit_fail

    mov     rax, 2              ; syscall: open
    mov     rdi, [rsp+16]       ; fichier passé en argument
    xor     rsi, rsi            ; O_RDONLY
    syscall

    cmp     rax, 0
    jl      exit_fail
    mov     r13, rax            ; fd

    mov     rax, 0              ; syscall: read
    mov     rdi, r13
    mov     rsi, file_header
    mov     rdx, 5
    syscall

    mov     rax, 3              ; syscall: close
    mov     rdi, r13
    syscall

    mov     rsi, file_header
    mov     rdi, elf_signature
    mov     rcx, 4
    repe cmpsb
    jne     exit_fail

    cmp     byte [file_header+4], 2
    jne     exit_fail

exit_success:
    mov     rax, 60
    xor     rdi, rdi
    syscall

exit_fail:
    mov     rax, 60
    mov     rdi, 1
    syscall
