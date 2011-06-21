import "components"
import QtQuick 1.0
import com.nokia.symbian 1.1
import "js/irail.js" as Script

Window {
    //
    // Configuration
    //

    id: root

    property Menu menu
    property Dialog about


    //
    // Window structure
    //

    StatusBar {
        id: statusBar
        anchors.top: root.top
    }

    Flickable {
        id: flickable
        clip: true
        anchors {
            left: root.left
            right: root.right
            top: statusBar.visible ? statusBar.bottom: root.top
            bottom: toolBar.visible ? toolBar.top: root.bottom
        }
        contentHeight: column.height

        SampleColumn {
            id: column
            anchors {
                left: parent.left
                right: parent.right
                margins: column.spacing
            }
        }
    }

    ScrollDecorator {
        flickableItem: flickable
    }

    ToolBar {
        id: toolBar
        anchors.bottom: root.bottom
        tools: ToolBarLayout {
            id: toolBarlayout

            // Back buton
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
    }


    //
    // Dynamic components
    //


    Component {
        id: aboutComponent

        AboutDialog {
            id: about
        }
    }

    Component {
        id: menuComponent

        Menu {
            content: MenuLayout {
                MenuItem {
                    text: "About"
                    onClicked: {
                        if (!about)
                            about = aboutComponent.createObject(menu)
                        about.open()
                    }
                }
                MenuItem { text: "Exit"; onClicked: Qt.quit() }
            }
        }
    }
}
