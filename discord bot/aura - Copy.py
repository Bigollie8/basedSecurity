import base64
from codecs import encode
from datetime import datetime
import json
import os
import time
import requests
import uuid
import discord
import glob
import json
import MySQLdb
from yaml import load
from utils import luraph_utils
from discord import app_commands

with open("utils/config.json", "r") as f:
    config = json.load(f)

db = MySQLdb.connect(
    host = config['database']['ip'],
    user = config['database']['user'],
    passwd = config['database']['passwd'],
    db = config['database']['dbname']
)
sendquery = db.cursor()
if __name__ == "__main__":
    try:
        class client(discord.Client):
            def __init__(self):
                super().__init__(intents=discord.Intents.default())
                self.syned = False
            
            async def on_ready(self):
                await self.wait_until_ready()
                if not self.syned:
                    await tree.sync(guild = discord.Object(id = config['discord']['serverid']))
                    self.syned = True

                print("Logged in")
    except (KeyboardInterrupt, SystemExit):
        print("Exiting.")
        exit()

class lua:
    #done
    def get_user_details(ctx: int):
        sendquery.execute(f"SELECT id, skeetuid, username, password, role, blocked, ip, steamID, discord, discordID, last_loaded, loader_downloads, vendorID, deviceID FROM users WHERE discordID = '{str(ctx)}';")
        information = []
        for row in sendquery.fetchall():
            for number in range(len(row)):
                information.append(row[number])
            return information

    #done
    def get_user_role(ctx):
        return lua.get_user_details(ctx)[4]
    
    #done
    def get_invite_role(ctx):
        sendquery.execute(f"SELECT invite, taken, role FROM invitecodes WHERE invite = '{str(ctx)}';")
        for invite in sendquery.fetchall(): return invite[2]
    
    #done
    def get_invite_validity(ctx):
        sendquery.execute(f"SELECT invite, taken FROM invitecodes WHERE invite = '{ctx}';")
        if sendquery.rowcount == 0:
            return "Invalid Invite"
        elif sendquery.rowcount == 1:
            for x in sendquery.fetchall():
                if x[1] == "false" or x[1] == "False" or x[1] == "0" or x[1] == 0:
                    return "Valid Invite"
                else:
                    return "Invalid Invite"
    
    #done
    def redeem_invite(ctx):
        if lua.get_invite_validity(ctx) == "Valid Invite":
            sendquery.execute(f"UPDATE invitecodes SET taken = 1 WHERE invite = '{ctx}';")
            db.commit()
            return "Successfully redeemed"
        elif lua.get_invite_validity(ctx) == "Invalid Invite":
            return "Invalid Invite"
    
    #done
    def generate_invite(ctx):
        if lua.get_invite_validity(uuid.uuid1()) == "Valid Invite":
            uuid1 = uuid.uuid1()
            sendquery.execute(f"INSERT INTO invitecodes (invite, taken, role) VALUES('{uuid1}', '0', '{ctx}');")
            db.commit()
            return uuid1
        else:
            uuid2 = uuid.uuid1()
            sendquery.execute(f"INSERT INTO invitecodes (invite, taken, role) VALUES('{uuid2}', '0', '{ctx}');")
            db.commit()
            return uuid2
    
    #done
    def delete_invite(ctx):
        if lua.get_invite_validity(ctx) == "Valid Invite":
            sendquery.execute(f"DELETE FROM invitecodes WHERE invite = '{ctx}';")
            db.commit()
            return f"Successfully deleted {ctx} from the database of invites."
        else:
            print(sendquery.rowcount)
            return "Invalid invite. Can't delete, sorry. Message Ollie"
    
    #done
    def remove_logs(ctx):
        sendquery.execute(f"DELETE FROM hackinglog WHERE ip = '{ctx}';")
        db.commit()
        if sendquery.rowcount == 0:
            return f"Logs for {ctx} have been cleared."
    
    #done
    def set_user_role(ctx, role):
        try:
            sendquery.execute(f"UPDATE users SET role = '{role}' WHERE username = '{ctx}';")
            db.commit()
            if sendquery.rowcount == 1:
                return f"Successfully set {ctx} to {role}"
            else:
                return f"Failed to set {ctx} to {role}"
        except Exception as e:
            return e
    
    #done
    def register(uid: int, invite: str, username: str, password: str, discorduser: discord.User):
        try:
            if lua.get_invite_validity(invite):
                if lua.redeem_invite(invite) == "Successfully redeemed":
                    sendquery.execute(f"INSERT INTO users (skeetuid, username, password, invite, role, discord, discordID) VALUES('{uid}', '{username}', '{password}', '{invite}', '{lua.get_invite_role(invite)}', '{discorduser.display_name}#{discorduser.discriminator}', '{discorduser.id}');")
                    db.commit()
                    if sendquery.rowcount == 1:
                        return "Successfully registered"
                    elif sendquery.rowcount == 0:
                        return "Failed to register"
                else:
                    return "Invalid invite used."
            else:
                return "Invalid Invite."
        except Exception as e:
            return e

    def block_user(ctx, bool):
        sendquery.execute(f"UPDATE users SET blocked = '{bool}' WHERE discordID = '{ctx}';")
        db.commit()
        print(sendquery.rowcount)
        if sendquery.rowcount == 1 or 2: 
            return "Successfully updated their state" 
        else: 
            return "Failed to update their state"

