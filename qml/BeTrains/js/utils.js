.pragma library

function readableDuration(seconds) {
    var output = ""

    var hours = Math.floor(seconds / 3600)
    if (hours > 0) {
        output = hours + "h"
        seconds = seconds - hours*3600
    }

    var minutes = Math.floor(seconds / 60)
    if (minutes > 0) {
        output = output + minutes + "m"
        seconds = seconds - minutes*60
    }

    return output
}

function getDateTime(seconds) {
    return new Date(1000*seconds)
}

function readableTime(datetime) {
    // FIXME: this is a "workaround" as the DefaultLocaleShortDate on
    // Symbian seems to include seconds...
    return Qt.formatTime(datetime, "hh:mm")
}

function getDynamicObject(object, component, parent) {
    if (object)
        return object;
    return component.createObject(parent)
}
