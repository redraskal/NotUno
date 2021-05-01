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

def prettyPrint(card):
  if card == Cards.UNKNOWN.value:
    return "Unknown"
  if card == Cards.WILD.value:
    return "Wild"
  if card == (Cards.WILD.value + Cards.DRAW.value):
    return "Wild Draw 4"
  return "Unknown"
