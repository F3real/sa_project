import threading
import socket
import configparser
import MySQLdb
import datetime

HOST = '127.0.0.1'
PORT = 5003

DB_PASSWORD = ''
DB_USERNAME = ''
DB_HOST = ''
DB_NAME = ''
WEEKDAYS = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']

MSG_SERVER_HOST = '127.0.0.1'
MSG_SERVER_PORT = 5001

def Main():
    config = configparser.ConfigParser()
    config.read('db.ini')
    global DB_PASSWORD
    global DB_USERNAME
    global DB_HOST
    global DB_NAME
    DB_PASSWORD = config['DEFAULT']['PASSWORD']
    DB_USERNAME = config['DEFAULT']['USERNAME']
    DB_HOST = config['DEFAULT']['HOST']
    DB_NAME = config['DEFAULT']['NAME']

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
                if data_list[0] == "RFID_M":
                    threading.Thread(target=handle_auth_message, args=(data_list[1], data_list[2],)).start()

    mySocket.shutdown()
    mySocket.close()

def handle_auth_message(reader_id, user_id):
    print("Handling RFID request")
    db=MySQLdb.connect(host=DB_HOST, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    
    cur = db.cursor()
    cur.execute("SELECT room_id, type FROM rfid WHERE id=%s LIMIT 1", (reader_id,))
    res = cur.fetchall()
    room_id = res[0][0]
    rfid_type = res[0][1]

    now = datetime.datetime.now()
    day = WEEKDAYS[now.weekday()]
    hour = now.hour
  
    cur.execute("SELECT * FROM permissions WHERE room_id=%s and user_id=%s and day=%s", (room_id, user_id, day))
    res = cur.fetchall()[0]
    if hour > res[3] and hour < res[4]:
        mySocket = socket.socket()
        mySocket.connect((MSG_SERVER_HOST, MSG_SERVER_PORT))
        msg = 'GATE {}'.format(room_id)
        mySocket.send(msg.encode())
        mySocket.close()

        #Insert into access log
        cur.execute("""INSERT INTO `entrylog` (`id`, `room_id`, `time`, `type`, `user_id`) 
        VALUES (NULL, %s, %s, %s, %s)""", (room_id, now.isoformat(), rfid_type, user_id))
        db.commit()

if __name__ == '__main__':
    Main()