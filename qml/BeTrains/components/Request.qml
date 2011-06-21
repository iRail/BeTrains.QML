import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: page
    anchors.fill: parent


    //
    // Toolbar
    //

    tools: ToolBarLayout {
        id: pageSpecificTools

        // Quit buton
        // TODO: quit logo
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        // Make request
        ToolButton {
            iconSource: "toolbar-search"
            enabled: false
            onClicked: pageStack.push(secondPage)
        }
    }


    //
    // Contents
    //

    Column {
        id: contents
        spacing: 14

        anchors {
            left: parent.left
            right: parent.right
            margins: contents.spacing
        }

        Row {
            id: origin

            Text {
                id: originLabel
                anchors.verticalCenter: parent.verticalCenter
                font { family: platformStyle.fontFamilyRegular; pixelSize: platformStyle.fontSizeMedium }
                color: platformStyle.colorNormalLight
                text: "Origin: "
            }

            TextField {
                placeholderText: "Station"
            }

        }
    }
}
