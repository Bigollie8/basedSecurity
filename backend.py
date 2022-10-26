from flask import Flask
from flask import request
import cipher
import time
import random
import hashlib

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'peekaboo!'

def check1():
    return False


urlEncrypt = (cipher.encryptMessage("thisismetypingareallylongmsg",str(random.randint(20,123))))
url = '/login/<username>/<creds>'

def updateKey():
    global urlEncrypt
    urlEncrypt = (cipher.encryptMessage("thisismetypingareallylongmsg",str(random.randint(20,123))))
    urlEncrypt = hashlib.md5(urlEncrypt.encode())
    urlEncrypt = urlEncrypt.hexdigest()
    return str(urlEncrypt)


@app.route('/generate')
def generate():
    updateKey()
    print("Expected response == " + urlEncrypt)
    return ('http://127.0.0.1:5000' + '/login'+ '/admin/' + urlEncrypt)

@app.route(url,methods = ['POST','GET'])
def login(username,creds):
    if request.method == 'GET':
        print("Success")

        if creds == urlEncrypt:
            return {"100":"Success", "username":username,"URL":creds}
        else:
            return {"400":"Failed",creds:urlEncrypt}
    else:
        print("false")
        return {"400":""}


if __name__ == '__main__':
    app.run()






