import requests
import time
import Cipher
import hashlib

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


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

heartbeatVars = {
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
    vars["payload"] = info["username"] + ":" + info["vendorid"] + ":" + info["deviceid"] + ":" + info["unix"]
    vars["key"] = int(str(round(time.time()))[9]) + 3
    vars["encryptedPayload"] = Cipher.encrypt(vars["payload"],vars["key"])
    vars["hash"] = hashlib.md5((vars["encryptedPayload"] + info["plaintext"]).encode()).hexdigest()
    vars["url"] = "http://127.0.0.1:5000" + '/login/'+ vars["encryptedPayload"] +'/' + vars["hash"]

def updateHeartbeatVars():
    heartbeatVars["payload"] = info["username"] + ":" + info["vendorid"] + ":" + info["deviceid"] + ":" + info["unix"]
    heartbeatVars["key"] = int(str(round(time.time()))[9]) + 3
    heartbeatVars["encryptedPayload"] = Cipher.encrypt(heartbeatVars["payload"],heartbeatVars["key"])
    heartbeatVars["hash"] = hashlib.md5((heartbeatVars["encryptedPayload"] + info["plaintext"]).encode()).hexdigest()
    heartbeatVars["url"] = "http://127.0.0.1:5000" + '/heartbeat/'+ heartbeatVars["encryptedPayload"] +'/' + heartbeatVars["hash"]

def testConnection():
    print(vars["url"])
    textResponse = requests.get(vars["url"])
    responseJSON = textResponse.json()
    if responseJSON['Status']:
        print("Response : " + textResponse.text)
        print(f'{bcolors.OKGREEN} Success {bcolors.ENDC}')
    else:
        print(f'{bcolors.FAIL}Failed to connect{bcolors.ENDC}')

    print(f'{bcolors.OKCYAN}' + ('---'*35) + f'{bcolors.ENDC}')

def testHeartbeat():
    print(heartbeatVars["url"])
    textResponse = requests.get(heartbeatVars["url"])
    responseJSON = textResponse.json()
    if responseJSON['Status']:
        print("Response : " + textResponse.text)
        print(f'{bcolors.OKGREEN} Success {bcolors.ENDC}')
    else:
        print(f'{bcolors.FAIL}Failed to connect{bcolors.ENDC}')

    print(f'{bcolors.OKCYAN}' + ('---'*35) + f'{bcolors.ENDC}')

mode = input("Would you like to manually ping server ( Y or N ) : ")

print(f'{bcolors.OKCYAN}' + ('---'*35) + f'{bcolors.ENDC}')

while True:
    restoreVars()
    if mode == "y" or mode == "Y":
        print("""
        To send a false connection select a number:\n
        [1] : Send False Name
        [2] : Send False VendorID
        [3] : Send False DeviceID
        [4] : Send False hash
        [5] : Test Heartbeat
        [6] : Unix + 1
        [7] : Unix + 3
        [8] : Unix - 3

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
        info["unix"] = str(round(time.time()))
        if userinput == "6":
            info["unix"] = str(round(time.time() + 1))
        if userinput == "7":
            info["unix"] = str(round(time.time() + 3))
        if userinput == "8":
            info["unix"] = str(round(time.time() - 3))
        updateVars()
        if userinput == "4":
            vars["hash"] = hashlib.md5(info["deviceid"].encode()).hexdigest()
            vars["url"] = "http://127.0.0.1:5000" + '/login'+ '/'+ vars["encryptedPayload"] +'/' + vars["hash"]
        if userinput == "5":
            updateHeartbeatVars()
            testHeartbeat()
            pass
        testConnection()

    else:
        time.sleep(1)
        info["unix"] = str(round(time.time()))
        updateVars()
        testConnection()
        time.sleep(1)
        updateHeartbeatVars()
        testHeartbeat()
