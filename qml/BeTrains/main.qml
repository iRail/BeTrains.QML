import "components"
import QtQuick 1.0
import com.nokia.symbian 1.1
import "js/irail.js" as Script

Window {
    id: root

    //
    // Window structure
    //

    StatusBar {
        id: statusBar
        anchors.top: root.top
    }

    TabBar {
        id: tabBar
        anchors { left: parent.left; right: parent.right; top: statusBar.bottom }
        TabButton { tab: tab1content; text: "Favs" }
        TabButton { tab: tab2content; text: "Planner" }
        TabButton { tab: tab3content; text: "Demo" }
    }

    TabGroup {
        id: tabGroup
        anchors { left: parent.left; right: parent.right; top: statusBar.bottom; bottom: parent.bottom }

        // define the content for tab 1
        Page {
            id: tab1content
            Text {
                anchors.centerIn: parent
                text: "Tab 1 content"
                font.pointSize: 25
                color: "white"
            }
        }

        // define the content for tab 2
        Page {
            id: tab2content
            Text {
                anchors.centerIn: parent
                text: "Tab 2 content"
                font.pointSize: 25
                color: "pink"
            }
        }

        // define content for tab 3
        Page {
            id: tab3content
            Text {
                anchors.centerIn: parent
                text: "Tab 3 content"
                font.pointSize: 25
                color: "cyan"
            }
        }
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
