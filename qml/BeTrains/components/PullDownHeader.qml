import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    //
    // External interface
    //

    property ListView view

    property int threshold: view.height / 7.5

    // TODO: somehow detect mouse release, it is more intuitive

    property string idleString: "Pull down to refresh..."
    property string pullingString: "Hold to refresh..."
    property string pulledString: "Refreshing!"

    property alias delay: timer.interval

    signal pulled()


    //
    // Initialization
    //

    property bool __pulled: false
    property bool __pulling: false

    width: view.width
    height: 0

    visible: enabled

    Component.onCompleted: {
        view.contentYChanged.connect(function () {
            if (!enabled)
                return

            if (__pulled) {
                if (view.contentY === 0) {
                    pulled()
                    __pulled = false;
                }
            } else if (-view.contentY > threshold) {
                if (!__pulling) {
                    __pulling = true
                    timer.restart()
                }
                opacity = 1
                refreshIcon.rotation = 180
                refreshText.text = pullingString
            } else if (-view.contentY > 10) {
                __pulling = false
                opacity = 0.5
                refreshIcon.rotation = 0
                refreshText.text = idleString
            } else
                opacity = 0
        })
    }

    Timer {
        id: timer

        interval:  750
        running: false
        repeat: false

        onTriggered: {
            if (__pulling) {
                __pulled = true
                refreshText.text = pulledString
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }


    //
    // Contents
    //

    Row {
        anchors {
            bottom: parent.top
            horizontalCenter: parent.horizontalCenter
            left: parent.left
            leftMargin: 2 * platformStyle.paddingLarge
            bottomMargin: 10
        }
        spacing: platformStyle.paddingLarge

        Image {
            id: refreshIcon
            // FIXME: pass platformInverted, but it seems that this isn't accessible from everywhere
            // (i.e. window variable isn't valid in case of a dynamically loaded component)
            source: privateStyle.imagePath("toolbar-refresh", false)

            Behavior on rotation {
                NumberAnimation {
                    duration: 250
                }
            }
        }

        Text {
            id: refreshText
            color: platformStyle.colorNormalLight

        }
    }
}
