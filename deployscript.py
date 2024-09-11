import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLabel, QLineEdit, QTextEdit, QPushButton, QVBoxLayout, QComboBox, QMessageBox
from discord_webhook import DiscordWebhook, DiscordEmbed
import time

import src.python.mysql_utils as mysql_utils

database = mysql_utils.mysql()
version = 0

class WebhookSender(QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        database.connect()
        usernames = database.get_admin_usernames()
        version = database.get_version()
        version_parts = version[0][0].split('.')
        major = int(version_parts[0])
        minor = int(version_parts[1])
        patch = int(version_parts[2])
        patch += 1
        version = f"{major}.{minor}.{patch}"
        database.disconnect()

        # Set up the layout
        layout = QVBoxLayout()

        # Name
        self.name_label = QLabel('Name:')
        self.name_input = QComboBox(self)
        for username in usernames:   
            self.name_input.addItems(username)  # Add usernames to the combo box
        layout.addWidget(self.name_label)
        layout.addWidget(self.name_input)

        # Version
        self.version_label = QLabel('Version:')
        self.version_input = QLineEdit(self)
        self.version_input.setText(version)  # Set the default value to the retrieved version
        layout.addWidget(self.version_label)
        layout.addWidget(self.version_input)

        # Environment (Prod/Dev)
        self.env_label = QLabel('Environment:')
        self.env_combo = QComboBox(self)
        self.env_combo.addItems(["Dev", "Prod"])
        layout.addWidget(self.env_label)
        layout.addWidget(self.env_combo)

        # Notes
        self.notes_label = QLabel('Details:')
        self.notes_input = QTextEdit(self)
        layout.addWidget(self.notes_label)
        layout.addWidget(self.notes_input)

        # Submit Button
        self.submit_button = QPushButton('Send Webhook', self)
        self.submit_button.clicked.connect(self.send_webhook)
        layout.addWidget(self.submit_button)

        # Set layout
        self.setLayout(layout)

        # Window settings
        self.setWindowTitle('Discord Deploy Webook Alert')
        self.setGeometry(300, 300, 400, 300)

    def send_webhook(self):
        name = self.name_input.currentText()  # Get the selected username
        version = self.version_input.text()
        environment = self.env_combo.currentText()
        notes = self.notes_input.toPlainText()

        if not name or not version or not environment:
            QMessageBox.warning(self, 'Input Error', 'Please fill in all fields.')
            return

        try:
            url = "https://discord.com/api/webhooks/1159910814623486092/wKYNBYfB3p3epZ3nkTzxbnPgP_A9Vmq3EnfFRXAtZogoIRNDG_Q1pyiGnuyKAy1uSD8I"  # Replace with your actual Discord webhook URL

            embed = DiscordEmbed(title="Deploybot",color='03b2f8')
            embed.set_author(name="BasedSecurity",icon_url ="https://cdn.discordapp.com/attachments/1097943477754527836/1164934299666104452/4fb7a80e-204f-4fb9-8675-509d4fbcb862.jpeg?ex=6545049c&is=65328f9c&hm=0efc1fb515bbb4e08fa56832054799e416740330d574b2ed34affa4cab0eb198&")
            embed.add_embed_field(name='Name', value=str(name))
            embed.add_embed_field(name='version', value=str(version))
            embed.add_embed_field(name='Environment', value=str(environment))
            embed.add_embed_field(name='Details', value=str(notes))
            embed.set_footer(text=str(time.strftime("%Y-%m-%d %H:%M:%S")))
            webhook = DiscordWebhook(url=url)
            webhook.add_embed(embed)
            webhook.execute(remove_embeds=True)
            QMessageBox.warning(self, 'Success', 'Update MSG Sent!.')


        except Exception as e:
            QMessageBox.warning(self, 'Failed', 'Failed to send msg :' + str(e))

def main():
    app = QApplication(sys.argv)
    ex = WebhookSender()
    ex.show()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
