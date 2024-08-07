from flask import Flask, request, render_template, redirect, url_for, make_response
from discord_webhook import DiscordWebhook, DiscordEmbed
import cipher
import time
import hashlib
import mysql_utils
from pathlib import Path
import sentry_sdk

sentry_sdk.init(
    dsn="https://41492d979138c903702bfdc45f335cff@o4507728101048320.ingest.us.sentry.io/4507728105242624",
    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    traces_sample_rate=1.0,
    # Set profiles_sample_rate to 1.0 to profile 100%
    # of sampled transactions.
    # We recommend adjusting this value in production.
    profiles_sample_rate=1.0,
)


print("Starting Backend!")

database = mysql_utils.mysql()

app = Flask(__name__,template_folder=Path(__file__).parent / 'templates',static_folder=Path(__file__).parent / 'static')

# General information that will be used to store user data
info = {
    "username" : "NULL",
    "vendorid" : "NULL",
    "deviceid" : "NULL",
    "passedUNIX" : "Null",
    "unix" : "NULL",
    "password" : "NULL",
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
    "SuccessWebhook" : DiscordWebhook(url='https://discord.com/api/webhooks/970590028457734215/Jmuq-3QwbHbPdXj2eNegf9zna2s8TVULQYQCWmtuPk0cvK2WJcgZ8ffi1jxenL2r3yPU'),
    "websiteLogin" : DiscordWebhook(url='https://discord.com/api/webhooks/1269163565689081916/W6kCMKLcL4csEd82-QjwKGmSH19iV_WINAnNHBDG5ISa3lBOKzekSvhOIQE8e7lEvETW'),
    "location" : "http://basedSecurity.net/"
}

# "Location" : "http://localhost:5000/"
# "Location" : "http://basedSecurity.net/"


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
    embed = DiscordEmbed(title="Login Attempt - Version 2.0", description= status + " - " + vars["reason"],color='03b2f8')
    embed.set_author(name="BasedSecurity",icon_url ="https://cdn.discordapp.com/attachments/1097943477754527836/1164934299666104452/4fb7a80e-204f-4fb9-8675-509d4fbcb862.jpeg?ex=6545049c&is=65328f9c&hm=0efc1fb515bbb4e08fa56832054799e416740330d574b2ed34affa4cab0eb198&")
    embed.add_embed_field(name='Name', value=name)
    embed.add_embed_field(name='Hash', value=hash)
    embed.add_embed_field(name='Payload', value=payload)
    embed.add_embed_field(name='Expected Hash', value=vars[type + "expectedHash"])
    embed.add_embed_field(name='Expected Payload', value=vars[type + "expectedEncrypt"])
    embed.add_embed_field(name="desync", value=verifyVars["differance"])
    embed.set_footer(text="User Agent - " + str(userAgent))

    url.add_embed(embed)
    url.execute(remove_embeds=True)
    
def sendWebhookWebsite(url,status,name,role,endpoint):
    # This function sends a webhook to a discord server giving the status of there login
    embed = DiscordEmbed(title="Website Login - Version 2.0",color='03b2f8')
    embed.set_author(name="BasedSecurity",icon_url ="https://cdn.discordapp.com/attachments/1097943477754527836/1164934299666104452/4fb7a80e-204f-4fb9-8675-509d4fbcb862.jpeg?ex=6545049c&is=65328f9c&hm=0efc1fb515bbb4e08fa56832054799e416740330d574b2ed34affa4cab0eb198&")
    embed.add_embed_field(name='Name', value=name)
    embed.add_embed_field(name='Role', value=role)
    embed.add_embed_field(name='Endpoint', value=endpoint)


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
    print(str(userInfo))
    info["deviceid"] = str(userInfo[5])
    info["vendorid"] = str(userInfo[4])
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
    try:
        if database.failed_connections(info["username"])[0] > 3:
            database.ban_user(info["username"])
            return True
        else:
            return False
    except Exception as e:
        print("Failed to get failed connection attempts" + str(e))

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
            vars["reason"] = "User is failedconnection"
            return False

        if ban_check():
            vars["reason"] = "Too many failed attemts, user banned"
            return False

        if returnDic["response"][1] != info["vendorid"]: #may not be right
            print(info)
            print(returnDic["response"][1] + " - " + info["vendorid"])
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

        # if len(verifyVars["decryptPayload"][0]) != verifyVars["expectedLength"]:
        #     vars["reason"] = "Improper payload length " + str(verifyVars["expectedLength"]) + " " + str(len(verifyVars["decryptPayload"][0]))
        #     return False

        vars["reason"] = "Success"
        return True
    else:
        return False

UP = "\x1B[7A"
CLR = "\x1B[0K"

def cookie_encrypt(username,cookie):
    encrypted = cipher.encrypt(hashlib.md5(cookie.encode()).hexdigest(),3)
    database.update_cookie(username,encrypted)
    return encrypted

def cookie_decrypt(cookie):
    decrypted = cipher.decrypt(cookie,3)
    return decrypted


def template_choice():
    return render_template('adminPrompt.html')

@app.route('/')
def index():#This will be used for logging and allow us to blacklist ip, this may not work
    return render_template('home.html')

@app.route('/logout')
def logout():
    response = make_response(redirect('/signin', 302))
    response.set_cookie('username', '', expires=0)
    response.set_cookie('based', '', expires=0)
    return response



