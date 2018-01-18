import configparser

from flask import Flask
from flaskext.mysql import MySQL
from flask_restful import Resource, Api
from flask_httpauth import HTTPBasicAuth

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
                    print(res)
        finally:
            db.close()
        return "Welcome"

api.add_resource(StudentLogs, '/logs')

@auth.verify_password
def verify(username, password):
    if not (username and password):
        return False
    return username == "root" and password == "root"

if __name__ == "__main__":
    app.run('localhost', 5004, debug=True)