import sys
import os
from ftplib import FTP
import math

# the goal of the script is going to have 3 functions
# Function 1 will be used to split the script into 2 seperate halves, this will be the obfuscated script (we can do the obfucsation manually or pass it through if you have a method to use luraph)
# Splitting string using string slicing

h1 = ""
h2 = open("half2.txt","w")
filename = "live.lua"
build = "basedSecurity"

list_of_files = []

def gatherPayloadInfo():
    info = open("string.txt","r")
    og_text = info.read()
    info.close()
    return og_text

og_text = gatherPayloadInfo()

def splitScript(string):
    n = len(string)
    if n%2 == 0:
        string1 = string[0:n//2]
        string2 = string[n//2:]
        h1 = string1
        h2.write(string2)
        return True
    else:
        string1 = string[0:(n//2+1)]
        string2 = string[(n//2+1):]
        h1 = string1
        h2.write(string2)
        return True

def generatePayload():
    payload = open(filename,"w")
    #payload.write(h1)
    payload.write(og_text)
    payload.close()
    return True

filePath = os.path.join("public_html//builds//" + build)
path = os.path.join("public_html//builds//" + build + "//" + filename)

def listFiles():
    # This function will take the local save of the security and 
    # push the update to the cpanel. This will keep us accountable
    # to our github commit and gives a more orginized feeling to 
    # pushing updates 

    for root, dirs, files in os.walk(filePath):
        for file in files:
            if "php" in file:
                print("Appending " + str(file) + " to payload")
                list_of_files.append(os.path.join(root,file))

def uploadHalf1():
    print("Done")

data = []
    
def uploadHalf2():
    ftp = FTP('162.0.228.203')
    ftp.login("baseddepartment", "+cvssATXEc@7")
    print("Connected")
    ftp.cwd(filePath)
    print("Current path is " + filePath)
    ftp.dir(data.append)
    for line in data:
        print("- " +  line)
    ftp.storlines('STOR ' + build, open(filename, 'rb'))
    print(string.format("Attempted to replace file for the build %s and the file %s",build,filename))      
    ftp.quit()


def driver():
    splitScript(og_text)
    generatePayload()
    #listFiles()
    #uploadHalf1() #this will upload where the normal lua goes now
    uploadHalf2()

driver()