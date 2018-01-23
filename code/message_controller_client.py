import socket
import pika
import threading


HOST = '127.0.0.1'
PORT = 5000
RABBIT_MQ = 'localhost'

def Main():

    gate_thread = threading.Thread(target = handler_gate)
    gate_thread.start()

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
                if data_list[0] == "RFID":
                    handle_rfid_message(data_list[1], data_list[2])

    mySocket.shutdown()
    mySocket.close()


##RFID##

#Handle incoming messages from RFID readers
def handle_rfid_message(reader_id, user_id):
    print("Handling RFID request")
    connection = pika.BlockingConnection(pika.ConnectionParameters(RABBIT_MQ))
    channel = connection.channel()
    channel.queue_declare(queue='RFID')
    channel.basic_publish(exchange='',
                      routing_key='RFID',
                      body='{} {}'.format(reader_id, user_id))
    connection.close()


##GATE##

#Server for handling incoming gate messages
def handler_gate():
    connection = pika.BlockingConnection(pika.ConnectionParameters(RABBIT_MQ))
    channel = connection.channel()
    channel.queue_declare(queue='gate')
    channel.basic_consume(callback_gate,
                      queue='gate',
                      no_ack=True)
    channel.start_consuming()

#Callback function called on each incoming message
#to deliver it to appropriate gate
def callback_gate(ch, method, properties, body):
    print(" [x] Received %r" % body)
    mySocket = socket.socket()
    gate_id = body.decode('utf-8')
    mySocket.connect((GATE_INFO[gate_id][0], GATE_INFO[gate_id][1]))
    msg = 'GATE {}'.format(gate_id)
    mySocket.send(msg.encode())
    mySocket.close()

GATE_INFO = {'4':['localhost', 5002]}

if __name__ == '__main__':
    Main()