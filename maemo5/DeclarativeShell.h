#ifndef DECLARATIVESHELL_H
#define DECLARATIVESHELL_H

#include <QtCore/QObject>

class QDeclarativeComponent;
class QDeclarativeContext;
class QDeclarativeEngine;

class DeclarativeShell : public QObject
{
    Q_OBJECT
public:
    DeclarativeShell(QObject *parent = 0);
    ~DeclarativeShell();

    void setSource(const QString &file);

    QDeclarativeEngine *engine() const;
    QDeclarativeContext *rootContext() const;

private:
    QDeclarativeComponent *m_component;
    QDeclarativeEngine *m_engine;
};

#endif // DECLARATIVESHELL_H
