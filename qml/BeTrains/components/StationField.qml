import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Utils

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
                if (!chooser)
                    chooser = Utils.loadObjectByPath("components/StationChooser.qml", field)
                chooser.open();
            }
        }
    }


    //
    // Objects
    //

    property Dialog chooser
}
