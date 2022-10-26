from flask import Flask
from flask import request
import cipher
import time
import random
import hashlib

app = Flask(__name__)

key = str(random.randint(20,123))
urlEncrypt =    cipher.encryptMessage("thisismetypingareallylongmsg",key)
urlHash = (hashlib.md5(urlEncrypt.encode())).hexdigest()
url = '/login/<payload>/<creds>'

def updateKey():
    global urlEncrypt
    global urlHash
    global key
    key = str(random.randint(20,123))
    urlEncrypt = cipher.encryptMessage("thisismetypingareallylongmsg",key)
    urlHash = hashlib.md5(urlEncrypt.encode()).hexdigest()
    return str(urlHash)

@app.route('/')
def index():
    return 'BasedSecurity.inc!'

@app.route('/generate')

def generate():
    updateKey()
    print("Expected response == " + urlHash)
    return ('http://127.0.0.1:5000' + '/login'+ '/'+ urlEncrypt +'/' + urlHash)

@app.route(url,methods = ['POST','GET'])
def login(payload,creds):
    if request.method == 'GET':
        print("Success")

        if creds == urlHash:
            return {"100":"Success", "payload":(cipher.decryptMessage(payload,key)),"URL":creds}
        else:
            return {"400":"Failed",creds:urlHash}
    else:
        print("false")
        return {"400":""}


if __name__ == '__main__':
    app.run()






