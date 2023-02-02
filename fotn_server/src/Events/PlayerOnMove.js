const { response } = require("../Util/Network")
const errorEnum = require('../Enum/Error')
const playerEnum = require('../Enum/Player')

module.exports = class PlayerOnMove {
    constructor(core) {
        this.core = core
    }

    handle(connection, payload) {
        if (!('uid' in payload) && !this.core.players.exists(payload.uid))
            response.error(connection, errorEnum.UID_NOT_FOUND, { msg: "Error from sended data"})

        const updatedPlayer = this.core.players.applyPlayerFunction(payload.uid, 'updatePosition', payload.position)

        response.allPlayer(this.core.players, playerEnum.PLAYER_HAS_MOVE, {
            player: updatedPlayer.toString()
        })
    }
}