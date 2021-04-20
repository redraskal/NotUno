import asyncio
import websockets
import json

from notuno.opcodes import Opcodes
class WebSocketClient:
  def __init__(self, uri="wss://swarm.notuno.ryben.dev"):
    self.uri = uri

  async def connect(self):
    """Connects to the NotUno game servers, returns a socket"""
    self.socket = await websockets.connect(self.uri)

    return self.socket
  
  async def send(self, opcode, data = None):
    """Sends a json message to the server"""
    # Set op to the integer value of the opcode
    message = {'op': opcode.value}

    if data:
      message['d'] = data

    await self.socket.send(json.dumps(message))
  
  async def receive(self):
    """Awaits the receival of a json message from the server"""
    data = await self.socket.recv()

    # Parse the incoming data as a json message
    message = json.loads(data)

    return message