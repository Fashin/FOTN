const ws = require('ws')
const { Game } = require('./src/Core/Game')

// TODO : env
const port = 5000
const server = new ws.Server({ port })
const game = new Game(server)

game.init()