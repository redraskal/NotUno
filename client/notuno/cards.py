from enum import Enum

# The values of the cards in this object are calculated by 2^n
class Cards(Enum):
  UNKNOWN = 0
  NUMBERED = 2
  CANCEL = 4
  SKIP = 8
  REVERSE = 16
  DRAW = 32
  WILD = 64
  RED = 128
  YELLOW = 256
  BLUE = 512
  GREEN = 1024
  NUMBER_0 = 2048
  NUMBER_1 = 4096
  NUMBER_2 = 8192
  NUMBER_3 = 16384
  NUMBER_4 = 32768
  NUMBER_5 = 65536
  NUMBER_6 = 131072
  NUMBER_7 = 262144
  NUMBER_8 = 524288
  NUMBER_9 = 1048576

def formatList(cards):
  """Convert a list of card numbers to a list of card name strings"""
  return map(prettyPrint, cards)

pretty = {
  "Unknown": Cards.UNKNOWN.value,
  "Red": Cards.RED.value,
  "Yellow": Cards.YELLOW.value,
  "Blue": Cards.BLUE.value,
  "Green": Cards.GREEN.value,
  "Cancel": Cards.CANCEL.value,
  "Skip": Cards.SKIP.value,
  "Reverse": Cards.REVERSE.value,
  "Draw": Cards.DRAW.value,
  "Wild": Cards.WILD.value,
  "0": Cards.NUMBER_0.value,
  "1": Cards.NUMBER_1.value,
  "2": Cards.NUMBER_2.value,
  "3": Cards.NUMBER_3.value,
  "4": Cards.NUMBER_4.value,
  "5": Cards.NUMBER_5.value,
  "6": Cards.NUMBER_6.value,
  "7": Cards.NUMBER_7.value,
  "8": Cards.NUMBER_8.value,
  "9": Cards.NUMBER_9.value,
}

def prettyPrint(card):
  """Takes a card number and outputs the card name string"""
  output = ""

  if card & Cards.WILD.value and card & Cards.DRAW.value:
    return "Wild Draw 4"

  for name, num in pretty.items():
    if card & num:
      output = output + ("", " ")[len(output) > 0] + name

  if card & Cards.DRAW.value:
    output += " 2"

  if len(output) > 0:
    return output
  else:
    return str(card)

def fromString(name):
  """Takes a card name string and outputs a card number"""
  words = name.lower().split()
  output = Cards.UNKNOWN.value

  for name, num in pretty.items():
    if name.lower() in words:
      output += num

  return output