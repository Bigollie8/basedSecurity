import sys
import os
from github import Github

g = github("username","password")
repos = g.get_user().get_repos()

path = "C:/Users/bigol/repos/basedSecurity"

def startupText():
    # This function is used to alert the users of the steps they need
    # to take to ensure they update the website properly. It is colored
    # red to stand out more to the user
    sys.stdout.write("\033[;1m")
    sys.stdout.write("\033[1;31m")
    print("# WARNING, make sure you are on the master branch and have the most recent files #")
    sys.stdout.write("\033[0;0m")


def verify():
    # This function is intented to give the user a chance to exit if 
    # they have not completed all the steps needed to push the update
    text = input("Press enter to continue, or type quit to exit : ")

    if len(text) > 0: 
        print("Exiting program")
        return False

    return True

def downloadGithub():
    # This function is going to be used to download the most recent files from
    # github. 
    print("Done")


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


startupText()
verify()
updateFiles()