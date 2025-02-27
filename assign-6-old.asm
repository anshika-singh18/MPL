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

section .bss
  input resb 5

section .text
  global _start
  _start:
    read input, 5
    exit
    