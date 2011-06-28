import QtQuick 1.0
import com.nokia.symbian 1.1
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent
    property alias source: connectionModel.source
    property alias id: connectionModel.id


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
            onClicked: connectionModel.reload()
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
        id: connectionView
        model: connectionModel
        delegate: connectionDelegate
    }


    //
    // Data
    //

    XmlListModel {
        id: connectionModel

        property string id
        query: "/connection/connection[id=" + id + "]"
    }

    Component {
        id: connectionDelegate

        ListItem {
            id: item
        }
    }
}
