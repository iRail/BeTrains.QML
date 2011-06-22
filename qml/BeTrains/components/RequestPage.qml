import QtQuick 1.0
import com.nokia.symbian 1.1
import com.nokia.extras 1.1

Page {
    id: page
    anchors.fill: parent

    property date datetime: new Date()


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
            enabled: originField.text !== "" && destinationField.text !== ""
            onClicked: {
                pageStack.push(connectionsComponent, {
                               origin: originField.text,
                               destination: destinationField.text,
                               usedatetime: datetimeCheck.checked,
                               datetime: datetime,
                               ready: true
            });
            }
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
            width: parent.width
            Column {
                id: stationColumn
                width: parent.width - swapButton.width - platformStyle.paddingMedium

                StationField {
                    id: originField
                    placeholderText: "Origin..."
                    width: parent.width
                    KeyNavigation.tab: destinationField
                }

                StationField {
                    id: destinationField
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
                    var temp = destinationField.text
                    destinationField.text = originField.text
                    originField.text = temp
                    swapButton.focus = true
                }
            }
        }

        CheckBox {
            id: datetimeCheck
            text: "Specify date and time"
        }

        ButtonRow {
            id: typeGroup
            width: parent.width - platformStyle.paddingMedium
            exclusive: true

            ToolButton {
                text: "Departure"
                enabled: datetimeCheck.checked
            }
            ToolButton {
                text: "Arrival";
                enabled: datetimeCheck.checked
            }
        }

        Button {
            id: dateField
            text: "Date: " + datetime.toLocaleDateString()
            enabled: datetimeCheck.checked
            width: parent.width - platformStyle.paddingMedium

            DatePickerDialog {
                id: dateDialog
                titleText: "Select the date"
                rejectButtonText: "Cancel"
                acceptButtonText: "Ok"

                Component.onCompleted: {
                    year = datetime.getFullYear()
                    month = datetime.getMonth()
                    day = datetime.getDate()
                }

                onAccepted: datetime = new Date(year, month, day, datetime.getHours(), datetime.getMinutes(), datetime.getSeconds(), datetime.getMilliseconds())
            }

            MouseArea {
                anchors.fill: parent
                onClicked: dateDialog.open()
            }
        }

        Button {
            id: timeField
            text: "Time: " + datetime.toLocaleTimeString()
            enabled: datetimeCheck.checked
            width: parent.width - platformStyle.paddingMedium

            TimePickerDialog {
                id: timeDialog
                titleText: "Select the time"
                rejectButtonText: "Cancel"
                acceptButtonText: "Ok"

                Component.onCompleted: {
                    hour = datetime.getHours()
                    minute = datetime.getMinutes()
                    second = datetime.getSeconds()
                }

                onAccepted: datetime = new Date(datetime.getFullYear(), datetime.getMonth(), datetime.getDate(), hour, minute, second, 0)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: timeDialog.open()
            }
        }
    }


    //
    // Dynamic components
    //

    Component {
        id: connectionsComponent
        ConnectionsPage {
            id: connections
        }
    }
}
