import asyncio
from notuno.websocket import WebSocketClient
import sys

from notuno.opcodes import Opcodes
from notuno.user import User

class NotUnoClient:
  def __init__(self):
    self.socket = WebSocketClient("ws://localhost:3000")

    print("\nConnecting to the (Not)Uno game servers...")

    asyncio.run(self.connect())

  async def connect(self):
    await self.socket.connect()

    print("Connected!")

    await self.login()

  async def login(self):
    self.username = self.prompt_username()

    print("Logging in as {username}...\n".format(username=self.username))
    # Create user object and send to the server for registration
    self.user = User(username=self.username)
    await self.socket.send(Opcodes.LOGIN, self.username)

    await self.listen()

  async def create_session(self):
    print("\nCreating game session...")

    await self.socket.send(Opcodes.CREATE)

    await self.listen()

  async def listen(self):
    message = await self.socket.receive()
    opcode = Opcodes(message['op'])

    switch = {
      Opcodes.LOGIN_STATUS: lambda: self.handle_login_status(message['d'])
    }

    func = switch.get(opcode, lambda: sys.exit("An error has occured, last message for reference: {message}".format(message=message)))
    await func()
    
    await self.listen()

  async def handle_login_status(self, status):
    if status:
      await self.handle_login_success()
    else:
      await self.handle_login_error()

  async def handle_login_success(self):
    session_code = input("Enter a session code or press ENTER to create a game: ")

    if not session_code:
      await self.create_session()
    else:
      # Join session
      print("\nJoining game session...")

  async def handle_login_error(self):
    print("\nUsername is not available.")

    await self.login()

  def prompt_username(self):
    """Prompts for a username input, returns the username"""
    username = ""

    while not username:
      username = input("\nChoose a username: ")
    
    return username