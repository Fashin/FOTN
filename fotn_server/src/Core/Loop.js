module.exports = class Loop {
    constructor() {}

    run() {
        setTimeout(() => {
            this.run()
        }, 1000 / 60)
    }
}