import QtQuick 1.0
import com.nokia.symbian 1.1

SelectionDialog {
    id: textSelection
    titleText: "Select a station"
    selectedIndex: -1
    model: stationModel


    //
    // Data
    //

    XmlListModel {
        id: stationModel

        source: "http://api.irail.be/stations.php"
        query: "/stations/station"

        XmlRole { name: "modelData"; query: "string()"; }

        XmlRole { name: "name"; query: "string()"; }
        XmlRole { name: "id"; query: "@id/string()"; isKey: true }
        XmlRole { name: "latitude"; query: "@locationX/string()";}
        XmlRole { name: "longitude"; query: "@locationY/string()" }
    }
}
