import threading

class InputThread(threading.Thread):
  """A class that asynchronously listens for keyboard input and outputs the results to a queue"""
  def __init__(self, queue, name='input-thread'):
    self.queue = queue
    super(InputThread, self).__init__(name=name)
    self.start()
  
  def run(self):
    while True:
      self.queue.put(input())