#ifndef BANNER_H
#define BANNER_H

#ifdef Q_WS_MAEMO_6

#include <QtDeclarative/QDeclarativeItem>

#include <meegotouch/mbanner.h>
#include <meegotouch/mscene.h>

class Banner : public QDeclarativeItem
{
    Q_OBJECT
public:
    Banner() {}
    ~Banner() {}

    Q_INVOKABLE void show() {
        MScene *s = qobject_cast<MScene *>(scene());
        Q_ASSERT(s);

        MBanner *eventBanner = new MBanner();
        eventBanner->setStyleName("EventBanner");
        eventBanner->setIconID("icon-l-settings");
        eventBanner->setTitle("New updates waiting to install");
        eventBanner->setSubtitle("130 files");
        eventBanner->appear(s, MSceneWindow::DestroyWhenDone);
    }
};

#endif

#endif // BANNER_H
