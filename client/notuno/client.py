import asyncio
from notuno.websocket import WebSocketClient
import sys

from notuno.opcodes import Opcodes
from notuno.player import Player
from notuno.game import Game

class NotUnoClient:
  def __init__(self):
    self.socket = WebSocketClient("ws://localhost:3000")

    print("\nConnecting to the (Not)Uno game servers...")

    asyncio.run(self.connect())

  async def connect(self):
    await self.socket.connect()

    print("Connected!")

    await self.login()
    await self.listen()

  async def login(self):
    """Prompt for a username and attempt to login"""
    self.username = self.prompt_username()

    print("Logging in as {username}...\n".format(username=self.username))
    # Create Player object and send to the server for registration
    self.player = Player(username=self.username)
    await self.socket.send(Opcodes.LOGIN, self.username)

  async def create_session(self):
    """Send a packet to create a game session on the server"""
    print("\nCreating game session...")

    await self.socket.send(Opcodes.CREATE)

    await self.listen()
  
  async def join_session(self, code):
    """Send a packet to join a game session on the server if the code is valid"""
    print("\nJoining game session...")

    await self.socket.send(Opcodes.JOIN, code)

    await self.listen()

  async def listen(self):
    """Listen for the next socket packet and process it accordingly"""
    message = await self.socket.receive()
    opcode = Opcodes(message['op'])

    switch = {
      Opcodes.LOGIN_STATUS: lambda: self.handle_login_status(message['d']),
      Opcodes.SERVER_INFO: lambda: self.handle_server_info(message['d']),
      Opcodes.CREATE_STATUS: lambda: self.handle_create_status(message['d']),
      Opcodes.JOIN_STATUS: lambda: self.handle_join_status(message['d']),
      Opcodes.LOBBY_INIT: lambda: self.handle_lobby_init(message['d']),
      Opcodes.LOBBY_UPDATE_PLAYERS: lambda: self.handle_lobby_update_players(message['d']),
      Opcodes.LOBBY_STATE: lambda: self.handle_lobby_state(message['d']),
      Opcodes.COMMAND_RESPONSE: lambda: self.handle_command_response(message['d']),
    }

    func = switch.get(opcode, lambda: sys.exit("An error has occurred, last message for reference: {message}".format(message=message)))
    # Run the packet handler function async
    await func()
    
    await self.listen()

  async def handle_login_status(self, status):
    """Handle a received login status packet"""
    if status:
      await self.handle_login_success()
    else:
      await self.handle_login_error()

  async def handle_login_success(self):
    """Handle a successful login, prompt for a session code or a new session"""
    session_code = input("Enter a session code or press ENTER to create a game: ")

    if not session_code:
      await self.create_session()
    else:
      await self.join_session(session_code)

  async def handle_login_error(self):
    """Print that a username is not available and restart the login process"""
    print("\nUsername is not available.")

    await self.login()

  async def handle_create_status(self, status):
    """Handle a create match status packet"""
    if not status:
      print("\nCould not create match.")

      await self.handle_login_success()
    else:
      await self.listen()

  async def handle_join_status(self, status):
    """Handles a join status packet"""
    if not status:
      print("\nCould not join match.")

      await self.handle_login_success()
    else:
      await self.listen()

  async def handle_lobby_init(self, data):
    """Initializes the game class"""
    self.game = Game(
      code=data['c'],
      player=self.player, 
      players=data['p'],
      socket=self.socket
    )

    asyncio.create_task(self.game.await_queue())

    # Draw the game on the cli
    self.game.draw()

    await self.listen()

  async def handle_lobby_update_players(self, players):
    """Updates the current players and re-draws the game"""
    self.game.players = players

    self.game.draw()

    await self.listen()

  async def handle_lobby_state(self, state):
    """Updates the current lobby state and re-draws the game"""
    self.game.state = state
    
    self.game.draw()

    await self.listen()
  
  async def handle_command_response(self, response):
    """Handles a command response"""
    self.game.draw()

    print("> {response}".format(response=response))

    await self.listen()

  async def handle_server_info(self, server_info):
    """Updates the server info in the client instance"""
    self.server_info = server_info

  def prompt_username(self):
    """Prompts for a username input, returns the username"""
    username = ""

    while not username:
      username = input("\nChoose a username: ")
    
    return username