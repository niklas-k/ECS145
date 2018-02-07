import socket
import sys

global cliHost, cliPort, cliConn
cliConn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
cliHost = sys.argv[1]
cliPort = int(sys.argv[2])
cliConn.connect((cliHost, cliPort))

i = 0
while(1):
    input = raw_input(">> ")
    if input == "done":
        break
    cliConn.send(input)
    data = cliConn.recv(1000000)
    i += 1
    print data
    if not data:
        break
    print 'received', len(data), 'bytes'

cliConn.close()

