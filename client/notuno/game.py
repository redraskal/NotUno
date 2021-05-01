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
    self.card_count = {}
    self.discard_pile = Cards.UNKNOWN.value

  async def await_queue(self):
    """Listen for input events and send commands to the server"""
    await asyncio.sleep(0.3)

    try:
      message = self.queue.get(False) # non-blocking

      if not message:
        asyncio.create_task(self.await_queue())
        return

      message = message.lower().replace("draw 4", "").replace("draw 2", "")

      # Ignore gameplay input if the current turn is not the client
      if self.turn != self.player.username:
        await self.socket.send(Opcodes.COMMAND, message)
        
        asyncio.create_task(self.await_queue())
        return

      if message == "draw":
        await self.socket.send(Opcodes.GAME_DRAW_CARD)
        
        asyncio.create_task(self.await_queue())
        return
      
      if message == "skip":
        await self.socket.send(Opcodes.GAME_SKIP_CARD)
        
        asyncio.create_task(self.await_queue())
        return
      
      # Attempt to parse a card number from the user input
      # Will return Cards.UNKNOWN.value if a card is not found
      number = fromString(message)

      if number != Cards.UNKNOWN.value and number in self.cards:
        await self.socket.send(Opcodes.GAME_USE_CARD, number)
        
        asyncio.create_task(self.await_queue())
        return

      await self.socket.send(Opcodes.COMMAND, message)

      asyncio.create_task(self.await_queue())
    except:
      message = None
      asyncio.create_task(self.await_queue())

  def pretty_print_players(self):
    """Returns a string of the player list and the card count if available"""

    if self.state == State.LOBBY:
      return ", ".join(self.players)
    else:
      output = []

      for player in self.players:
        card_count = 0

        if self.card_count:
          card_count = self.card_count.get(player, 0)

        output.append(player + " (" + str(card_count) + ")")

      return ", ".join(output)

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
        print("\nYOUR TURN! TYPE THE CARD YOU WANT TO PLAY OR TYPE 'draw' or 'skip'")

    print("\nPlayers: {players}".format(players=self.pretty_print_players()))
    print("\nType a command:")

class State(Enum):
  LOBBY = "LOBBY"
  IN_GAME = "IN_GAME"
