import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent
    property alias source: connectionModel.source
    property alias id: connectionModel.id

    onStatusChanged: {
        if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            connectionModel.source = ""
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
            onClicked: connectionModel.reload()
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
