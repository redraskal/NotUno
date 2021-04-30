const { nanoid } = require('nanoid'),
  OPCODES = require('./opcodes')

const State = {
  LOBBY: 'LOBBY',
  IN_GAME: 'IN_GAME'
}

class Game {

  static MIN_PLAYERS = 2

  constructor() {
    this.code = nanoid(6)
    this.players = []
    this.state = State.LOBBY
  }

  reset() {
    this.state = State.LOBBY
    this.broadcastState()

    // TODO
  }

  start() {
    if(this.state != State.LOBBY) return

    this.state = State.IN_GAME
    this.broadcastState()

    // TODO
  }
  
  broadcast(json) {
    this.players.forEach(player => player.socket.json(json))
  }

  add(player) {
    if(this.contains(player) || this.state != State.LOBBY) return false

    this.players.push(player)
    player.code = this.code

    player.socket.json({ op: OPCODES.LOBBY_INIT, d: {
      c: this.code,
      p: this.players.map(player => player.username)
    } })

    this.broadcastPlayersInLobby()

    // Start game with right # of players
    if(this.players.length >= Game.MIN_PLAYERS) {
      this.start()
    }

    return true
  }

  contains(player) {
    return this.players.find(el => el.username == player.username)
  }

  remove(player) {
    if(!this.contains(player)) return false

    const playerIndex = this.players.indexOf(player.username)
    this.players.splice(playerIndex, 1)

    this.broadcastPlayersInLobby()

    // Reset game to lobby if only one player remains
    if(this.players.length == 1) {
      this.reset()
    }

    return true
  }

  broadcastPlayersInLobby() {
    this.broadcast({ op: OPCODES.LOBBY_UPDATE_PLAYERS, d: this.players.map(player => player.username) })
  }

  broadcastState() {
    this.broadcast({ op: OPCODES.LOBBY_STATE, d: this.state })
  }
}

module.exports = Game