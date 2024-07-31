import MySQLdb

#Melly DB - host="162.0.225.59", user="lurker", passwd="Wv4H$BPBEFEvk#D7", db="lurker_based"
#AWS DB - 

status = False

class mysql:
    def __init__(self):
        print("Starting")
        self.database = None
        self.cursor = None
    
    def connect(self):
        try:
            self.database = MySQLdb.connect(host="34.230.223.44", user="based", passwd="q0UekP3DuEJBy9tOpXkJ", db="baseddb")
            self.cursor = self.database.cursor()
            print("\033[95mEstablished connection to server\033[0m")
        except:
            print("\033[91m\033[01m!WARNING! Connection to database failed\033[0m")

    def disconnect(self):
        if self.database:
            self.database.close()

    def updateIP(self, username, ip):
        try:
            query = "UPDATE lua_users SET ip = %s WHERE username = %s" 
            params = (ip,username)
            self.cursor.execute(query,params)
            self.database.commit()
            return True
        except MySQLdb.Error as e:
            print(e)
            print("Failed to update IP")
            return False

    def get_user(self, username):
        try:
            self.cursor.execute("SELECT * FROM lua_users WHERE username = %s", (username,))
            return self.cursor.fetchone()
        except Exception as e:
            print("User not found: " + str(e))
            return False

    def update_user(self,username,deviceid,vendorid):
        try:
            query = "UPDATE lua_users SET DeviceID = %s, VendorID = %s WHERE username = %s"
            params = (int(deviceid), int(vendorid), username)
            self.cursor.execute(query,params)
            self.database.commit()
            return True
        except Exception as e:
            print(e)
            print("Failed to update user info")
            return False

    def total_connections(self,username):
        try:
            query = "SELECT TotalConnections FROM lua_users WHERE username = %s"
            params = (username,)
            self.cursor.execute(query,params)
            return self.cursor.fetchone()
        except:
            print("Failed to get Failed connections status")
            return False

    def update_connections(self,username,total):
        try:
            query = "UPDATE lua_users SET TotalConnections = %s WHERE username = %s" 
            newTotal = total[0] + 1
            params = (newTotal,username,)
            self.cursor.execute(query,params)
            self.database.commit()
            return True
        except Exception as e:
            print(e)
            print("Failed to updated total Loads")
            return False
        
    def ban_status(self,username):
        try:
            query = "SELECT banned FROM lua_users WHERE username = %s"
            params = (username,)
            self.cursor.execute(query,params)
            return self.cursor.fetchone()
        except Exception as e:
            print(e)
            print("Failed to get ban status")
            return False
        
    def failed_connections(self,username):
        try:
            query = "SELECT failedConnections FROM lua_users WHERE username = %s"
            params = (username,)
            self.cursor.execute(query,params)
            return self.cursor.fetchone()
        except:
            print("Failed to get Failed connections status")
            return False
        
    def update_failed_connections(self,username,bans):
        try:
            query = "UPDATE lua_users SET failedConnections = %s WHERE username = %s"
            bans += 1
            params = (bans,username,)
            self.cursor.execute(query,params)
            self.database.commit()
            return bans
        except:
            print("Failed to update failed attempts")
            return False
        
    def ban_user(self,username):
        try:
            query = "UPDATE lua_users SET banned = 1 WHERE username = %s"
            params = (username,)
            self.cursor.execute(query,params)
            self.database.commit()
            return True
        except:
            print("Failed to ban user")
            return False

