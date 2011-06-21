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
        TabButton { tab: tabFavourites; text: "Favs" }
        TabButton { tab: tabPlanner; text: "Planner" }
        TabButton { tab: tabLiveboard; text: "Liveboard" }
    }

    TabGroup {
        id: tabGroup
        anchors { left: parent.left; right: parent.right; top: tabBar.bottom; bottom: parent.bottom }

        Page {
            id: tabFavourites
            Text {
                anchors.centerIn: parent
                text: "Tab 1 content"
                font.pointSize: 25
                color: "white"
            }
        }

        Page {
            id: tabPlanner
            Planner {
                anchors { left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom }
            }
        }

        Page {
            id: tabLiveboard
            Demo {
                anchors { left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom }
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
