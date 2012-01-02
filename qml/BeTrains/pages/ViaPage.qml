import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent

    property alias xml: viaModel.xml
    property alias id: viaModel.id

    onStatusChanged: {
        if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            id = -1
        }
    }


    //
    // Contents
    //

    ListView {
        id: viaView

        anchors {
            fill: parent
            margins: platformStyle.paddingMedium
        }
        visible: viaModel.valid

        clip: true
        model: viaModel
        delegate: viaDelegate
    }

    Text {
        anchors.centerIn: viaView
        visible: if (!viaModel.valid || viaModel.count <= 0) true; else false;
        text: {
            switch (viaModel.status) {
            case XmlListModel.Error:
                return "Error!"
            case XmlListModel.Ready:
                return "No results"
            default:
                return ""
            }
        }
        color: platformStyle.colorDisabledLight
        font.pixelSize: platformStyle.fontSizeLarge
    }

    BusyIndicator {
        anchors.centerIn: viaView
        visible: if (viaModel.status === XmlListModel.Loading) true; else false
        running: true
        height: viaView.height / 10
        width: height
    }


    //
    // Data
    //

    XmlListModel {
        id: viaModel

        property int id

        property bool valid
        valid: if (id !== -1 && status === XmlListModel.Ready) true; else false;

        query: "/connections/Connections[" + (id + 1) + "]/via"

        XmlRole { name: "station"; query: "station/name/string()"; isKey: true }

        XmlRole { name: "arrival"; query: "arrival/time/number()"; isKey: true }
        XmlRole { name: "arrival_platform"; query: "arrival/platform/name/string()"; }

        XmlRole { name: "departure"; query: "departure/time/number()"; isKey: true }
        XmlRole { name: "departure_platform"; query: "departure/platform/name/string()"; }

        XmlRole { name: "direction"; query: "direction/string()"; isKey: true }
    }

    Component {
        id: viaDelegate

        ListItem {
            id: item

            Column {
                anchors.fill: item.paddingItem
                id: column1

                ListItemText {
                    id: stationText
                    mode: item.mode
                    role: "Title"
                    text: "Transfer at " + station
                }
                ListItemText {
                    id: directionText
                    mode: item.mode
                    role: "SubTitle"
                    text: "Towards " + direction
                }
            }
            Column {
                id: column2
                anchors {
                    top: column1.top
                    right: parent.right
                    rightMargin: platformStyle.paddingMedium
                }

                width: Math.max(arrText.width, depText.width)
                ListItemText {
                    id: arrText
                    mode: item.mode
                    role: "Title"
                    text: "Platform " + arrival_platform + ", " + Utils.readableTime(Utils.getDateTime(arrival))
                }
                ListItemText {
                    id: depText
                    mode: item.mode
                    role: "Title"
                    text: "Platform " + departure_platform + ", " + Utils.readableTime(Utils.getDateTime(departure))
                }
            }
        }
    }
}
