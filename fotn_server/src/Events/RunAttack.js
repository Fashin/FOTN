const errorEnum = require('../Enum/Error')
const playerEnum = require('../Enum/Player')
const { response } = require("../Util/Network")

module.exports = class RunAttack {

    constructor(core) {
        this.core = core
    }


    handle(connection, payload) {
        if (!('uid' in payload) || !('attackType' in payload))
            response.error(connection, errorEnum.PSEUDO_NOT_FOUND, { msg: "Error from sended data" })

        response.allPlayer(this.core.players, playerEnum.PLAYER_RUN_ATTACK, {
            player: this.core.players.find(payload.uid).toString(),
            attackType: payload.attackType
        })
    }
}