import math
import random
import time
from time import sleep
from tqdm import tqdm
import os
import pyfiglet

banner = pyfiglet.figlet_format("Based Security")

os.system('clear')
print(banner)

payload = "thisismetypingareallylongmsg"
key = random.randint(2,10)

def encrypt(payload,key):
    cipher = ""

    payload_len = len(payload)
    payload_lst = list(payload)

    col = key

    row = int(math.ceil(payload_len / col))

    null =int((row*col) - payload_len)
    payload_lst.extend('_' * null)    

    matrix = [payload_lst[i: i + col]
                for i in range(0, len(payload_lst),col)]

    for _ in range(col):
        for x in range(row):
            cipher += matrix[x][_]   

    return cipher

def decrypt(payload,key):
    plaintext = ""

    k_index = 0

    payload_index = 0
    payload_len = len(payload)
    payload_lst = list(payload)

    col = key
    row = int(math.ceil(payload_len / col))

    matrix = [payload_lst[i: i + col]
                for i in range(0, len(payload_lst),col)]

    for _ in range(col):
        for r in range(row):
            try:
                matrix[r][k_index] = payload_lst[payload_index]
            except IndexError:
                print("matrix[" + str(r) + "][" + str(k_index) + "]")
                print("Error Decrypting - Index error")
                return "Failed"
            payload_index += 1
        k_index += 1

    try:
        plaintext = ''.join(sum(matrix, []))
    except TypeError:
        raise TypeError("This program cannot",
                        "handle repeating words.")
  
    null_count = plaintext.count('_')
  
    if null_count > 0:
        return plaintext[: -null_count]
  
    return plaintext


print("Verifying encryption")

for x in range(10):
    key = random.randint(2,len(payload)/2)
    encrypted = encrypt(payload,key)
    decrypted = decrypt(encrypted,key)
    if payload != decrypted:
        print("Failed check " + str(x+1) + "/10")

for i in tqdm(range(10)):
    sleep(.3)

