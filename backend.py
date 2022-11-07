from turtle import color
from flask import Flask
from flask import request
from discord_webhook import DiscordWebhook, DiscordEmbed
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

tracking = {
    "success" : 0,
    "fail" : 0,
    "total" : 0,
}

FailWebook = DiscordWebhook(url='https://discord.com/api/webhooks/970590193260310558/oZwVN0FrgFYGez66lMtIQIfDBN1TVFUw45AhbFjuQZV9WYT7WOFgHJ9oninI8tMTke00')
SuccessWebhook = DiscordWebhook(url='https://discord.com/api/webhooks/970590028457734215/Jmuq-3QwbHbPdXj2eNegf9zna2s8TVULQYQCWmtuPk0cvK2WJcgZ8ffi1jxenL2r3yPU')
#successEmbed = DiscordEmbed(title='Login Attempt', description='Success', color='03b2f8')
#failEmbed = DiscordEmbed(title='Login Attempt', description='Fail', color='03b2f8')
#FailWebook.add_embed(failEmbed)
#SuccessWebhook.add_embed(successEmbed)

def sendWebhook(url,status,hash,payload,name):
    embed = DiscordEmbed(title="Login Attempt", description=status,color='03b2f8')
    embed.add_embed_field(name='Name', value=name)
    embed.add_embed_field(name='Hash', value=hash)
    embed.add_embed_field(name='Payload', value=payload)
    embed.add_embed_field(name='Expected Hash', value=vars["expectedHash"])
    embed.add_embed_field(name='Expected Payload', value=vars["expectedEncrypt"])
    url.add_embed(embed)
    url.execute(remove_embeds=True)

def updateUserInfo(payload):
    decrypted = Cipher.decrypt(payload,vars["key"])

    try:
        if decrypted == None:
            return False
        table = decrypted.split(":")
    except ValueError:
        print("Invalid Payload")
        return False

    info["username"] = table[0]
    #Search databse for info and update it accordingly
    info["vendorid"] = str(3021)
    info["deviceid"] = str(1739)

    return True

def updateVars(payload):
    vars["key"] = int(str(round(time.time()))[9]) + 3
    if not updateUserInfo(payload):
        return False
    info["unix"] = str(round(time.time()))
    vars["expectedPayload"] = info["username"] + ":" + info["vendorid"] + ":" +  info["deviceid"] + ":" +  info["unix"] + ":" +  info["plaintext"]
    vars["expectedEncrypt"] = Cipher.encrypt(vars["expectedPayload"],vars["key"])
    vars["expectedHash"] = hashlib.md5(vars["expectedEncrypt"].encode()).hexdigest()
    return True

def verify(payload,creds):
    tracking["total"] += 1
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
            tracking["success"] += 1
            print("Connection Tracking: \nSuccess = " + str(tracking["success"]) + "\nFail = " + str(tracking["fail"]) + "\nTotal = " + str(tracking["total"]))
            sendWebhook(SuccessWebhook,True,creds,payload,"name")
            return {"Status" : True,"URL":creds,"payload":Cipher.decrypt(payload,vars["key"])}
        else:
            tracking["fail"] += 1
            print("Connection Tracking: \nSuccess = " + str(tracking["success"]) + "\nFail = " + str(tracking["fail"]) + "\nTotal = " + str(tracking["total"]))
            sendWebhook(FailWebook,False,creds,payload,"name")
            return {"Status" : False,creds:vars["expectedHash"]}
    else:
        print("False")
        sendWebhook(FailWebook,False,creds,payload,"name")
        return {"Status": False}


if __name__ == '__main__':
    app.run()

