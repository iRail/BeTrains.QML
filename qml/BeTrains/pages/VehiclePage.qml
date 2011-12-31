import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Utils

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
        // Back buton
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }

        // Menu
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: {
                window.menu = Utils.getDynamicObject(window.menu, menuComponent, window)
                window.menu.open()
            }
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
            vehicle = vehicle.replace('BE.NMBS.', '') // FIXME: working around API bug
            if (vehicle !== "")
                source = "http://data.irail.be/NMBS/Vehicle/" + vehicle + ".xml"
        }

        source: ""
        query: "/vehicle/Vehicle/stops"

        XmlRole { name: "station"; query: "station/name/string()"; isKey: true}
        XmlRole { name: "time"; query: "time/number()"; isKey: true }
        XmlRole { name: "delay"; query: "delay/number()" }
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
                    text: Utils.readableTime(Utils.getDateTime(time))
                }
                ListItemText {
                    id: delayText
                    mode: item.mode
                    role: "SubTitle"
                    text: delay > 0 ? "+" + Utils.readableDuration(delay) : ""
                }
            }
        }
    }
}
