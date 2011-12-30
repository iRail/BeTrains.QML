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
        if (status === PageStatus.Activating) {
            connectionsModel.setSource()
        }
        else if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            // FIXME: revert this to .source when removing the data fetching workaround
            connectionsModel.xml = ""
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
        id: connectionsStatus
        anchors.centerIn: connectionsView
        visible: if (connectionsModel.count > 0) false; else true;
        text: {
            switch (connectionsModel.status) {
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
        id: connectionsModel

        property string origin
        property string destination
        property bool usedatetime: false
        property date datetime

        function setSource() {
            if (origin !== "" && destination !== "") {
                var source = "http://data.irail.be/NMBS/Connections/" + origin + "/" + destination
                if (usedatetime) {
                    var datestring = Qt.formatDate(datetime, "ddMMyy")
                    var timestring = (datetime.getHours() < 10 ? ("0".datetime.getHours()) : datetime.getHours()) + Qt.formatTime(datetime, "mm")
                    source = source + "/" + datestring + "/" + timestring
                }
                source = source + ".xml"

                // FIXME: this is a work-around, using a separate XMLHttpRequest object so we actually
                // have access to the downloaded source afterwards (in order to pass it to the ConnectionPage).
                // FIX 1: get access to the model its xml property after having used the source property
                // FIX 2: use a XPath function to acquire the source of a connection
                // FIX 3: use a hierarchical ListView (TreeView)
                var doc = new XMLHttpRequest();
                doc.onreadystatechange = function() {
                    if (doc.readyState === XMLHttpRequest.DONE) {
                        connectionsModel.xml = doc.responseText
                    }
                }
                connectionsStatus.text = "Loading..."
                doc.open("GET", source);
                doc.send();
            }
        }

        query: "/connections/Connections"

        XmlRole { name: "origin"; query: "departure/station/name/string()"; isKey: true }
        XmlRole { name: "departure"; query: "departure/time/string()"; isKey: true }
        XmlRole { name: "delay"; query: "departure/delay/number()"; }
        XmlRole { name: "vias"; query: "count(via)"; }

        XmlRole { name: "destination"; query: "arrival/station/name/string()"; isKey: true }
        XmlRole { name: "arrival"; query: "arrival/time/string()"; isKey: true }

        XmlRole { name: "duration"; query: "duration/number()"; }
    }

    Component {
        id: connectionsDelegate

        ListItem {
            id: item
            subItemIndicator: if (vias > 0) true; else false;

            Column {
                ListItemText {
                    id: connectionText
                    mode: item.mode
                    role: "Title"
                    text: origin + " to " + destination
                }
                ListItemText {
                    id: durationText
                    mode: item.mode
                    role: "SubTitle"
                    text: Utils.readableDuration(duration) + " en route, " + (vias > 0 ? ("via " + vias + " others") : "direct")
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
                    text: delay > 0 ? "+" + Utils.readableDuration(delay) : ""
                }
            }

            onClicked: {
                if (vias === 0)
                    return;
                viaPage = Utils.getDynamicObject(viaPage, viaComponent, page)
                pageStack.push(viaPage, {xml: connectionsModel.xml, id: connectionsView.currentIndex});
            }
        }
    }


    //
    // Dynamic components
    //

    property ViaPage viaPage
    Component {
        id: viaComponent
        ViaPage {}
    }
}
