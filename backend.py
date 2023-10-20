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
    "vendorid" : "NULL",
    "deviceid" : "NULL",
    "passedUNIX" : "Null",
    "unix" : "NULL",
    "plaintext" : "BasedSecurity"
}

# common variables assigned to a table.
vars = {
    "expectedPayload" : "NULL",
    "key" : 0,
    "expectedEncrypt" : "NULL",
    "expectedHash" : "NULL",
    "reason" : "NULL - Reason not updated",
    "loginURL" :'/login/<payload>/<creds>',
    "heartbeatexpectedPayload" : "NULL",
    "heartbeatkey" : 0,
    "heartbeatexpectedEncrypt" : "NULL",
    "heartbeatexpectedHash" : "NULL",
    "heartbeatURL" : '/heartbeat/<payload>/<creds>',
    "heartbeatFailWebook" : DiscordWebhook(url='https://discord.com/api/webhooks/991387394228097114/SrNPjcrV8UXnhSCXRO1BZHrkxqQqZsMS8574kVTnbeAruP39LD4bOrTAryGUkwPyMSEi'),
    "FailWebook" : DiscordWebhook(url='https://discord.com/api/webhooks/970590193260310558/oZwVN0FrgFYGez66lMtIQIfDBN1TVFUw45AhbFjuQZV9WYT7WOFgHJ9oninI8tMTke00'),
    "SuccessWebhook" : DiscordWebhook(url='https://discord.com/api/webhooks/970590028457734215/Jmuq-3QwbHbPdXj2eNegf9zna2s8TVULQYQCWmtuPk0cvK2WJcgZ8ffi1jxenL2r3yPU')
}

# This table is used to store information used to verify user
verifyVars = {
    "expectedLength" : 0,
    "decryptPayload" : "NULL",
    "differance" : 0
}

# This table tracks the stats of the backend
tracking = {
    "success" : 0,
    "heartbeat" : 0,
    "fail" : 0,
    "total" : 0
}

returnDic = {
    "reason" : "No reason given",
    "response" : "NULL"
}

def sendWebhook(url,status,name,hash,payload,type,userAgent):
    # This function sends a webhook to a discord server giving the status of there login

    embed = DiscordEmbed(title="Login Attempt - Version 1.92", description= status + " - " + vars["reason"],color='03b2f8')
    embed.add_embed_field(name='Name', value=name)
    embed.add_embed_field(name='Hash', value=hash)
    embed.add_embed_field(name='Payload', value=payload)
    embed.add_embed_field(name='Expected Hash', value=vars[type + "expectedHash"])
    embed.add_embed_field(name='Expected Payload', value=vars[type + "expectedEncrypt"])
    embed.add_embed_field(name="desync", value=verifyVars["differance"])
    embed.add_embed_field(name="Server Key", value=vars[type + "key"])
    embed.add_embed_field(name="User Agent", value=userAgent)
    url.add_embed(embed)
    url.execute(remove_embeds=True)

def endpoint():
    user_agent = request.headers.get("user-agent")
    return user_agent

def registerUser(username):
    #This function will be used when the user has not registered
    if info["deviceid"] == "None" or info["vendorid"] == "None":
        print("Updating user info")
        database.update_user(username,returnDic["response"][2],returnDic["response"][1])
        return True

def databaseQuery(username):
    userInfo = database.get_user(username)
    if userInfo == None or userInfo == False:
        return False
    
    info["deviceid"] = str(userInfo[4])
    info["vendorid"] = str(userInfo[5])
    return True

def updateUserInfo(payload,type):
    # This function takes the users payload, decrypts it and then proceeds to split it up
    # by a :. It then takes this information to search the database and see if we have a
    # user that is registered with that name, if so it returns the expected device id and
    # vendor id. If not it returns false.  

    global decrypted 

    decrypted = possibleDecryptions(payload,type)
    for x in decrypted: 
        if x != False:
            x = x.split(":")
            info["username"] = x[0] #first item should be username

            if not databaseQuery(info["username"]): continue

            info["passedUNIX"] = x[3]
            returnDic["response"] = x
            
            if registerUser(info["username"]):
                if not databaseQuery(info["username"]): continue

            return True
        
    vars["reason"] = "Username not found inside of database or unable to establish connection"
    return False


def updateVars(payload,type):
    # This function takes the most recent information passed and updates related variables used to 
    # secure the connection to the server.
    info["unix"] = str(round(time.time()))

    vars[type + "key"] = int(info["unix"][9]) + 1 # Add one so it can never be zero
    
    if not updateUserInfo(payload,type):
        return False
    
    vars[type + "expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"]
    vars[type + "expectedEncrypt"] = cipher.encrypt(vars[type + "expectedPayload"],vars[type + "key"])
    vars[type + "expectedHash"] = hashlib.md5((vars[type + "expectedEncrypt"] + info["plaintext"]).encode()).hexdigest()
    verifyVars["expectedLength"] = len(vars[type + "expectedPayload"])
    verifyVars["differance"] = int(info["passedUNIX"]) - int(info["unix"])

    if abs(verifyVars["differance"]) < 3:
        print("Adjusting vars - " + str(verifyVars["differance"]))
        vars[type + "key"] = int(info["unix"][9]) + 1 + verifyVars["differance"] # Add one so it can never be zero
        
    elif abs(verifyVars["differance"]) >= 3:
        print("Adjustment is larger than 3 : " + info["passedUNIX"] + " - " + info["unix"] + "=" + str(verifyVars["differance"]))
        return False   

    while vars[type + "key"] <= 1: # A key of 1 does not apply an encryption and is bad
        print("Key should not be 1")
        vars[type + "key"] += 1     
    
    unixAdjustment(type)
    vars["reason"] = "Updated expected payload"

    #if not cipher.encrypt: return True
    return True

