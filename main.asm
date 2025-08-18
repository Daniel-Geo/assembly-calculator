global _start

section .data
welcome db 0dh, 0ah, 0dh, 0ah, "********** Hello and Welcome to the Calculator! **********", 0dh, 0ah
welcome_length equ $-welcome

choice db "Please make your choice: ", 0dh, 0ah
choice_length equ $-choice

operator db "1. Add", 0dh, 0ah, "2. Subtract", 0dh, 0ah, "3. Multiply", 0dh, 0ah, "4. Divide", 0dh, 0ah, "5. Exit", 0dh, 0ah
operator_length equ $-operator

first_number db "Please enter your first number: ", 0dh, 0ah
first_number_length equ $-first_number

second_number db "Please enter your second number: ", 0dh, 0ah
second_number_length equ $-second_number

tmp db 0, 0

first_temp db 0, 0
second_temp db 0, 0

answer db "Answer of "
answer_length equ $-answer

plus db " + "
symbol_length equ $-plus
minus db " - "
multiply db " * "
divide db " / "
equals db " = "

outch db 0

section .text
_start:
    
LOOP:
call welcome_message
call get_choice
call operators
call get_input

welcome_message:
    mov rax, 1
    mov rdi, 1
    mov rsi, welcome
    mov rdx, welcome_length
    syscall
    ret

get_choice:
    mov rax, 1
    mov rdi, 1
    mov rsi, choice
    mov rdx, choice_length
    syscall
    ret

operators:
    mov rax, 1
    mov rdi, 1
    mov rsi, operator
    mov rdx, operator_length
    syscall
    ret

get_input:
    mov rax, 0
    mov rdi, 0
    mov rsi, tmp
    mov rdx, 2
    syscall

    cmp byte[rsi], "1"
    je Add

    cmp byte[rsi], "2"
    je Subtract

    cmp byte[rsi], "3"
    je Multiply

    cmp byte[rsi], "4"
    je Divide

    cmp byte[rsi], "5"
    je Exit

    jmp LOOP

Add:
    mov rax, 1
    mov rdi, 1
    mov rsi, first_number
    mov rdx, first_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, first_temp
    mov rdx, 2
    syscall

    mov r8, first_temp

    mov rax, 1
    mov rdi, 1
    mov rsi, second_number
    mov rdx, second_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, second_temp
    mov rdx, 2
    syscall

    mov r9, second_temp

    push r9
    push r8

    mov r8, [first_temp]
    mov r9, [second_temp]

    sub r8, 48
    sub r9, 48

    mov r10, r8
    add r10, r9

    pop r8
    pop r9

    add r10, 48

    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, plus
    mov rdx, symbol_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r9
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, equals
    mov rdx, symbol_length
    syscall

    mov [rsp+8], r10

    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp+8]
    mov rdx, 1
    syscall

    jmp LOOP

Subtract:
    mov rax, 1
    mov rdi, 1
    mov rsi, first_number
    mov rdx, first_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, first_temp
    mov rdx, 2
    syscall

    mov r8, first_temp

    mov rax, 1
    mov rdi, 1
    mov rsi, second_number
    mov rdx, second_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, second_temp
    mov rdx, 2
    syscall

    mov r9, second_temp

    push r9
    push r8

    mov r8, [first_temp]
    mov r9, [second_temp]

    sub r8, 48
    sub r9, 48

    mov r10, r8
    sub r10, r9

    pop r8
    pop r9

    add r10, 48

    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, minus
    mov rdx, symbol_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r9
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, equals
    mov rdx, symbol_length
    syscall

    mov [rsp+8], r10

    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp+8]
    mov rdx, 1
    syscall

    jmp LOOP

Multiply:
    mov rax, 1
    mov rdi, 1
    mov rsi, first_number
    mov rdx, first_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, first_temp
    mov rdx, 2
    syscall

    mov r8, first_temp

    mov rax, 1
    mov rdi, 1
    mov rsi, second_number
    mov rdx, second_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, second_temp
    mov rdx, 2
    syscall

    mov r9, second_temp

    push r9
    push r8

    mov r8, [first_temp]
    mov r9, [second_temp]

    sub r8, 48
    sub r9, 48

    mov r10, r8
    imul r10, r9

    pop r8
    pop r9

    add r10, 48

    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, multiply
    mov rdx, symbol_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r9
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, equals
    mov rdx, symbol_length
    syscall

    mov [rsp+8], r10

    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp+8]
    mov rdx, 1
    syscall

    jmp LOOP


Divide:
    mov rax, 1
    mov rdi, 1
    mov rsi, first_number
    mov rdx, first_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, first_temp
    mov rdx, 2
    syscall

    mov r8, first_temp

    mov rax, 1
    mov rdi, 1
    mov rsi, second_number
    mov rdx, second_number_length
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, second_temp
    mov rdx, 2
    syscall

    mov r9, second_temp

    movzx eax, byte [first_temp]
    sub    al, 48
    movzx ebx, byte [second_temp]
    sub    bl, 48

    test   bl, bl
    jz     LOOP

    xor    ah, ah
    div    bl
    add al, 48
    mov [outch], al

    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, divide
    mov rdx, symbol_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r9
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, equals
    mov rdx, symbol_length
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, outch
    mov rdx, 1
    syscall

    jmp LOOP

Exit:
    mov rax, 60
    xor rdi, rdi
    syscall
    sysexit
