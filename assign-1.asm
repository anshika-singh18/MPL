section .data
    msg1 db"Enter 5 Numbers: ", 0xA, 0xD
    msg1len equ $-msg1

    msg2 db"Numbers Entered Are: ", 0xA, 0xD
    msg2len equ $-msg2

section .bss
    array resq 200

section .text
    global _start
    _start:
        mov rax, 1
        mov rdi, 1
        mov rsi, msg1
        mov rdx, msg1len
        syscall

        mov rcx, 05H
        mov rbx, array
        
    loop1:
        push rcx
        mov rax, 0
        mov rdi, 0
        mov rsi, rbx
        mov rdx, 17
        syscall

        pop rcx
        add rbx, 17
        dec rcx
        jnz loop1
 

        mov rax, 1
        mov rdi, 1
        mov rsi, msg2
        mov rdx, msg2len
        syscall

        mov rcx, 05H
        mov rbx, array
        
    loop2:
        push rcx
        mov rax, 1
        mov rdi, 1
        mov rsi, rbx
        mov rdx, 17
        syscall

        pop rcx
        add rbx, 17
        dec rcx
        jnz loop2


        mov rax, 60
        mov rdi, 0
        syscall
