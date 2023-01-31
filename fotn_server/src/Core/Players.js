const crypto = require('crypto')
const Player = require('./Player')
const { response } = require('../Util/Network')
const playerEnum = require('../Enum/Player')

module.exports = class Players {
    constructor() {
        this.players = []
    }

    add(data) {
        const newPlayer = new Player(data, crypto.randomBytes(16).toString('hex'));

        this.players.push(newPlayer)
        
        return newPlayer
    }

    remove(uid) {
        this.players = this.players.filter(player => !player.is(uid))
    }

    getPlayers() {
        return this.players
    }

    applyPlayerFunction(uid, handle, data) {
        let updatedPlayer = null

        this.players = this.players.filter(player => {
            if (player.is(uid))
                updatedPlayer = player[handle](data)
            return player
        })

        return updatedPlayer
    }

    toString() {
        return this.players.map(player => player.toString())
    }
}