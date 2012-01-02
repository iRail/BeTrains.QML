import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    property ListView view

    width: view.width
    height: 0

    property bool __alreadyPulled: false
    property int __dragThreshold: view.height / 7.5
    signal pulled()

    visible: enabled

    function __onContentYChanged() {
        if (!enabled)
            return

        if (__alreadyPulled && view.contentY === 0) {
            pulled()
            __alreadyPulled = false;
        }

        if (__alreadyPulled || -view.contentY > __dragThreshold) {
            __alreadyPulled = true
            opacity = 1
            refreshIcon.rotation = 180
            refreshText.text = "Refreshing!"
        } else if (-view.contentY > 10) {
            opacity = 0.5
            refreshIcon.rotation = 0
            refreshText.text = "Pull down to refresh..."
        } else
            opacity = 0

    }

    Component.onCompleted: {
        view.contentYChanged.connect(__onContentYChanged)
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
