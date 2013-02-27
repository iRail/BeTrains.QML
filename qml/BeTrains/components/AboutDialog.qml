import QtQuick 1.1
import com.nokia.symbian 1.1

QueryDialog {
    id: dialog
    titleText: qsTr("About BeTrains")
    message: "<p>"
             + "<strong>BeTrains</strong> is part of the <a href=\"http://betrains.com\">BeTrains</a> project, and made possible by:"
             + "<ul>"
             + "<li><a href=\"mailto:tim.besard@gmail.com\">Tim Besard</a></li>"
             + "<li><a href=\"mailto:contact@bertware.com\">Bert Marcelis</a></li>"
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
