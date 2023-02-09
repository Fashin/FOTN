const { response } = require("../Util/Network")
const errorEnum = require('../Enum/Error')
const playerEnum = require('../Enum/Player')

module.exports = class Disconnected {
    constructor(core) {
        this.core = core
    }

    handle(connection, payload) {
        if (!("uid" in payload))
            response.error(connection, errorEnum.UID_NOT_FOUND, { msg: "Error from sended data" })

        const removedPlayer = this.core.players.remove(payload.uid)

        response.allPlayer(this.core.players, playerEnum.PLAYER_IS_DISCONNECTED, {
            uid: payload.uid,
            name: removedPlayer?.name
        })
    }
}