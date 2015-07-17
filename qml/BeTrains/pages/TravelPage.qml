import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../components"
import "../js/utils.js" as Utils
import "../js/storage.js" as Storage

Page {
    id: page
    anchors.fill: parent


    property date __datetime: new Date()
    property bool __datetimeSpecified: false
    property bool __departure: true
    property bool _editHistory:false

    //
    // Contents
    //
    state: (screen.currentOrientation === Screen.Portrait) ? "portrait" : "landscape"

    states: [
        State {
            name: "landscape"

            PropertyChanges {
                target: originField;
                width: (parent.width/2)-(swapButton.width/2)
                anchors.top:parent.top
                anchors.left: parent.left
            }

            PropertyChanges {
                target: destinationField;
                width: (parent.width/2)-(swapButton.width/2)
                anchors.top:parent.top
                anchors.left: originField.right
            }
            PropertyChanges {
                target: swapButton;
                anchors.top:parent.top
                anchors.left: destinationField.right
                height:destinationField.height
            }
        },
        State {
            name: "portrait"

            PropertyChanges {
                target: originField;
                width: parent.width-swapButton.width
                anchors.top:parent.top
                anchors.left: parent.left
            }

            PropertyChanges {
                target: destinationField;
                width: parent.width-swapButton.width
                anchors.top:originField.bottom
                anchors.left: parent.left
            }
            PropertyChanges {
                target: swapButton;
                anchors.top:parent.top
                anchors.left: destinationField.right
                height:destinationField.height*2
            }
        }
    ]


    TextField {
        id: originField
        x:0
        y:0
        placeholderText: qsTr("Origin...")
        width: parent.width-swapButton.width
        anchors.top:parent.top
        anchors.left: parent.left
        KeyNavigation.tab: destinationField
    }

    TextField {
        id: destinationField
        placeholderText: qsTr("Destination...")
        width: parent.width-swapButton.width
        anchors.top:originField.bottom
        anchors.left: parent.left
    }


    Button {
        id: swapButton
        iconSource: "../icons/swap.png"
        anchors.top:parent.top
        anchors.left: destinationField.right
        height:destinationField.height*2
        onClicked: {
            var temp = destinationField.searchText
            destinationField.searchText = originField.searchText
            originField.searchText = temp
            swapButton.focus = true
        }
    }


    SelectionListItem {
        id:selectionListItm
        title: (__departure ? qsTr("Departure") : qsTr("Arrival"))
        subTitle:  (__datetimeSpecified ? (__datetime.toLocaleString()) : qsTr("Right now"))
        anchors.top:destinationField.bottom
        function __onDialogAccepted() {
            __departure = datetimeDialog.departure
            __datetime = datetimeDialog.datetime
            __datetimeSpecified = datetimeDialog.specified
        }

        width: parent.width
        onClicked: {
            if (!datetimeDialog) {
                datetimeDialog = Utils.loadObjectByPath("components/TravelTimeDialog.qml", page)
                datetimeDialog.accepted.connect(__onDialogAccepted)
            }
            datetimeDialog.departure = __departure
            datetimeDialog.datetime = __datetime
            datetimeDialog.specified = __datetimeSpecified
            datetimeDialog.open()
        }
    }


    ListView {
        id: historyView

        anchors {
            left: parent.left
            right: parent.right
            top: selectionListItm.bottom
            bottom: parent.bottom
            topMargin: platformStyle.paddingLarge
        }

        clip: true
        model: historyModel
        header: Component {
            ListItem {
                id: item
                subItemIndicator: true

                // FIXME: silence some errors
                property int index: 0

                ListItemText {
                    anchors.fill: item.paddingItem
                    text: qsTr("New query")
                }

                onClicked: {
                    if (originField.text === "" || destinationField.text === "") {
                        banner.text = qsTr("Please fill out both station fields")
                        banner.open()
                    } else {
                        var connection = {"origin": originField.text,
                            "destination": destinationField.text,
                            "datetimeSpecified": __datetimeSpecified,
                            "datetime": __datetimeSpecified ? __datetime : new Date(),
                                                              "departure": __departure,
                                                              "favorite": false}
                        historyModel.addConnection(connection)
                        loadConnection(connection)
                    }
                }
            }
        }

        delegate: historyDelegate
    }

    InfoBanner {
        id: banner
    }


    //
    // Data
    //

    ListModel {
        id: historyModel

        Component.onCompleted: {
            Storage.getConnections(historyModel)
        }

        function addConnection(connection) {
            Storage.addConnection(connection)
            Storage.getConnections(historyModel)
        }
    }

    Component {
        id: historyDelegate

        ListItem {
            id: item
            subItemIndicator: true

            Row {
                spacing: platformStyle.paddingMedium
                width:parent.width
                Image {

                    id: favoriteIcon
                    source: privateStyle.imagePath("qtg_graf_rating_rated", page.platformInverted)
                    anchors.verticalCenter: parent.verticalCenter
                    states: [
                        State { name: "Favorite"; when: favorite
                            PropertyChanges {target: favoriteIcon; opacity: 1}
                        },
                        State { name: "History"; when: !favorite
                            PropertyChanges {target: favoriteIcon; opacity: 0.1}
                        }
                    ]
                    transitions: [
                        Transition { from: "Favorite"; to: "History"; reversible: true
                            NumberAnimation { properties: "opacity"; duration: 250 }
                        }
                    ]
                }


                Column {
                    id: column1

                    ListItemText {
                        id: connectionText
                        mode: item.mode
                        role: "Title"
                        text: origin + " → " + destination
                        font.capitalization: Font.Capitalize
                    }
                    ListItemText {
                        id: datetimeText
                        mode: item.mode
                        role: "SubTitle"
                        text: {
                            var datetimeString
                            if (departure) {
                                if (datetimeSpecified)
                                    datetimeString = qsTr("Depart at %1").arg((new Date(datetime)).toLocaleString())
                                else
                                    datetimeString = qsTr("Depart right now")
                            } else {
                                if (datetimeSpecified)
                                    datetimeString = qsTr("Arrive at %1").arg((new Date(datetime)).toLocaleString())
                                else
                                    datetimeString = qsTr("Arrive right now")
                            }
                            return datetimeString
                        }
                    }
                }
                Column {
                    id: editFavouriteCollumn
                    visible:_editHistory
                     anchors.right: removeItemCollumn.left

                    width:50
                    Button {
                        id: favouriteButton
                        visible:_editHistory
                        iconSource:privateStyle.imagePath("qtg_graf_rating_rated", page.platformInverted)
                        anchors.verticalCenter: parent.verticalCenter

                        onClicked: {
                            var connection = historyModel.get(index)
                            connection.favorite = !connection.favorite
                            Storage.updateConnection(connection)
                            historyModel.set(index, connection)
                        }
                    }
                }

                Column {

                    id: removeItemCollumn
                    visible:_editHistory
                    width:50
                    anchors.right: parent.right
                    Button {
                        id: removeButton
                        iconSource:"../icons/close.svg"
                        anchors.verticalCenter: parent.verticalCenter
                        visible:_editHistory
                                            onClicked: {
                            var connection = historyModel.get(index)
                            Storage.removeConnection(connection)
                            Storage.getConnections(historyModel)
                        }

                    }
                }

           }

            onPressAndHold: {
                _editHistory=!_editHistory
            }

            onClicked: {
                var connection = historyModel.get(index)
                if (!connection.datetimeSpecified)
                    connection.datetime = new Date()
                loadConnection(connection)
            }
        }
    }


    //
    // Objects
    //

    property variant connectionsPage
    property variant datetimeDialog


    //
    // Auxiliary
    //

    function loadConnection(connection) {
        if (!connectionsPage)
            connectionsPage = Utils.loadObjectByPath("pages/ConnectionsPage.qml", page)

        pageStack.push(connectionsPage, {
                           origin: connection.origin,
                           destination: connection.destination,
                           datetime: connection.datetime,
                           departure: connection.departure,
                           lockDatetime: connection.datetimeSpecified});
    }
}
