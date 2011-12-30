import "pages"
import "js/utils.js" as Utils
import QtQuick 1.1
import com.nokia.symbian 1.1

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
            top: statusBar.bottom
            left: parent.left;
            right: parent.right;
        }
        TabButton { tab: pageStackLiveboard; text: "Liveboard" }
        TabButton { tab: pageStackTravel; text: "Travel" }
    }

    TabGroup {
        id: tabGroup
        currentTab: pageStack

        anchors {
            left: parent.left;
            right: parent.right
            top: tabBarLayout.bottom;
            bottom: toolBar.top
        }

        PageStack {
            id: pageStackLiveboard
            anchors.fill: parent
            toolBar: toolBar
        }

        PageStack {
            id: pageStackTravel
            anchors.fill: parent
            toolBar: toolBar
        }
    }

    // This reserves space
    ToolBar {
        id: toolBar
        anchors.bottom: window.bottom
    }

    Component.onCompleted: {
        pageStackLiveboard.push(liveboardPage);
        pageStackTravel.push(travelPage)
    }


    //
    // Dynamic components
    //

    property LiveboardPage liveboardPage : LiveboardPage {}
    property TravelPage travelPage : TravelPage {}
}
