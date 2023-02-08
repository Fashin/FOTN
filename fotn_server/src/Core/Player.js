const config = require('../config')

module.exports = class Player {
    constructor({ name, connection }, uid) {
        this.uid = uid
        this.connection = connection
        this.name = name
        this.position = {
            x: 0,
            y: 0,
            z: 0
        }
        this.look_direction = 0
        // TODO : separate class ?
        this.health = 100
        this.kills = 0
        this.deaths = 0
        this.counter = false
        this.stamina = 100
    }

    is(uid) {
        return this.uid === uid
    }

    // =========================
    // MISC
    // =========================
    updatePosition(position) {
        this.position.x = position.x
        this.position.y = position.y // need review for jump
        this.position.z = position.z
        this.look_direction = position.look_direction

        return this
    }

    updateHealth(attackType) {
        const damage = (this.kills * 0.2) + config.attack[attackType]

        if (this.counter) {
            if (this.stamina - (damage * 2) > 0) {
                this.health = (damage * 2) - this.stamina
                this.stamina = 0
            }
            else
                this.stamina = this.stamina - (damage * 2)
        }
        else
            this.health = this.health - damage

        // TODO : checker si le joueur n'est pas mort

        return this
    }

    // =========================
    // Setter & Getter    
    // =========================
    setConnection(connection) {
        this.connection = connection

        return this
    }

    getConnection() {
        return this.connection
    }

    setCounter(value) {
        if (value && this.stamina >= 50) {
            this.counter = value
            this.stamina = this.stamina - 49
        }
        else if (!value)
            this.counter = value
        return this
    }

    getCounter() {
        return this.counter
    }

    toString() {
        return {
            uid: this.uid,
            name: this.name,
            position: this.position,
            look_direction: this.look_direction,
            health: this.health,
            stamina: this.stamina,
            counter: this.counter,
            kills: this.kills,
            deaths: this.deaths,
        }
    }
}