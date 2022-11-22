from flask import Flask
from flask import request
from discord_webhook import DiscordWebhook, DiscordEmbed
import Cipher
import time
import hashlib
import mysql_utils
from rich.console import Console

database = mysql_utils.mysql()

app = Flask(__name__)

# General information that will be used to store user data
info = {    
    "username" : "Filler",
    "vendorid" : str(123),
    "deviceid" : str(123),
    "unix" : str(123),
    "plaintext" : "BasedSecurity"
}

# common variables assigned to a table.
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

# This table is used to store information used to verify user
verifyVars = {
    "expectedLength" : 0,
    "decryptPayload" : "",
    "differance" : 0
}

# This table tracks the stats of the backend
tracking = {
    "success" : 0,
    "fail" : 0,
    "total" : 0,
    "heartbeat" : 0
}

def sendWebhook(url,status,hash,payload,name):
    # This function sends a webhook to a discord server giving the status of there login

    embed = DiscordEmbed(title="Login Attempt", description=status + " - " + vars["reason"],color='03b2f8')
    embed.add_embed_field(name='Name', value=name)
    embed.add_embed_field(name='Hash', value=hash)
    embed.add_embed_field(name='Payload', value=payload)
    embed.add_embed_field(name='Expected Hash', value=vars["expectedHash"])
    embed.add_embed_field(name='Expected Payload', value=vars["expectedEncrypt"])
    url.add_embed(embed)
    url.execute(remove_embeds=True)


def updateUserInfo(payload,type):
    # This function takes the users payload, decrypts it and then proceeds to split it up
    # by a :. It then takes this information to search the database and see if we have a
    # user that is registered with that name, if so it returns the expected device id and
    # vendor id. If not it returns false. 

    global table
    decrypted = Cipher.decrypt(payload,vars[type + "key"])

    try:
        if decrypted == None:
            return False
        table = decrypted.split(":")
    except ValueError:
        return False

    info["username"] = table[0]

    userInfo = database.get_user(info["username"])
    if userInfo == None:
        return False

    info["deviceid"] = str(userInfo[5])
    info["vendorid"] = str(userInfo[4])
    return True


def updateVars(payload,type):
    # This function takes the most recent information passed and updates related variables used to 
    # secure the connection to the server.

    vars[type + "key"] = int(str(round(time.time()))[9]) + 3
    if not updateUserInfo(payload,type):
        vars["reason"] = "User not Found - " + table[0]
        return False
    info["unix"] = str(round(time.time())) 
    vars[type + "expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"]
    vars[type + "expectedEncrypt"] = Cipher.encrypt(vars[type + "expectedPayload"],vars[type + "key"])
    vars[type + "expectedHash"] = hashlib.md5((vars[type + "expectedEncrypt"] + info["plaintext"]).encode()).hexdigest()
    return True

def updateVerify(payload,type):
    # This is used to update user expected variables right when you 
    # initiate connection

    verifyVars["expectedLength"] = len(vars[type + "expectedPayload"])
    verifyVars["decryptPayload"] = [Cipher.decrypt(payload,vars[type + "key"]),Cipher.decrypt(payload,vars[type + "key"] - 1),Cipher.decrypt(payload,vars[type + "key"] + 1),Cipher.decrypt(payload,vars[type + "key"] - 2),Cipher.decrypt(payload,vars[type + "key"] + 2)]
    verifyVars["differance"] = abs(int(table[3]) - int(info["unix"]))

