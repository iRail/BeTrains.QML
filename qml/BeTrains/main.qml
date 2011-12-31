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
    // Dynamic components
    //

    property LiveboardPage liveboardPage : LiveboardPage {}
    property TravelPage travelPage : TravelPage {}

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
                        about = Utils.getDynamicObject(about, aboutComponent, menu)
                        about.open()
                    }
                }
            }
        }
    }
    property Dialog about
    Component {
        id: aboutComponent

        AboutDialog {}
    }
}
