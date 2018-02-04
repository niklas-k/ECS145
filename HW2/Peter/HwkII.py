import socket
import sys

global cliHost, cliPort, cliConn
cliConn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cliHost = sys.argv[1]
cliPort = int(sys.argv[2])
cliConn.connect((cliHost, cliPort))

input = raw_input("enter CSIF username>> ")
cliConn.send(input)
input = raw_input(">> ")
cliConn.send(input)

i = 0
while(1):
    data = cliConn.recv(1000000)
    i += 1
    if (i < 5):
        print data
    if not data:
        break
    print 'received', len(data), 'bytes'
    input = raw_input(">> ")
    if input == "done":
        break
    cliConn.send(input)

cliConn.close()
