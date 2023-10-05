import MySQLdb

#Melly DB - host="162.0.225.59", user="lurker", passwd="Wv4H$BPBEFEvk#D7", db="lurker_based"
#AWS DB - host="34.230.223.44", user="based", passwd="q0UekP3DuEJBy9tOpXkJ", db="baseddb"

status = False

class mysql:
    def __init__(self):
        try:
            self.database = MySQLdb.connect(host="162.0.225.59", user="lurker", passwd="Wv4H$BPBEFEvk#D7", db="lurker_based")
            self.cursor = self.database.cursor()
            status = True
            print("\033[95mEstablished connection to server\033[0m")
        except:
            print("\033[91m\033[01m!WARNING! Connection to database failed\033[0m")
    
    def get_user(self, username):
        try:
            self.cursor.execute("SELECT * FROM lua_users WHERE username = %s", (username,))
            return self.cursor.fetchone()
        except:
            print("User not found")
            return False

            # query = "UPDATE key_list SET used = %s, redeemedBy = %s WHERE invite_key = %s"
            # params = (True, discord_id, invite_info['inviteKey'])
            # self.db.update_query(query, params)

    def update_user(self,username,deviceid,vendorid):
        try:
            query = "UPDATE lua_users SET DeviceID = %s, VendorID = %s WHERE username = %s"
            params = (int(deviceid), int(vendorid), username)
            self.cursor.execute(query,params)
            self.database.commit()
            print("Should have updated user : " + str(deviceid) + ", "+ str(vendorid) + ", " + username)
            return True
        except Exception as e:
            print(e)
            print("Failed to update user info")
            print("Should have updated user : " + str(deviceid) + ", "+ str(vendorid) + ", " + username)
            return False
    
    def ban_user(self,username,bans):
        return True