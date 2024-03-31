%macro write 2
mov rax, 1
mov rdi, 1
mov rsi, %1
mov rdx, %2
syscall
%endmacro

%macro read 2
mov rax, 0
mov rdi, 0
mov rsi, %1
mov rdx, %2
syscall
%endmacro

%macro exit 0
mov rax, 60
mov rdi, 0
syscall
%endmacro

section .data
    menu db "1 - Addition", 0xA
         db "2 - Subtraction", 0xA
         db "3 - Multiplication", 0xA
         db "4 - Division", 0xA
         db "op> "
    menuLen equ $-menu

    msg1 db "Enter first number (16 digits): "
    msg1Len equ $-msg1

    msg2 db "Enter second number (16 digits): "
    msg2Len equ $-msg2

    msg3 db "Answer is: "
    msg3Len equ $-msg3


section .bss
    choice resb 2
    num1 resb 17
    num2 resb 17
    result resb 17

section .text
    global _start

    _start:
        mov byte [result+16], 0xA
        write menu, menuLen
        read choice, 2
        cmp byte [choice], '4'
        jg exitprog
        
        write msg1, msg1Len
        read num1, 17
        write msg2, msg2Len
        read num2, 17

        call process_inp

        cmp byte [choice], '1'
        je addition
        cmp byte [choice], '2'
        je subtraction
        cmp byte [choice], '3'
        je multiplication
        cmp byte [choice], '4'
        je division

    exitprog: exit

    addition:
        mov rsi, [num1]
        mov rdi, [num2]

        mov [result], rsi
        add [result], rdi

        call display
        jmp _start

    subtraction:
        mov rsi, [num1]
        mov rdi, [num2]

        mov [result], rsi
        sub [result], rdi

        call display
        jmp _start

    multiplication:
        mov rax, [num1]
        mov rbx, [num2]

        mul rbx
        mov [result], rax
        call display
        jmp _start

    division:
        mov rax, [num1]
        mov rbx, [num2]

        div rbx
        mov [result], rax
        call display
        jmp _start

    display:
        mov rcx, 16
        mov rsi, result+15
        mov rdx, [result]
        mov rbx, 0
    
        next2:
            mov bl,dl
            ror rdx, 4
            and bl, 0x0F
            cmp bl, 0x0A
            jl add30h
            add bl, 0x7            
        add30h:
            add bl, 0x30
            mov [rsi], bl
            dec rsi
            loop next2
        
        write msg3, msg3Len
        write result, 17
        write result+16, 1 ; additional new line
        
        ret

    process_inp:
        mov rbx, 0
        mov rsi, num1
        mov rcx, 16
    
    process_loop: rol rbx, 4
        mov dl, [rsi];
        cmp dl, 0x40
        jl noadd9
        add dl, 9
    noadd9: and dl, 0x0F
        add bl, dl
        inc rsi
        loop process_loop
        
        cmp rsi, num1+16
        jnz return
        mov [num1], rbx
        mov rsi, num2
        mov rbx, 0
        mov rcx, 16
        jmp process_loop

    return: mov [num2], rbx
        ret
