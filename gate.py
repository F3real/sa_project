import socket
import threading


HOST = '127.0.0.1'
PORT = 5002
GATE_ID = 1 #identifies gate so we know its location

def Main():

    mySocket = socket.socket()
    mySocket.bind((HOST,PORT))
    mySocket.listen(1)

    while True:
        conn, addr = mySocket.accept()
        data = conn.recv(1024).decode()
        if data:
            print ("RECIEVED DATA:  " + str(data))
            data_list = data.split()
            if len(data_list) >= 2:
                if data_list[0] == "GATE" and int(data_list[1]) == GATE_ID:
                    print("GATE OPEN")

    mySocket.shutdown()
    mySocket.close()

if __name__ == '__main__':
    Main()