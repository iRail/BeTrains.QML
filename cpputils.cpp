class CppUtils : public QObject
{

public:


    systemLanguage() const {
        return QLocale::system();
    }

};
