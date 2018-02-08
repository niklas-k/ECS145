Readme for HwkII:

Server File: HwkIIServer.py
Client File: HwKII.py

Group:
Peter Van Ausdeln
Henry Jue
Niklas Kraemer

Starting Server:
In interactive mode, first import * from HwkIIServer, then use the sysStart function. The function has two parameters, a list of the hosts used, such as [“pc34.cs.ucdavis.edu”,”pc35.cs.ucdavis.edu”], and a port number, such as 2000. A sample execution might look like this:

>>>from HwkIIServer import *; sysStart([“pc34.cs.ucdavis.edu”,”pc35.cs.ucdavis.edi”],2000)

Starting Client:
Starting the client is a simple matter. Just run “python HwkII.py <hostname> <port number>”. An example of a client connecting to the previously mentioned server (if that server was started from pc34) would be:

username@pc34:~$ python HwkII.py pc34.cs.ucdavis.edu 2000

Available Functions:
All four functions mentioned in the HwkII prompt (dOpen, dRead, dWrite, dClose) are available to be used from the client. The parameters are identical to their analogous python functions (i.e. dOpen and dClose take a filename, dRead takes a number of bytes with the filename, and dWrite takes a string to write with the filename).

Closing Client:
To close the client, simply enter “done” into the client prompt. Once the client has successfully closed, a message should appear on the server side telling you that the client has closed.

Closing Server:
We’ve built a method for (relatively) gracefully closing the server. Pressing Ctrl-C will nicely close the server if there are no clients currently connected. If there are still clients connected, pressing Ctrl-C a second time will forcefully shut down the server.