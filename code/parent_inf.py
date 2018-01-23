import configparser

from flask import Flask, jsonify
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

#to view connect to https://user:pass@localhost:5004/logs
class StudentLogs(Resource):
    @auth.login_required
    def get(self):
        db = mysql.connect()
        res = ()
        entries = []
        try:
            with db.cursor() as cur:
                cur.execute("SELECT id FROM user WHERE codice_fiscale=%s LIMIT 1", (auth.username(),))
                res = cur.fetchall()[0][0]
            with db.cursor() as cur:
                cur.execute("""SELECT user_id, name, surname FROM parents, user WHERE user.id=parents.user_id
                            AND parents.parent_id=%s""", (res,))
                res = cur.fetchall()
                for child_data in res:
                    cur.execute("""SELECT time, type FROM entrylog WHERE user_id=%s AND room_id=1
                                AND time BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE()""", (child_data[0],))
                    res = cur.fetchall()
                    entries.append(child_data[1:])
                    entries.append(res)
        finally:
            db.close()
        return jsonify(entries)

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
