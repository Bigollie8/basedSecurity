from flask import Flask
from flask import request
from discord_webhook import DiscordWebhook, DiscordEmbed
import cipher
import time
import hashlib
import mysql_utils

database = mysql_utils.mysql()

app = Flask(__name__)

# General information that will be used to store user data
info = {    
    "username" : "NULL",
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
    "heartbeatFailWebook" : DiscordWebhook(url='https://discord.com/api/webhooks/991387394228097114/SrNPjcrV8UXnhSCXRO1BZHrkxqQqZsMS8574kVTnbeAruP39LD4bOrTAryGUkwPyMSEi'),
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

def sendWebhook(url,status,hash,payload,name,type):
    # This function sends a webhook to a discord server giving the status of there login

    embed = DiscordEmbed(title="Login Attempt build 30", description=status + " - " + vars["reason"],color='03b2f8')
    embed.add_embed_field(name='Name', value=name)
    embed.add_embed_field(name='Hash', value=hash)
    embed.add_embed_field(name='Payload', value=payload)
    embed.add_embed_field(name='Expected Hash', value=vars[type + "expectedHash"])
    embed.add_embed_field(name='Expected Payload', value=vars[type + "expectedEncrypt"])
    embed.add_embed_field(name='Key', value=vars["key"])
    url.add_embed(embed)
    url.execute(remove_embeds=True)


def updateUserInfo(payload,type):
    # This function takes the users payload, decrypts it and then proceeds to split it up
    # by a :. It then takes this information to search the database and see if we have a
    # user that is registered with that name, if so it returns the expected device id and
    # vendor id. If not it returns false. 

    global table 

    try:
        decrypted = cipher.decrypt(payload,vars[type + "key"])
        table = decrypted.split(":")
    except ValueError:
        sendWebhook(vars["FailWebook"],"Fail","",payload,str((int(str(round(time.time()))[9]) + 1)),"")
        table = ["28 - Failed to decrypt with key : " + str(vars[type + "key"]) + "And payload " + payload]
        return False

    info["username"] = table[0]
    
    try:
        userInfo = database.get_user(info["username"])
        info["deviceid"] = str(userInfo[5])
        info["vendorid"] = str(userInfo[4])
    except ValueError:
        table = ["Username not found inside of database or unable to establish connection"]
        raise TypeError("Username not found inside of database or unable to establish connection")

    return True


def updateVars(payload,type):
    # This function takes the most recent information passed and updates related variables used to 
    # secure the connection to the server.

    vars[type + "key"] = int(str(round(time.time()))[9]) + 1 # Add one so it can never be zero
    if not updateUserInfo(payload,type):
        vars["reason"] = "User not Found - " + table[0]
        return False
    info["unix"] = str(round(time.time()) - 2)
    vars[type + "expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"]
    vars[type + "expectedEncrypt"] = cipher.encrypt(vars[type + "expectedPayload"],vars[type + "key"])
    vars[type + "expectedHash"] = hashlib.md5((vars[type + "expectedEncrypt"] + info["plaintext"]).encode()).hexdigest()
    return True

def updateVerify(payload,type):
    # This is used to update user expected variables right when you 
    # initiate connection

    verifyVars["expectedLength"] = len(vars[type + "expectedPayload"])
    try: 
        verifyVars["decryptPayload"] = [cipher.decrypt(payload,vars[type + "key"]),cipher.decrypt(payload,vars[type + "key"] - 1),cipher.decrypt(payload,vars[type + "key"] + 1),cipher.decrypt(payload,vars[type + "key"] - 2),cipher.decrypt(payload,vars[type + "key"] + 2)]
    except:
        verifyVars["decryptPayload"] = [cipher.decrypt(payload,vars[type + "key"])]


    verifyVars["differance"] = abs(int(table[3]) - int(info["unix"]))

def unixAdjustment(type):
    # This function is used to adjust the expected variables when there is a differenace 
    # in unix less than 1.

    vars[type + "expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" + str(int(info["unix"]) + abs(int(table[3]) - int(info["unix"])))
    vars[type + "expectedEncrypt"] = cipher.encrypt(vars[type + "expectedPayload"],vars[type + "key"])
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

        if abs(verifyVars["differance"]) > 1:
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
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            sendWebhook(vars["SuccessWebhook"],"Success",creds,payload,info["username"],"")
            return {"Status" : True,"URL":creds,"payload":cipher.decrypt(payload,vars["key"])}
        else:
            tracking["fail"] += 1
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            sendWebhook(vars["FailWebook"],"Fail",creds,payload,info["username"],"")
            return {"Status" : False}
    else:
        sendWebhook(vars["FailWebook"],"Improper Request",creds,payload,info["username"],"")
        return {"Status": False}

@app.route(vars["heartbeatURL"],methods = ['POST','GET'])
def heartbeat(payload,creds):
    if request.method == 'GET':
        if verify(payload,creds,"heartbeat"):
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            tracking["heartbeat"] += 1
            return {"Status" : True, "Type" : "Heartbeat"},303
        else:
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            tracking["fail"] += 1
            print("Failed verification - " + vars["reason"])
            sendWebhook(vars["heartbeatFailWebook"],"Fail",creds,payload,info["username"],"heartbeat")

            return{"Status" : False, "Type" : "Heartbeat"}
    else:
        print("Incorrect request format")
        return {"Status": False, "Type" : "Heartbeat"}

if __name__ == '__main__':
    app.run(host='0.0.0.0')

#


