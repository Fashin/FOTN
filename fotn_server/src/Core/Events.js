const ConnectPlayer = require('../Events/ConnectPlayer')
const PlayerOnMove = require('../Events/PlayerOnMove')

class Events {
    constructor(core) {
        // TODO : autoload all classes from Events folder
        this.ConnectPlayer = new ConnectPlayer(core)
        this.PlayerOnMove = new PlayerOnMove(core)
    }

    // Sub class need have following prototype : handle(connection, payload)
    trigger(connection, eventName, payload) {
        return this[eventName].handle(connection, payload)
    }
}

const EVENT_LIST = [
    'ConnectPlayer',
    'PlayerOnMove'
]

module.exports = {
    Events,
    EVENT_LIST
}