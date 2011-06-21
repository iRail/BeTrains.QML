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

        // Refresg
        ToolButton {
            iconSource: "toolbar-refresh"
            enabled: false
            onClicked: pageStack.push(secondPage)
        }

        // Make request
        ToolButton {
            iconSource: "toolbar-search"
            enabled: stationName.text !== ""
            onClicked: {
            }
        }
    }


    //
    // Contents
    //

    ListView {
        anchors.fill: parent
        clip: true
        id: liveboardView
        model: liveboardModel
        delegate: liveboardDelegate
        header: liveboardHeader
    }


    //
    // Data
    //

    XmlListModel {
        id: liveboardModel

        source: "http://api.irail.be/liveboard.php?station=gent"
        query: "/liveboard/departures/departure"

        XmlRole { name: "station"; query: "station/string()" }
        XmlRole { name: "time"; query: "time/string()" }
        XmlRole { name: "delay"; query: "@delay/string()" }
        XmlRole { name: "vehicle"; query: "vehicle/string()" }
        XmlRole { name: "platform"; query: "platform/string()" }
    }

    Component {
        id: liveboardHeader

        TextField {
            anchors { left: parent.left; right: parent.right; }
            id: stationName
            placeholderText: "station"
        }
    }

    Component {
        id: liveboardDelegate

        ListItem {
            id: item
            Column {
                ListItemText {
                    id: stationText
                    mode: item.mode
                    role: "Title"
                    text: station
                }
                ListItemText {
                    id: platformText
                    mode: item.mode
                    role: "SubTitle"
                    text: "Platform " + platform
                }
            }
            Column {
                anchors.right: parent.right
                ListItemText {
                    id: timeText
                    mode: item.mode
                    role: "Title"
                    text: Qt.formatTime(new Date(1000*time))
                }
                ListItemText {
                    id: delayText
                    mode: item.mode
                    role: "SubTitle"
                    text: delay > 0 ? "+"+delay : ""
                }
            }
        }
    }

}
