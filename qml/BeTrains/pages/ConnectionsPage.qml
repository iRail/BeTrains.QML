import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent

    property alias origin: connectionsModel.origin
    property alias destination: connectionsModel.destination
    property alias datetime: connectionsModel.datetime
    property alias arrival: connectionsModel.arrival

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            connectionsModel.update()
        } else if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            origin = ""
            destination = ""
            datetime = new Date()
            arrival = false
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
        visible: if (connectionsModel.valid) true; else false

        clip: true
        model: connectionsModel
        delegate: connectionsDelegate
    }

    Text {
        id: connectionsStatus
        anchors.centerIn: connectionsView
        visible: if (!connectionsModel.valid || connectionsModel.count <= 0) true; else false
        text: {
            // WORKAROUND
            if (connectionsModel.loading)
                return "Loading..."
            else if (connectionsModel.error)
                return "Error!"

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
        font.pixelSize: platformStyle.fontSizeLarge
    }


    //
    // Data
    //

    XmlListModel {
        id: connectionsModel

        property string origin
        property string destination
        property date datetime
        property bool arrival
        property string _source: ""

        function update() {
            if (origin !== "" && destination !== "") {
                var source = "http://data.irail.be/NMBS/Connections/" + origin + "/" + destination + "/" + Utils.generateDateUrl(datetime) + ".xml"
                if (arrival)
                    source = source + "?timeSel=arrival"

                // WORKAROUND: this is a work-around, using a separate XMLHttpRequest object so we actually
                // have access to the downloaded source afterwards (in order to pass it to the ConnectionPage).
                // FIX 1: get access to the model its xml property after having used the source property
                // FIX 2: use a XPath function to acquire the source of a connection
                // FIX 3: use a hierarchical ListView (TreeView)
                if (source !== _source) {
                    var doc = new XMLHttpRequest();
                    doc.onreadystatechange = function() {
                                if (doc.readyState === XMLHttpRequest.DONE) {
                                    if (doc.status != 200) {
                                        error = true
                                        loading = false
                                    } else {
                                        error = false
                                        loading = false
                                        connectionsModel.xml = doc.responseText
                                    }
                                }
                            }
                    loading = true
                    doc.open("GET", source);
                    doc.send();

                    // NOTE: this is to prevent redundant fetches when an identical source is configured
                    // (the XmlListModel doesn't refetch either when passed an identical source, does it?)
                    _source = source
                }
            }
        }

        // WORKAROUND: properties indicating the status of the XML fetch, as we can't (due to our
        // workaround) check the XmlListModel for them
        property bool loading: false
        property bool error: false

        property bool valid
        valid: if (origin !== "" && destination !== "" && status === XmlListModel.Ready && !loading && !error) true; else false;

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
                width: Math.max(timeText.width, delayText.width)
                ListItemText {
                    id: timeText
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        horizontalCenterOffset: -platformStyle.graphicSizeSmall
                    }
                    mode: item.mode
                    role: "Title"
                    text: Utils.readableTime(Utils.getDateTime(departure))
                }
                ListItemText {
                    id: delayText
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        horizontalCenterOffset: -platformStyle.graphicSizeSmall
                    }
                    color: "red"
                    mode: item.mode
                    role: "SubTitle"
                    visible: if (delay > 0) true; else false
                    text: "+" + Utils.readableDuration(delay)
                }
            }

            onClicked: {
                if (vias === 0)
                    return;
                if (!viaPage)
                    viaPage = Utils.loadObjectByPath("pages/ViaPage.qml", page)
                pageStack.push(viaPage, {xml: connectionsModel.xml, id: connectionsView.currentIndex});
            }
        }
    }


    //
    // Objects
    //

    property Page viaPage
}
