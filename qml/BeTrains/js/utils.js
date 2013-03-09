.pragma library

//===================================================================================================================


function removeNMBSSNCB(text) {
    return text.split("[")[0];
}

function readableDelay(seconds) {
    var dt = new Date(seconds * 1000)
    if (seconds <3600) {
        return "+0H"+pad(dt.getMinutes(),2)
    } else {
        return "+" + dt.getHours()+"H"+pad(dt.getMinutes(),2)
    }

}

function getDateTime(seconds) {
    return new Date(1000*seconds)
}

function readableDuration(seconds) {
    return parseUNIXTime(seconds)
}

function readableTime(datetime) {
    // FIXME: this is a "workaround" as the DefaultLocaleShortDate on
    // Symbian seems to include seconds...
    return Qt.formatTime(datetime, "hh:mm")
}

function generateDateUrl(datetime) {
    return Qt.formatDateTime(datetime, "yyyy/MM/dd/hh/mm")
}

function generateAPIDateUrl(datetime) {
    return Qt.formatDateTime(datetime, "ddMMyy")
}

function generateAPITimeUrl(datetime) {
    return Qt.formatDateTime(datetime, "hhmm")
}

function generateAPITimeUrl(datetime) {
      return pad(datetime.getHours(),2)+pad(datetime.getMinutes(),2);
}

function parseUNIXTime(unix_timestamp) {
    var dt = new Date(unix_timestamp * 1000)
    if (unix_timestamp<3600000) {
        return "00:"+pad(dt.getMinutes(),2) //fix for showing 01:xx instead of 00:xx
    } else {
        return pad(dt.getHours(),2)+":"+pad(dt.getMinutes(),2)
    }


    //    return readableTime(dt)
}

//===================================================================================================================

function loadObjectByComponent(component, parent) {
    // TODO: handle properties
    return component.createObject(parent)
}

function loadObjectByPath(path, parent, properties) {
    // TODO: dynamically load the component?
    var component = Qt.createComponent("../" + path)

    return loadObjectByComponent(component, parent)
}

function parseBoolean(str) {
    return /true/i.test(str);
}

function pad(number, length) {

    var str = '' + number;
    while (str.length < length) {
        str = '0' + str;
    }

    return str;

}

//===================================================================================================================

function getDistance(x1,y1,x2,y2) {
    return Math.sqrt((x2-x1)^2+(y2-y1)^2)
}

