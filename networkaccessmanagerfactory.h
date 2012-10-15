#ifndef NETWORKACCESSMANAGERFACTORY_H
#define NETWORKACCESSMANAGERFACTORY_H

#include <QtDeclarative/QDeclarativeNetworkAccessManagerFactory>
#include "customnetworkaccessmanager.h"

class NetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory {
public:
    explicit NetworkAccessManagerFactory(QString iUserAgent = "")
        : QDeclarativeNetworkAccessManagerFactory(), mUserAgent(iUserAgent) {
    }

    QNetworkAccessManager* create(QObject* parent)
    {
        CustomNetworkAccessManager *tManager = new CustomNetworkAccessManager(mUserAgent, parent);
        return tManager;
    }

private:
    QString mUserAgent;
};

#endif // NETWORKACCESSMANAGERFACTORY_H
