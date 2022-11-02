import requests



for x in range(3):
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
