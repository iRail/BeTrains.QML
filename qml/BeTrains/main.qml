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

    StatusBar {
        id: statusBar
        anchors.top: window.top
    }

    TabBarLayout {
        id: tabBarLayout
        anchors {
            left: parent.left;
            right: parent.right;
            top: statusBar.bottom
        }
        TabButton { tab: liveboardTab; text: "Liveboard" }
        TabButton { tab: travelTab; text: "Travel" }
    }

    TabGroup {
        id: tabGroup
        currentTab: liveboardTab

        anchors {
            left: parent.left;
            right: parent.right
            top: tabBarLayout.bottom;
            bottom: parent.bottom
        }

        Page {
            id: liveboardTab

            PageStack {
                id: liveboardPageStack
                toolBar: liveboardToolBar

                Component.onCompleted: {
                    push(liveboardPage);
                }
            }

            ToolBar {
                id: liveboardToolBar
                anchors.bottom: parent.bottom
            }
        }

        Page {
            id: travelTab

            PageStack {
                id: travelPageStack
                toolBar: travelToolBar

                Component.onCompleted: {
                    push(travelPage)
                }
            }

            ToolBar {
                id: travelToolBar
                anchors.bottom: parent.bottom
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
