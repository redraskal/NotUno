class Player {
  constructor(username, socket) {
    this.username = username
    this.socket = socket
  }

  get ingame() {
    return this.code != undefined
  }
}

module.exports = Player