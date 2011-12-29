import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: page
    anchors.fill: parent
    property alias id: vehicleModel.vehicle

    onStatusChanged: {
        if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            vehicleModel.source = ""
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
    }


    //
    // Contents
    //

    ListView {
        id: vehicleView

        anchors {
            fill: parent
            margins: platformStyle.paddingMedium
        }

        clip: true
        model: vehicleModel
        delegate: vehicleDelegate
    }

    Text {
        anchors.centerIn: vehicleView
        visible: if (vehicleModel.count > 0) false; else true;
        text: {
            switch (vehicleModel.status) {
            case XmlListModel.Loading:
                return "Loading..."
            case XmlListModel.Error:
                return "Error!"
            case XmlListModel.Ready:
                return "No results"
            }
        }
        color: platformStyle.colorDisabledLight
    }


    //
    // Data
    //

    XmlListModel {
        id: vehicleModel

        property string vehicle
        onVehicleChanged: {
            source = ""
            if (vehicle !== "")
                source = "http://api.irail.be/vehicle.php?id=" + vehicle
        }

        source: ""
        query: "/vehicleinformation/stops/stop"

        XmlRole { name: "station"; query: "station/string()"; isKey: true}
        XmlRole { name: "time"; query: "time/string()"; isKey: true }
        XmlRole { name: "delay"; query: "@delay/string()" }
    }

    Component {
        id: vehicleDelegate

        ListItem {
            id: item
            Column {
                ListItemText {
                    id: stationText
                    mode: item.mode
                    role: "Title"
                    text: station
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
