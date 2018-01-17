import socket

HOST = '127.0.0.1'
PORT = 5000
RFID_READER_ID = 1 #identifies RFID reader so we know its location

def Main():
    # Test function which sends hard coded data to server, it will be replaced with
    # real RFID reader code
    while True:
        wait = input("PRESS BUTTON TO CONTINUE.")
        try:
            send_data(1) #fixed user id
        except ConnectionError:
            print("Connection error")


def send_data(rfid_id):
    mySocket = socket.socket()
    mySocket.connect((HOST,PORT))
    msg = 'RFID {} {}'.format(RFID_READER_ID, rfid_id)
    mySocket.send(msg.encode())
    mySocket.close()

if __name__ == '__main__':
    Main()
