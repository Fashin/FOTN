module.exports = class Loop {
    constructor() {}

    run(core) {
        setTimeout(() => {
            
            

            this.run(core)
        }, 1000 / 60)
    }
}