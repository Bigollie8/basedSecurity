import requests
import time
import Cipher
import hashlib

#Testing vars for loader connection
info = {
    "username" : "Admina",
    "vendorid" : str(3021),
    "deviceid" : str(1739),
    "unix" : str(round(time.time())),
    "plaintext" : "BasedSecurity"
}

vars = {
    "payload" : "",
    "key" : 0,
    "encryptedPayload" : "",
    "hash" : "",
    "url" : "",
}

def updateVars():
    info["unix"] = str(round(time.time()))
    vars["payload"] = info["username"] + ":" + info["vendorid"] + ":" + info["deviceid"] + ":" + info["unix"] + ":" + info["plaintext"]
    vars["key"] = int(str(round(time.time()))[9]) + 3
    vars["encryptedPayload"] = Cipher.encrypt(vars["payload"],vars["key"])
    vars["hash"] = hashlib.md5(vars["encryptedPayload"].encode()).hexdigest()
    vars["url"] = "http://127.0.0.1:5000" + '/login'+ '/'+ vars["encryptedPayload"] +'/' + vars["hash"]

def testConnection():
    updateVars()
    print(vars["url"])
    textResponse = requests.get(vars["url"])
    responseJSON = textResponse.json()
    if responseJSON['Status']:
        print("Response : " + textResponse.text)
        print("Success")
    else:
        print("Failed to connect")

    print("---"*40)

mode = input("Would you like to manually ping server ( Y or N ) : ")

while True:
    if mode == "y" or mode == "Y":
        userinput = input("Press ENTER to test backend(type Q to quit) : ")
        if userinput == "q" or userinput == "Q":
            break
        testConnection()
    else:
        time.sleep(1)
        testConnection()