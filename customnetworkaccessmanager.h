#ifndef CUSTOMNETWORKACCESSMANAGER_H
#define CUSTOMNETWORKACCESSMANAGER_H

#include <QtCore/QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>

class CustomNetworkAccessManager : public QNetworkAccessManager {
    Q_OBJECT
public:
    explicit CustomNetworkAccessManager(QString iUserAgent = "", QObject *parent = 0)
        : QNetworkAccessManager(parent), mUserAgent(iUserAgent) {
    }

protected:
    QNetworkReply *createRequest(Operation iOperation, const QNetworkRequest &iRequest, QIODevice *iOutgoingData=0) {
        QNetworkRequest tRequest(iRequest);
        tRequest.setRawHeader("User-Agent", mUserAgent.toAscii());
        QNetworkReply *tReply = QNetworkAccessManager::createRequest(iOperation, tRequest, iOutgoingData);
        return tReply;
    }
private:
    QString mUserAgent;
};

#endif // CUSTOMNETWORKACCESSMANAGER_H
