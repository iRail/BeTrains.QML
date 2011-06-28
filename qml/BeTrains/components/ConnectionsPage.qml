import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: page
    anchors.fill: parent
    property alias origin: connectionsModel.origin
    property alias destination: connectionsModel.destination
    property alias usedatetime: connectionsModel.usedatetime
    property alias datetime: connectionsModel.datetime
    property bool ready

    onReadyChanged: connectionsModel.setSource()


    //
    // Toolbar
    //

    tools: ToolBarLayout {
        id: toolBar

        // Back buton
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }

        // Refresh
        ToolButton {
            id: refreshButton
            iconSource: "toolbar-refresh"
            onClicked: connectionsModel.reload()
        }
    }


    //
    // Contents
    //

    ListView {
        anchors {
            fill: parent
            margins: platformStyle.paddingMedium
        }

        clip: true
        id: connectionsView
        model: connectionsModel
        delegate: connectionsDelegate
    }


    //
    // Data
    //

    XmlListModel {
        id: connectionsModel

        property string origin
        property string destination
        property bool usedatetime: false
        property date datetime

        function setSource() {
            if (origin !== "" && destination !== "") {
                source = "http://api.irail.be/connections.php?from=" + origin + "&to=" + destination
                if (usedatetime) {
                    var datestring = Qt.formatDate(datetime, "ddMMyy")
                    var timestring = (datetime.getHours() < 10 ? ("0".datetime.getHours()) : datetime.getHours()) + Qt.formatTime(datetime, "mm")
                    source = source + "&date=" + datestring + "&time=" + timestring
                }
            }
        }

        source: ""
        query: "/connections/connection"

        XmlRole { name: "id"; query: "@id/string()"; }
        XmlRole { name: "origin"; query: "departure/station/string()"; isKey: true }
        XmlRole { name: "departure"; query: "departure/time/string()"; isKey: true }
        XmlRole { name: "departuredelay"; query: "departure/@delay/string()"; isKey: true }
        XmlRole { name: "destination"; query: "arrival/station/string()"; isKey: true }
        XmlRole { name: "arrival"; query: "arrival/time/string()"; isKey: true }
        XmlRole { name: "duration"; query: "duration/string()"; }
        XmlRole { name: "vias"; query: "vias/@number/string()"; }
    }

    Component {
        id: connectionsDelegate

        ListItem {
            id: item
            subItemIndicator: true

            Column {
                ListItemText {
                    id: viaText
                    mode: item.mode
                    role: "Title"
                    text: vias > 0 ? "Via " + vias + " others" : "Direct"
                }
                ListItemText {
                    id: durationText
                    mode: item.mode
                    role: "SubTitle"
                    text: "Duration: " + readableDuration(duration)
                }
            }
            Column {
                anchors.right: parent.right
                width: Math.max(timeText.width, delayText.width) + platformStyle.graphicSizeSmall
                ListItemText {
                    id: timeText
                    mode: item.mode
                    role: "Title"
                    text: Qt.formatTime(new Date(1000*departure))
                }
                ListItemText {
                    id: delayText
                    mode: item.mode
                    role: "SubTitle"
                    text: departuredelay > 0 ? "+ " + readableDuration(departuredelay) : ""
                }

            }
        }
    }

    function readableDuration(seconds) {
        var output = ""

        var hours = Math.floor(seconds / 3600)
        if (hours > 0) {
            output = hours + "h"
            seconds = seconds - hours*3600
        }

        var minutes = Math.floor(seconds / 60)
        if (minutes > 0) {
            if (output.length > 0)
                output = output + " "
            output = output + minutes + "m"
            seconds = seconds - minutes*60
        }

        return output
    }
}
