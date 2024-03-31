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
    msgGDT db "Contents of GDT are: "
    msgGDTLen equ $-msgGDT

    msgLDT db "Contents of LDT are: "
    msgLDTLen equ $-msgLDT

    msgIDT db "Contents of IDT are: "
    msgIDTLen equ $-msgIDT

    msgTR db "Contents of TR are: "
    msgTRLen equ $-msgTR

    msgMSW db "Contents of MSW are: "
    msgMSWLen equ $-msgMSW

    msgReal db "Processor in Real Mode", 0xA
    msgRealLen equ $-msgReal

    msgVritual db "Processor in Protected Mode", 0xA
    msgVirtualLen equ $-msgVritual

    msgCPUID db "CPUID is: ", 0xA
    msgCPUIDLen equ $-msgCPUID

section .bss
    outputAns resb 17
    

section .text
    global _start
    _start:
        mov byte [outputAns+16], 0xA

        sgdt [outputAns]
        call hex_to_ascii
        write msgGDT, msgGDTLen
        write outputAns, 17

        sldt [outputAns]
        call hex_to_ascii
        write msgLDT, msgLDTLen
        write outputAns, 17

        sidt [outputAns]
        call hex_to_ascii
        write msgIDT, msgIDTLen
        write outputAns, 17

        sldt [outputAns]
        call hex_to_ascii
        write msgTR, msgTRLen
        write outputAns, 17

        sidt [outputAns]
        call hex_to_ascii
        write msgMSW, msgMSWLen
        write outputAns, 17

        cmp byte [outputAns+15], '1'
        jne protected
        write msgReal, msgRealLen
        jmp not_protected

        protected:
        write msgVritual, msgVirtualLen

        not_protected:

        exit

    hex_to_ascii:
        mov rcx, 16
        mov rsi, outputAns+15
        mov rdx, [outputAns]
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
            
        ret