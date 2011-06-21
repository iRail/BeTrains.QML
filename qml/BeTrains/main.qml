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
                    home = homeComponent.createObject(homeStack)
                    homeStack.push(home)
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
                    request = requestComponent.createObject(plannerStack)
                    plannerStack.push(request)
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
                    liveboard = liveboardComponent.createObject(liveboardStack)
                    liveboardStack.push(liveboard)
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

    property Page home
    Component {
        id: homeComponent
        Home {
            id: home
        }
    }

    property Page request
    Component {
        id: requestComponent
        Request {
            id: request
        }
    }

    property Page liveboard
    Component {
        id: liveboardComponent
        Liveboard {
            id: liveboard
        }
    }
}
