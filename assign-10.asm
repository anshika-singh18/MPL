%macro write 2
mov rax, 1
mov rdi, 1
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
    msg1 db "Factorial is: "
    msg1Len equ $-msg1

section .bss
    result resb 17

section .text
    global _start
    _start:
        mov byte [result+16], 0xA

        pop rbx
        pop rbx
        pop rbx

        mov dh, [rbx]
        mov dl, [rbx+1]
        movzx rbx, dx
        sub rbx, 0x3030


        write msg1, msg1Len
        mov rax, rbx
        call factorial
        call display
        write result+16, 1

        exit

        factorial:
            cmp rbx, 1
            jg recursion
            ret
            
            recursion:
                dec rbx
                mul rbx
                call factorial
                ret
        
        display:
            mov rcx, 0
            mov rbx, 10

            display_loop: cmp rax, 0
                jle endloop
                mov rdx, 0
                div rbx
                add rdx, 0x30
                push rdx
                inc rcx
                jmp display_loop
            
            endloop:
                pop rax
                mov [result], rax
                push rcx
                write result, 1
                pop rcx
                loop endloop

            ret