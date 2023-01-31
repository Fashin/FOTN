const request = (data) => {
    return JSON.parse(data)
}

const sendData = (connection, event, code, data) => {
    return connection.send(JSON.stringify({
        event,
        code,
        data
    }))
}

// connection = a chaques jouers, ils faut stocké + bloqué sur toutes les connexions
const response = {
    allPlayer: (players, event, data) => (players.getPlayers().map(p => sendData(p.getConnection(), event, 200, data))),
    onePlayer: (player, event, data) => (sendData(player.getConnection(), event, 200, data)),
    success: (connection, event, data) => sendData(connection, event, 200, data),
    error: (connection, event, data) => sendData(connection, event, 401, data)
}

module.exports = {
    request,
    response
}