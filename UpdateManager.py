from multiprocessing import parent_process
import sys
import os
from git import Repo
from git import Git
import shutil
import datetime 


def constructPath():
    rawDate = datetime.datetime.now()
    if rawDate.hour > 12:
        hour = str(rawDate.hour - 12)
        suffix = "pm"
    else:
        hour = str(rawDate.hour)
        suffix = "am"

    timestamp = str(rawDate.year) + "-" + str(rawDate.month) + "-" + str(rawDate.day)  + " " + hour  + "-" + str(rawDate.minute)  + "-" + str(rawDate.second) + suffix
    parent = r'C:/Users/bigol/Desktop/Update Manager/root'
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


def verify():
    # This function is intented to give the user a chance to exit if 
    # they have not completed all the steps needed to push the update
    text = input("Press enter to continue, or type quit to exit : ")

    if len(text) > 0: 
        print("Exiting program")
        return False

    return True

def githubRepo():
    file = os.path.join(os.getcwd(), 'id_rsa.key')
    git_ssh_cmd = 'ssh -i %s' % file
    Repo.clone_from("https://github.com/Bigollie8/basedSecurity", path,env=dict(GIT_SSH_COMMAND=git_ssh_cmd))
    print("File saved to : " + path)
    print("Cloned")



def updateFiles():
    # This function will take the local save of the security and 
    # push the update to the cpanel. This will keep us accountable
    # to our github commit and gives a more orginized feeling to 
    # pushing updates 
    list_of_files = []

    for root, dirs, files in os.walk(path):
        for file in files:
            list_of_files.append(os.path.join(root,file))
    for name in list_of_files:
        if "\.git" not in name:
            print(name)
    print("Done")

def cleanup():
    try:
        shutil.rmtree(path)
    except OSError as e:
        print ("Error: %s - %s." % (e.filename, e.strerror))

def driver():
    for x in range(5): startupText()
    verify()
    updateFiles()
    githubRepo()
    input("Deleting files press enter!")
    cleanup()


driver()