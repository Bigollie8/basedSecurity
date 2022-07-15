from multiprocessing import parent_process
import sys
import os
from turtle import update
from git import Repo
import git
import shutil
import datetime 
from ftplib import FTP

def constructPath():
    # This function is used to construct a folder path used to store
    # the files from github

    rawDate = datetime.datetime.now()
    if rawDate.hour > 12:
        hour = str(rawDate.hour - 12)
        suffix = "pm"
    else:
        hour = str(rawDate.hour)
        suffix = "am"

    timestamp = str(rawDate.year) + "-" + str(rawDate.month) + "-" + str(rawDate.day)  + " " + hour  + "-" + str(rawDate.minute)  + "-" + str(rawDate.second) + suffix
    parent = r'C:\Users\bigol\Desktop\Update Manager\root'
    return os.path.join(parent, timestamp)
    
path = constructPath()

def startupText():
    # This function is used to alert the users of the steps they need
    # to take to ensure they update the website properly. It is colored
    # red to stand out more to the user

    sys.stdout.write("\033[;1m")
    sys.stdout.write("\033[1;31m")
    print("# WARNING # You are about to push an update to the servers # WARNING #")
    sys.stdout.write("\033[0;0m")


def pause():
    # This function is intented to give the user a chance to exit if 
    # they have not completed all the steps needed to push the update

    text = input("Press enter to continue, or type quit to exit : ")

    if len(text) > 0: 
        print("Exiting program")
        return False

    return True

list_of_files = []



def githubRepo():
    # This function pulls the files from our github when you intiate the 
    # code. This way we have the most recent files to upload to the backend
    # automatically

    file = os.path.join(os.getcwd(), 'id_rsa.key')
    git_ssh_cmd = 'ssh -i %s' % file
    Repo.clone_from("https://github.com/Bigollie8/basedSecurity", path,env=dict(GIT_SSH_COMMAND=git_ssh_cmd))
    print("File saved to : " + path)
    listFiles()

def cleanup():
    # This function removes all of the files from the folder but 
    # keeps the folder to keep track of the dates we update the
    # backend scripts

    input("Deleting files press enter!")

    try:
        shutil.rmtree(path)
    except OSError as e:
        print ("Error: %s - %s." % (e.filename, e.strerror))

def verifyConnection():
    # This function is used to ensure that we
    # are able to connect to the server
    try: 
        ftp = FTP('162.0.228.203')
        ftp.login("baseddepartment", "+cvssATXEc@7")
        ftp.cwd('public_html')
        ftp.retrlines('LIST')
    except Exception as e:
        print(str(e))
        return False
    finally:
        ftp.quit()
    return True

def checkFile(file):
    if "backend" not in file: return False
    if "php" not in file: return False
    if "lua" in file: return False

    return True

def listFiles():
    # This function will take the local save of the security and 
    # push the update to the cpanel. This will keep us accountable
    # to our github commit and gives a more orginized feeling to 
    # pushing updates 

    for root, dirs, files in os.walk(path):
        for file in files:
            if "php" in file:
                print("Appending " + str(file) + " to payload")
                list_of_files.append(os.path.join(root,file))

def updateFiles(files):
    ftp = FTP('162.0.228.203')
    ftp.login("baseddepartment", "+cvssATXEc@7")
    ftp.cwd('public_html')
    for x in files:
        if checkFile(x):
            serverPath = os.path.join("public_html",x.replace(path + r"\backend",""))
            print("Overwriting " + serverPath.replace("\\",""))
            ftp.storlines('STOR ' + serverPath.replace("\\",""), open(x, 'rb'))
    ftp.quit()

def driver():
    for x in range(5): startupText()
    if not pause(): return
    listFiles()
    githubRepo()
    if not verifyConnection(): return
    updateFiles(list_of_files)
    cleanup()
    print("Finished")

driver()