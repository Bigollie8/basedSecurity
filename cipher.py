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

testpayload = 'x0001' + str(round(time.time()* 7.19123))
testkey = random.randint(3,len(testpayload))

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
            matrix[r][k_index] = payload_lst[payload_index]
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

for i in tqdm(range(100)):
    sleep(.1)

for x in range(1000):
    testkey = random.randint(3,len(testpayload))
    encrypted = encrypt(testpayload,testkey)
    decrypted = decrypt(encrypted,testkey)
    if testpayload != decrypted:
        print("Failed check " + str(x+1) + "/10")

print("Done")



