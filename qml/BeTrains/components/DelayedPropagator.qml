import QtQuick 1.0

Item {
    property string input
    property string output
    property int delay: 500

    Timer {
        id: delayTimer

        interval:  parent.delay
        running: false
        repeat: false

        onTriggered: output = input
    }

    onInputChanged: delayTimer.restart()
}