def possibleDecryptions(payload,type):
    # This is used to update user expected variables right when you 
    # initiate connection
    #checks for +/- dysnc of key
    return [cipher.decrypt(payload,vars[type + "key"]),cipher.decrypt(payload,vars[type + "key"] - 1),cipher.decrypt(payload,vars[type + "key"] + 1),cipher.decrypt(payload,vars[type + "key"] - 2),cipher.decrypt(payload,vars[type + "key"] + 2)]

def ban_check():
    if database.failed_connections(info["username"])[0] > 3:
        database.ban_user(info["username"])
        return True 
    else:
        return False

def unixAdjustment(type):
    # This function is used to adjust the expected variables when there is a differenace 
    # in unix less than 1.

    vars[type + "expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" + str(int(info["unix"]) + verifyVars["differance"])
    vars[type + "expectedEncrypt"] = cipher.encrypt(vars[type + "expectedPayload"],vars[type + "key"])
    vars[type + "expectedHash"] = hashlib.md5((vars[type + "expectedEncrypt"] + info["plaintext"]).encode()).hexdigest()

def totalConnectionsDB():
    total = database.total_connections(info["username"])
    database.update_connections(info["username"],total)

def verify(payload,creds,type):
    # This function takes in payload, creds, and type. It then updates variables based off of the information given.
    # If the user is found it updates the verifcation data before its checked. There then are a series of checks
    # verifying information based off of various datapoints collected/given.

    tracking["total"] += 1
    if updateVars(payload,type):

        if database.ban_status(info["username"])[0] != 0:
            vars["reason"] = "User is banned"
            return False

        if ban_check():
            vars["reason"] = "To many failed attemts, user banned"
            return False

        if returnDic["response"][1] != info["vendorid"]: #may not be right
            vars["reason"] = "Invalid VendorId"
            return False

        if returnDic["response"][2] != info["deviceid"]: #may not be right
            vars["reason"] = "Invalid DeviceID"
            return False

        if abs(verifyVars["differance"]) >= 3:
            vars["reason"] = "Unix mismatch " + str(verifyVars["differance"])
            return False

        if vars[type + "expectedPayload"] not in decrypted:
            vars["reason"] = "Mismatched Payload"
            return False

        if vars[type + "expectedEncrypt"] != payload:
            vars["reason"] = "Improper Encrypt"
            return False

        if creds != vars[type + "expectedHash"]:
            vars["reason"] = "Mismatched Hash"
            return False
            
#        if len(verifyVars["decryptPayload"][0]) != verifyVars["expectedLength"]:
#            vars["reason"] = "Improper payload length " + str(verifyVars["expectedLength"]) + " " + str(len(verifyVars["decryptPayload"][0]))
#            return False
        
        vars["reason"] = ""
        return True
    else:
        return False
    
UP = "\x1B[7A"
CLR = "\x1B[0K"

@app.route('/')
def index():#This will be used for logging and allow us to blacklist ip, this may not work
    return 'BasedSecurity.inc!'

print('\n')
@app.route(vars["loginURL"],methods = ['POST','GET'])
def login(payload,creds):
    database.connect()
    # This is the general connection link. They pass payload and creds ( the hash ) and passes them to the verify 
    # function, If true it will send a success notifcation on discord and return information given to the user. If 
    #  they fail it seends a failed webhook with the reason, it returns false 
    if request.method == 'GET':
        if verify(payload,creds,""):
            tracking["success"] += 1
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            sendWebhook(vars["SuccessWebhook"],"Success",info["username"],creds,payload,"",endpoint())
            totalConnectionsDB()
            database.update_failed_connections(info["username"],-1)
            database.updateIP(info["username"],request.environ.get('HTTP_X_FORWARDED_FOR', request.remote_addr))
            database.disconnect()
            return {"Status" : True,"URL":creds,"payload":cipher.decrypt(payload,vars["key"])}           
        else:
            tracking["fail"] += 1
            try:
                database.update_failed_connections(info["username"],database.failed_connections(info["username"])[0])
            except:
                print("Could Not update fails, user not found")
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            sendWebhook(vars["FailWebook"],"Fail",info["username"],creds,payload,"",endpoint())
            database.disconnect()
            return {"Status" : False}
    else:
        try:
            database.update_failed_connections(info["username"],database.failed_connections(info["username"])[0])
        except:
            print("Cant update fails username not captured")    
        sendWebhook(vars["FailWebook"],"Improper Request",info["username"],creds,payload,"",endpoint())
        database.disconnect()
        return {"Status": False}
    
@app.route(vars["heartbeatURL"],methods = ['POST','GET'])
def heartbeat(payload,creds):
    database.connect()
    if request.method == 'GET':
        if verify(payload,creds,"heartbeat"):
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            tracking["heartbeat"] += 1
            database.disconnect()
            return {"Status" : True, "Type" : "Heartbeat"},303
        else:
            print(f"Connection Tracking: \nSuccess = {tracking['success']}\nHeartbeat = {tracking['heartbeat']}\nFail = {tracking['fail']}\nTotal = {tracking['total']}\n",end="\r")
            tracking["fail"] += 1
            print("Failed verification - " + vars["reason"])
            sendWebhook(vars["heartbeatFailWebook"],"Fail",info["username"],creds,payload,"heartbeat",endpoint())
            database.disconnect()
            return{"Status" : False, "Type" : "Heartbeat"}
    else:
        print("Incorrect request format")
        database.disconnect()
        return {"Status": False, "Type" : "Heartbeat"}
    
if __name__ == '__main__':
    app.run(host='0.0.0.0')
