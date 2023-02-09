const errorEnum = require('../Enum/Error')
const playerEnum = require('../Enum/Player')
const { response } = require("../Util/Network")

module.exports = class AttackPlayer {

    constructor(core) {
        this.core = core
    }

    handle(connection, payload) {
        if (!('defendPlayerUid' in payload) || !('attackPlayerUid' in payload) || !('attackType' in payload))
            response.error(connection, errorEnum.PSEUDO_NOT_FOUND, { msg: "Error from sended data" })

        let defendPlayer = this.core.players.find(payload.defendPlayerUid)
        let attackPlayer = this.core.players.find(payload.attackPlayerUid)
        const oldDeaths = defendPlayer.deaths

        defendPlayer = defendPlayer.updateHealth(payload.attackType)

        if (defendPlayer.deaths > oldDeaths) {
            attackPlayer = attackPlayer.addKill()

            response.allPlayer(this.core.players, playerEnum.PLAYER_IS_DEAD, {
                attackPlayer: attackPlayer.toString(),
                defendPlayer: defendPlayer.toString()                
            })
        }
        else
            response.allPlayer(this.core.players, playerEnum.PLAYER_IS_ATTACKED, {
                attackPlayer: attackPlayer.toString(),
                attackType: payload.attackType,
                defendPlayer: defendPlayer.toString()
            })
    }
}