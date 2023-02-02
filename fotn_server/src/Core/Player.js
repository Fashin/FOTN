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
        this.health = 100
        this.kills = 0
    }

    is(uid) {
        return this.uid === uid
    }

    updatePosition(position) {
        this.position.x = position.x
        this.position.y = position.y // need review for jump
        this.position.z = position.z
        this.look_direction = position.look_direction

        return this
    }

    // =========================
    // Setter & Getter    
    setConnection(connection) {
        this.connection = connection

        return this
    }

    getConnection() {
        return this.connection
    }

    toString() {
        return {
            uid: this.uid,
            name: this.name,
            position: this.position,
            look_direction: this.look_direction
        }
    }
}