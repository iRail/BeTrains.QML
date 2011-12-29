import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../js/utils.js" as Utils


Page {
    id: page
    anchors.fill: parent


    //
    // Toolbar
    //

    tools: ToolBarLayout {
        id: toolBar

        // Back buton
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked:
                pageStack.pop()
        }

        // Refresh
        ToolButton {
            id: refreshButton
            iconSource: "toolbar-refresh"
            onClicked:
                liveboardModel.reload()
            enabled:
                stationField.text.length > 0
        }
    }


    //
    // Contents
    //

    StationField {
        id: stationField
        placeholderText: "Station..."
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: platformStyle.paddingMedium
        }

        DelayedPropagator {
            id: inactivityTracker
            delay: 750

            input: stationField.text
            onInputChanged: liveboardModel.station = ""
            onOutputChanged: liveboardModel.station = output
        }
    }

    ListView {
        id: liveboardView
        anchors {
            top: stationField.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: platformStyle.paddingMedium
        }
        clip: true
        model: liveboardModel
        delegate: liveboardDelegate
    }

    Text {
        anchors.centerIn: liveboardView
        visible: if (liveboardModel.count > 0) false; else true;
        text: {
            switch (liveboardModel.status) {
            case XmlListModel.Loading:
                return "Loading..."
            case XmlListModel.Error:
                return "Error!"
            case XmlListModel.Ready:
                if (liveboardModel.source.toString())
                    return "No results"
                // Deliberate fall-through
            case XmlListModel.Null:
                return "Enter a station"
            }
        }
        color: platformStyle.colorDisabledLight
    }


    //
    // Data
    //

    XmlListModel {
        id: liveboardModel

        property string station
        onStationChanged: {
            source = ""
            if (station !== "")
                source = "http://data.irail.be/NMBS/Liveboard/" + station + ".xml"
        }

        source: ""
        query: "/liveboard/Liveboard/departures"

        XmlRole { name: "destination"; query: "direction/string()"; isKey: true}
        XmlRole { name: "time"; query: "time/number()"; isKey: true }
        XmlRole { name: "vehicle"; query: "vehicle/string()"; isKey: true }
        XmlRole { name: "delay"; query: "delay/number()" }
        XmlRole { name: "platform"; query: "platform/name/string()" }
    }

    Component {
        id: liveboardDelegate

        ListItem {
            id: item
            subItemIndicator: true

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
                width: Math.max(timeText.width, delayText.width) + platformStyle.graphicSizeSmall
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
                    text: delay > 0 ? "+" + Utils.readableDuration(delay) : ""
                }
            }

            onClicked: {
                vehiclePage = Utils.getDynamicObject(vehiclePage, vehicleComponent, page)
                pageStack.push(vehiclePage, {id: vehicle});
            }
        }
    }


    //
    // Dynamic components
    //

    property VehiclePage vehiclePage
    Component {
        id: vehicleComponent
        VehiclePage {
            id: vehicle
        }
    }
}
