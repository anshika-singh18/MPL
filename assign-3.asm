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
	msg1 db"Enter 5 numbers:", 0xA, 0xD
	msg1len equ $-msg1

	msg2 db"Highest number is: ", 0xA, 0xD
	msg2len equ $-msg2

	count equ 5

section .bss
	nums resb 200
	ans resb 17

section .text
	global _start

	_start:
		write msg1, msg1len

		mov rax, count
		mov rbx, nums
		call readnums

		mov rax, [nums]
		mov rbx, nums+9
		mov cl, count
		dec cl

	loop: 
		cmp rax, [rbx]
		jge skip
		mov rax, [rbx]

	skip: add rbx, 9
		dec cl
		jnz loop

		mov [ans], rax

		write msg2, msg2len
		write ans, 9
		exit
		ret

	readnums:
		push rax
		read rbx, 9
		pop rax
		add rbx, 9
		dec rax
		jnz readnums
		ret
