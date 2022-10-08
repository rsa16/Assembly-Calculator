; bits 64 defines that this is x64 assembly, default rel decides that registerless instructions are rip-relative, which basically means you can use registers that start with r. Beyond this, I'm not exactly sure how it works.
default rel
bits 64

; Variables (i mostly named the variable names random things because well... i have no creativity, might update the names in a new commit for clarity later.)
segment .data
	a db "---------------------------------", 0xa, 0x9, "ASSEMBLY CALCULATOR", 0x9, 0xa, "---------------------------------", 0xa, 0
	op_sentence db 'Enter Your Operation or type exit to exit(+, -, /, *): ', 0
	n_sent db "Enter The First Number: ", 0
	n_sent_2 db "Enter The Second Number: ", 0
	fmt db "%ld", 0
	sfm db " %c", 0
	op dq 0
	n db "%d", 0
	nm dq 0
	nmt dq 0
	o_sentence db "%ld + %ld = %d",0xa, 0
	e_sentence db "%ld - %ld = %d",0xa, 0
	d_sentence db "%ld / %ld = %d",0xa, 0
	m_sentence db "%ld * %ld = %d",0xa, 0

; code text
segment .text

; globalizing all the functions (is globalizing a word?)
global main
global addey
global subey
global muley
global divey

; Getting some external functions from different dlls because it'll make our lives easier.
extern printf
extern scanf

extern _CRT_INIT
extern ExitProcess

; Utility functions.
addey:
; Move the edx register into the eax register
mov	eax, edx

add eax, ecx ; Add ecx register to eax register
ret

subey:
mov	eax, edx ; Move edx register into eax register
sub ecx, eax ; subtract eax register from ecx register
mov eax, ecx ;Move ecx register into eax register
ret

muley:
mov	eax, edx ; Move edx register into eax register
imul eax, ecx ;Multiply ecx register to eax register
ret

divey:
mov eax, ecx ;Eax is the number being divided by, but argument is passed into ecx to move ecx into eax

mov ebx, edx ;Move edx register to ebx

xor edx, edx ;32 bit division automatically assums edx to be the higher 32 bit numbers, but we dont need that as it will make things confusing so we zero it out.

div ebx
ret

main:
	; Microsoft has an x64 calling convention that describes how it expects windows programs to work.
	call _CRT_INIT

	; rbp is not used for referencing local variables in the x64 calling convention, and 32 bytes are always allocated to rcd, rdx, 48, and 49, so move rbp into rsp, and subtract 32 bytes from rsp.
	push	rbp
	mov		rbp, rsp
	sub		rsp, 32

	; Printing opening sentences with printf
	lea		rcx, [a]
	call printf

	lea		rcx, [op_sentence]
	call printf

	; Scaning operation from input with sfm being the format and op being the operator variable
	lea     rcx, [sfm]
    	lea     rdx, [op]
    	call scanf

	; If else statements
	mov		rcx, [op] ; Move op variable into rcx register
	
	; If operator is + jump to add function
	cmp		rcx, "+" ; 
	je		.ad

	; If operator is - jump to subtract function
	cmp		rcx, "-"
	je		.sb

	; If operator is / jump to divide function
	cmp		rcx, "/"
	je		.dv

	; If operator is * jump to multiply function
	cmp		rcx, "*"
	je		.ml
	
	cmp 		rcx, "exit"
	je		.exit

	; If operator isnt either loop main func again
	jmp main

.exit
call ExitProcess

; Add Function
.ad:
; Print 'Enter the first number'
lea		rcx, [n_sent]
call printf

; Scan the number into nm variable with n being the format
lea     rcx, [n]
lea     rdx, [nm]
call scanf

; Print 'Enter the second number'
lea		rcx, [n_sent_2]
call printf

; Scan the number into nmt variable with n being the format
lea     rcx, [n]
lea     rdx, [nmt]
call scanf

; Moving first number into rcx register and second number into rdx register, then calling the add utility function with said arguments
mov rcx, [nm]
mov rdx, [nmt]
call addey

; Moving the first number into rdx register, second number into r8 register, and result into r9 register, then calling printf
lea rcx, [o_sentence]
mov rdx, [nm]
mov r8, [nmt]
mov r9, rax
call printf

; Looping main again
jmp main


; Subtract function
.sb:

; Print 'Enter the first number'
lea		rcx, [n_sent]
call printf

; Scan the number into nm variable with n being the format
lea     rcx, [n]
lea     rdx, [nm]
call scanf

; Print 'Enter the second number'
lea		rcx, [n_sent_2]
call printf

; Scan the number into nmt variable with n being the format
lea     rcx, [n]
lea     rdx, [nmt]
call scanf

; Moving first number into rcx register and second number into rdx register, then calling the subtract utility function with said arguments
mov rcx, [nm]
mov rdx, [nmt]
call subey

; Moving the first number into rdx register, second number into r8 register, and result into r9 register, then calling printf
lea rcx, [e_sentence]
mov rdx, [nm]
mov r8, [nmt]
mov r9, rax
call printf

; Looping main again
jmp main

.dv:
; Print 'Enter the first number'
lea		rcx, [n_sent]
call printf

; Scan the number into nm variable with n being the format
lea     rcx, [n]
lea     rdx, [nm]
call scanf

; Print 'Enter the second number'
lea		rcx, [n_sent_2]
call printf

; Scan the number into nmt variable with n being the format
lea     rcx, [n]
lea     rdx, [nmt]
call scanf

; Moving first number into rcx register and second number into rdx register, then calling the divide utility function with said arguments
mov rcx, [nm]
mov rdx, [nmt]
call divey

; Moving the first number into rdx register, second number into r8 register, and result into r9 register, then calling printf
lea rcx, [d_sentence]
mov rdx, [nm]
mov r8, [nmt]
mov r9, rax
call printf

; Looping main again
jmp main

.ml:

; Print 'Enter the first number'
lea		rcx, [n_sent]
call printf

; Scan the number into nm variable with n being the format
lea     rcx, [n]
lea     rdx, [nm]
call scanf

; Print 'Enter the second number'
lea		rcx, [n_sent_2]
call printf

; Scan the number into nmt variable with n being the format
lea     rcx, [n]
lea     rdx, [nmt]
call scanf

; Moving first number into rcx register and second number into rdx register, then calling the multiply utility function with said arguments
mov rcx, [nm]
mov rdx, [nmt]
call muley

; Moving the first number into rdx register, second number into r8 register, and result into r9 register, then calling printf
lea rcx, [m_sentence]
mov rdx, [nm]
mov r8, [nmt]
mov r9, rax
call printf

; Looping main again
jmp main




