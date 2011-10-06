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

    bool isEmpty() const { return m_stack.isEmpty(); }

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
    void setInitialWindow(Window *window);

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
    Q_PROPERTY(QFont font READ font)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(WindowStack *windowStack READ windowStack)
public:
    Window(QDeclarativeItem *parent = 0);
    ~Window();

    Q_INVOKABLE void addAction(QObject *actionObject);
    Q_INVOKABLE void addActions(QObject *menuGroup);

    QFont font() const { return m_window->font(); }

    QString title() const;
    void setTitle(const QString &title);

    // The stack this window is in, or null
    WindowStack *windowStack();
    void setWindowStack(WindowStack *stack);

    MainWindow *mainWindow() const { return m_window; }

signals:
    void titleChanged();

private slots:
    void updateSize(QSize newSize);

private:
    MainWindow *m_window;
    WindowStack *m_stack;
};

#endif // WINDOW_H
