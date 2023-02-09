const ConnectPlayer = require('../Events/ConnectPlayer')
const PlayerOnMove = require('../Events/PlayerOnMove')
const Disconnected = require('../Events/Disconnected')
const RunCounter = require('../Events/RunCounter')
const AttackPlayer = require('../Events/AttackPlayer')
const RunAttack = require('../Events/RunAttack')

class Events {
    constructor(core) {
        // TODO : autoload all classes from Events folder
        this.ConnectPlayer = new ConnectPlayer(core)
        this.PlayerOnMove = new PlayerOnMove(core)
        this.Disconnected = new Disconnected(core)
        this.RunCounter = new RunCounter(core)
        this.AttackPlayer = new AttackPlayer(core)
        this.RunAttack = new RunAttack(core)
    }

    // Sub class need have following prototype : handle(connection, payload)
    trigger(connection, eventName, payload) {
        return this[eventName].handle(connection, payload)
    }
}

const EVENT_LIST = [
    'ConnectPlayer',
    'PlayerOnMove',
    'Disconnected',
    'RunCounter',
    'AttackPlayer',
    'RunAttack'
]

module.exports = {
    Events,
    EVENT_LIST
}