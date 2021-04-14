import asyncio
import websockets

from message_pb2 import Message

class WebSocketClient:
  def __init__(self, uri="wss://swarm.notuno.ryben.dev"):
    self.uri = uri

  async def connect(self):
    """Connects to the NotUno game servers, returns a socket"""
    self.socket = await websockets.connect(self.uri)

    return self.socket
  
  async def send(self, opcode, message):
    """Sends a protobuf Message to the socket"""
    message = Message(opcode=opcode, data=message.SerializeToString())

    await self.socket.send(message.SerializeToString())
  
  async def receive(self):
    """Awaits the receival of a protobuf Message from the websocket server"""
    data = await self.socket.recv()

    # Parse the incoming data as a protobuf Message
    message = Message()
    message.ParseFromString(data)

    return message