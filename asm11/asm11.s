section .bss
    input_buffer  resb 256
    output_buffer resb 32

section .text
    global _start

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, input_buffer
    mov     rdx, 256
    syscall

    xor     r9d, r9d
    xor     rbx, rbx
count_loop:
    cmp     rbx, rax
    jge     end_count
    movzx   rdx, byte [input_buffer + rbx]
    cmp     rdx, 10
    je      end_count
    cmp     dl, 'a'
    je      add_vowel
    cmp     dl, 'e'
    je      add_vowel
    cmp     dl, 'i'
    je      add_vowel
    cmp     dl, 'o'
    je      add_vowel
    cmp     dl, 'u'
    je      add_vowel
    cmp     dl, 'y'
    je      add_vowel
    cmp     dl, 'A'
    je      add_vowel
    cmp     dl, 'E'
    je      add_vowel
    cmp     dl, 'I'
    je      add_vowel
    cmp     dl, 'O'
    je      add_vowel
    cmp     dl, 'U'
    je      add_vowel
    cmp     dl, 'Y'
    jne     next_char
add_vowel:
    inc     r9
next_char:
    inc     rbx
    jmp     count_loop

end_count:
    mov     rax, r9
    lea     rsi, [rel output_buffer]
    call    convert_u64_to_str_nl

    mov     rax, 1
    mov     rdi, 1
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

convert_u64_to_str_nl:
    mov     rdi, rsi
    add     rdi, 32
    xor     rbx, rbx
    test    rax, rax
    jnz     convert_loop
    dec     rdi
    mov     byte [rdi], '0'
    mov     rbx, 1
    jmp     convert_end
convert_loop:
    xor     rdx, rdx
    mov     r9, 10
    div     r9
    dec     rdi
    add     dl, '0'
    mov     [rdi], dl
    inc     rbx
    test    rax, rax
    jnz     convert_loop
convert_end:
    mov     byte [rdi+rbx], 10
    inc     rbx
    mov     rsi, rdi
    mov     rdx, rbx
    ret
