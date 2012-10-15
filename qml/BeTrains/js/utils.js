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

function generateDateUrl(datetime) {
    return Qt.formatDateTime(datetime, "yyyy/MM/dd/hh/mm")
}

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
