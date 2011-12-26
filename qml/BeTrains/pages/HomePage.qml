import "../components"
import "../js/utils.js" as Utils
import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: page
    anchors.fill: parent


    //
    // Toolbar
    //

    tools: ToolBarLayout {
        id: pageSpecificTools

        // Quit buton
        // TODO: quit logo
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        // Menu entry
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: {
                menu = Utils.getDynamicObject(menu, menuComponent, window)
                menu.open()
            }
        }
    }


    //
    // Contents
    //

    Column {
        spacing: 48
        anchors.centerIn: parent

        Button {
            text: "Liveboards"
            onClicked: {
                liveboardPage = Utils.getDynamicObject(liveboardPage, liveboardComponent, page)
                pageStack.push(liveboardPage);
            }
        }

        Button {
            text: "Connections"
            onClicked: {
                requestPage = Utils.getDynamicObject(requestPage, requestComponent, page)
                pageStack.push(requestPage);
            }
        }
    }


    //
    // Dynamic components
    //

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

    property Page liveboardPage
    Component {
        id: liveboardComponent

        LiveboardPage{}
    }

    property Page requestPage
    Component {
        id: requestComponent

        RequestPage{}
    }
}
