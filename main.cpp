#include <QtGui/QApplication>
#include <QtCore/QTranslator>
#include <QtCore/QLocale>
#include <QtDeclarative/QDeclarativeEngine>
#include "qmlapplicationviewer.h"
#include "networkaccessmanagerfactory.h"
#include "customnetworkaccessmanager.h"
#include <QDebug>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // Initialize Qt
    QScopedPointer<QApplication> tApplication(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> tQmlApplicationViewer(QmlApplicationViewer::create());

    // Load a translation
    QTranslator tTranslator;
    if (tTranslator.load("BeTrains." + QLocale::system().name(), ":/i18n")) {
        tApplication->installTranslator(&tTranslator);
    }

    // Provide a custom user agent
    // FIXME: add some platform details (e.g. 'Mozilla/5.0 (Unknown; U; Linux x86_64; en-GB) AppleWebKit/533.3 (KHTML, like Gecko) Qt/4.7.4 Safari/533.3')
    NetworkAccessManagerFactory tNetworkAccessManagerFactory("BeTrains-QML/0.5 (Symbian edition)");
    tQmlApplicationViewer->engine()->setNetworkAccessManagerFactory(&tNetworkAccessManagerFactory);
    tQmlApplicationViewer->setResizeMode(QDeclarativeView::SizeRootObjectToView);

    // Load the QML entrypoint
    tQmlApplicationViewer->setMainQmlFile(QLatin1String("qml/BeTrains/main.qml"));

    tQmlApplicationViewer->showFullScreen();

    return tApplication->exec();
}
