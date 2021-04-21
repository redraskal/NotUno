const getId = require('docker-container-id'),
  config = require('config')

const region = process.env.REGION || 'local'
var name = config['name'] || 'unknown'

function getInfo() {
  return `${region}-${name}`
}

console.log(`[SERVER-INFO]: ${getInfo()}`)

(async () => {
  const id = await getId()

  if(id) name = id

  console.log(`[SERVER-INFO]: ${getInfo()}`)
})()

module.exports = getInfo
module.exports.name = name
module.exports.region = region