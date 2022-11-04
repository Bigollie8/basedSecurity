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


def testConnection():
    info["unix"] = str(round(time.time()))
    payload = info["username"] + ":" + info["vendorid"] + ":" + info["deviceid"] + ":" + info["unix"] + ":" + info["plaintext"]
    key = int(str(round(time.time()))[9]) + 3
    encryptedPayload = Cipher.encrypt(payload,key)
    hash = hashlib.md5(encryptedPayload.encode()).hexdigest()
    url = "http://127.0.0.1:5000" + '/login'+ '/'+ encryptedPayload +'/' + hash
    print(url)
    textResponse = requests.get(url)
    responseJSON = textResponse.json()
    print("Encrypting - " + payload)
    print("Hashing - " + encryptedPayload)
    print(key)
    print(hash)
    if responseJSON['Status']:
        print("Response :" + textResponse.text)
        print("Success")
    else:
        print("Failed to connect")

    print("-_"*40)

while True:
    #userinput = input("Press ENTER to test backend(type Q to quit) : ")
    #if userinput != "q" and userinput != "Q":
    #    testConnection()
    #else:
    #    break
    time.sleep(3)
    testConnection()