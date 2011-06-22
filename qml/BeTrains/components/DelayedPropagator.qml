import QtQuick 1.0

Item {
    property string input
    property string output
    property alias delay: delayTimer.interval

    Timer {
        id: delayTimer

        interval:  parent.delay
        running: false
        repeat: false

        onTriggered: output = input
    }

    onInputChanged: delayTimer.restart()
}
