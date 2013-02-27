.pragma library
Qt.include("utils.js")

var __schemaVersion = 6
var __db

function initialize() {
    __db = openDatabaseSync("betrains", "1.0", "userdata", 100000)
    createTables()

    if (getSetting("__schemaVersion") !== __schemaVersion.toString()) {
        reset()
        createTables()
        setSetting("__schemaVersion", __schemaVersion.toString())
    }
}

function createTables() {
    __db.transaction(
        function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)")
            tx.executeSql("CREATE TABLE IF NOT EXISTS stations(id TEXT UNIQUE, x TEXT, y TEXT, name TXT)")
            tx.executeSql("CREATE TABLE IF NOT EXISTS connections(id INTEGER PRIMARY KEY ASC, origin TEXT, destination TEXT, datetimeSpecified TEXT, datetime TEXT, datetimeType TEXT, favorite TEXT)")
        }
    )
}

function reset() {
    __db.transaction(
        function(tx) {
            tx.executeSql("DROP TABLE settings;")
            tx.executeSql("DROP TABLE connections;")
            tx.executeSql("DROP TABLE stations;")
        }
    )
}

function setSetting(setting, value) {
    var res = "Error"
    __db.transaction(
        function(tx) {
            var rs = tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?,?);", [setting,value])
            if (rs.rowsAffected > 0)
                res = "OK"
        }
    )
    return res
}

function getSetting(setting) {
    var res = "Unknown"
    __db.readTransaction(
        function(tx) {
            var rs = tx.executeSql("SELECT value FROM settings WHERE setting=?;", [setting])
            if (rs.rows.length > 0)
                res = rs.rows.item(0).value
        }
    )
    return res
}

function getConnections(connections) {
    var res = "Unknown"
    connections.clear()
    __db.readTransaction(
        function(tx) {
            var rs = tx.executeSql("SELECT * FROM connections ORDER BY favorite DESC, datetime DESC;")
            if (rs.rows.length > 0) {
                for (var i = 0; i < rs.rows.length; i++) {
                    connections.append({"id": rs.rows.item(i).id,
                                        "origin": rs.rows.item(i).origin,
                                        "destination": rs.rows.item(i).destination,
                                        "datetimeSpecified": parseBoolean(rs.rows.item(i).datetimeSpecified),
                                        "datetime": new Date(parseInt(rs.rows.item(i).datetime)),
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
    var res = "Unknown"
    __db.transaction(
        function(tx) {
            var rs = tx.executeSql("INSERT INTO connections(origin, destination, datetimeSpecified, datetime, datetimeType, favorite) VALUES (?,?,?,?,?,?);",
                [connection.origin,
                 connection.destination,
                 connection.datetimeSpecified,
                 connection.datetime.getTime(),
                 (connection.departure ? "departure" : "arrival"),
                 connection.favorite])
            if (rs.rowsAffected) {
                rs = tx.executeSql("SELECT max(id) AS id FROM connections")
                if (rs.rows.length > 0) {
                    connection.id = rs.rows.item(0).id
                    res = "OK"
                }
            }
        }
    )
    return res
}

function updateConnection(connection) {
    var res = "Unknown"
    __db.transaction(
        function(tx) {
            var rs = tx.executeSql("UPDATE connections SET origin=?, destination=?, datetimeSpecified=?, datetime=?, datetimeType=?, favorite=? WHERE id=?;",
               [connection.origin,
                connection.destination,
                connection.datetimeSpecified,
                connection.datetime.getTime(),
                (connection.departure ? "departure" : "arrival"),
                connection.favorite,
                connection.id])
            if (rs.rowsAffected > 0)
                res = "OK"
        }
    )
    return res
}

function removeConnection(connection) {
    var res = "Unknown"
    __db.transaction(
        function(tx) {
            var rs = tx.executeSql("DELETE FROM connections WHERE id=?;",    [connection.id])
            if (rs.rowsAffected > 0)
                res = "OK"
        }
    )
    return res
}

//
//=====================================================================================================
//=====================================================================================================
// Code for storage of stations list
//

function loadStationList(language) {
    if (language!=="nl" && language!=="fr" && language!=="de" && language!=="en") {language="nl"}
    xmlDoc.load("http://api.irail.be/stations/?lang="+language);
    xmlObj=xmlDoc.documentElement;

    for (var i=0;i<xmlObj.childNodes.length;i++)
    {
        var name= xmlObj.childNodes(i).firstChild.text
        var id =  xmlObj.childNodes(i).getAttribute("id")
        var x =  xmlObj.childNodes(i).getAttribute("locationX")
        var y =  xmlObj.childNodes(i).getAttribute("locationY")
        insertStation(id,x,y,name)
    }

}

function insertStation(id,x,y,name) {

    var rs = tx.executeSql("INSERT INTO stations(id, x, y, name) VALUES (?,?,?,?);",[id,x,y,name])
    if (!rs.rowsAffected) {rs = tx.executeSql("UPDATE stations SET x=?, y=?, name=? WHERE id=?;",       [x,y,name,id])}
    return rs.rowsAffected

}

function getStation(id) {
    var rs = tx.executeSql("SELECT x,y,name FROM stations WHERE id=?",[id])
    var x = rs.rows.item(0).x
    var y = rs.rows.item(0).y
    var name = rs.rows.item(0).name
    return [x,y,name]
}

function getStationNear(x,y) {
  var rawx=x.substring(0, x.length - 4)
  var rawy=y.substring(0, y.length - 4)
  var rs = tx.executeSql("SELECT id,x,y,name FROM stations WHERE x LIKE ?% AND y LIKE ?%",[rawx,rawy])
    var results = new Array();
    for (var i=0;i<tx.rows.length;i++)
    {
        var res_id = rs.rows.item(i).id
        var res_x = rs.rows.item(i).x
        var res_y = rs.rows.item(i).y
        var res_name = rs.rows.item(i).name
        results[i]=[res_id,res_x,res_y,res_name]
    }
}
