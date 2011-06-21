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
    property Dialog about
    property Column demo
    property Column planner


    function hideAll() {
        demo.state = "hidden"
        planner.state = "hidden"
    }


    Component {
        id: menuComponent

        Menu {
            content: MenuLayout {

                // Demo
                MenuItem {
                    text: "Demo"
                    onClicked: {
                        if (!demo)
                            demo = demoComponent.createObject(menu)
                        hideAll()
                        demo.state = "shown"
                    }
                }

                // Planner
                MenuItem {
                    text: "Planner"
                    onClicked: {
                        if (!planner)
                            planner = plannerComponent.createObject(menu)
                        hideAll()
                        planner.state = "shown"
                    }
                }

                // About
                MenuItem {
                    text: "About"
                    onClicked: {
                        if (!about)
                            about = aboutComponent.createObject(menu)
                        about.open()
                    }
                }

                // Exit
                MenuItem { text: "Exit"; onClicked: Qt.quit() }
            }
        }
    }

    Component {
        id: aboutComponent

        AboutDialog {
            id: about
        }
    }

    Component {
        id: demoComponent

        Demo {
            id: demo

            anchors {
                left: root.left
                right: root.right
                top: statusBar.visible ? statusBar.bottom: root.top
                bottom: toolBar.visible ? toolBar.top: root.bottom
            }
        }
    }

    Component {
        id: plannerComponent

        Planner {
            id: planner

            anchors {
                left: root.left
                right: root.right
                top: statusBar.visible ? statusBar.bottom: root.top
                bottom: toolBar.visible ? toolBar.top: root.bottom
            }
        }
    }
}
