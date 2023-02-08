const errorEnum = require('../Enum/Error')
const playerEnum = require('../Enum/Player')
const { response } = require("../Util/Network")

module.exports = class RunCounter {
    constructor(core) {
        this.core = core
    }

    handle(connection, payload) {
        if (!('counter' in payload) || !('uid' in payload))
            response.error(connection, errorEnum.PSEUDO_NOT_FOUND, { msg: "Error from sended data" })

        const defendPlayer = this.core.players.applyPlayerFunction(payload.uid, 'setCounter', payload.counter)

        // if user has just counter, redo operation
        if (payload.counter)
            setTimeout(() => {
                const defendPlayer = this.core.players.applyPlayerFunction(payload.uid, 'setCounter', false)

                response.allPlayer(this.core.players, playerEnum.PLAYER_END_COUNTER, {
                    defendPlayer: defendPlayer.toString()
                })
            }, 2500)

        response.allPlayer(this.core.players, playerEnum.PLAYER_ON_COUNTER, {
            defendPlayer: defendPlayer.toString()
        })
    }
}