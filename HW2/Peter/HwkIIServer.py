import socket # networking module
import sys
import os
import threading

def sysStart(hostList, portNum):
    global serSock, serPort, serHosts, threadList
    serSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    serPort = portNum
    serHosts = hostList
    serSock.bind(("", serPort))
    serSock.listen(5)
    threadList = []
    
    while True:
        try:
	    clientConn,address = serSock.accept()
        except KeyboardInterrupt:
	    try:
		if threading.activeCount() == 1:
		    break
	    except KeyboardInterrupt:
		sys.exit()
	newClient = srvr(clientConn)
        threadList.append(newClient)
        newClient.start()
    
def sysStop(hostList):
    for thread in threadList:
        thread.join()
    print threading.activeCount()
    serSock.close()
    if threading.activeCount() == 1:
        print "Client Closed"

class srvr(threading.Thread):
    origHost = None
    FPList = {}
    threadLock = threading.Lock()
    def __init__(self,newConn):
        threading.Thread.__init__(self)
        self.origHost = socket.gethostname()
        self.clientConn = newConn
    
    def toHashHost(self,fileName):
        if self.origHost != socket.gethostname():
            os.system("exit &")
            os.chdir("/tmp")
        
        if str(socket.gethostname) != serHosts[hash(fileName) % len(serHosts)]:
            os.system("ssh "+serHosts[hash(fileName) % len(serHosts)]+" &")
            os.chdir("/tmp")
	
    
    def getFunc(self, data):
    	func = data.split("(")[0]
    	fileName = data.split("(")[1].split(",")[0].split(")")[0]
    	try:
            bytesRW = data.split(",")[1].split(")")[0]
    	except:
            bytesRW = ""
    	return (func, fileName, bytesRW)
    
    def dOpen(self,fileName):
        self.toHashHost(fileName)
        try:
            a = open(fileName, 'r+')
        except IOError:
            a = open(fileName, 'a+')
        self.FPList[fileName] = a
        return "Opened "+fileName
    
    def dRead(self,fileName,bytesToRead):
        self.toHashHost(fileName)
        fp = self.FPList[fileName]
        readBytes = fp.read(int(bytesToRead))
        return readBytes
    
    def dWrite(self, fileName, bytesToWrite):
        self.toHashHost(fileName)
        fp = self.FPList[fileName]
        fp.write(bytesToWrite)
        return "Wrote \""+bytesToWrite+"\" to "+fileName
    
    def dClose(self, fileName):
        self.toHashHost(fileName)
        print os.getcwd()
        fp = self.FPList[fileName]
        fp.close
        del self.FPList[fileName]
        return "Closed "+fileName
    
    def run(self):
        os.chdir("/tmp")
        while 1:
            clientInput = self.clientConn.recv(1000)
            if clientInput == "" or clientInput == "done":
                break
            os.getcwd()
            clientInput = self.getFunc(clientInput)
            if clientInput[0] == "dOpen":
                clientOutput = self.dOpen(clientInput[1])
            elif clientInput[0] == "dRead":
                clientOutput = self.dRead(clientInput[1],clientInput[2])
            elif clientInput[0] == "dWrite":
                clientOutput = self.dWrite(clientInput[1],clientInput[2])
            elif clientInput[0] == "dClose":
                clientOutput = self.dClose(clientInput[1])
            else:
                clientOutput = "Failed Command"
            srvr.threadLock.acquire()
            self.clientConn.send(clientOutput)
            srvr.threadLock.release()
    
        self.clientConn.close()
	numClients = threading.activeCount() - 1
        print "client connection closed"
	print str(numClients) + " currently active client connections"
        return

