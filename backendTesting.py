import requests
import time
import Cipher
import hashlib
import random

#Testing vars for loader connection
info = {
    "username" : "Admin",
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

def restoreVars():
    info["username"] = "Admin"
    info["vendorid"] = str(3021)
    info["deviceid"] = str(1739)

def updateVars():
    info["unix"] = str(round(time.time()))
    vars["payload"] = info["username"] + ":" + info["vendorid"] + ":" + info["deviceid"] + ":" + info["unix"]
    vars["key"] = int(str(round(time.time()))[9]) + 3
    vars["encryptedPayload"] = Cipher.encrypt(vars["payload"],vars["key"])
    vars["hash"] = hashlib.md5((vars["encryptedPayload"] + info["plaintext"]).encode()).hexdigest()
    vars["url"] = "http://127.0.0.1:5000" + '/login'+ '/'+ vars["encryptedPayload"] +'/' + vars["hash"]

def testConnection():
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
    restoreVars()
    if mode == "y" or mode == "Y":
        print("""
        To send a false connection select a number:\n
        [1] : Send False Name
        [2] : Send False VendorID
        [3] : Send False DeviceID
        [4] : Send False hash

        """)
        userinput = input("Press ENTER to test backend(type Q to quit) : ")
        if userinput == "q" or userinput == "Q":
            break
        elif userinput == "1":
            info["username"] = "Null"
        elif userinput == "2":
            info["deviceid"] = "1234"
        elif userinput == "3":
            info["vendorid"] = "1234"
        updateVars()
        if userinput == "4":
            vars["hash"] = hashlib.md5(info["deviceid"].encode()).hexdigest()
            vars["url"] = "http://127.0.0.1:5000" + '/login'+ '/'+ vars["encryptedPayload"] +'/' + vars["hash"]
            print(vars["hash"])

        testConnection()

    else:
        time.sleep(random.randint(1,3))
        updateVars()
        testConnection()