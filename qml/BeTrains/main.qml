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

    PageStack {
        id: pageStack
        anchors {
            left: parent.left;
            right: parent.right
            top: statusBar.bottom;
            bottom: toolBar.top
        }
        toolBar: toolBar
    }

    ToolBar {
        id: toolBar
        anchors.bottom: window.bottom

        tools: ToolBarLayout {
            id: toolBarLayout

            ToolButton {
                flat: true
                iconSource: "toolbar-back"
                onClicked: pageStack.depth <= 1 ? Qt.quit() : pageStack.pop();
            }
        }
    }

    Component.onCompleted: {
        pageStack.push(homePage);
    }


    //
    // Dynamic components
    //

    property Page homePage: HomePage{}
}
