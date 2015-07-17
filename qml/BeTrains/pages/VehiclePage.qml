import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../js/utils.js" as Utils

Page {
    id: page
    anchors.fill: parent


    property alias id: vehicleModel.vehicle
    property alias datetime: vehicleModel.datetime
property alias stationname:vehicleModel.stationname

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            vehicleModel.update(false)
        } else if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            id = ""
            datetime = new Date()
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
        header: vehicleHeader
    }

    Text {
        anchors.centerIn: vehicleView
        visible: if (!vehicleModel.valid || vehicleModel.count <= 0) true; else false;
        text: {
            switch (vehicleModel.status) {
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
        id: vehicleHeader

        PullDownHeader {
            view: vehicleView
            onPulled: {
                vehicleModel.update(true)
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: vehicleView
        visible: if (vehicleModel.status === XmlListModel.Loading) true; else false
        running: true
    //    height: vehicleView.height / 10
     //   width: height
    }


    //
    // Data
    //

    XmlListModel {
        id: vehicleModel

        property string vehicle
        property string stationname
        property date datetime

        function update(forceReload) {
            // FIXME: working around API bug for data.irail
            //vehicle = vehicle.replace('BE.NMBS.', '')

            if (vehicle !== "") {
                //source = "http://data.irail.be/NMBS/Vehicle/" + vehicle + "/" + Utils.generateDateUrl(datetime) + ".xml"
//&time=" + Utils.generateAPITimeUrl(datetime) + "&date="+ Utils.generateAPIDateUrl(datetime)
                source="http://api.irail.be/vehicle/?id=" + vehicle + "&fast=true"
                console.log("Loading vehicle page info from " + source )
                // If the URL is identical, force a reload
                if (forceReload && status === XmlListModel.Ready)
                    console.log("Loading vehicle page info from " + source )
                    reload()
            }
        }

        property bool valid
        valid: if (vehicle !== "" && status === XmlListModel.Ready) true; else false;

        source: ""
        query: "/vehicleinformation/stops/stop"

        XmlRole { name: "station"; query: "station/string()"; isKey: true}
        XmlRole { name: "time"; query: "time/number()"; isKey: true }
        XmlRole { name: "delay"; query: "@delay/number()" }

    }

    Component {
        id: vehicleDelegate

        ListItem {
            id: item

            Column {
                anchors.fill: item.paddingItem
                id: column1

                ListItemText {
                    id: stationText
                    mode: item.mode
                    role: "Title"
                    text: station
                }
            }
            Column {
                id: column2
                anchors {
                    top: column1.top
                    right: parent.right
                    rightMargin: platformStyle.paddingMedium
                }
                width: Math.max(timeText.width, delayText.width)
                ListItemText {
                    id: timeText
                    anchors.horizontalCenter: parent.horizontalCenter
                    mode: item.mode
                    role: "Title"
                    text: Utils.readableTime(Utils.getDateTime(time))
                }
                ListItemText {
                    id: delayText
                    anchors.horizontalCenter: parent.horizontalCenter
                    mode: item.mode
                    role: "SubTitle"
                    color: "red"
                    visible: if (delay > 0) true; else false
                    text:  Utils.readableDelay(delay)
                }
            }

            onClicked: {
                if (!liveboardpage)
                    liveboardpage = Utils.loadObjectByPath("pages/LiveboardPage.qml", page)
                liveboardpage.station=station
                liveboardpage.searchtext=station
                pageStack.push(liveboardpage, {station: station, datetime: Utils.getDateTime(time)});
            }
        }
    }
    //
    // Objects
    //

    property variant liveboardpage
}

