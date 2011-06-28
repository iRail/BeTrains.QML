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
