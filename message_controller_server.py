import threading
import socket
import pika


RABBIT_MQ = 'localhost'
HOST = '127.0.0.1'
PORT = 5001

ACCESS_SERVICE_IP = 'localhost'
ACCESS_SERVICE_PORT = 5003

def Main():
    rfid_thread = threading.Thread(target = handler_RFID)
    rfid_thread.start()
    
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
                if data_list[0] == "GATE":
                    handle_gate_message(data_list[1])

    mySocket.shutdown()
    mySocket.close()


##RFID##

#Server for handling incoming RFID requests
def handler_RFID():
    connection = pika.BlockingConnection(pika.ConnectionParameters(RABBIT_MQ))
    channel = connection.channel()
    channel.queue_declare(queue='RFID')
    channel.basic_consume(callback_RFID,
                      queue='RFID',
                      no_ack=True)
    channel.start_consuming()

#Callback function called on each incoming message
def callback_RFID(ch, method, properties, body):
    print(" [x] Received %r" % body)
    data = body.decode('utf-8').split()
    mySocket = socket.socket()
    mySocket.connect((ACCESS_SERVICE_IP,ACCESS_SERVICE_PORT))
    msg = 'RFID_M {} {}'.format(data[0], data[1])
    mySocket.send(msg.encode())
    mySocket.close()


##GATE##

#Send message to open gate in case of authorization
def handle_gate_message(door_id):
    print("Handling RFID request")
    connection = pika.BlockingConnection(pika.ConnectionParameters(RABBIT_MQ))
    channel = connection.channel()
    channel.queue_declare(queue='gate')
    channel.basic_publish(exchange='',
                      routing_key='gate',
                      body='{}'.format(door_id))
    connection.close()


if __name__ == '__main__':
    Main()