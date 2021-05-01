const { nanoid } = require('nanoid'),
  OPCODES = require('./opcodes'),
  CARDS = require('./cards')

const State = {
  LOBBY: 'LOBBY',
  IN_GAME: 'IN_GAME'
}

class Game {

  static MAX_PLAYERS = 10

  constructor(owner) {
    this.owner = owner
    this.code = nanoid(6)
    this.players = []
    this.state = State.LOBBY
    this.turns = 0
    this.lastCard = CARDS.UNKNOWN

    this.colors = [CARDS.RED, CARDS.BLUE, CARDS.GREEN, CARDS.YELLOW]
  }

  reset() {
    if(this.state != State.IN_GAME) return false

    this.state = State.LOBBY
    this.broadcastState()

    this.turns = 0
    this.lastCard = CARDS.UNKNOWN

    this.players.forEach(player => player.cards = [])

    return true
  }

  start() {
    if(this.state != State.LOBBY || this.players.length < 2) return false

    this.state = State.IN_GAME
    this.broadcastState()

    // Shuffle players, current turn will be 0 index
    this.players = this.players.sort(() => .5 - Math.random())

    this.broadcastPlayersInLobby()

    this.shuffleDeck()

    this.players.forEach(player => player.cards = [])

    this.nextTurn()

    return true
  }

  checkWinConditions(turn) {
    if(!turn.cards || turn.cards.length > 0) return false

    this.reset()

    this.broadcast({ op: OPCODES.COMMAND_RESPONSE, d: `${turn.username} won the match!` })

    return true
  }

  nextTurn() {
    if(this.state != State.IN_GAME) return

    // Get player for current turn,
    // returns first player in array if this is the first turn
    // or moves the first player in the array to the back
    // and fetches the next player at index 0
    const turn = this.turns == 0 ? this.players[0] : this.players.shift()
    if(this.turns > 0) this.players.push(turn)

    // Give everyone their cards if this is the first turn
    if(this.turns == 0) {
      this.players.forEach(player => this.giveCards(player, 7))

      // Set first card in discard pile
      const firstCard = this.deck.shift()
      this.setDiscardPile(firstCard)
    }

    if(this.checkWinConditions(turn)) return

    // Send turn info to clients
    this.broadcastPlayersInLobby()
    this.broadcast({ op: OPCODES.GAME_UPDATE_TURN, d: turn.username })

    this.turns++
  }

  setDiscardPile(card) {
    this.lastCard = card
    this.broadcast({ op: OPCODES.GAME_UPDATE_CARD, d: card })
  }

  shuffleDeck() {
    this.deck = []

    for(var cardNumber = 0; cardNumber <= 9; cardNumber++) {
      for(var i = 0; i < this.colors.length; i++) {
        const color = this.colors[i]

        switch(cardNumber) {
          case 0:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_0)
          case 1:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_1)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_1)
          case 2:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_2)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_2)
          case 3:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_3)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_3)
          case 4:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_4)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_4)
          case 5:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_5)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_5)
          case 6:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_6)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_6)
          case 7:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_7)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_7)
          case 8:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_8)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_8)
          case 9:
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_9)
            this.deck.push(CARDS.NUMBERED + color + CARDS.NUMBER_9)
        }

        this.deck.push(CARDS.CANCEL + color)
        this.deck.push(CARDS.SKIP + color)
        this.deck.push(CARDS.REVERSE + color)
        this.deck.push(CARDS.DRAW + color)
      }
    }

    for(var i = 0; i < 4; i++) {
      this.deck.push(CARDS.WILD)
      this.deck.push(CARDS.WILD + CARDS.DRAW)
    }

    this.deck = this.deck.sort(() => .5 - Math.random())
  }

  giveCards(player, amount) {
    for(var i = 0; i < amount; i++) {
      this.giveCard(player, false)
    }

    player.socket.json({ op: OPCODES.GAME_RECEIVE_CARDS, d: player.cards })
  }

  isCardUseable(card) {
    if(card == CARDS.UNKNOWN) {
      // Some invalid card number
      return false
    } else if(card & CARDS.RED 
        || card & CARDS.BLUE 
        || card & CARDS.YELLOW 
        || card & CARDS.GREEN) {
      // Colored cards

      // Both the previous card and the current card are of the same special card type
      if((this.lastCard & CARDS.CANCEL) && (card & CARDS.CANCEL)
        || (this.lastCard & CARDS.SKIP) && (card & CARDS.SKIP)
        || (this.lastCard & CARDS.REVERSE) && (card & CARDS.REVERSE)
        || (this.lastCard & CARDS.DRAW) && (card & CARDS.DRAW)) return true
      
      const lastNumber = CARDS.stripColor(this.lastCard) ^ CARDS.NUMBERED
      const currentNumber = CARDS.stripColor(card) ^ CARDS.NUMBERED
      
      // Both cards have the same number
      if(lastNumber == currentNumber) return true

      // Card is not the same color as the discard pile
      if((this.lastCard & CARDS.RED) && !(card & CARDS.RED)
        || (this.lastCard & CARDS.BLUE) && !(card & CARDS.BLUE)
        || (this.lastCard & CARDS.YELLOW) && !(card & CARDS.YELLOW)
        || (this.lastCard & CARDS.GREEN) && !(card & CARDS.GREEN)) return false

      return true
    } else {
      // Non-colored cards, always useable
      return true
    }
  }

  findUseableCards(player) {
    return player.cards.filter(card => this.isCardUseable(card))
  }

  useCard(player, card) {
    if(this.state == State.IN_GAME || players[0] == player) {
      if(!this.isCardUseable(card)) return false
      
      this.setDiscardPile(card)

      const cardIndex = player.cards.indexOf(card)
      player.cards.splice(cardIndex, 1)

      player.socket.json({ op: OPCODES.GAME_REMOVE_CARDS, d: [card] })

      this.nextTurn()

      return true
    } else {
      return false
    }
  }

  drawCard(player) {
    if(this.state == State.IN_GAME && players[0] == player) {
      this.giveCard(player)
      
      this.broadcast({ op: OPCODES.GAME_CARD_DRAWN })

      // Go to next turn if the player has no useable cards
      if(this.findUseableCards(player).length == 0) {
        this.nextTurn()
      }

      return true
    } else {
      return false
    }
  }

  giveCard(player, sendPacket = true) {
    if(this.deck.length == 0) this.shuffleDeck()

    const card = this.deck.shift()

    player.cards.push(card)

    if(sendPacket) player.socket.json({ op: OPCODES.GAME_RECEIVE_CARDS, d: [card] })
  }
  
  broadcast(json) {
    this.players.forEach(player => player.socket.json(json))
  }

  handleCommand(player, command) {
    if(!this.contains(player)) return 'You are not in a lobby.'

    switch(command) {
      case 'start':
        if(player.username == this.owner.username 
            && this.state == State.LOBBY
            && this.players.length > 1) {
          this.start()
          
          return 'Match is starting.'
        } else {
          return 'You cannot start the match.'
        }
      default:
        return 'Command not found.'
    }
  }

  add(player) {
    if(this.contains(player) || this.state != State.LOBBY
      || this.players.length >= this.MAX_PLAYERS) return false

    this.players.push(player)
    player.code = this.code

    player.socket.json({ op: OPCODES.LOBBY_INIT, d: {
      c: this.code,
      p: this.players.map(player => player.username)
    } })

    this.broadcastPlayersInLobby()

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

    player.cards = []

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