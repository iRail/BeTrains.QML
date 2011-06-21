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

    Demo {
        id: demo
        state: "shown"
        y: statusBar.height
        width: parent.width
        height: parent.height
    }

    Planner {
        id: planner
        state: "hidden"
        y: statusBar.height
        width: parent.width
        height: parent.height
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
                    menu.open()
                }
            }
        }
    }


    //
    // Components
    //

    function hideAll() {
        demo.state = "hidden"
        planner.state = "hidden"
    }

    Menu {
        id: menu
        content: MenuLayout {

            // Demo
            MenuItem {
                text: "Demo"
                onClicked: {
                    hideAll()
                    demo.state = "shown"
                }
            }

            // Planner
            MenuItem {
                text: "Planner"
                onClicked: {
                    hideAll()
                    planner.state = "shown"
                }
            }

            // About
            MenuItem {
                text: "About"
                onClicked: {
                    about.open()
                }
            }

            // Exit
            MenuItem { text: "Exit"; onClicked: Qt.quit() }
        }
    }
}
