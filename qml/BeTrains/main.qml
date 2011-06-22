import "components"
import QtQuick 1.0
import com.nokia.symbian 1.1

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
        TabButton { tab: homeTab; text: "Home" }
        TabButton { tab: plannerTab; text: "Planner" }
        TabButton { tab: liveboardTab; text: "Liveboard" }
    }

    TabGroup {
        id: tabGroup
        anchors { left: parent.left; right: parent.right; top: tabBar.bottom; bottom: parent.bottom }

        Page {
            id: homeTab

            PageStack {
                id: homeStack
                toolBar: homeTools

                Component.onCompleted: {
                    homeStack.push(homeComponent)
                }
            }

            ToolBar {
                id: homeTools
                anchors { bottom: parent.bottom }
            }
        }

        Page {
            id: plannerTab

            PageStack {
                id: plannerStack
                toolBar: plannerTools

                Component.onCompleted: {
                    plannerStack.push(requestComponent)
                }
            }

            ToolBar {
                id: plannerTools
                anchors { bottom: parent.bottom }
            }
        }

        Page {
            id: liveboardTab

            PageStack {
                id: liveboardStack
                toolBar: liveboardTools

                Component.onCompleted: {
                    liveboardStack.push(liveboardComponent)
                }
            }

            ToolBar {
                id: liveboardTools
                anchors { bottom: parent.bottom }
            }
        }
    }


    //
    // Dynamic components
    //

    Component {
        id: homeComponent
        HomePage {
            id: home
        }
    }

    Component {
        id: requestComponent
        RequestPage {
            id: request
        }
    }

    Component {
        id: liveboardComponent
        LiveboardPage {
            id: liveboard
        }
    }
}
