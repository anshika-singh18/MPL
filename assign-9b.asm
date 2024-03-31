%macro writedata 2
mov rax, 1
mov rdi, 1
mov rsi, %1
mov rdx, %2
syscall
%endmacro

%macro readdata 2
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
    linesMsg db "Number of Lines in file: ",
    linesMsgLen equ $-linesMsg
    lines times 3 db 0xA

    spacesMsg db "Number of Blank Spaces in file: "
    spacesMsgLen equ $-spacesMsg
    spaces times 3 db 0xA

    occurMsg db "Number of times e occures: "
    occurMsgLen equ $-occurMsg
    occurs times 3 db 0xA

    charMsg db "Enter Character to search: "
    charMsgLen equ $-charMsg

section .text
    extern openfile, readfile, buff, dataLen

    global _start
    _start:
        call openfile
        call readfile

        mov bl, 0xA
        mov rdi, lines
        call count
        writedata linesMsg, linesMsgLen
        writedata lines, 3


        mov bl, 0x20
        mov rdi, spaces
        call count
        writedata spacesMsg, spacesMsgLen
        writedata spaces, 3

        writedata charMsg, charMsgLen
        readdata occurMsg+16, 1
        mov bl, [occurMsg+16]
        mov rdi, occurs
        call count
        writedata occurMsg, occurMsgLen
        writedata occurs, 2
        exit

    count:
        mov rsi, buff
        mov rcx, dataLen
        xor al, al

        countloop:
        cmp [rsi], bl
        jne notnew
        add al, 1

        notnew:
        add rsi, 1
        loop countloop

        add al, 0x30
        mov [rdi], al
        ret

