import QtQuick 1.1
import com.nokia.symbian 1.1
import "pages"
import "components"
import "js/utils.js" as Utils

Window {
    id: window

    //
    // Window structure
    //

    PageStackWindow {
        initialPage: mainPage
        showStatusBar: true
        showToolBar: true

        Page {
            id: mainPage
            tools: toolBarLayout

            TabGroup {
                id: tabGroup
                currentTab: liveboardStack
                anchors.fill: parent

                PageStack {
                    id: liveboardStack
                    Component.onCompleted: liveboardStack.push(liveboardPage)
                }

                PageStack {
                    id: travelStack
                    Component.onCompleted: travelStack.push(travelPage)
                }
            }
        }
    }


    //
    // Toolbar
    //

    ToolBarLayout {
        id: toolBarLayout

        // Back buton
        ToolButton {
            property bool closeButton: tabGroup.currentTab.depth <= 1
            flat: true
            iconSource: closeButton ? "icons/close.svg" : "toolbar-back"
            onClicked: closeButton ? Qt.quit() : tabGroup.currentTab.pop();
        }

        // Tab bar
        ButtonRow {
            TabButton { tab: liveboardStack; text: "Liveboard" }
            TabButton { tab: travelStack; text: "Travel" }
        }

        // Menu
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: {
                if (!window.menu)
                    window.menu = Utils.loadObjectByComponent(menuComponent, window)
                window.menu.open()
            }
        }
    }


    //
    // Objects
    //

    // Statically loaded objects
    property Page liveboardPage: LiveboardPage {}
    property Page travelPage: TravelPage {}

    // Dynamically loaded objects
    property Dialog aboutDialog

    // In-line defined menu component
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
                        if (!aboutDialog)
                            aboutDialog = Utils.loadObjectByPath("components/AboutDialog.qml", menu)
                        aboutDialog.open()
                    }
                }

                // Quit
                MenuItem {
                    text: "Quit"
                    onClicked: Qt.quit()
                }
            }
        }
    }
}
