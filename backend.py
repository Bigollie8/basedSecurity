from flask import Flask
from flask import request
import Cipher
import time
import hashlib
import pyfiglet

app = Flask(__name__)

info = {
    "username" : "Filler",
    "vendorid" : str(123),
    "deviceid" : str(123),
    "unix" : str(123),
    "plaintext" : "BasedSecurity"
}

vars = {
    "expectedPayload" : str(info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"] + ":" +  info["plaintext"]),
    "key" : 1,
    "expectedEncrypt" : "",
    "expectedHash" : "",
    "url" :'/login/<payload>/<creds>',
}

banner = pyfiglet.figlet_format("Based Security")

verifyVars = {
    "expectedLength" : 0,
    "decryptPayload" : "",
}

def updateUserInfo(payload):
    decrypted = Cipher.decrypt(payload,vars["key"])
    table = decrypted.split(":")
    info["username"] = table[0]
    #Search databse for info and update it accordingly
    info["vendorid"] = str(3021)
    info["deviceid"] = str(1739)


def updateVars(payload):
    vars["key"] = int(str(round(time.time()))[9]) + 3
    updateUserInfo(payload)
    info["unix"] = str(round(time.time()))
    vars["expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"] + ":" +  info["plaintext"]
    vars["expectedEncrypt"] = Cipher.encrypt(vars["expectedPayload"],vars["key"])
    vars["expectedHash"] = hashlib.md5(vars["expectedEncrypt"].encode()).hexdigest()
    return True

def verify(payload,creds):
    if updateVars(payload):
        verifyVars["expectedLength"] = 0
        verifyVars["decryptPayload"] = Cipher.decrypt(payload,vars["key"])
        if creds != vars["expectedHash"]:
            print("Mismatched Hash")
            return False
        if vars["expectedPayload"] != verifyVars["decryptPayload"]:
            print("Mismatched Payload")
            return False
        if len(verifyVars["decryptPayload"]) == verifyVars["expectedLength"]:
            print("Imroper payload length")
            return False
        return True

@app.route('/')
def index():
    return 'BasedSecurity.inc!'

@app.route(vars["url"],methods = ['POST','GET'])
def login(payload,creds):
    if request.method == 'GET':
        if verify(payload,creds):
            return {"Status" : True,"URL":creds,"payload":Cipher.decrypt(payload,vars["key"])}
        else:
            return {"Status" : False,creds:vars["expectedHash"]}
    else:
        print("False")
        return {"Status":"Error"}


if __name__ == '__main__':
    app.run()






