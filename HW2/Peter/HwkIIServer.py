import socket # networking module
import sys
import os
import threading
class srvr(threading.Thread):
    threadLock = threading.Lock()
    id = 0
    def __init__(self,newConn):
        threading.Thread.__init__(self)
        self.myid = srvr.id
        srvr.id += 1
        self.clientConn = newConn
    def run(self):
        username = self.clientConn.recv(1000)
        while 1:
            clientInput = self.clientConn.recv(1000)
            if clientInput == "":
                break
            srvr.threadLock.acquire()
            clientInput = os.popen("ssh "+username+"@pc34.cs.ucdavis.edu -t \"cd /tmp; ls\"").read()
            print clientInput
            self.clientConn.send(clientInput)
            srvr.threadLock.release()
        self.clientConn.close()

def sysStart(hostList, portNum):
    global serSock, serPort, threadList
    serSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    serPort = portNum
    serSock.bind(("", serPort))
    serSock.listen(5)
    threadList = []

    for i in range(5):
        clientConn,address = serSock.accept()
        newClient = srvr(clientConn)
        threadList.append(newClient)
        newClient.start()

    serSock.close()

    for thread in threadList:
        thread.join()