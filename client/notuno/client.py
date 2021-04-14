import asyncio
from notuno.websocket import WebSocketClient

import user_pb2 as User

class NotUnoClient:
  def __init__(self):
    self.username = self.prompt_username()
    self.socket = WebSocketClient("ws://localhost:3000")

    print("\nConnecting to the (Not)Uno game servers...")

    asyncio.run(self.connect())

  async def connect(self):
    await self.socket.connect()

    print("Connected!\n")

    print("Logging in as {username}...\n".format(username=self.username))
    # Create user object and send to the server for registration
    self.user = User.User(username=self.username)
    await self.socket.send(0, self.user)

    await self.socket.receive()

    session_code = input("Enter a session code or press ENTER to create a game: ")

    if not session_code:
      # Create session
      print("\nCreating game session...")
    else:
      # Join session
      print("\nJoining game session...")

  def prompt_username(self):
    """Prompts for a username input, returns the username"""
    username = ""

    while not username:
      username = input("\nChoose a username: ")
    
    return username