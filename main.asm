section .data
    prompt_num1 db "Enter the first number: ", 0
    len_prompt_num1 equ $ - prompt_num1
    prompt_num2 db "Enter the second number: ", 0
    len_prompt_num2 equ $ - prompt_num2
    prompt_op db "Choose an operation (+, -, *, /): ", 0
    len_prompt_op equ $ - prompt_op
    result_msg db "The result is: ", 0
    len_result_msg equ $ - result_msg
    error_msg db "Error: Invalid input, or input/output overflow, or division by zero", 0
    len_error_msg equ $ - error_msg
    new_line db 10, 0

section .bss
    num1 resb 16
    num2 resb 16
    op resb 1
    num1_int resd 1
    num2_int resd 1
    result resd 1
    result_buffer resb 12

section .text
    global _start

_start:
    ; ask for first number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_num1
    mov edx, len_prompt_num1
    int 0x80

    ; convert first number and save it
    mov ecx, num1
    call read_and_convert
    mov [num1_int], eax

    ; ask for second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_num2
    mov edx, len_prompt_num2
    int 0x80

    ; convert second number and save it
    mov ecx, num2
    call read_and_convert
    mov [num2_int], eax

    ; ask for operation
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_op
    mov edx, len_prompt_op
    int 0x80

    ; read operation
    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 1
    int 0x80

    ; switch (op)
    mov al, [op]
    cmp al, '+'
    je do_add
    cmp al, '-'
    je do_sub
    cmp al, '*'
    je do_mul
    cmp al, '/'
    je do_div
    jmp show_error

do_add:
    mov eax, [num1_int]
    add eax, [num2_int]
    jo  show_error
    mov [result], eax
    jmp print_result

do_sub:
    mov eax, [num1_int]
    sub eax, [num2_int]
    jo  show_error
    mov [result], eax
    jmp print_result

do_mul:
    mov eax, [num1_int]
    imul eax, [num2_int]
    jo  show_error
    mov [result], eax
    jmp print_result

do_div:
    ; verify if denominator is equal to zero
    mov eax, [num2_int]
    cmp eax, 0
    je show_error

    ; divide
    mov eax, [num1_int]
    cdq
    idiv dword [num2_int]
    mov [result], eax
    jmp print_result

show_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, len_error_msg
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80
    jmp exit

print_result:
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, len_result_msg
    int 0x80

    ; convert result to string
    mov eax, [result]
    mov edi, result_buffer + 11
    mov ecx, 0
    cmp eax, 0
    jge positive_number

    inc ecx
    neg eax

positive_number:
    mov ebx, 10

convert_loop:
    xor edx, edx

    ; make div and save the remainder
    div ebx
    add dl, '0'
    mov [edi], dl

    ; inc counter and move pointer
    inc ecx
    dec edi

    ; check if result of previous div was zero
    test eax, eax
    jnz convert_loop

    ; check if negative to print sign
    mov ebx, result_buffer + 11
    sub ebx, ecx
    cmp edi, ebx
    je skip_sign

    mov byte [edi], '-'
    dec edi

skip_sign:
    ; finally print result
    inc edi
    mov edx, ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    int 0x80

    ; print \n
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80

exit:
    ; clear user \n before exit
    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

read_and_convert:
    ; read up to 15 digits + '\n'
    mov eax, 3
    mov ebx, 0
    mov edx, 16
    int 0x80

    mov esi, ecx
    xor eax, eax
    xor ebx, ebx

str_to_dec_loop:
    mov bl, [esi]
    cmp bl, 10
    je done_convert

    ; validate '0'..'9'
    cmp bl, '0'
    jb show_error
    cmp bl, '9'
    ja show_error
    sub bl, '0'

    ; prevent 32-bit overflow: if eax > 2147483647
    mov edx, eax
    cmp edx, 214748364
    ja show_error
    jb ok
    cmp bl, 7
    ja show_error

ok:
    mov eax, edx
    imul eax, eax, 10
    add eax, ebx

    inc esi
    jmp str_to_dec_loop

done_convert:
    ret