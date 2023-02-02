const ConnectPlayer = require('../Events/ConnectPlayer')
const PlayerOnMove = require('../Events/PlayerOnMove')
const Disconnected = require('../Events/Disconnected')

class Events {
    constructor(core) {
        // TODO : autoload all classes from Events folder
        this.ConnectPlayer = new ConnectPlayer(core)
        this.PlayerOnMove = new PlayerOnMove(core)
        this.Disconnected = new Disconnected(core)
    }

    // Sub class need have following prototype : handle(connection, payload)
    trigger(connection, eventName, payload) {
        return this[eventName].handle(connection, payload)
    }
}

const EVENT_LIST = [
    'ConnectPlayer',
    'PlayerOnMove',
    'Disconnected'
]

module.exports = {
    Events,
    EVENT_LIST
}