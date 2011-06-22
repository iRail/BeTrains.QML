import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: page
    anchors.fill: parent


    //
    // Toolbar
    //

    tools: ToolBarLayout {
        id: pageSpecificTools

        // Quit buton
        // TODO: quit logo
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        // Make request
        ToolButton {
            iconSource: "toolbar-search"
            enabled: false
            onClicked: pageStack.push(secondPage)
        }
    }


    //
    // Contents
    //

    Column {
        id: contents
        spacing: platformStyle.paddingMedium

        anchors {
            left: parent.left
            right: parent.right
            margins: platformStyle.paddingMedium
        }

        Row {
            anchors.fill: parent
            Column {
                id: stationColumn
                width: parent.width - swapButton.width - platformStyle.paddingMedium

                StationField {
                    id: origin
                    placeholderText: "Origin..."
                    width: parent.width
                }

                StationField {
                    id: destination
                    placeholderText: "Destination..."
                    width: parent.width
                }

            }

            Button {
                id: swapButton
                height: stationColumn.height
                anchors.right: parent.right
                text: "Swap"

                onClicked: {
                    var temp = destinationName.text
                    destinationName.text = originName.text
                    originName.text = temp
                    swapButton.focus = true
                }
            }
        }
    }
}
