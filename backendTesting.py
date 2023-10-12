import requests
import time
import cipher
import hashlib

#BASE_URL = "http://basedsecurity.net"
BASE_URL = "http://localhost:5000"

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
    "desync" : 0
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
    print(vars["payload"])
    vars["key"] = int(info['unix'][9]) + 1#accounts for dysnc in aws instance
    
    if vars["key"] == 1: # A key of 1 does not apply an encryption and is bad
        vars["key"] += 1

    vars["encryptedPayload"] = cipher.encrypt(vars["payload"],vars["key"])
    if not vars["encryptedPayload"]: 
        print(info['unix'])
        return False
    vars["hash"] = hashlib.md5((vars["encryptedPayload"] + info["plaintext"]).encode()).hexdigest()
    vars["url"] = BASE_URL + '/login/'+ vars["encryptedPayload"] +'/' + vars["hash"]

def updateHeartbeatVars():
    heartbeatVars["payload"] = info["username"] + ":" + info["vendorid"] + ":" + info["deviceid"] + ":" + info["unix"]
    heartbeatVars["key"] = int(info['unix'][9]) + 1 #accounts for dysnc in aws instance

    if vars["key"] == 1: # A key of 1 does not apply an encryption and is bad
        vars["key"] += 1

    heartbeatVars["encryptedPayload"] = cipher.encrypt(heartbeatVars["payload"],heartbeatVars["key"])
    heartbeatVars["hash"] = hashlib.md5((heartbeatVars["encryptedPayload"] + info["plaintext"]).encode()).hexdigest()
    heartbeatVars["url"] = BASE_URL + '/heartbeat/'+ heartbeatVars["encryptedPayload"] +'/' + heartbeatVars["hash"]

def testConnection():
    print(vars["url"])
    try:
        textResponse = requests.get(vars["url"])
        print("Response : " + textResponse.text)
        responseJSON = textResponse.json()
        if responseJSON['Status']:
            print(f'{bcolors.OKGREEN} Success {bcolors.ENDC}')
        else:
            print(f'{bcolors.FAIL} Failed {bcolors.ENDC}')
    except ValueError:
        raise TypeError(f'{bcolors.FAIL}Failed to connect with key : {bcolors.ENDC}' + str(vars["key"]))
    
    print(f'{bcolors.OKCYAN}' + ('---'*35) + f'{bcolors.ENDC}')

def testHeartbeat():
    print(heartbeatVars["url"])
    try: 
        textResponse = requests.get(heartbeatVars["url"])
        print("Response : " + textResponse.text)
        responseJSON = textResponse.json()
        if responseJSON['Status']:
            print(f'{bcolors.OKGREEN} Success {bcolors.ENDC}')
        else:
            print(f'{bcolors.FAIL} Failed {bcolors.ENDC}')

    except:
        raise TypeError(f'{bcolors.FAIL}Failed to connect with key : {bcolors.ENDC}' + str(heartbeatVars["key"]))
    
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
        print(vars["key"])
        userinput = input("Press ENTER to test backend(type Q to quit) : ")
        if userinput == "q" or userinput == "Q":
            break
        elif userinput == "1":
            info["username"] = "Null"
        elif userinput == "2":
            info["vendorid"] = "1234"
        elif userinput == "3":
            info["deviceid"] = "1234"
        info["unix"] = str(round(time.time()) + vars["desync"])
        if userinput == "6":
            info["unix"] = str(int(info["unix"]) + 1)
        if userinput == "7":
            info["unix"] = str(int(info["unix"]) + 3)
        if userinput == "8":
            info["unix"] = str(int(info["unix"]) - 3)
        updateVars()

        if userinput == "4":
            vars["hash"] = hashlib.md5(info["deviceid"].encode()).hexdigest()
            vars["url"] = BASE_URL + '/login'+ '/'+ vars["encryptedPayload"] +'/' + vars["hash"]
        if userinput == "5":
            updateHeartbeatVars()
            testHeartbeat()
            pass
        if userinput != "5":
            print(vars["key"])
            testConnection()

    else:
        time.sleep(1)
        info["unix"] = str(round(time.time()) + vars["desync"])
        updateVars()
        testConnection()
        time.sleep(1)
        info["unix"] = str(round(time.time()) + vars["desync"])
        updateHeartbeatVars()
        testHeartbeat()
