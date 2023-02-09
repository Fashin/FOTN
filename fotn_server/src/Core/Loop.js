const { response } = require("../Util/Network")
const playerEnum = require('../Enum/Player')

module.exports = class Loop {
    constructor() {}

    run(core) {
        // TODO : better loop
        setTimeout(() => {
            core.players.getPlayers().map(p => {
                if (p.stamina < 100) {
                    const updatedPlayer = core.players.applyPlayerFunction(p.uid, 'setStamina', p.stamina + 10)
                    
                    response.allPlayer(core.players, playerEnum.PLAYER_STAMINA_UPDATE, {
                        player: updatedPlayer.toString()
                    })
                }
            })

            this.run(core)
        }, 1000)
    }
}