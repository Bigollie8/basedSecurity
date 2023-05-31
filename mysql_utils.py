import MySQLdb

class mysql:
    def __init__(self):
        self.database = MySQLdb.connect(host="34.230.223.44", user="based", passwd="q0UekP3DuEJBy9tOpXkJ", db="baseddb")
        self.cursor = self.database.cursor()
    
    def get_user(self, username):
        self.cursor.execute("SELECT * FROM lua_users WHERE name = %s", (username,))
        return self.cursor.fetchone()