class ConfirmRegister(discord.ui.View):
    def __init__(self):
        super().__init__()
        self.val = None
        self.author = None
    
    @discord.ui.button(label='Confirm Registration', style=discord.ButtonStyle.green)
    async def confirm(self, interaction: discord.Interaction, button: discord.ui.button):
        await interaction.response.send_message('Confirmed.', ephemeral=True)
        self.val = True
        self.author = interaction.user.id
        self.stop()
    
    @discord.ui.button(label='Cancel Registration', style=discord.ButtonStyle.red)
    async def cancel(self, interaction: discord.Interaction, button: discord.ui.button):
        await interaction.response.send_message('Canceled.', ephemeral=True)
        self.val = False
        self.author = interaction.user.id
        self.stop()

client = client()
tree = app_commands.CommandTree(client)

@tree.command(name = "loader", description = "generates custom loader for you", guild = discord.Object(id = config['discord']['serverid'])) # FINISH 
async def loader(interaction: discord.Interaction):
    start = time.time()
    details = lua.get_user_details(interaction.user.id)
    if details[2] is None:
        await interaction.response.send_message("Are you sure you're registered?", ephemeral=True)
    else:
        luraph_utils.replace_username(config['path'] + "loader.lua", 21, str(details[2]))
        script = f"{config['path']}loader.lua"
        
        res = requests.get("https://api.lura.ph/v1/obfuscate/nodes", headers={"Luraph-API-Key": "68272821c2173ab9a37a7c09b494aa442c0b1227421759f386555a4d42810c08"})
        nodes = json.loads(res.text)

        request = requests.post("https://api.lura.ph/v1/obfuscate/new", headers={"Luraph-API-Key": "68272821c2173ab9a37a7c09b494aa442c0b1227421759f386555a4d42810c08"}, json={"fileName": f"{details[2]}.lua", "node": nodes['recommendedId'], "script": base64.b64encode(bytes(open(script).read(), 'utf-8')).decode(), "options": {"INTENSE_VM_STRUCTURE": False,"ENABLE_GC_FIXES": False,"TARGET_VERSION": "CS:GO","VM_ENCRYPTION": False,"DISABLE_LINE_INFORMATION": False,"USE_DEBUG_LIBRARY": False}})
        if request.status_code != 400:
            jobID = json.loads(request.text)
            loader = requests.get(f"https://api.lura.ph/v1/obfuscate/download/{jobID['jobId']}", headers={"Luraph-API-Key": "68272821c2173ab9a37a7c09b494aa442c0b1227421759f386555a4d42810c08"})
            if loader.status_code == 200:
                #print(loader.text)
                embed = discord.Embed(title = f"Loaded Generated",color = discord.Color.red(), timestamp = datetime.today().now(),)
                embed.description = f"Your build has been successfully generated. It took {round(time.time() - start)}s to generate."
                embed.add_field(name="Built By", value=f"{details[2]}", inline=True)
                embed.add_field(name="Built type", value=f"{details[4]}", inline=True)
                embed.add_field(name="Time Built", value=f"{datetime.utcfromtimestamp(datetime.today().now().timestamp()).strftime('%Y-%m-%d %H:%M:%S')}", inline=True)
                embed.add_field(name="Disclaimer", value="You may be banned if found tampering, patching, reverse engineering, debugging, decompiling, or in anyway modifiying the build.", inline=False)
                embed.set_footer(text=f"basedSecurity ")
                with open(f"loaders/{details[2]}.lua", "w") as f:
                    f.write(loader.text)

                await interaction.response.send_message(file=discord.File(fr"loaders/{details[2]}.lua"), embed=embed, ephemeral=True)
                os.remove(f"loaders/{details[2]}.lua")
            else:
                await interaction.response.send_message("Failed to download loader.", ephemeral=True)
        else:
            await interaction.response.send_message("Failed to send request to luraph to upload the lua.", ephemeral=True)

