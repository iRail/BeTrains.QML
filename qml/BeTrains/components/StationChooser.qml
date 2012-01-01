import QtQuick 1.1
import com.nokia.symbian 1.1

SelectionDialog {
    id: textSelection
    titleText: "Select a station"
    selectedIndex: -1
    model: stationModel

    property string station: selectedIndex !== -1 ? stationModel.get(selectedIndex).name : ""
    onRejected: selectedIndex = -1


    //
    // Data
    //

    XmlListModel {
        id: stationModel

        source: "http://data.irail.be/NMBS/Stations.xml"
        query: "/stations/Stations"

        XmlRole { name: "modelData"; query: "name/string()"; }

        XmlRole { name: "name"; query: "name/string()"; }
        XmlRole { name: "latitude"; query: "lat/number()";}
        XmlRole { name: "longitude"; query: "long/number()" }
    }
}
