import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    property ListView view

    width: view.width
    height: 0

    opacity: {
        if (-view.contentY > 100) {
            return 1
        } else if (-view.contentY > 10) {
            return 0.5
        } else
            return 0
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

            source: privateStyle.imagePath("toolbar-refresh", window.platformInverted)

            rotation: {
                if (-view.contentY > 100)
                    return 270
                else
                    return 90
            }
            Behavior on rotation {
                NumberAnimation {
                    duration: 250
                }
            }
        }

        Text {
            id: refreshText

            color: platformStyle.colorNormalLight

            text: {
                if (-view.contentY > 100)
                    return "Release to refresh..."
                else
                    return "Pull to refresh..."
            }
        }
    }
}
