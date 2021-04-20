const CARDS = require('./cards')

var card = CARDS.NUMBERED + CARDS.NUMBER_0 + CARDS.RED

console.log(`Card: ${card}, is red: ${card & CARDS.RED}, is green: ${card & CARDS.GREEN}`)

card ^= CARDS.RED + CARDS.GREEN

console.log(`Card: ${card}, is red: ${card & CARDS.RED}, is green: ${card & CARDS.GREEN}`)