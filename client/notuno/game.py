from enum import Enum
import os
from notuno.opcodes import Opcodes
from notuno.input_thread import InputThread
from notuno.cards import Cards
import queue
import asyncio

class Game:
  def __init__(self, code, player, socket, players):
    self.code = code
    self.player = player
    self.socket = socket

    self.players = players
    self.state = State.LOBBY

    self.turn = ""
    self.cards = []
    self.discard_pile = Cards.UNKNOWN.value

    self.queue = queue.Queue()
    self.input_thread = InputThread(self.queue)
  
  async def await_queue(self):
    """Listen for input events and send commands to the server"""
    await asyncio.sleep(0.3)

    try:
      message = self.queue.get(False) # non-blocking

      if message:
        await self.socket.send(Opcodes.COMMAND, message)
    except:
      message = None

    asyncio.create_task(self.await_queue())

  def draw(self):
    """Re-draws the game screen on the cli"""
    os.system('cls||clear') # Quick fix for re-drawing the messages (:
    print("Not(Uno) lobby: {code}\n---".format(code=self.code))

    if self.state == State.LOBBY:
      print("IN LOBBY - type 'start' to start the match")
    else:
      print("CURRENT TURN: {turn}".format(turn=self.players[0]))
      print("CURRENT CARD: {card}".format(card=self.discard_pile))

      print("\nCARDS: {cards}".format(cards=self.cards))

    print("\nPlayers: {players}".format(players=", ".join(self.players)))
    print("\nType a command:")

class State(Enum):
  LOBBY = "LOBBY"
  IN_GAME = "IN_GAME"
