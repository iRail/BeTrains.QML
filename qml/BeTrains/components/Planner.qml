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
}
