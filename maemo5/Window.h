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

class Window;
class StackedWindow : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(WindowStack* windowStack READ windowStack)
    Q_PROPERTY(Window* initialWindow READ initialWindow WRITE setInitialWindow)
public:
    StackedWindow(QDeclarativeItem *parent = 0) :
        QDeclarativeItem(parent),
        m_initialWindow(0),
        m_stack(new WindowStack)
    {}
    ~StackedWindow()
    {
        delete m_stack;
    }

    WindowStack *windowStack() const { return m_stack; }
    void setWindowStack(WindowStack *stack) { m_stack = stack; }

    Window *initialWindow() const { return m_initialWindow; }
    void setInitialWindow(Window *window) { m_initialWindow = window; }

private:
    Window *m_initialWindow;
    WindowStack *m_stack;
};

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    MainWindow();
    ~MainWindow();

    QGraphicsScene *scene() { return m_view->scene(); }
    QDeclarativeView *view() { return m_view; }

signals:
    void sizeChanged(QSize newSize);

protected:
    virtual bool event(QEvent *event);

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

    // The stack this window is in, or null
    WindowStack *windowStack();
    void setWindowStack(WindowStack *stack);

    MainWindow *mainWindow() const { return m_window; }

signals:
    void titleChanged();

private slots:
    void updateMainWindowParent(QDeclarativeItem *parent);
    void updateSize(QSize newSize);

private:
    MainWindow *m_window;
    WindowStack *m_stack;
};

#endif // WINDOW_H
