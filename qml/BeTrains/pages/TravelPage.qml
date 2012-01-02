import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../components"
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent

    property date __datetime: new Date()
    property bool __timeSpecified: false
    property bool __departure: true


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
                width: parent.width - swapButton.width - parent.spacing
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

        SelectionListItem {
            title: (__departure ? "Departure" : "Arrival")
            subTitle:  (__timeSpecified ? (__datetime.toLocaleString()) : "Right now")

            function __onDialogAccepted() {
                __departure = timeDialog.departure
                __datetime = timeDialog.datetime
                __timeSpecified = timeDialog.specified
            }

            width: parent.width
            onClicked: {
                if (!timeDialog) {
                    timeDialog = Utils.loadObjectByPath("components/TravelTimeDialog.qml", page)
                    timeDialog.accepted.connect(__onDialogAccepted)
                }
                timeDialog.departure = __departure
                timeDialog.datetime = __datetime
                timeDialog.specified = __timeSpecified
                timeDialog.open()
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
                                       datetime: __timeSpecified ? __datetime : new Date(),
                                       departure: __departure,
                                       lockDatetime: __timeSpecified
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

    property variant connectionsPage
    property variant timeDialog
}
