# bot.py
# This file is intended to be a "getting started" code example for students.
# The code in this file is fully functional.
# Students are free to edit the code in the milestone 3 folder.
# Students are NOT allowed to distribute this code without the express permission of the class instructor
# IMPORTANT: How to set your secret environment variables? read README guidelines.

# imports
import os
import discord
import database as db

# environment variables
token = os.environ['DISCORD_TOKEN']
server = os.environ['DISCORD_GUILD']
#server_id = os.environ['SERVER_ID']  # optional
#channel_id = os.environ['CHANNEL_ID']  # optional

# database connection
# secret keys related to your database must be updated. Otherwise, it won't work
db_conn = db.connect()
# bot events
client = discord.Client(intents=discord.Intents.all())


# while 1:
#   msg = input()
#   msg = my_split(msg)
#   print(msg)
#   #  msg = msg.split()
#   if 'END' in msg:
#     break
#   # if "milestone3" in msg:
#   #   print("I am alive. Signed: 'your bot'")
#   if msg[0] in COMMANDS:
#     print(COMMANDS[msg[0]](msg))
#   else:
#     print("I'm sorry but I don’t understand you :)")
#     print("I can only understand:")
#     print()
#     for idx, i in enumerate(HELP):
#       key_list = list(COMMANDS.keys())
#       print(key_list[idx], "\n", i)
#       print()


@client.event
async def on_ready():
    """
    This method triggers with the bot connects to the server
    Note that the sample implementation here only prints the
    welcome message on the IDE console, not on Discord
    :return: VOID
    """
    print("{} has joined the server".format(client.user.name))


@client.event
async def on_message(message):
    """
    This method triggers when a user sends a message in any of your Discord server channels
    :param message: the message from the user. Note that this message is passed automatically by the Discord API
    :return: VOID
    """
    response = None # will save the response from the bot
    if message.author == client.user:
        return # the message was sent by the bot
    if message.type is discord.MessageType.new_member:
        response = "Welcome {}".format(message.author) # a new member joined the server. Welcome him.
    else:
        # A message was send by the user.
        msg = message.content.lower()
        print("Len of the message", len(msg))
        msg = db.my_split(msg)
        if msg[0] in db.COMMANDS:
          response = db.COMMANDS[msg[0]](msg)
        else:
          text = "I'm sorry but I don’t understand you :)\nI can only understand:\n\n"
          for idx, i in enumerate(db.HELP):
            key_list = list(db.COMMANDS.keys())
            text += key_list[idx]
            text += "\n"
            text += i
            text += "\n\n"
          response = text
    if response:
        # bot sends response to the Discord API and the response is show
        # on the channel from your Discord server that triggered this method.
        embed = discord.Embed(description=response)
        await message.channel.send(embed=embed)


try:
    # start the bot and keep the above methods listening for new events
    client.run(token)
except:
    print("Bot is offline because your secret environment variables are not set. Head to the left panel, " +
          "find the lock icon, and set your environment variables. For more details, read the README file in your " +
          "milestone 3 repository")

