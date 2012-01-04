import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "pages"
import "components"
import "js/utils.js" as Utils
import "js/storage.js" as Storage

Window {
    id: window

    property string __schemaIdentification: "2"

    Component.onCompleted: {
        Storage.initialize()
        if (Storage.getSetting("schemaIdentification") !== __schemaIdentification) {
            Storage.reset()
            Storage.setSetting("schemaIdentification", __schemaIdentification)
        }
    }

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
            TabButton { tab: liveboardStack; iconSource: "toolbar-list" }
            TabButton { tab: travelStack; iconSource: "toolbar-search" }
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
    property variant liveboardPage: LiveboardPage {}
    property variant travelPage: TravelPage {}

    // Dynamically loaded objects
    property variant aboutDialog

    // In-line defined menu component
    property variant menu
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
