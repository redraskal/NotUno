import asyncio
import websockets

class WebSocketClient:
  def __init__(self, uri="wss://swarm.notuno.ryben.dev"):
    self.uri = uri

  async def connect(self):
    """Connects to the NotUno game servers, returns a socket"""
    self.socket = await websockets.connect(self.uri)

    return self.socket
  
  async def send(self, data):
    """Sends data to the socket"""
    await self.socket.send(data)