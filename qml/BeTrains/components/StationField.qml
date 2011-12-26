import "../js/utils.js" as Utils
import QtQuick 1.1
import com.nokia.symbian 1.1

TextField {
    id: field
    placeholderText: "Destination..."
    platformLeftMargin: chooserArea.width + platformStyle.paddingSmall

    Image {
        anchors { top: parent.top; left: parent.left; margins: platformStyle.paddingMedium }
        smooth: true
        fillMode: Image.PreserveAspectFit
        source: "image://theme/qtg_graf_search_indicator"
        height: parent.height - platformStyle.paddingMedium * 2
        width: parent.height - platformStyle.paddingMedium * 2

        MouseArea {
            id: chooserArea
            anchors.fill: parent
            onClicked: {
                chooser = Utils.getDynamicObject(chooser, chooserComponent, field)
                chooser.open();
            }
        }
    }


    //
    // Dynamic components
    //

    property StationChooser chooser
    Component {
        id: chooserComponent

        StationChooser {
            onAccepted: {
                field.text = stationDialog.station
                field.forceActiveFocus()
            }
        }
    }
}
