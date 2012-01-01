import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent

    property alias xml: connectionModel.xml
    property alias id: connectionModel.id

    onStatusChanged: {
        if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            id = -1
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
        id: connectionView

        anchors {
            fill: parent
            margins: platformStyle.paddingMedium
        }
        visible: connectionModel.valid

        clip: true
        model: connectionModel
        delegate: connectionDelegate
    }

    Text {
        anchors.centerIn: connectionView
        visible: if (!connectionModel.valid || connectionModel.count <= 0) true; else false;
        text: {
            switch (connectionModel.status) {
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
        id: connectionModel

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
        id: connectionDelegate

        ListItem {
            id: item

            Column {
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
                anchors.right: parent.right
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
