#ifndef WINDOW_H
#define WINDOW_H

#include <QtCore/QStack>
#include <QtDeclarative/QDeclarativeItem>
#include <QtDeclarative/QDeclarativeView>
#include <QtGui/QMainWindow>

class MainWindow;
class Window;
class WindowStack : public QObject
{
    Q_OBJECT
public:
    WindowStack() {}
    ~WindowStack() {}

public slots:
    void push(QObject *object);

protected:
    bool eventFilter(QObject *obj, QEvent *event);

private:
    QStack<MainWindow *> m_stack;
};

//class StackedWindow : public QDeclarativeItem
//{
//    Q_OBJECT
//public:
//    StackedWindow(QDeclarativeItem *parent = 0) : QDeclarativeItem(parent) {}
//    ~StackedWindow() {}
//};

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    MainWindow()
    {
        setAttribute(Qt::WA_Maemo5StackedWindow);
    }
    ~MainWindow() {}

    QGraphicsScene *scene() { return m_view->scene(); }
    QDeclarativeView *view() { return m_view; }

private:
    QDeclarativeView *m_view;
};

class Window : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(WindowStack* windowStack READ windowStack)
public:
    Window(QDeclarativeItem *parent = 0);
    ~Window();

    void componentComplete();

    QString title() const;
    void setTitle(const QString &title);

    WindowStack *windowStack();
    void setWindowStack(WindowStack *stack);

    MainWindow *mainWindow() const { return m_window; }

signals:
    void titleChanged();

private slots:
    void updateMainWindowParent(QDeclarativeItem *parent);

private:
    MainWindow *m_window;
    WindowStack *m_stack;
};

#endif // WINDOW_H
