.pragma library
// TODO: introduce global database state
Qt.include("utils.js")

function openDatabase() {
    return openDatabaseSync("betrains", "1.0", "userdata", 100000)
}

function initialize() {
    var db = openDatabase()
    db.transaction(
        function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)")
            tx.executeSql("CREATE TABLE IF NOT EXISTS connections(origin TEXT, destination TEXT, datetimeSpecified TEXT, datetime TEXT, datetimeType TEXT, favorite TEXT)")
        }
    )
}

function reset() {
    var db = openDatabase()
    db.transaction(
        function(tx) {
            tx.executeSql("DROP TABLE IF EXISTS settings")
            tx.executeSql("DROP TABLE IF EXISTS connections")
        }
    )
    initialize()
}

function setSetting(setting, value) {
    var db = openDatabase()
    var res = "Error"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?,?);", [setting,value])
            if (rs.rowsAffected > 0)
                res = "OK"
        }
    )
    return res
}

function getSetting(setting) {
    var db = openDatabase()
    var res = "Unknown"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("SELECT value FROM settings WHERE setting=?;", [setting])
            if (rs.rows.length > 0)
                res = rs.rows.item(0).value
        }
    )
    return res
}

function getConnections(connections) {
    var db = openDatabase()
    var res = "Unknown"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("SELECT * FROM connections;")
            if (rs.rows.length > 0) {
                for (var i = 0; i < rs.rows.length; i++) {
                    connections.append({"origin": rs.rows.item(i).origin,
                                        "destination": rs.rows.item(i).destination,
                                        "datetimeSpecified": parseBoolean(rs.rows.item(i).datetimeSpecified),
                                        "datetime": parseInt(rs.rows.item(i).datetime),
                                        "departure": (rs.rows.item(i).datetimeType === "departure"),
                                        "favorite": parseBoolean(rs.rows.item(i).favorite)})
                }
                res = "OK"
            }
        }
    )
    return res
}

function addConnection(connection) {
    var db = openDatabase()
    var res = "Unknown"
    db.transaction(
        function(tx) {
            var rs = tx.executeSql("INSERT INTO connections VALUES (?,?,?,?,?,?);",
                [connection.origin,
                 connection.destination,
                 connection.datetimeSpecified,
                 connection.datetime,
                 (connection.departure ? "departure" : "arrival"),
                 connection.favorite])
            if (rs.rows.length > 0)
                res = "OK"
        }
    )
    return res
}
