const crypto = require('crypto')
const Player = require('./Player')

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
        let removedPlayer = null

        this.players = this.players.filter(player => {
            if (!player.is(uid))
                return true

            removedPlayer = player
            return false
        })

        return removedPlayer
    }

    getPlayers() {
        return this.players
    }

    find(uid) {
        return this.players.filter(player => player.is(uid))[0]
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