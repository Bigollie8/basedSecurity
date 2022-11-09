from flask import Flask
from flask import request
from discord_webhook import DiscordWebhook, DiscordEmbed
import Cipher
import time
import hashlib
import pyfiglet
import os

app = Flask(__name__)

info = {
    "username" : "Filler",
    "vendorid" : str(123),
    "deviceid" : str(123),
    "unix" : str(123),
    "plaintext" : "BasedSecurity"
}

vars = {
    "expectedPayload" : str(info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"]),
    "key" : 1,
    "expectedEncrypt" : "",
    "expectedHash" : "",
    "reason" : "",
    "loginURL" :'/login/<payload>/<creds>',
    "heartbeatexpectedPayload" : str(info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"]),
    "heartbeatkey" : 1,
    "heartbeatexpectedEncrypt" : "",
    "heartbeatexpectedHash" : "",
    "heartbeatURL" : '/heartbeat/<payload>/<creds>',

    "FailWebook" : DiscordWebhook(url='https://discord.com/api/webhooks/970590193260310558/oZwVN0FrgFYGez66lMtIQIfDBN1TVFUw45AhbFjuQZV9WYT7WOFgHJ9oninI8tMTke00'),
    "SuccessWebhook" : DiscordWebhook(url='https://discord.com/api/webhooks/970590028457734215/Jmuq-3QwbHbPdXj2eNegf9zna2s8TVULQYQCWmtuPk0cvK2WJcgZ8ffi1jxenL2r3yPU')
}

banner = pyfiglet.figlet_format("Based Security")

verifyVars = {
    "expectedLength" : 0,
    "decryptPayload" : "",
}

tracking = {
    "success" : 0,
    "fail" : 0,
    "total" : 0,
    "heartbeat" : 0
}

def sendWebhook(url,status,hash,payload,name):
    embed = DiscordEmbed(title="Login Attempt", description=status + " - " + vars["reason"],color='03b2f8')
    embed.add_embed_field(name='Name', value=name)
    embed.add_embed_field(name='Hash', value=hash)
    embed.add_embed_field(name='Payload', value=payload)
    embed.add_embed_field(name='Expected Hash', value=vars["expectedHash"])
    embed.add_embed_field(name='Expected Payload', value=vars["expectedEncrypt"])
    url.add_embed(embed)
    url.execute(remove_embeds=True)

def updateUserInfo(payload,type):
    global table
    decrypted = Cipher.decrypt(payload,vars[type + "key"])
    try:
        if decrypted == None:
            return False
        table = decrypted.split(":")
    except ValueError:
        print("Invalid Payload")
        return False

    info["username"] = table[0]
    var = True
    #Search databse for info and update it accordingly
    if not var:
        #If user is not found return false
        return False
    #Updated user info with matched data from database
    info["deviceid"] = str(1739)
    info["vendorid"] = str(3021)
    return True

def updateVars(payload,type):
    vars[type + "key"] = int(str(round(time.time()))[9]) + 3
    if not updateUserInfo(payload,type):
        print("Failed to update user info")
        return False
    info["unix"] = str(round(time.time())) 
    vars[type + "expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"]
    vars[type + "expectedEncrypt"] = Cipher.encrypt(vars[type + "expectedPayload"],vars[type + "key"])
    vars[type + "expectedHash"] = hashlib.md5((vars[type + "expectedEncrypt"] + info["plaintext"]).encode()).hexdigest()
    return True

def verify(payload,creds,type):
    tracking["total"] += 1
    if updateVars(payload,type):
        verifyVars["expectedLength"] = 0
        verifyVars["decryptPayload"] = Cipher.decrypt(payload,vars[type + "key"])

        if table[1] != info["vendorid"]:
            vars["reason"] = "Invalid VendorId"
            return False
        if table[2] != info["deviceid"]:
            vars["reason"] = "Invalid DeviceID"
            return False
        if table[3] != info["unix"]:
            vars["reason"] = "Unix mismatch " + str(int(info["unix"]) - int(table[3]))
            return False
        if vars[type + "expectedEncrypt"] != payload:
            vars["reason"] = "Improper Encrypt"
            return False
        if vars[type + "expectedPayload"] != verifyVars["decryptPayload"]:
            vars["reason"] = "Mismatched Payload"
            return False
        if creds != vars[type + "expectedHash"]:
            vars[type + "reason"] = "Mismatched Hash"
            return False
        if len(verifyVars["decryptPayload"]) == verifyVars["expectedLength"]:
            vars["reason"] = "Improper payload length"
            return False
        if table[3] != info["unix"]:
            vars["reason"] = "Invalid Unix"
            return False
        vars["reason"] = ""
        return True

UP = "\x1B[6A"
CLR = "\x1B[0K"
print("\n\n")  # set up blank lines so cursor moves work


@app.route('/')
def index():
    return 'BasedSecurity.inc!'

@app.route(vars["loginURL"],methods = ['POST','GET'])
def login(payload,creds):
    if request.method == 'GET':
        if verify(payload,creds,""):
            tracking["success"] += 1
            print(f"{UP}Connection Tracking: \nSuccess = {tracking['success']}{CLR}\nHeartbeat = {tracking['heartbeat']}{CLR}\nFail = {tracking['fail']}{CLR}\nTotal = {tracking['total']}",end="\r",flush = True)
            #sendWebhook(vars["SuccessWebhook"],"Success",creds,payload,info["username"])
            return {"Status" : True,"URL":creds,"payload":Cipher.decrypt(payload,vars["key"])}
        else:
            tracking["fail"] += 1
            print(f"{UP}Connection Tracking: \nSuccess = {tracking['success']}{CLR}\nHeartbeat = {tracking['heartbeat']}{CLR}\nFail = {tracking['fail']}{CLR}\nTotal = {tracking['total']}",end="\r")
            sendWebhook(vars["FailWebook"],"Fail",creds,payload,info["username"])
            return {"Status" : False,creds:vars["expectedHash"]}
    else:
        sendWebhook(vars["FailWebook"],"Improper Request",creds,payload,info["username"])
        return {"Status": False}

@app.route(vars["heartbeatURL"],methods = ['POST','GET'])
def heartbeat(payload,creds):
    if request.method == 'GET':
        if verify(payload,creds,"heartbeat"):
            tracking["heartbeat"] += 1
            return {"Status" : True, "Type" : "Heartbeat"},303
        else:
            tracking["fail"] += 1
            print("Failed verification - " + vars["reason"])
            return{"Status" : False, "Type" : "Heartbeat"}
    else:
        print("Incorrect request format")
        return {"Status": False, "Type" : "Heartbeat"}

if __name__ == '__main__':
    app.run()





