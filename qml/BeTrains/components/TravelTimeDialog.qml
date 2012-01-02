import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../js/utils.js" as Utils

CommonDialog {
    id: dialog
    titleText: "Travel time"
    buttonTexts: ["OK", "Cancel"]
    height: content.height

    property alias departure: typeDepartureButton.checked
    property alias specified: timeSpecifiedSwitch.checked
    property date datetime: new Date()

    onButtonClicked: {
        if (index === 0)
            accept()
        else
            reject()
    }

    onClickedOutside: {
        privateStyle.play(Symbian.PopUp)
        reject()
    }


    //
    // Contents
    //

    content: Column {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        ButtonRow {
            id: typeGroup
            width: parent.width
            exclusive: true
            checkedButton: typeDepartureButton

            ToolButton {
                id: typeDepartureButton
                text: "Depart"
            }
            ToolButton {
                id: typeArrivalButton
                text: "Arrive";
            }
        }

        Row {
            spacing: platformStyle.paddingMedium
            width: parent.width

            Switch {
                id: timeSpecifiedSwitch
            }

            Text {
                id: timeLabel
                width: parent.width - parent.spacing - timeSpecifiedSwitch.width
                height: timeSpecifiedSwitch.height
                verticalAlignment: Text.AlignVCenter
                text: "Specify time?"
                font.pixelSize: platformStyle.fontSizeMedium
                color: platformStyle.colorNormalLight
            }
        }

        Row {
            width: parent.width
            spacing: platformStyle.paddingMedium

            Button {
                id: dateField
                text: datetime.toLocaleDateString()
                enabled: timeSpecifiedSwitch.checked
                width: (parent.width - platformStyle.paddingMedium) / 2

                DatePickerDialog {
                    id: dateDialog
                    titleText: "Select the date"
                    rejectButtonText: "Cancel"
                    acceptButtonText: "Ok"

                    Component.onCompleted: {
                        year = datetime.getFullYear()
                        month = datetime.getMonth()
                        day = datetime.getDate()
                    }

                    onAccepted: datetime = new Date(year, month, day, datetime.getHours(), datetime.getMinutes(), datetime.getSeconds(), datetime.getMilliseconds())
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: dateDialog.open()
                }
            }

            Button {
                id: timeField
                text: Utils.readableTime(datetime)
                enabled: timeSpecifiedSwitch.checked
                width: (parent.width - platformStyle.paddingMedium) / 2

                TimePickerDialog {
                    id: timeDialog
                    titleText: "Select the time"
                    rejectButtonText: "Cancel"
                    acceptButtonText: "Ok"

                    Component.onCompleted: {
                        hour = datetime.getHours()
                        minute = datetime.getMinutes()
                        second = datetime.getSeconds()
                    }

                    onAccepted: datetime = new Date(datetime.getFullYear(), datetime.getMonth(), datetime.getDate(), hour, minute, second, 0)
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: timeDialog.open()
                }
            }
        }
    }
}
