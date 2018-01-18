import configparser

from flask import Flask
from flaskext.mysql import MySQL
from flask_restful import Resource, Api
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import check_password_hash

app = Flask(__name__)

api = Api(app)

auth = HTTPBasicAuth()

config = configparser.ConfigParser() 
config.read('db.ini')

mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = config['DEFAULT']['USERNAME']
app.config['MYSQL_DATABASE_PASSWORD'] = config['DEFAULT']['PASSWORD']
app.config['MYSQL_DATABASE_DB'] = config['DEFAULT']['NAME']
app.config['MYSQL_DATABASE_HOST'] = config['DEFAULT']['HOST']
mysql.init_app(app)

#to view connect to http://localhost:5004/logs
class StudentLogs(Resource):
    @auth.login_required
    def get(self):
        db = mysql.connect()
        res = ""
        try:
            with db.cursor() as cur:
                cur.execute("SELECT room_id, type FROM rfid WHERE id=%s LIMIT 1", (1,))
                res = cur.fetchall()
        finally:
            db.close()
        return "Welcome " + auth.username()

api.add_resource(StudentLogs, '/logs')

#RES

@auth.verify_password
def verify(username, password):
    if not (username and password):
        return False
    db = mysql.connect()
    res = False
    try:
        with db.cursor() as cur:
            cur.execute("SELECT password FROM user WHERE codice_fiscale=%s LIMIT 1", (username,))
            password_hash = cur.fetchall()
            if password_hash != ():
                res = check_password_hash(password_hash[0][0], password)
    finally:
        db.close()
    return res

if __name__ == "__main__":
    context = ('server.crt', 'private.key')
    app.run('localhost', 5004, ssl_context=context, debug=True)
