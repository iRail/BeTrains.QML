import QtQuick 1.0
import com.nokia.symbian 1.1

Page {
    id: page

    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
        bottom: parent.bottom
    }


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

        // Menu entry
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: {
                if (!menu)
                    menu = menuComponent.createObject(root)
                menu.open()
            }
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
                text: "Home screen"
            }

        }
    }

    //
    // Dynamic components
    //

    property Menu menu
    Component {
        id: menuComponent

        Menu {
            id: menu
            content: MenuLayout {
                // About
                MenuItem {
                    text: "About"
                    onClicked: {
                        if (!about)
                            about = aboutComponent.createObject(menu)
                        about.open()
                    }
                }
            }
        }
    }

    property Dialog about
    Component {
        id: aboutComponent

        AboutDialog {

        }
    }
}
