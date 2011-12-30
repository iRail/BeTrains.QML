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
        TabButton { tab: tabLiveboard; text: "Liveboard" }
        TabButton { tab: tabTravel; text: "Travel" }
    }

    TabGroup {
        id: tabGroup
        currentTab: tabLiveboard

        anchors {
            left: parent.left;
            right: parent.right
            top: tabBarLayout.bottom;
            bottom: parent.bottom
        }

        Page {
            id: tabLiveboard

            PageStack {
                id: pageStackLiveboard
                toolBar: toolBarLiveboard

                Component.onCompleted: {
                    push(liveboardPage);
                }
            }

            ToolBar {
                id: toolBarLiveboard
                anchors.bottom: parent.bottom
            }
        }

        Page {
            id: tabTravel

            PageStack {
                id: pageStackTravel
                toolBar: toolBarTravel

                Component.onCompleted: {
                    push(travelPage)
                }
            }

            ToolBar {
                id: toolBarTravel
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
