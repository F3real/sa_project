import threading
import pika


RABBIT_MQ = 'localhost'

def Main():
    rfid_thread = threading.Thread(target = handler_RFID)
    rfid_thread.start()
    rfid_thread.join()
    #TODO create server for listening for response from auth service
    #and call handle_gate_message with response

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
    #TODO send message to auth service


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