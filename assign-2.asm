
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
    msg1 db"Enter String: "
    msg1len equ $-msg1

    msg2 db"Number of characters are: "
    msg2len equ $-msg2

    loop1 db"looping...", 0xA, 0xD
    looplen equ $-loop1


section .bss
    num resb 17
    ans resb 5

section .text
    global _start
    _start:
        write msg1, msg1len
        read num, 17
        mov byte [ans+4], 0xA

        sub al, 1
        mov bl, al
        
        and bl, 0x0F

        cmp bl, 0xA
        jl noadd7_1
        add bx, 0x7
    noadd7_1: add bx, 0x30

        mov [ans], bx
        write ans, 5

        exit