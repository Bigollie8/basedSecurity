import requests

url = requests.get("http://127.0.0.1:5000/generate")
print("Attempting to connect to " + url.text)

x = requests.get(url.text)

print("Response :" + x.text)