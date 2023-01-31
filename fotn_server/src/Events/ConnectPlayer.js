const { response } = require("../Util/Network")
const errorEnum = require('../Enum/Error')
const playerEnum = require('../Enum/Player')

module.exports = class ConnectPlayer {
    constructor(core) {
        this.core = core
    }

    handle(connection, payload) {
        if (!('pseudo' in payload) && payload.pseudo !== '')
            response.error(connection, errorEnum.PSEUDO_NOT_FOUND, { msg: "Error from sended data" })

        const player = this.core.players.add({
            name: payload.pseudo,
            connection
        })

        // send response to asked connected user & load all already connected
        response.onePlayer(player, playerEnum.PLAYER_IS_LOGIN, {
            player: player.toString(),
            players: this.core.players.toString()
        })

        // send response to already connected player to one new player is connected
        response.allPlayer(this.core.players, playerEnum.PLAYER_IS_LOGGED, {
            player: player.toString()
        })
    }
}