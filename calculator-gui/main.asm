BITS 64
section .text
global calc

; int calc(long long a, long long b, char op, long long* out)
; rdi=a, rsi=b, rdx=op (dl), rcx=out
; returns eax: 0 ok, 1 bad op, 2 div0, 3 overflow
calc:
    push    rbp
    mov     rbp, rsp
    push    rbx

    mov     rax, rdi
    mov     rbx, rsi

    cmp     dl, '+'
    je      .add
    cmp     dl, '-'
    je      .sub
    cmp     dl, '*'
    je      .mul
    cmp     dl, '/'
    je      .div

    mov     eax, 1
    jmp     .done

.add:
    add     rax, rbx
    jo      .ovf
    mov     [rcx], rax
    xor     eax, eax
    jmp     .done

.sub:
    sub     rax, rbx
    jo      .ovf
    mov     [rcx], rax
    xor     eax, eax
    jmp     .done

.mul:
    imul    rax, rbx
    jo      .ovf
    mov     [rcx], rax
    xor     eax, eax
    jmp     .done

.div:
    test    rbx, rbx
    je      .div0
    mov     r8, rax
    mov     r9, rbx
    mov     r10, 0x8000000000000000
    cmp     r8, r10
    jne     .do_div
    cmp     r9, -1
    jne     .do_div
    jmp     .ovf

.do_div:
    cqo
    idiv    rbx
    mov     [rcx], rax
    xor     eax, eax
    jmp     .done

.div0:
    mov     eax, 2
    jmp     .done

.ovf:
    mov     eax, 3

.done:
    pop     rbx
    pop     rbp
    ret

section .note.GNU-stack noalloc noexec nowrite