#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtCore/QSettings>
#include <QtCore/QStringList>

class Settings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(QStringList allKeys READ allKeys)
    Q_PROPERTY(QString group READ group NOTIFY groupChanged)
public:
    Settings(QObject *parent = 0) : QSettings(parent) {}
    ~Settings() {}

    // Properties
    QStringList allKeys() const { return QSettings::allKeys(); }
    QString group() const { return QSettings::group(); }

    // Invokables
    Q_INVOKABLE void beginGroup(const QString &prefix) { QSettings::beginGroup(prefix); emit groupChanged(); }
    Q_INVOKABLE void endGroup() { QSettings::endGroup(); emit groupChanged(); }

    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const
    {
        return QSettings::value(key, defaultValue);
    }

signals:
    void groupChanged();

public slots:
    void setValue(const QString &key, const QVariant &value)
    {
        QSettings::setValue(key, value);
    }

    void sync() { QSettings::sync(); }
};

#endif // SETTINGS_H
