import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "pages"
import "components"
import "js/utils.js" as Utils
import "js/storage.js" as Storage
import QtQuick 1.0


    //
    // Window structure
    //

    PageStackWindow {
        id: pagestackwindow
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
                    Component.onCompleted: {   Storage.initialize(); travelStack.push(travelPage)}
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
            TabButton { id: tabBtnLiveboard; tab: liveboardStack; iconSource: "toolbar-list" }
            TabButton { id:tabBtnTravel; tab: travelStack; iconSource: "toolbar-search" }
        }

        // Menu
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: {
                if (!pagestackwindow.menu)
                    pagestackwindow.menu = Utils.loadObjectByComponent(menuComponent, pagestackwindow)
                pagestackwindow.menu.open()
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
                    text: qsTr("About")
                    onClicked: {
                        if (!aboutDialog)
                            aboutDialog = Utils.loadObjectByPath("components/AboutDialog.qml", menu)
                        aboutDialog.open()
                    }
                }

                // Quit
                MenuItem {
                    text: qsTr("Quit")
                    onClicked: Qt.quit()
                }
            }
        }
    }

    Text {
        id: statustext
        x: 2
        y: 2
        width: 230
        height: 22
        color: "#ffffff"
        text: qsTr("BeTrains")
        font.pixelSize: 20
    }
}
