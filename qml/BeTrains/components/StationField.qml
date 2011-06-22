import QtQuick 1.0
import com.nokia.symbian 1.1

TextField {
    id: station
    placeholderText: "Destination..."
    platformLeftMargin: stationSearch.width + platformStyle.paddingSmall

    Image {
        anchors { top: parent.top; left: parent.left; margins: platformStyle.paddingMedium }
        smooth: true
        fillMode: Image.PreserveAspectFit
        source: "image://theme/qtg_graf_search_indicator"
        height: parent.height - platformStyle.paddingMedium * 2
        width: parent.height - platformStyle.paddingMedium * 2

        MouseArea {
            id: stationSearch
            anchors.fill: parent
            onClicked: destinationSearchDialog.open()
        }

        StationChooser {
            id: stationDialog

            onAccepted: {
                station.text = stationDialog.station
                station.forceActiveFocus()
            }
        }
    }
}
