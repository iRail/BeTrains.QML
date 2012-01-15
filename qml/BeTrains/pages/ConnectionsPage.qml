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
    property alias departure: connectionsModel.departure
    property bool lockDatetime

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            connectionsModel.update(false)
        } else if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            origin = ""
            destination = ""
            datetime = new Date()
            lockDatetime = true
            departure = true
        }
    }


    //
    // Contents
    //

    Column {
        id: information
        width: parent.width
        anchors {
            top: parent.top
            bottomMargin: platformStyle.paddingLarge
            margins: platformStyle.paddingMedium
        }

        Row {
            width: parent.width
            Text {
                text: qsTr("From: ")
                color: platformStyle.colorDisabledLight
                font.pixelSize: platformStyle.fontSizeLarge
            }
            Text {
                text: {
                    if (connectionsModel.valid && connectionsModel.count > 0)
                        return connectionsModel.get(0).origin
                    else
                        return origin
                }

                color: platformStyle.colorNormalLight
                font.pixelSize: platformStyle.fontSizeLarge
            }
        }

        Row {
            width: parent.width
            Text {
                text: qsTr("To: ")
                color: platformStyle.colorDisabledLight
                font.pixelSize: platformStyle.fontSizeLarge
            }
            Text {
                text: {
                    if (connectionsModel.valid && connectionsModel.count > 0)
                        return connectionsModel.get(0).destination
                    else
                        return destination
                }

                color: platformStyle.colorNormalLight
                font.pixelSize: platformStyle.fontSizeLarge
            }
        }
    }

    ListView {
        id: connectionsView
        width: parent.width
        anchors {
            top: information.bottom
            bottom: parent.bottom
            margins: platformStyle.paddingMedium
        }
        visible: if (connectionsModel.valid) true; else false

        clip: true
        model: connectionsModel
        delegate: connectionsDelegate
        header: connectionsHeader
    }

    Text {
        id: connectionsStatus
        anchors.centerIn: connectionsView
        visible: if (!connectionsModel.valid || connectionsModel.count <= 0) true; else false
        text: {
            // WORKAROUND
            if (connectionsModel.loading)
                return ""
            else if (connectionsModel.error)
                return qsTr("Error!")

            switch (connectionsModel.status) {
            case XmlListModel.Error:
                return qsTr("Error!")
            case XmlListModel.Ready:
                return qsTr("No results")
            default:
                return ""
            }
        }
        color: platformStyle.colorDisabledLight
        font.pixelSize: platformStyle.fontSizeLarge
    }

    Component {
        id: connectionsHeader

        PullDownHeader {
            view: connectionsView
            onPulled: {
                if (!lockDatetime)
                    datetime = new Date()
                connectionsModel.update(true)
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: connectionsView
        visible: if (connectionsModel.status === XmlListModel.Loading || connectionsModel.loading) true; else false
        running: true
        height: connectionsView.height / 10
        width: height
    }


    //
    // Data
    //

    XmlListModel {
        id: connectionsModel

        property string origin
        property string destination
        property date datetime
        property bool departure
        property string _source: ""

        function update(forceReload) {
            if (origin !== "" && destination !== "") {
                var source = "http://data.irail.be/NMBS/Connections/" + origin + "/" + destination + "/" + Utils.generateDateUrl(datetime) + ".xml"
                if (!departure)
                    source = source + "?timeSel=arrival"

                // WORKAROUND: this is a work-around, using a separate XMLHttpRequest object so we actually
                // have access to the downloaded source afterwards (in order to pass it to the ConnectionPage).
                // FIX 1: get access to the model its xml property after having used the source property
                // FIX 2: use a XPath function to acquire the source of a connection
                // FIX 3: use a hierarchical ListView (TreeView)
                if (forceReload || source !== _source) {
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
                anchors.fill: item.paddingItem
                id: column1

                ListItemText {
                    id: viaText
                    mode: item.mode
                    role: "Title"
                    text: (vias > 0 ? qsTr("Via %n other(s)", "", vias) : qsTr("Direct connection"))
                }
                ListItemText {
                    id: durationText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("%1 en route").arg(Utils.readableDuration(duration))
                }
            }
            Column {
                id: column2
                anchors {
                    top: column1.top
                    right: parent.right
                    rightMargin: platformStyle.graphicSizeSmall + platformStyle.paddingSmall
                }

                width: Math.max(timeText.width, delayText.width)
                ListItemText {
                    id: timeText
                    anchors.horizontalCenter: parent.horizontalCenter
                    mode: item.mode
                    role: "Title"
                    text: Utils.readableTime(Utils.getDateTime(departure))
                }
                ListItemText {
                    id: delayText
                    anchors.horizontalCenter: parent.horizontalCenter
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

    property variant viaPage
}
