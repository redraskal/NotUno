const config = require('config'),
  ws = require('ws'),
  server = new ws.Server(config.get('websocket')),
  OPCODES = require('./opcodes'),
  serverInfo = require('./serverInfo'),
  Player = require('./player'),
  Game = require('./game')

// Players object mapped by username: Player
const players = {}
const games = {}

function handleLogin(socket, username) {
  if(username in players) {
    // Username is not available
    return false
  } else {
    const player = new Player(username, socket)

    players[username] = player
    return true
  }
}

function handleDisconnect(username) {
  const player = players[username]
  const game = player ? games[player.code] : false

  if(game) {
    game.remove(player)

    // Delete empty games
    if(game.players.length == 0) {
      console.log(`[GAME] Removing empty match ${game.code}...`)

      delete games[game.code]
    }
  }

  delete players[username]
}

function handleMessage(socket, player, op, data) {
  switch(op) {
    case OPCODES.CREATE:
      if(player.ingame) {
        socket.json({ op: OPCODES.CREATE_STATUS, d: false })
      } else {
        socket.json({ op: OPCODES.CREATE_STATUS, d: true })

        // Create game lobby
        const game = new Game(player)
        games[game.code] = game

        console.log(`[GAME] Created match ${game.code}.`)

        // Add player to the game
        game.add(player)
      }
      break
    case OPCODES.JOIN:
      if(player.ingame) {
        socket.json({ op: OPCODES.JOIN_STATUS, d: false })
      } else {
        const game = games[data]
        const joinStatus = game ? game.add(player) : false

        socket.json({ op: OPCODES.JOIN_STATUS, d: joinStatus })
      }
      break
    case OPCODES.COMMAND:
      if(player.ingame) {
        const game = games[player.code]
        var commandResponse = game ? game.handleCommand(player, data) : 'Commands are not available.'

        if(data == 'online') commandResponse = `Players online: ${Object.keys(players).length}, games: ${Object.keys(games).length}`

        socket.json({ op: OPCODES.COMMAND_RESPONSE, d: commandResponse })
      } else {
        socket.json({ op: OPCODES.COMMAND_RESPONSE, d: 'Commands are not available.' })
      }
      break
    case OPCODES.GAME_USE_CARD:
      if(player.ingame) {
        const game = games[player.code]

        if(game) {
          game.useCard(player, data)
        }
      }
      break
    case OPCODES.GAME_DRAW_CARD:
      if(player.ingame) {
        const game = games[player.code]

        if(game) {
          game.drawCard(player)
        }
      }
      break
    default:
      // Send websocket error if the message could not be handled
      socket.json({ op: 400 })
  }
}

function handleConnection(socket, raw) {
  const ip = raw.headers['x-forwarded-for'] || raw.socket.remoteAddress
  var username = undefined

  // Add function to the socket for sending json data
  socket.json = function(json) {
    const data = JSON.stringify(json)

    this.send(data)

    console.log(`[SOCKET] ${ip} <- [${OPCODES.lookup(json.op)}] ${data}`)
  }

  console.log(`[SOCKET] ${ip} -> CONNECT`)

  // Send server info to client (region + container name)
  socket.json({ op: OPCODES.SERVER_INFO, d: serverInfo })

  socket.on('message', message => {
    const json = JSON.parse(message)
    var op = json.op
    const data = json.d

    console.log(`[SOCKET] ${ip} [${OPCODES.lookup(op)}] -> ${message}`)

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
      handleMessage(socket, players[username], op, data)
    }
  })

  socket.on('close', () => {
    // Remove socket and username from players map on disconnect
    if(username) handleDisconnect(username)

    console.log(`[SOCKET] ${ip} -> DISCONNECT`)
  })
}

server.on('connection', (socket, raw) => handleConnection(socket, raw))

console.log(`WebSocket server started on ${config['websocket']['host'] || '0.0.0.0'}:${config.get('websocket.port')}`)