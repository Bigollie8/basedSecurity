from xml.etree.ElementTree import TreeBuilder
import requests

def testConnection():
    url = requests.get("http://127.0.0.1:5000/generate")
    print("Attempting to connect to " + url.text)
    x = requests.get(url.text)
    InfoJSon = x.json()
    
    if InfoJSon['Status']:
        print("Response :" + x.text)
        print("Success")
    else:
        print("Failed to connect")

    print("-_"*40)

while True:
    userinput = input("Press ENTER to test backend(type Q to quit) : ")
    if userinput != "q" or userinput != "Q":
        testConnection()
    else:
        break