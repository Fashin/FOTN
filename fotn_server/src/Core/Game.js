const {Events, EVENT_LIST} = require('./Events')
const Players = require('./Players')
const Loop = require('./Loop')
const { request } = require('../Util/Network')

class Game {
    constructor(server) {
        this.server = server
        this.loop = new Loop()
        this.events = null
        this.connection = null
        this.players = new Players()
    }

    init() {
        this.events = new Events(this)
        
        this.server.on('connection', (connection) => {
            this.connection = connection
            this.handleRequests()
        })

        this.loop.run(this)
    }

    handleRequests() {        
        console.log('A new user has run the game, in waiting of connection...')
    
        this.connection.on('message', (data) => {
            this.handleEvents(data)
        })
    
        this.connection.on('close', (reasonCode, description) => {
            console.log('Disconnected [' + reasonCode + '] : ' + description);
        })
    }

    handleEvents(data) {
        const payload = request(data)
    
        if (EVENT_LIST.indexOf(payload.event) === -1)
            return this.connection.send(JSON.stringify({
                error: true,
                msg: 'Called event is not in the current list',
                code: 500
            }))
       
        this.events.trigger(this.connection, payload.event, payload.data)
    }
}

module.exports = {
    Game
}