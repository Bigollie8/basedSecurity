import math
import random
import time
from time import sleep
import os
import pyfiglet

#Draws the logo in the console 
banner = pyfiglet.figlet_format("BasedSecurity", font = "slant")
os.system('clear')
print('\033[96m')
print(banner)
print("\033[95m\033[4mDeveloped by bigollie8 " + u"\U0001F512")
print("\033[0m\n")

testpayload = ""
testkey = ""

def encrypt(payload,key):
    cipher = ""

    payload_len = len(payload)
    payload_lst = list(payload)

    col = key

    if col == 0:
        return False

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

    if payload_len == 0:
        print("Invalid Payload")
        return False
    
    try:
        col = key
        row = int(math.ceil(payload_len / col))
        matrix = [payload_lst[i: i + col]
                for i in range(0, len(payload_lst),col)]
    except:
        return False

    for _ in range(col):
        for r in range(row):
            try:
                matrix[r][k_index] = payload_lst[payload_index]
            except IndexError:
                return False
            payload_index += 1
        k_index += 1

    try:
        plaintext = ''.join(sum(matrix, []))
    except TypeError:
        print("Unable to construct payload")
        return False

    null_count = plaintext.count('_')

    if null_count > 0:
        return plaintext[: -null_count]
    return plaintext

datas = [1,2,3,4,5,6,7,8,9,10]

for x in datas:
    # This is intended to verify the integrity of the encryption and 
    # ensure that there should be no issue with the cipher
    data = datas.pop(0)
    sleep(random.random()/2)
    testpayload = 'x0011' + str(round(time.time()* random.randint(1,19)))
    testkey = random.randint(3,len(testpayload))
    encrypted = encrypt(testpayload,testkey)
    decrypted = decrypt(encrypted,testkey)
    if testpayload != decrypted:
        print("\033[91m\033[01m!WARNING! Encryption failed!")
        break
    print("\033[96m Encryption Verifed : \033[0m" + encrypted + "-->" + decrypted + "\n")
    


