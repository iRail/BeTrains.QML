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
            // FIXME: revert this to .source when removing the data fetching workaround
            connectionModel.xml = ""
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
        id: connectionView

        anchors {
            fill: parent
            margins: platformStyle.paddingMedium
        }

        clip: true
        model: connectionModel
        delegate: connectionDelegate
    }

    Text {
        anchors.centerIn: connectionView
        visible: if (connectionModel.count > 0) false; else true;
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
    }


    //
    // Data
    //

    XmlListModel {
        id: connectionModel

        property int id
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
                    text: "Platform " + arrival_platform + ", " + Qt.formatTime(new Date(1000*arrival))
                }
                ListItemText {
                    id: depText
                    mode: item.mode
                    role: "Title"
                    text: "Platform " + departure_platform + ", " + Qt.formatTime(new Date(1000*departure))
                }
            }
        }
    }
}
