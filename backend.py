from flask import Flask
from flask import request
import Cipher
import time
import random
import hashlib
import os
import pyfiglet

app = Flask(__name__)

payloadVAR = 'x0001' + str(round(time.time()* 7.19123))
key = random.randint(3,len(payloadVAR))
urlEncrypt = Cipher.encrypt(payloadVAR,key)
urlHash = (hashlib.md5(urlEncrypt.encode())).hexdigest()
url = '/login/<payload>/<creds>'
creds = 0
banner = pyfiglet.figlet_format("Based Security")


def updateKey():
    global urlEncrypt
    global urlHash
    global key

    key = random.randint(3,len(payloadVAR))
    urlEncrypt = Cipher.encrypt(payloadVAR,key)
    urlHash = hashlib.md5(urlEncrypt.encode()).hexdigest()

    return str(urlHash)

def reset(length):
    time.sleep(length)
    os.system('clear')
    print(banner)

def verify(payload,creds):
    expectedLength = 0
    if creds != urlHash:
         return False
    decryptPayload = Cipher.decrypt(payload,key)
    if len(decryptPayload) == expectedLength:
        return False
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
    if request.method == 'GET':
        if verify(payload,creds):
            reset(2)
            return {"Status" : True,"URL":creds,"payload":Cipher.decrypt(payload,key)}
        else:
            return {"Status" : False,creds:urlHash}
    else:
        
        print("False")
        return {"Status":"Error"}



if __name__ == '__main__':
    app.run()






