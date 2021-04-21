const { nanoid } = require('nanoid'),
  config = require('config')

const region = process.env.REGION || 'local'
var name = config['name'] || nanoid().slice(0, 5)
const info = `${region}-${name}`

console.log(`[SERVER-INFO]: ${info}`)

module.exports = info
module.exports.name = name
module.exports.region = region