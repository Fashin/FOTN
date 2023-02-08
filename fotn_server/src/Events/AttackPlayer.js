const errorEnum = require('../Enum/Error')
const playerEnum = require('../Enum/Player')
const { response } = require("../Util/Network")

module.exports = class AttackPlayer {

    constructor(core) {
        this.core = core
    }

    handle(connection, payload) {
        if (!('uid' in payload) || !('attackType' in payload))
            response.error(connection, errorEnum.PSEUDO_NOT_FOUND, { msg: "Error from sended data" })

        const attackedPlayer = this.core.players.applyPlayerFunction(payload.uid, 'updateHealth', payload.attackType)

        response.allPlayer(this.core.players, playerEnum.PLAYER_IS_ATTACKED, {
            attackPlayer: this.core.players.find(payload.uid).toString(),
            defendPlayer: attackedPlayer.toString()
        })
    }
}