# NotUno
It's (Not)Uno on the cli :D

---

### Storing card data
(Not)Uno cards are stored as numbers using bitwise operations.

Example:
```js
const CARDS = require('./cards')

// Create a red 0 (Not)Uno card
var card = CARDS.NUMBERED + CARDS.NUMBER_0 + CARDS.RED

// Will return true
console.log('card is red: ' + (card & CARDS.RED))

// Toggle red & green
card ^= CARDS.RED + CARDS.GREEN

// Will return true
console.log('card is green: ' + (card & CARDS.GREEN))

// Will return false
console.log('card is red: ' + (card & CARDS.RED))
```

### WebSocket Messages
Data will be sent through JSON messages in the format of {"op": opcode, "d": data}.
Unless more than one data object is sent, the key supplied in the table below will not be present.
The data object will not be present if the op does not require data.
| Opcode | Name  | Data     | Direction |
| :----: | :---: | :------: | :-------: |
| 1      | login | username: string | Send      
| 2      | login_status | success: boolean | Receive
| 3      | join | code: string | Send
| 4      | join_status | success: boolean | Receive
| 5      | create | | Send
| 6      | create_status | success: boolean | Receive
| 7      | lobby_init | code: string, players: string[] | Receive
| 8      | lobby_state | state: string | Receive
| 9 | game_update_turn | username: string | Receive
| 10 | game_use_card | card: number (see docs) | Send
| 11 | game_draw_card | | Send
| 12 | game_receive_cards | cards: number[] (see docs) | Receive
| 13 | game_update_card | card: number (see docs) | Receive
| 14 | game_card_drawn | | Receive
| 15 | lobby_update_players | players: string[] | Receive
| 16 | server_info | name: string | Receive

### WebSocket Errors
| Opcode | Name |
| :----: | :--: |
| 400    | invalid_opcode