@app.route('/get_cookie', methods=['GET'])
def get_cookie():
    database.connect()
    cookie_value = request.cookies.get("based")
    database.disconnect()
    print(cookie_value)
    return cookie_decrypt(cookie_value)


@app.route('/signin', methods=['GET', 'POST'])
def signin():#This will be used for logging and allow us to blacklist ip, this may not work
    error = None
    try:
        print("Attempting to connect to database")
        database.connect()
    except:
        print("Connection Failed")

    if request.method == 'POST':
        try:
            if not database.get_user(request.form['username']):
                error = 'Invalid Credentials. Please try again.'
            elif request.form['password'] != database.get_password(request.form['username'])[0]:
                error = 'Invalid Credentials. Please try again.'
            elif database.ban_status(request.form['username'])[0] != 0:
                error = 'User is banned. Please contact support.'
            elif database.user_role(request.form['username'])[0] == "User":
                print("Trying to render Admin panel")
                sendWebhookWebsite(vars["websiteLogin"],"Success",request.form['username'],"Admin",vars['location'])
                cookie =  cookie_encrypt(info['username'],"BasedCookie89745326487632498765928376")
                info['username'] = request.form['username']
                database.update_cookie(info['username'],cookie)
                totalConnectionsDB()
                database.disconnect()

                #update cookie info
                response = make_response(redirect('/user', 302))
                response.set_cookie("based",cookie)
                response.set_cookie("username",info['username'])
                return response
            
            elif database.user_role(request.form['username'])[0] == "Admin":
                print("Trying to render Admin panel")
                sendWebhookWebsite(vars["websiteLogin"],"Success",request.form['username'],"Admin",vars['location'])
                cookie =  cookie_encrypt(info['username'],"BasedCookie89745326487632498765928376")
                info['username'] = request.form['username']
                database.update_cookie(info['username'],cookie)
                totalConnectionsDB()
                database.disconnect()

                #update cookie info
                response = make_response(redirect('/admin', 302))
                response.set_cookie("based",cookie)
                response.set_cookie("username",info['username'])
                return response

        except Exception as e:
            print(e)
            
        error = "Failed to get role"
    return render_template('signin.html')


# Route for handling the login page logic
@app.route('/admin', methods=['GET', 'POST'])
def admin():
    error = None
    try:
        print("Attempting to connect to database")
        database.connect()
        print(database.Masterkey())

    except:
        print("Connection Failed")
        error = 'Login Expired, please Login again'    
        return redirect('/signin', 302)
    try:
        if database.get_cookie(info['username'])[0] == request.cookies.get("based"):
            users = database.get_users()
            FFsuccessConnections = tracking["success"]
            FEheartbeat = tracking["heartbeat"]
            FEfailedConnections = tracking["fail"]
            FEtotalConections = tracking["total"]
            FEaverage = round(((FFsuccessConnections + FEheartbeat) / (FEtotalConections + .0001)) * 100,2)
            database.disconnect()
            return render_template('admin.html', users=users,  error=error, username=info['username'], average=FEaverage, successConnections =FFsuccessConnections, heartbeat=FEheartbeat, failedConnections=FEfailedConnections, totalConnections = FEtotalConections)
        else:
            error = "Login Expired, please Login again"
            print(error)
            database.disconnect()
            print("Permissions not found")
            return redirect('/home', 302)

    except Exception as e:
        print("Cant display Admin Panel")
        print(e)
        error = "Failed to get role"
        database.disconnect()
        return redirect('/home', 302)
    
    return redirect('/home', 302)

@app.route('/user')
def user():
    try:
        print("Attempting to connect to database")
        database.connect()
    except:
        print("Connection Failed")
    try:
        if database.get_cookie(info['username'])[0] == request.cookies.get("based"):
            perms = database.user_role(info['username'])
            print(perms)
            database.disconnect()
            return render_template('users.html', username=info['username'], perms=perms[0])
        else:
            print("Permissions not found")
            database.disconnect()
            return redirect('/home', 302)
    except Exception as e:
        print("Cant display User Panel")
        print(e)
        database.disconnect()
        return redirect('/home', 302)


@app.route('/home')
def home():#This will be used for logging and allow us to blacklist ip, this may not work
    try:
        print("Attempting to connect to database")
        database.connect()
        perms = database.user_role(request.cookies.get("username"))
        print("User found with the role : " + perms[0])
        return render_template('home.html', perms=perms[0])

    except:
        perms = ["Visitor"]
        print("Connection Failed")

    

    return render_template('home.html')

@app.route('/sentry-debug')
def sentry():
    1/0  # raises an error
    return "<p>Hello, World!</p>"

@app.route('/about')
def about():#This will be used for logging and allow us to blacklist ip, this may not work
    try:

        print("Attempting to connect to database")
        database.connect()
        perms = database.user_role(request.cookies.get("username"))
        print("User found with the role : " + perms[0])
        return render_template('about.html', perms=perms[0])
    except:
        perms = ["Visitor"]
        print("Connection Failed")

    return render_template('about.html', perms=perms[0])

print('\n')

@app.route(vars["loginURL"],methods = ['POST','GET'])
def login(payload,creds):
    try:
        print("Attempting to connect to database")
        database.connect()
    except:
        print("Connection Failed")

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
                print("Tracking Fails")
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
