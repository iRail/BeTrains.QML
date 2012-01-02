import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../components"
import "../js/utils.js" as Utils


Page {
    id: page
    anchors.fill: parent


    //
    // Contents
    //

    SearchBox {
        id: liveboardHeader
        width: parent.width
        anchors {
            left: parent.left
            right: parent.right
        }
        placeHolderText: "Station..."

        property alias entering: inactivityTracker.active
        DelayedPropagator {
            id: inactivityTracker
            delay: 750
            property bool active: false

            input: liveboardHeader.searchText
            onInputChanged: {
                active = true
                liveboardModel.station = ""
                liveboardModel.update()
            }
            onOutputChanged: {
                active = false
                liveboardModel.station = output
                liveboardModel.update()
            }
        }
    }

    ListView {
        id: liveboardView
        anchors {
            top: liveboardHeader.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: platformStyle.paddingMedium
        }
        visible: if (liveboardModel.valid && !liveboardHeader.entering) true; else false
        clip: true
        model: liveboardModel
        delegate: liveboardDelegate
    }

    Text {
        anchors.centerIn: liveboardView
        visible: if (!liveboardModel.valid || liveboardHeader.entering || liveboardModel.count <= 0) true; else false
        text: {
            switch (liveboardModel.status) {
            case XmlListModel.Error:
                return "Error!"
            case XmlListModel.Ready:
                if (liveboardModel.valid)
                    return "No results"
                // Deliberate fall-through
            case XmlListModel.Null:
                return "Enter a station"
            default:
                return ""
            }
        }
        color: platformStyle.colorDisabledLight
        font.pixelSize: platformStyle.fontSizeLarge
    }

    BusyIndicator {
        anchors.centerIn: liveboardView
        visible: if (liveboardModel.status === XmlListModel.Loading) true; else false
        running: true
        height: liveboardView.height / 10
        width: height
    }


    //
    // Data
    //

    XmlListModel {
        id: liveboardModel

        property string station
        property date datetime: new Date()

        function update() {
            if (station !== "")
                source = "http://data.irail.be/NMBS/Liveboard/" + station + "/" + Utils.generateDateUrl(datetime) + ".xml"
        }

        property bool valid
        valid: if (station !== "" && status === XmlListModel.Ready) true; else false;

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
                    visible: if (platform !== "") true; else false
                    text: "Platform " + platform
                }
            }
            Column {
                anchors.right: parent.right
                width: Math.max(timeText.width, delayText.width)
                ListItemText {
                    id: timeText
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        horizontalCenterOffset: -platformStyle.graphicSizeSmall
                    }
                    mode: item.mode
                    role: "Title"
                    text: Utils.readableTime(Utils.getDateTime(time))
                }
                ListItemText {
                    id: delayText
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        horizontalCenterOffset: -platformStyle.graphicSizeSmall
                    }
                    color: "red"
                    mode: item.mode
                    role: "SubTitle"
                    visible: if (delay > 0) true; else false
                    text: "+" + Utils.readableDuration(delay)
                }
            }

            onClicked: {
                if (!vehiclePage)
                    vehiclePage = Utils.loadObjectByPath("pages/VehiclePage.qml", page)
                pageStack.push(vehiclePage, {id: vehicle, datetime: Utils.getDateTime(time)});
            }
        }
    }


    //
    // Objects
    //

    property Page vehiclePage
}
