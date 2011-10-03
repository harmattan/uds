/*
    Copyright (C) 2011 Harald Sitter <apachelogger@ubuntu.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
