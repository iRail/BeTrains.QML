import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent

    property alias id: vehicleModel.vehicle
    property alias datetime: vehicleModel.datetime

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            vehicleModel.update()
        } else if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            id = ""
            datetime = new Date()
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
                if (!window.menu)
                    window.menu = Utils.loadObjectByComponent(menuComponent, window)
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
        visible: vehicleModel.valid
        clip: true
        model: vehicleModel
        delegate: vehicleDelegate
    }

    Text {
        anchors.centerIn: vehicleView
        visible: if (!vehicleModel.valid || vehicleModel.count <= 0) true; else false;
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
        font.pixelSize: platformStyle.fontSizeLarge
    }


    //
    // Data
    //

    XmlListModel {
        id: vehicleModel

        property string vehicle
        property date datetime

        function update() {
            vehicle = vehicle.replace('BE.NMBS.', '') // FIXME: working around API bug
            if (vehicle !== "")
                source = "http://data.irail.be/NMBS/Vehicle/" + vehicle + "/" + Utils.generateDateUrl(datetime) + ".xml"
        }

        property bool valid
        valid: if (vehicle !== "" && status === XmlListModel.Ready) true; else false;

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
                    color: "red"
                    visible: if (delay > 0) true; else false
                    text: Utils.readableDuration(delay)
                }
            }
        }
    }
}
