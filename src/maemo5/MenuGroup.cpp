#include "MenuGroup.h"

#include <QtCore/QDebug>
#include <QtGui/QActionGroup>

#include "MenuItem.h"

MenuGroup::MenuGroup(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    m_actionGroup(new QActionGroup(this))
{
    qDebug() << Q_FUNC_INFO;
    m_actionGroup->setExclusive(true);
}

void MenuGroup::componentComplete()
{
    qDebug() << Q_FUNC_INFO;
    MenuItem *item = 0;
    foreach (QObject *child, children()) {
        item = qobject_cast<MenuItem *>(child);
        if (item) {
            item->setActionGroup(m_actionGroup);
            item->setCheckable(true);
        }
    }
}
