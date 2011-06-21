import QtQuick 1.0
import com.nokia.symbian 1.1

Column {
    id: root
    spacing: 14


    //
    // Contents
    //

    Column {
        id: contents
        spacing: 14

        anchors {
            left: parent.left
            right: parent.right
            margins: root.spacing
        }
        Row {
            id: origin

            Text {
                id: originLabel
                anchors.verticalCenter: parent.verticalCenter
                font { family: platformStyle.fontFamilyRegular; pixelSize: platformStyle.fontSizeMedium }
                color: platformStyle.colorNormalLight
                text: "Origin: "
            }

            TextField {
                placeholderText: "Station"
            }

        }
    }


    //
    // States and transitions
    //

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: root
                x: parent.width
            }
        },
        State {
            name: "hiddenLeft"
            PropertyChanges {
                target: root
                x: -parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: root
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: root
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
