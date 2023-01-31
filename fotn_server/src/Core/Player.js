module.exports = class Player {
    constructor({ name, connection }, uid) {
        this.uid = uid
        this.name = name,
        this.position = {
            x: 0,
            y: 0,
            z: 0
        }
        this.connection = connection
    }

    is(uid) {
        return this.uid === uid
    }

    updatePosition(position) {
        this.position.x = position.x
        this.position.y = position.y // need review for jump down
        this.position.z = position.z

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
            position: this.position
        }
    }
}