def unixAdjustment(type):
    # This function is used to adjust the expected variables when there is a differenace 
    # in unix less than 1.

    vars[type + "expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" + str(int(info["unix"]) + abs(int(table[3]) - int(info["unix"])))
    vars[type + "expectedEncrypt"] = Cipher.encrypt(vars[type + "expectedPayload"],vars[type + "key"])
    vars[type + "expectedHash"] = hashlib.md5((vars[type + "expectedEncrypt"] + info["plaintext"]).encode()).hexdigest()

def verify(payload,creds,type):
    # This function takes in payload, creds, and type. It then updates variables based off of the information given.
    # If the user is found it updates the verifcation data before its checked. There then are a series of checks
    # verifying information based off of various datapoints collected/given.

    tracking["total"] += 1
    if updateVars(payload,type):
        updateVerify(payload,type)

        if table[1] != info["vendorid"]:
            vars["reason"] = "Invalid VendorId"
            return False

        if table[2] != info["deviceid"]:
            vars["reason"] = "Invalid DeviceID"
            return False

        if abs(verifyVars["differance"]) == 1:
            unixAdjustment(type)

        if abs(verifyVars["differance"]) >= 2:
            vars["reason"] = "Unix mismatch " + str(int(info["unix"]) - int(table[3]))
            return False

        if vars[type + "expectedPayload"] not in verifyVars["decryptPayload"]:
            vars["reason"] = "Mismatched Payload"
            return False

        if vars[type + "expectedEncrypt"] != payload:
            vars["reason"] = "Improper Encrypt"
            return False

        if creds != vars[type + "expectedHash"]:
            vars[type + "reason"] = "Mismatched Hash"
            return False
            
        if len(verifyVars["decryptPayload"][0]) != verifyVars["expectedLength"]:
            vars["reason"] = "Improper payload length " + str(verifyVars["expectedLength"]) + " " + str(len(verifyVars["decryptPayload"][0]))
            return False
        vars["reason"] = ""
        return True

UP = "\x1B[6A"
CLR = "\x1B[0K"

@app.route('/')
def index():
    return 'BasedSecurity.inc!'

print('\n')
@app.route(vars["loginURL"],methods = ['POST','GET'])
def login(payload,creds):
    # This is the general connection link. They pass payload and creds ( the hash ) and passes them to the verify 
    # function, If true it will send a success notifcation on discord and return information given to the user. If 
    #  they fail it seends a failed webhook with the reason, it returns false 
    if request.method == 'GET':
        if verify(payload,creds,""):
            tracking["success"] += 1
            print(f"{UP}Connection Tracking: \nSuccess = {tracking['success']}{CLR}\nHeartbeat = {tracking['heartbeat']}{CLR}\nFail = {tracking['fail']}{CLR}\nTotal = {tracking['total']}{CLR}\n",end="\r")
            #sendWebhook(vars["SuccessWebhook"],"Success",creds,payload,info["username"])
            return {"Status" : True,"URL":creds,"payload":Cipher.decrypt(payload,vars["key"])}
        else:
            tracking["fail"] += 1
            print(f"{UP}Connection Tracking: \nSuccess = {tracking['success']}{CLR}\nHeartbeat = {tracking['heartbeat']}{CLR}\nFail = {tracking['fail']}{CLR}\nTotal = {tracking['total']}{CLR}\n",end="\r")
            sendWebhook(vars["FailWebook"],"Fail",creds,payload,info["username"])
            return {"Status" : False}
    else:
        sendWebhook(vars["FailWebook"],"Improper Request",creds,payload,info["username"])
        return {"Status": False}

@app.route(vars["heartbeatURL"],methods = ['POST','GET'])
def heartbeat(payload,creds):
    if request.method == 'GET':
        if  (payload,creds,"heartbeat"):
            print(f"{UP}Connection Tracking: \nSuccess = {tracking['success']}{CLR}\nHeartbeat = {tracking['heartbeat']}{CLR}\nFail = {tracking['fail']}{CLR}\nTotal = {tracking['total']}{CLR}\n",end="\r")
            tracking["heartbeat"] += 1
            return {"Status" : True, "Type" : "Heartbeat"},303
        else:
            print(f"{UP}Connection Tracking: \nSuccess = {tracking['success']}{CLR}\nHeartbeat = {tracking['heartbeat']}{CLR}\nFail = {tracking['fail']}{CLR}\nTotal = {tracking['total']}{CLR}\n",end="\r")
            tracking["fail"] += 1
            print("Failed verification - " + vars["reason"])
            return{"Status" : False, "Type" : "Heartbeat"}
    else:
        print("Incorrect request format")
        return {"Status": False, "Type" : "Heartbeat"}

if __name__ == '__main__':
    app.run()