@tree.command(name = "register", description = "register", guild = discord.Object(id = config['discord']['serverid'])) #should be done
async def register(interaction: discord.Interaction, skeetuid: int, invite: str, username: str, password: str):
    confirm = ConfirmRegister()
    msg = await interaction.channel.send("Confirm your details. If they're correct, Press Confirm", view=confirm)
    await confirm.wait()
    if confirm.val is None:
        await msg.delete()
    elif confirm.val and confirm.author == interaction.user.id:
        await msg.delete()
        registerd = lua.register(skeetuid, invite, username, password, interaction.user)
        if registerd != "Successfully registered":
            await interaction.response.send_message(f"Failed to register due to: {registerd}", ephemeral=True)
        elif registerd == "Successfully registered":
            embed = discord.Embed(
                title = "Registered Successfully.",
                color = discord.Color.blue(),
                timestamp = datetime.today().now()
            )
            embed.add_field(name = "Skeet uid", value = f"{skeetuid}", inline=False)
            embed.add_field(name = "Username", value = f"{username}", inline=False)
            embed.add_field(name = "Invite", value = f"{invite}", inline=False)

            await interaction.response.send_message(embed=embed, ephemeral=True)
    elif not confirm.val and confirm.author == interaction.user.id:
        await msg.delete()

@tree.command(name = "user_details", description = "get user details", guild = discord.Object(id = config['discord']['serverid'])) #should be done
async def userdetails(interaction: discord.Interaction, user: discord.User):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("You are not authorized to run this command.", ephemeral=True)
    else:
        details = lua.get_user_details(user.id)

        embed = discord.Embed(
            title = f"User Details for {user.name}",
            color = discord.Color.blue(),
            timestamp = datetime.today().now()
        )
        embed.add_field(name = "User ID", value = f"{details[0]}", inline=True)
        embed.add_field(name = "Username", value = f"{details[2]}", inline=True)
        embed.add_field(name = "Password", value = f"||{details[3]}||", inline=True)
        embed.add_field(name = "IP", value = f"||{details[6]}||", inline=True)
        embed.add_field(name = "Role", value = f"{details[4]}", inline=True)
        embed.add_field(name = "Blocked", value = f"{details[5]}", inline=True)
        embed.add_field(name = "Discord", value = f"||<@!{details[9]}>||", inline=True)
        embed.add_field(name = "Last Loaded", value = f"||{details[10]}||", inline=False)
        await interaction.response.send_message(embed=embed, ephemeral=True)

@tree.command(name = "delete_invite", description="delete invite", guild= discord.Object(id = config['discord']['serverid'])) #should be done
async def deleteinv(interaction: discord.Interaction, invite: str):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("You are not authorized to run this command.", ephemeral=True)
    else:
        deletion = lua.delete_invite(invite)
        if deletion != f"Successfully deleted {invite} from the database of invites.":
            embed = discord.Embed(
                title = f"Successfully deleted invite",
                color = discord.Color.blue(),
                timestamp = datetime.today().now()
            )
            await interaction.response.send_message(embed=embed, ephemeral=True)
        else:
            await interaction.response.send_message(content=deletion)

@tree.command(name = "generate", description="generates invite", guild = discord.Object(id = config['discord']['serverid'])) #should be done
async def generate(interaction: discord.Interaction, role: str):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("You are not authorized to run this command.", ephemeral=True)
    else:
        await interaction.response.send_message(lua.generate_invite(role), ephemeral=True)

@tree.command(name = "remove_logs", description = "removes hacking logs", guild = discord.Object(id = config['discord']['serverid'])) #should be done
async def removelog(interaction: discord.Interaction, ip: str):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("You are not authorized to run this command.", ephemeral=True)
    else:
        await interaction.response.send_message(lua.remove_logs(ip), ephemeral=True)

@tree.command(name = "set_role", description = "changes user role to role given", guild = discord.Object(id = config['discord']['serverid'])) #should be done
async def setrole(interaction: discord.Interaction, user: discord.User, role: str):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("You are not authorized to run this command.", ephemeral=True)
    else:
        await interaction.response.send_message(lua.set_user_role(user.name, role), ephemeral=True)

@tree.command(name = "block", description="Sets block status of user", guild = discord.Object(id = config['discord']['serverid'])) #should be done
async def blockuser(interaction: discord.Interaction, user: discord.User, state: str):
    if not interaction.user.guild_permissions.administrator:
        await interaction.response.send_message("You are not authorized to run this command.", ephemeral=True)
    else:
        if state == "False":
            state = 0
        elif state == "false":
            state = 0
        elif state == "True":
            state = 1
        elif state == "true":
            state = 1

        await interaction.response.send_message(content=lua.block_user(user.id, state), ephemeral=True)

client.run(config['discord']['discordtoken']) 