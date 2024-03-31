section .data
    dataLen equ 200
    filepath db "file.txt", 0

section .bss
    fd resq 1
    buff resb dataLen

section .text
    global openfile, readfile, closefile, buff, dataLen

    openfile:
        mov rax, 2
        mov rdi, filepath
        mov rsi, 2
        mov rdx, 777
        syscall
        mov [fd], rax
        ret
    
    readfile:
        mov rax, 0
        mov rdi, [fd]
        mov rsi, buff
        mov rdx, dataLen
        syscall
        ret

    closefile:
        mov rax, 2
        mov rdi, filepath
        syscall
        ret
