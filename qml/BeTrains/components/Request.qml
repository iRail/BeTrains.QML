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

                TextField {
                    id: originName
                    placeholderText: "Origin..."
                    width: parent.width
                    platformLeftMargin: originSearch.width + platformStyle.paddingSmall

                    Image {
                        anchors { top: parent.top; left: parent.left; margins: platformStyle.paddingMedium }
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        source: "image://theme/qtg_graf_search_indicator"
                        height: parent.height - platformStyle.paddingMedium * 2
                        width: parent.height - platformStyle.paddingMedium * 2

                        MouseArea {
                            id: originSearch
                            anchors.fill: parent
                            onClicked: originSearchDialog.open()
                        }

                        StationChooser {
                            id: originSearchDialog

                            onAccepted: {
                                originName.text = originSearchDialog.station
                                originName.forceActiveFocus()
                            }
                        }
                    }
                }

                TextField {
                    id: destinationName
                    placeholderText: "Destination..."
                    width: parent.width
                    platformLeftMargin: originSearch.width + platformStyle.paddingSmall

                    Image {
                        anchors { top: parent.top; left: parent.left; margins: platformStyle.paddingMedium }
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        source: "image://theme/qtg_graf_search_indicator"
                        height: parent.height - platformStyle.paddingMedium * 2
                        width: parent.height - platformStyle.paddingMedium * 2

                        MouseArea {
                            id: destinationSearch
                            anchors.fill: parent
                            onClicked: destinationSearchDialog.open()
                        }

                        StationChooser {
                            id: destinationSearchDialog

                            onAccepted: {
                                destinationName.text = destinationSearchDialog.station
                                destinationName.forceActiveFocus()
                            }
                        }
                    }
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
