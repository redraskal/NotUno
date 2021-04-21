const OPCODES = {
  LOGIN: 1,
  LOGIN_STATUS: 2,
  JOIN: 3,
  JOIN_STATUS: 4,
  CREATE: 5,
  CREATE_STATUS: 6,
  LOBBY_INIT: 7,
  LOBBY_STATE: 8,
  GAME_UPDATE_TURN: 9,
  GAME_USE_CARD: 10,
  GAME_DRAW_CARD: 11,
  GAME_RECEIVE_CARDS: 12,
  GAME_UPDATE_CARD: 13,
  GAME_CARD_DRAWN: 14,
  LOBBY_UPDATE_PLAYERS: 15,
  SERVER_INFO: 16
}

const keys = Object.keys(OPCODES)
const values = Object.values(OPCODES)

module.exports = OPCODES
module.exports.lookup = value => keys.find(key => OPCODES[key] === value)
module.exports.values = values