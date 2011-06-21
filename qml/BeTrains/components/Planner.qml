import QtQuick 1.0
import com.nokia.symbian 1.1

Column {
    id: column
    spacing: 14


    //
    // Contents
    //

    Row {
        id: origin

        TextField {
            placeholderText: "Station"
        }

    }


    //
    // States and transitions
    //

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: column
                x: parent.width
            }
        },
        State {
            name: "hiddenLeft"
            PropertyChanges {
                target: column
                x: -parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: column
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: column
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
