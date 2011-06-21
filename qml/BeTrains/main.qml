import QtQuick 1.0
import com.nokia.symbian 1.1

Window {
    //
    // Configuration
    //

    id: root

    property Menu menu
    property Dialog about


    //
    // Window structure
    //

    StatusBar {
        id: statusBar
        anchors.top: root.top
    }

    Flickable {
        id: flickable
        clip: true
        anchors {
            left: root.left
            right: root.right
            top: statusBar.visible ? statusBar.bottom: root.top
            bottom: toolBar.visible ? toolBar.top: root.bottom
        }
        contentHeight: column.height

        SampleColumn {
            id: column
            anchors {
                left: parent.left
                right: parent.right
                margins: column.spacing
            }
        }
    }

    ScrollDecorator {
        flickableItem: flickable
    }

    ToolBar {
        id: toolBar
        anchors.bottom: root.bottom
        tools: ToolBarLayout {
            id: toolBarlayout
            ToolButton {
                flat: true
                iconSource: "toolbar-back"
                onClicked: Qt.quit()
            }
            ToolButton {
                iconSource: "toolbar-menu"
                onClicked: {
                    if (!menu)
                        menu = menuComponent.createObject(root)
                    menu.open()
                }
            }
        }
    }


    //
    // Components
    //

    Component {
        id: menuComponent
        Menu {
            content: MenuLayout {
                MenuItem {
                    text: "About"
                    onClicked: {
                        if (!about)
                            about = aboutComponent.createObject(menu)
                        about.open()
                    }
                }
                MenuItem { text: "Exit"; onClicked: Qt.quit() }
            }
        }
    }

    Component {
        id: aboutComponent
        QueryDialog {
            titleText: "About BeTrains"
            message: "<p>"
                     + "<strong>BeTrains</strong> is part of the <a href=\"http://betrains.com\">BeTrains</a> project, and made possible by:"
                     + "<ul>"
                     + "<li><a href=\"mailto:tim.besard@gmail.com\">Tim Besard</a></li>"
                     + "</ul>"
                     + "... and many others"
                     + "</p>"
                     + "<p>"
                     + "The BeTrains project is based upon and related with the <a href=\"http://project.irail.be\">iRail</a> project."
                     + " "
                     + "It is however NOT affiliated with the Belgian train company!"
                     + "</p>"
                     + "<p>"
                     + "Be sure to check out our site, BeTrains exists for other platforms as well!"
                     + "</p>"

            acceptButtonText: "Ok"
        }
    }
}
