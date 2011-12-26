import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent

    property alias origin: connectionsModel.origin
    property alias destination: connectionsModel.destination
    property alias usedatetime: connectionsModel.usedatetime
    property alias datetime: connectionsModel.datetime
    onStatusChanged: {
        if(status == PageStatus.Activating) {
            connectionsModel.setSource()
        }
    }


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
        id: connectionsView

        anchors {
            fill: parent
            margins: platformStyle.paddingMedium
        }

        clip: true
        model: connectionsModel
        delegate: connectionsDelegate
    }    

    Text {
        anchors.centerIn: parent
        visible: if (connectionsModel.count > 0) false; else true;
        text: "Loading..."
        color: platformStyle.colorDisabledLight
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
                source = "http://data.irail.be/NMBS/Connections/" + origin + "/" + destination
                if (usedatetime) {
                    var datestring = Qt.formatDate(datetime, "ddMMyy")
                    var timestring = (datetime.getHours() < 10 ? ("0".datetime.getHours()) : datetime.getHours()) + Qt.formatTime(datetime, "mm")
                    source = source + "/" + datestring + "/" + timestring
                }
                source = source + ".xml"
            }
        }

        source: ""
        query: "/connections/Connections"

        XmlRole { name: "origin"; query: "departure/station/name/string()"; isKey: true }
        XmlRole { name: "departure"; query: "departure/time/string()"; isKey: true }
        XmlRole { name: "departuredelay"; query: "departure/delay/number()"; isKey: true }

        XmlRole { name: "destination"; query: "arrival/station/name/string()"; isKey: true }
        XmlRole { name: "arrival"; query: "arrival/time/string()"; isKey: true }

        XmlRole { name: "duration"; query: "duration/number()"; }
    }

    Component {
        id: connectionsDelegate

        ListItem {
            id: item
            subItemIndicator: true

            Column {
//                ListItemText {
//                    id: viaText
//                    mode: item.mode
//                    role: "Title"
//                    text: vias > 0 ? "Via " + vias + " others" : "Direct"
//                }
                ListItemText {
                    id: durationText
                    mode: item.mode
                    role: "SubTitle"
                    text: "Duration: " + Utils.readableDuration(duration)
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
                    text: departuredelay > 0 ? "+" + Utils.readableDuration(departuredelay) : ""
                }

            }
        }
    }
}
