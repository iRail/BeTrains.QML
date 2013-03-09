# Add more folders to ship with the application, here
folder_01.source = qml/BeTrains
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01
#symbian:TARGET.UID3 = 0x2006E37A #Protected range
symbian:DEPLOYMENT.installer_header = 0x2006E37A
# Additional import path used to resolve QML modules in Creator's code model

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application


# Allow network access and GPS access on Symbian
symbian {
    TARGET.CAPABILITY += NetworkServices

    vendorinfo += "%{\"Bertware\"}" ":\"Bertware\""

    TARGET.UID3 += 0x2006E37A
}

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Manage Qt dependencies for C++ code
QT += network

# Add dependency to Symbian components
CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

#To lock in cpp
#DEFINES += ORIENTATIONLOCK


# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()


 vendorinfo = \
     "%{\"Bertware\"}" \
     ":\"Bertware\""
my_deployment.pkg_prerules = vendorinfo


DEPLOYMENT+=my_deployment
DEPLOYMENT.display_name = BeTrains
DEPLOYMENT.installer_header = "$${LITERAL_HASH}{\"BeTrains Installer\"},(0x2006E37A),1,0,2"
DEPLOYMENT.header = "$${LITERAL_HASH}{\"BeTrains\"},(0x2006E37A),1,0,2"

#TARGET.UID3 = A0015DFA

HEADERS += \
    networkaccessmanagerfactory.h \
    customnetworkaccessmanager.h

# Translations
TRANSLATIONS = $$files(i18n/BeTrains*.ts)
isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
isEmpty(TS_DIR):TS_DIR = i18n
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$TS_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM
PRE_TARGETDEPS += compiler_TSQM_make_all

evilhack {
    SOURCES += \
        qml/BeTrains/main.qml \
        qml/BeTrains/pages/VehiclePage.qml \
        qml/BeTrains/pages/TravelPage.qml \
        qml/BeTrains/pages/ConnectionsPage.qml \
        qml/BeTrains/pages/ViaPage.qml \
        qml/BeTrains/pages/LiveboardPage.qml \
        qml/BeTrains/components/AboutDialog.qml \
        qml/BeTrains/components/TravelTimeDialog.qml \
        qml/BeTrains/components/PullDownHeader.qml \
        qml/BeTrains/components/StackableSearchBox.qml \
        qml/BeTrains/components/DelayedPropagator.qml
}

# Resourcess
RESOURCES += \
    BeTrains.qrc
