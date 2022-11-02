from flask import Flask
from flask import request
import Cipher
import time
import random
import hashlib
import os
import pyfiglet

app = Flask(__name__)

payloadVAR = "thisismetypingareallylongmsg"
key = random.randint(3,len(payloadVAR)/2)
urlEncrypt = Cipher.encrypt(payloadVAR,key)
urlHash = (hashlib.md5(urlEncrypt.encode())).hexdigest()
url = '/login/<payload>/<creds>'
creds = 0
banner = pyfiglet.figlet_format("Based Security")


def updateKey():
    global urlEncrypt
    global urlHash
    global key
    key = random.randint(3,len(payloadVAR)/2)
    print("Key is now " + str(key))
    urlEncrypt = Cipher.encrypt(payloadVAR,key)
    urlHash = hashlib.md5(urlEncrypt.encode()).hexdigest()
    return str(urlHash)

def reset(length):
    time.sleep(length)
    os.system('clear')
    print(banner)

def verify(creds):
    print(key)
    expectedLength = 28
    if creds != urlHash:
         return False
    decryptPayload = Cipher.decrypt(payloadVAR,key)
    if len(decryptPayload) != expectedLength:
        return False
    print("Returning true")
    return True

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
    test = creds
    if request.method == 'GET':
        if verify(test):
            reset(2)
            return {"Status" : True,"URL":creds,"payload":Cipher.decrypt(payload,key)}
        else:
            return {"Status" : False,creds:urlHash}
    else:
        
        print("False")
        return {"Status":"Error"}



if __name__ == '__main__':
    app.run()






