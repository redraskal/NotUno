const config = require('config'),
  ws = require('ws'),
  http = require('http'),
  https = require('https'),
  web = config['websocket.cert'] ? https.createServer({
    cert: fs.readFileSync(config.get('websocket.cert')),
    key: fs.readFileSync(config.get('websocket.key'))
  }) : http.createServer(),
  server = new ws.Server({ server: web }),
  OPCODES = require('./opcodes')

// Active connections mapped by username: socket
const players = {}

function handleLogin(socket, username) {
  if(username in players) {
    // Username is not available
    return false
  } else {
    players[username] = socket

    return true
  }
}

function handleDisconnect(username) {
  delete players[username]
}

function handleMessage(socket, username, op, data) {
  switch(op) {
    case OPCODES.CREATE:
      // TODO: Create game lobby
      socket.json({ op: OPCODES.CREATE_STATUS, d: false })
      break
  }
}

function handleConnection(socket, raw) {
  const ip = raw.socket.remoteAddress
  var username = undefined

  // Add function to the socket for sending json data
  socket.json = function(json) {
    const data = JSON.stringify(json)

    this.send(data)

    console.log(`${ip} <- [${OPCODES.lookup(json.op)}] ${data}`)
  }

  console.log(`${ip} -> CONNECT`)

  socket.on('message', message => {
    const json = JSON.parse(message)
    var op = json.op
    const data = json.d

    console.log(`${ip} [${OPCODES.lookup(op)}] -> ${message}`)

    // Validate the serverbound message
    if(!op || !(op in OPCODES.values)) {
      return socket.json({ op: 400 })
    }

    if(op == OPCODES.LOGIN && data && data.length > 0) {
      const success = handleLogin(socket, data)

      // Store the socket's username if login was successful
      if(success) username = data

      socket.json({ op: OPCODES.LOGIN_STATUS, d: success })
    } else if(username) {
      // Only allow message handling if username is present
      handleMessage(socket, username, op, data)
    }
  })

  socket.on('close', () => {
    // Remove socket and username from players map on disconnect
    if(username) handleDisconnect(username)

    console.log(`${ip} -> DISCONNECT`)
  })
}

server.on('connection', (socket, raw) => handleConnection(socket, raw))

web.listen(config.get('websocket.port'))

console.log(`WebSocket server started on 0.0.0.0:${config.get('websocket.port')}`)