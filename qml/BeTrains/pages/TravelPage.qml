import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../components"
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent

    property date datetime: new Date()


    //
    // Contents
    //

    Column {
        id: configuration
        spacing: platformStyle.paddingMedium

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: platformStyle.paddingMedium
        }

        Row {
            width: parent.width
            spacing: platformStyle.paddingMedium

            Column {
                id: stationColumn
                width: parent.width - swapButton.width - platformStyle.paddingMedium
                spacing: platformStyle.paddingSmall

                StackableSearchBox {
                    id: originField
                    placeHolderText: "Origin..."
                    width: parent.width
                    KeyNavigation.tab: destinationField
                }

                StackableSearchBox {
                    id: destinationField
                    placeHolderText: "Destination..."
                    width: parent.width
                }
            }

            Button {
                id: swapButton
                height: stationColumn.height
                iconSource: "../icons/swap.png"

                onClicked: {
                    var temp = destinationField.text
                    destinationField.text = originField.searchText
                    originField.searchText = temp
                    swapButton.focus = true
                }
            }
        }

        ButtonRow {
            id: typeGroup
            width: parent.width
            exclusive: true
            checkedButton: typeNowButton

            ToolButton {
                id: typeDepartureButton
                text: "Depart"
            }
            ToolButton {
                id: typeNowButton
                text: "Now"
            }
            ToolButton {
                id: typeArrivalButton
                text: "Arrive";
            }
        }

        Row {
            width: parent.width
            spacing: platformStyle.paddingMedium

            Button {
                id: dateField
                text: datetime.toLocaleDateString()
                enabled: !typeNowButton.checked
                width: (parent.width - platformStyle.paddingMedium) / 2

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
                text: Utils.readableTime(datetime)
                enabled: !typeNowButton.checked
                width: (parent.width - platformStyle.paddingMedium) / 2

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
    }

    ListView {
        id: historyView

        anchors {
            left: parent.left
            right: parent.right
            top: configuration.bottom
            bottom: parent.bottom
            topMargin: platformStyle.paddingLarge
        }

        clip: true
        model: ListModel {
            ListElement {
                contents: "Look up"
            }
        }
        delegate: Component {
            ListItem {
                ListItemText {
                    text: contents
                }
                onClicked: {
                    if (!connectionsPage)
                        connectionsPage = Utils.loadObjectByPath("pages/ConnectionsPage.qml", page)

                    if (originField.searchText === "" || destinationField.searchText === "") {
                        banner.text = "Please fill out both station fields"
                        banner.open()
                    } else {
                        pageStack.push(connectionsPage, {
                                       origin: originField.searchText,
                                       destination: destinationField.searchText,
                                       datetime: typeNowButton.checked ? new Date() : datetime,
                                       arrival: typeArrivalButton.checked
                        });
                    }
                }
            }
        }
    }

    InfoBanner {
         id: banner
     }


    //
    // Objects
    //

    property Page connectionsPage
}
