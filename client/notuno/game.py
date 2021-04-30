from enum import Enum
import os
from notuno.opcodes import Opcodes
from notuno.input_thread import InputThread
import queue
import asyncio

class Game:
  def __init__(self, code, player, socket, players):
    self.code = code
    self.player = player
    self.socket = socket

    self.players = players
    self.state = State.LOBBY

    self.queue = queue.Queue()
    self.input_thread = InputThread(self.queue)

    self.await_queue()
  
  def await_queue(self):
    """Listen for input events and send commands to the server"""
    while True:
      try:
        message = self.queue.get(False) # non-blocking

        self.socket.send(Opcodes.COMMAND, message)
      except queue.Empty:
        break
    self.await_queue()

  def draw(self):
    """Re-draws the game screen on the cli"""
    os.system('cls||clear') # Quick fix for re-drawing the messages (:
    print("Not(Uno) lobby: {code}".format(code=self.code))

    if self.state == State.LOBBY:
      print("IN LOBBY - type 'start' to start the match")

    print("\nPlayers: {players}".format(players=", ".join(self.players)))
    print("\nType a command:")

class State(Enum):
  LOBBY = "LOBBY"
  IN_GAME = "IN_GAME"
