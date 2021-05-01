from enum import Enum
import os
from notuno.opcodes import Opcodes
from notuno.input_thread import InputThread
from notuno.cards import Cards, formatList, prettyPrint, fromString
import queue
import asyncio

class Game:
  def __init__(self, code, player, socket, players):
    self.code = code
    self.player = player
    self.socket = socket

    self.players = players
    self.state = State.LOBBY

    self.reset()

    self.queue = queue.Queue()
    self.input_thread = InputThread(self.queue)
  
  def reset(self):
    self.turn = ""
    self.cards = []
    self.discard_pile = Cards.UNKNOWN.value

  async def await_queue(self):
    """Listen for input events and send commands to the server"""
    await asyncio.sleep(0.3)

    try:
      message = self.queue.get(False) # non-blocking

      if not message:
        return

      message = message.lower()

      if message == "draw":
        await self.socket.send(Opcodes.GAME_DRAW_CARD)
        return
      
      number = fromString(message)

      if number != Cards.UNKNOWN.value:
        await self.socket.send(Opcodes.GAME_USE_CARD, number)
        return

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
      print("CURRENT TURN: {turn}".format(turn=self.turn))
      print("CURRENT CARD: {card}".format(card=prettyPrint(self.discard_pile)))

      print("\nCARDS: {cards}".format(cards=", ".join(list(map(str, formatList(self.cards))))))

      if self.turn == self.player.username:
        print("\nYOUR TURN! TYPE THE CARD YOU WANT TO PLAY OR TYPE 'draw'")

    print("\nPlayers: {players}".format(players=", ".join(self.players)))
    print("\nType a command:")

class State(Enum):
  LOBBY = "LOBBY"
  IN_GAME = "IN_GAME"
