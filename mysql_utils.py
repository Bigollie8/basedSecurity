import MySQLdb

class mysql:
    def __init__(self):
        self.database = MySQLdb.connect(host="199.192.21.32", user="baseddepartment_basedadmin", passwd="ASDJHFGASD*&^%ASRD", db="baseddepartment_based")
        self.cursor = self.database.cursor()
    
    def get_user(self, username):
        self.cursor.execute("SELECT * FROM lua_users WHERE username = %s", (username,))
        return self.cursor.fetchone()
