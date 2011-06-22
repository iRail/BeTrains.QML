import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: page
    anchors.fill: parent


    //
    // Toolbar
    //

    tools: ToolBarLayout {
        id: toolBar

        // Quit buton
        // TODO: quit logo
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        // Refresh
        ToolButton {
            id: refreshButton
            iconSource: "toolbar-refresh"
            onClicked: liveboardModel.reload()
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

        property string station
        onStationChanged: {
            if (station !== "")
                source = "http://api.irail.be/liveboard.php?station=" + station
            else
                source = ""
        }

        source: ""
        query: "/liveboard/departures/departure"

        XmlRole { name: "destination"; query: "station/string()"; isKey: true}
        XmlRole { name: "time"; query: "time/string()"; isKey: true }
        XmlRole { name: "vehicle"; query: "vehicle/string()"; isKey: true }
        XmlRole { name: "delay"; query: "@delay/string()" }
        XmlRole { name: "platform"; query: "platform/string()" }
    }

    Component {
        id: liveboardHeader
        TextField {
            anchors { left: parent.left; right: parent.right; }
            id: stationName
            placeholderText: "station"

            DelayedPropagator {
                id: inactivityTracker
                delay: 500
            }
            Binding {
                target: inactivityTracker; property: 'input'
                value: text
            }
            Binding {
                target: liveboardModel; property: 'station'
                value: inactivityTracker.output
            }

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
                    text: destination
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
                    text: delay > 0 ? "+"+delay/60 + " min" : ""
                }
            }
        }
    }
}
