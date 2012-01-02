import QtQuick 1.1

Item {
    property string contents
    property alias delay: delayTimer.interval

    signal input()
    signal output()

    Timer {
        id: delayTimer

        interval:  parent.delay
        running: false
        repeat: false

        onTriggered: {
            output()
        }
    }

    onContentsChanged: {
        input()
        delayTimer.restart()
    }
}
