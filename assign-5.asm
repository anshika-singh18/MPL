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
    nums db -0x54
         db -0x4A
         db +0x0F
         db +0x55
         db -0x4C
         db -0x32
         db -0x6A
         db +0x00
         db -0x7F
         db +0x39

    count equ 10

    negative_num_msg db "Negative count: "
    len_negative_num_msg equ $-negative_num_msg

    positive_num_msg db "Positive count: "
    len_positive_num_msg equ $-positive_num_msg

    pos_count db 0x30, 0xA
    neg_count db 0x30, 0xA

section .bss
    output resb 40
    

section .text
    global _start
    _start:

        mov rsi, nums
        mov rdi, output
        mov cl, count

    mainloop: movzx ax, byte [rsi]
        bt ax, 7
        mov byte [rdi], '+'
        inc byte [pos_count]
        jnc positive
        neg al
        mov byte [rdi], '-'
        dec byte [pos_count]
        inc byte [neg_count]
    
    positive: rol ax, 4
        ror al, 4
        add ax, 0x3030
        
        cmp al, 0x3A
        jl no_add_7
        add al, 7
    
    no_add_7: mov [rdi+1], ah
        mov [rdi+2], al
        mov byte [rdi+3], 0xA
        add rdi, 4
        inc rsi
        loop mainloop

        write output, 40

        write positive_num_msg, len_positive_num_msg
        write pos_count, 2

        write negative_num_msg, len_negative_num_msg
        write neg_count, 2

        exit
        