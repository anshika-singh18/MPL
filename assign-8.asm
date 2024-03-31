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
    data db "ShreyashB", 0xA
    dataLen equ $-data

    msgOver db "Result after copy with overlap: "
    msgOverLen equ $-msgOver
    
    msgNonOver db "Result after copy without overlap: "
    msgNonOverLen equ $-msgNonOver


section .bss
    nonoverlap resb dataLen

section .text
    global _start
    _start:
        mov rsi, data
        mov rdi, nonoverlap
        mov rcx, dataLen
        cld

        loop1:
        movsb
        loop loop1
        
        write msgNonOver, msgNonOverLen
        write data, dataLen

        mov rsi, data
        mov rdi, data+5
        mov rcx, 4

        loop2:
        movsb
        loop loop2
        
        write msgOver, msgOverLen
        write data, dataLen
        exit