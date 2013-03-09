import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../js/utils.js" as Utils


Page {
    id: page
    anchors.fill: parent

    property string xml
    onXmlChanged: {viaModel.xml=xml;departureModel.xml=xml;arrivalModel.xml=xml}
    property int id
    onIdChanged: {viaModel.id=id;departureModel.id=id;arrivalModel.id=id}

    onStatusChanged: {
        if (status === PageStatus.Inactive && !pageStack.find(function(_page) { return (_page === page) } )) {
            id = -1
        }
    }

    state: (screen.currentOrientation === Screen.Portrait) ? "portrait" : "landscape"

    states: [
        State {
            name: "landscape"

            PropertyChanges {
                target: departureView
                height: 90
                width:parent.width/2
                anchors.left: parent.left
                anchors.top: parent.top
                delegate: departureDelegate_landscape

            }

            PropertyChanges {
                target: arrivalView
                height: 90
                width:parent.width/2
                anchors.left: departureView.right
                anchors.right: parent.right
                anchors.top: parent.top
                delegate: arrivalDelegate_landscape
                model: arrivalModel

            }
            PropertyChanges {
                target: viaView
                delegate: viaDelegate_landscape
            }




        },
        State {
            name: "portrait"

            PropertyChanges {
                target: departureView
                height: 90
                width:parent.width
                anchors.top: parent.top
                anchors.left: parent.left
                delegate: departureDelegate_portrait
            }

            PropertyChanges {
                target: arrivalView
                height: 90
                width: parent.width
                anchors.left: parent.left
                anchors.right:parent.right
                anchors.top: departureView.bottom
                visible:arrivalModel.valid

                delegate: arrivalDelegate_portrait
            }
            PropertyChanges {
                target: viaView
                delegate: viaDelegate_portrait
            }


        }
    ]


    ListView {
        id: departureView
        height: 120

        anchors.left: parent.left
        anchors.top: parent.top
        visible:departureModel.valid

        clip: true
        model: departureModel
        delegate: departureDelegate_portrait
    }


    ListView {
        id: arrivalView
        height: 90
        width: parent.width/2

        visible:arrivalModel.valid

        clip: true
        model: arrivalModel
        delegate: arrivalDelegate_portrait
    }

    ListView {
        id: viaView
        anchors.right: parent.right

        anchors.left: parent.left

        anchors.bottom: parent.bottom

        anchors.top: arrivalView.bottom

        visible: viaModel.valid

        clip: true
        model: viaModel
        delegate: viaDelegate_portrait


    }

    Text {
        anchors.centerIn: viaView
        visible: if (!viaModel.valid || viaModel.count <= 0) true; else false;
        text: {
            switch (viaModel.status) {
            case XmlListModel.Error:
                return qsTr("Error!")
            case XmlListModel.Ready:
                if(viaModel.count==0) { return qsTr("No vias") } else {  return qsTr("No results")}
            default:
                return ""
            }
        }
        color: platformStyle.colorDisabledLight
        font.pixelSize: platformStyle.fontSizeLarge


    }

    BusyIndicator {
        anchors.centerIn: viaView
        visible: if (viaModel.status === XmlListModel.Loading) true; else false
        running: true
        //     height: viaView.height / 10
        //    width: height
    }

    //
    // Data
    //

    XmlListModel {
        id: viaModel

        property int id

        property bool valid
        valid: if (id !== -1 && status === XmlListModel.Ready) true; else false;

        query: "/connections/connection[" + (id + 1) + "]/vias/via"

        XmlRole { name: "via_station"; query: "station/string()"; isKey: true }

        XmlRole { name: "via_arrival"; query: "arrival/time/number()"; isKey: true }
        XmlRole { name: "via_arrival_platform"; query: "arrival/platform/string()"; }

        XmlRole { name: "via_departure"; query: "departure/time/number()"; isKey: true }
        XmlRole { name: "via_departure_platform"; query: "departure/platform/string()"; }

        XmlRole { name: "via_vehicle"; query: "vehicle/string()"; isKey: true }

        XmlRole { name: "via_direction"; query: "direction/string()"; isKey: true }
        XmlRole { name: "via_waittime"; query: "timeBetween/number()" }
    }

    XmlListModel {
        id: arrivalModel

        property int id

        property bool valid
        valid: if (id !== -1 && status === XmlListModel.Ready) true; else false;

        query: "/connections/connection[" + (id + 1) + "]/arrival"

        XmlRole { name: "arrival_station"; query: "station/string()"; isKey: true }

        XmlRole { name: "arrival_time"; query: "time/number()"; }
        XmlRole { name: "arrival_platform"; query: "platform/number()"; }

        XmlRole { name: "arrival_vehicle"; query: "vehicle/string()"; isKey: true }
        XmlRole { name: "arrival_direction"; query: "direction/string()"; }

        XmlRole { name: "arrival_delay"; query: "@delay/number()"; }

    }

    XmlListModel {
        id: departureModel

        property int id

        property bool valid
        valid: if (id !== -1 && status === XmlListModel.Ready) true; else false;

        query: "/connections/connection[" + (id + 1) + "]/departure"

        XmlRole { name: "departure_station"; query: "station/string()"; isKey: true }

        XmlRole { name: "departure_time"; query: "time/number()";  }
        XmlRole { name: "departure_platform"; query: "platform/number()"; }

        XmlRole { name: "departure_vehicle"; query: "vehicle/string()"; isKey: true }
        XmlRole { name: "departure_direction"; query: "direction/string()"; }

        XmlRole { name: "departure_delay"; query: "@delay/number()"; }

    }


    Component {
        id: viaDelegate_portrait

        ListItem {
            id: viaListItem
            height: 90
            Column {
                anchors.left: viaListItem.paddingItem.left
                anchors.top: viaListItem.paddingItem.top
                id: columnMainInfo

                ListItemText {
                    id: via_stationText
                    mode: viaListItem.mode
                    role: "Title"
                    text: qsTr("Transfer at %1").arg(via_station)
                }
//                ListItemText {
//                    id: via_directionText
//                    mode: viaListItem.mode
//                    role: "SubTitle"
//                    text: qsTr("Towards %1").arg(via_direction)
//                }
                ListItemText {
                    id: via_departureText
                    mode: viaListItem.mode
                    role: "SubTitle"
                    text: qsTr("Departure: platform %1 at %2").arg(via_departure_platform).arg(Utils.parseUNIXTime(via_departure))
                }
                ListItemText {
                    id: via_arrivalText
                    mode: viaListItem.mode
                    role: "SubTitle"
                    text: qsTr("Arrival: platform %1 at %2").arg(via_arrival_platform).arg(Utils.parseUNIXTime(via_arrival))
                }
            }

            Column {
                id: columnDetails
                width: via_timeText.width

                anchors.right: viaListItem.paddingItem.right
                anchors.top:  viaListItem.paddingItem.top

                ListItemText {
                    id: via_timeText
                    mode: viaListItem.mode
                    role: "Title"
                    text: Utils.parseUNIXTime(via_departure)
                }
            }
            onClicked: {
                if (!vehiclePage)
                    vehiclePage = Utils.loadObjectByPath("pages/VehiclePage.qml", page)
                pageStack.push(vehiclePage, {id: via_vehicle, datetime: Utils.getDateTime(via_arrival),stationname: via_station});
            }
        }
    }

    Component {
        id: viaDelegate_landscape

        ListItem {
            id: viaListItem
            height: 70

            Column {
                anchors.top: viaListItem.paddingItem.top
                anchors.left: viaListItem.paddingItem.left
                id: columnMainInfo
                width: parent.width/2
                Row {
                    ListItemText {
                        id: via_stationText
                        mode: viaListItem.mode
                        role: "Title"
                        text: qsTr("Transfer at %1").arg(via_station)
                    }
                }
//                Row {
//                    ListItemText {
//                        id: via_directionText
//                        mode: viaListItem.mode
//                        role: "SubTitle"
//                        text: qsTr("Towards %1").arg(via_direction)
//                    }
//                }
                Row {
                    ListItemText {
                        id: via_arrivalDepartureText
                        mode: viaListItem.mode
                        role: "SubTitle"
                        text: qsTr("Arrival: platform %1 at %2").arg(via_arrival_platform).arg(Utils.parseUNIXTime(via_arrival))
                    }
                }
            }
            Column{
                id:colDetails
                anchors{

                    top:  viaListItem.paddingItem.top
                    left:  columnMainInfo.right
                    // leftMargin: platformStyle.graphicSizeSmall + platformStyle.paddingSmall

                }
                width:parent.width/2

                Row{

                    ListItemText {
                        id: via_timeText
                        mode: viaListItem.mode
                        role: "Title"
                        text:Utils.parseUNIXTime(via_departure)


                    }
                }
//                Row {//placeholder
//                    ListItemText {
//                        id: via_placeholderText
//                        mode: viaListItem.mode
//                        role: "SubTitle"
//                        text: " "
//                    }
//                }
                Row {
                    ListItemText {
                        id: via_ArrivalText
                        mode: viaListItem.mode
                        role: "SubTitle"
                        text: qsTr("Departure: platform %1 at %2").arg(via_departure_platform).arg(Utils.parseUNIXTime(via_departure))

                    }
                }
            }

            onClicked: {
                if (!vehiclePage)
                    vehiclePage = Utils.loadObjectByPath("pages/VehiclePage.qml", page)
                pageStack.push(vehiclePage, {id: via_vehicle, datetime: Utils.getDateTime(via_arrival),stationname: via_station});
            }
        }
    }



    Component {
        id: departureDelegate_portrait

        ListItem {
            id: item
            height: 90
            Column {
                anchors.top:  item.paddingItem.top
                anchors.left: item.paddingItem.left
                id: column1

                ListItemText {
                    id: dep_stationText
                    mode: item.mode
                    role: "Title"
                    text: qsTr("Board at %1").arg(departure_station)
                }
                ListItemText {
                    id: dep_directionText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Towards %1").arg(Utils.removeNMBSSNCB(departure_direction))
                }

                ListItemText {
                    id: dep_platformText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Platform %1").arg(departure_platform)
                }
            }

            Column {

                id: column2
                anchors.right: item.paddingItem.right
                anchors.top:  item.paddingItem.top
                width: Math.max(dep_timeText.width, dep_delayText.width)

                ListItemText {
                    id: dep_timeText
                    mode: item.mode
                    role: "Title"
                    text: Utils.parseUNIXTime(departure_time)
                }
                ListItemText {
                    id: dep_delayText
                    mode: item.mode
                    role: "SubTitle"
                    color:"Red"
                    visible: if (departure_delay > 0) true; else false
                    text:  Utils.readableDelay(departure_delay)
                }
            }

            onClicked: {
                if (!vehiclePage)
                    vehiclePage = Utils.loadObjectByPath("pages/VehiclePage.qml", page)
                pageStack.push(vehiclePage, {id: departure_vehicle, datetime: Utils.getDateTime(departure_time),stationname: departure_station});
            }
        }

    }

    Component {
        id: departureDelegate_landscape
        ListItem {
            id: item
            height: 90
            Column {
                anchors.top:  item.paddingItem.top
                anchors.left: item.paddingItem.left
                id: column1

                ListItemText {
                    id: dep_stationText
                    mode: item.mode
                    role: "Title"
                    text: qsTr("Board at %1").arg(departure_station)
                }
                ListItemText {
                    id: dep_directionText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Towards %1").arg(Utils.removeNMBSSNCB(departure_direction))
                }

                ListItemText {
                    id: dep_platformText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Platform %1").arg(departure_platform)
                }
            }

            Column {

                id: column2
                anchors.right: item.paddingItem.right
                anchors.top:  item.paddingItem.top
                width: Math.max(dep_timeText.width, dep_delayText.width)

                ListItemText {
                    id: dep_timeText
                    mode: item.mode
                    role: "Title"
                    text: Utils.parseUNIXTime(departure_time)
                }
                ListItemText {
                    id: dep_placeholderText
                    mode: item.mode
                    role: "Title"
                    text: " "
                }
                ListItemText {
                    id: dep_delayText
                    mode: item.mode
                    role: "SubTitle"
                    color:"Red"
                    visible: if (departure_delay > 0) true; else false
                    text:  Utils.readableDelay(departure_delay)
                }
            }

            onClicked: {
                if (!vehiclePage)
                    vehiclePage = Utils.loadObjectByPath("pages/VehiclePage.qml", page)
                pageStack.push(vehiclePage, {id: departure_vehicle, datetime: Utils.getDateTime(departure_time),stationname: departure_station});
            }
        }
    }


    Component {
        id: arrivalDelegate_portrait

        ListItem {
            id: item
            height: 90

            Column {
                anchors.top:  item.paddingItem.top
                anchors.left: item.paddingItem.left
                id: column1


                ListItemText {
                    id: arr_stationText
                    mode: item.mode
                    role: "Title"
                    text: qsTr("Arrive at %1").arg(arrival_station)
                }
                ListItemText {
                    id: arr_directionText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Towards %1").arg(Utils.removeNMBSSNCB(arrival_direction))
                }

                ListItemText {
                    id: arr_platformText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Platform %1").arg(arrival_platform)
                }
            }

            Column {

                id: column2
                anchors.right: item.paddingItem.right
                anchors.top:  item.paddingItem.top
                width: Math.max(arr_timeText.width, arr_delayText.width)

                ListItemText {
                    id: arr_timeText
                    mode: item.mode
                    role: "Title"
                    text: Utils.parseUNIXTime(arrival_time)
                }
                ListItemText {
                    id: arr_delayText
                    mode: item.mode
                    role: "SubTitle"
                    color:"Red"
                    visible: if (arrival_delay > 0) true; else false
                    text:  Utils.readableDelay(arrival_delay)
                }
            }

            onClicked: {
                if (!vehiclePage)
                    vehiclePage = Utils.loadObjectByPath("pages/VehiclePage.qml", page)
                pageStack.push(vehiclePage, {id: arrival_vehicle, datetime: Utils.getDateTime(arrival_time),stationname: arrival_station});
            }
        }
    }

    Component {
        id: arrivalDelegate_landscape

        ListItem {
            id: item
            height: 90

            Column {
                anchors.top:  item.paddingItem.top
                anchors.left: item.paddingItem.left
                id: column1


                ListItemText {
                    id: arr_stationText
                    mode: item.mode
                    role: "Title"
                    text: qsTr("Arrive at %1").arg(arrival_station)
                }
                ListItemText {
                    id: arr_directionText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Towards %1").arg(Utils.removeNMBSSNCB(arrival_direction))
                }

                ListItemText {
                    id: arr_platformText
                    mode: item.mode
                    role: "SubTitle"
                    text: qsTr("Platform %1").arg(arrival_platform)
                }
            }

            Column {

                id: column2
                anchors.right: item.paddingItem.right
                anchors.top:  item.paddingItem.top
                width: Math.max(arr_timeText.width, arr_delayText.width)

                ListItemText {
                    id: arr_timeText
                    mode: item.mode
                    role: "Title"
                    text: Utils.parseUNIXTime(arrival_time)
                }
                ListItemText {
                    id: arr_placeholderText
                    mode: item.mode
                    role: "Title"
                    text: " "
                }
                ListItemText {
                    id: arr_delayText
                    mode: item.mode
                    role: "SubTitle"
                    color:"Red"
                    visible: if (arrival_delay > 0) true; else false
                    text:  Utils.readableDelay(arrival_delay)
                }
            }

            onClicked: {
                if (!vehiclePage)
                    vehiclePage = Utils.loadObjectByPath("pages/VehiclePage.qml", page)
                pageStack.push(vehiclePage, {id: arrival_vehicle, datetime: Utils.getDateTime(arrival_time),stationname: arrival_station});
            }
        }
    }


    //
    // Objects
    //

    property variant vehiclePage
}

