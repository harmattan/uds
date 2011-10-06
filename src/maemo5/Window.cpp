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

#include "Window.h"

#include <QtGui/QApplication>
#include <QtGui/QDesktopWidget>
#include <QtGui/QResizeEvent>

void WindowStack::push(QObject *object)
{
    Window *window = qobject_cast<Window *>(object);
    Q_ASSERT(window);
    MainWindow *mainWindow = window->mainWindow();
    Q_ASSERT(mainWindow);

    window->setWindowStack(this);

    // The first window on the stack does not need special treatment as it
    // has no QWidget parent, and thus also needs no flag tempering.
    if (!m_stack.isEmpty()) {
        mainWindow->setParent(m_stack.last());
        mainWindow->setWindowFlags(mainWindow->windowFlags() | Qt::Window);
    }
    m_stack.push(mainWindow);
    mainWindow->installEventFilter(this);
    mainWindow->scene()->addItem(window);
    mainWindow->show();
}

bool WindowStack::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::Hide) {
        Q_ASSERT(obj == m_stack.last());
        obj->removeEventFilter(this);
        m_stack.pop();
    }
    // standard event processing
    return QObject::eventFilter(obj, event);
}

// -------------------------------------------------------------------------- //

void StackedWindow::setInitialWindow(Window *window)
{
    m_initialWindow = window;
    if (m_stack->isEmpty())
        m_stack->push(window);
}

// -------------------------------------------------------------------------- //

#include <QtGui/QMenuBar>

MainWindow::MainWindow() :
    m_view(new QDeclarativeView)
{
    setAttribute(Qt::WA_Maemo5StackedWindow);
//    setAttribute(Qt::WA_Maemo5AutoOrientation, true);
    setCentralWidget(m_view);
}

MainWindow::~MainWindow()
{
    delete m_view;
}

bool MainWindow::event(QEvent *event)
{
    switch (event->type()) {
    case QEvent::Hide: {
        qDebug() << Q_FUNC_INFO << "DELETE";
        deleteLater();
    }
    case QEvent::Resize: {
        const QResizeEvent *resize = static_cast<const QResizeEvent *>(event);
        emit sizeChanged(resize->size());
        break;
    }
    default:
        break;
    }
    return QMainWindow::event(event);
}

// -------------------------------------------------------------------------- //

#include "MenuGroup.h"
Window::Window(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    m_window(new MainWindow),
    m_stack(0)
{
    connect(m_window, SIGNAL(sizeChanged(QSize)),
            this, SLOT(updateSize(QSize)));
    m_window->view()->setResizeMode(QDeclarativeView::SizeRootObjectToView);
}

Window::~Window()
{
}

void Window::addAction(QObject *actionObject)
{
    qDebug() << "hui";
    QAction *action = qobject_cast<QAction *>(actionObject);
    m_window->menuBar()->addAction(action);
}

void Window::addActions(QObject *actionObjects)
{
    MenuGroup *group = qobject_cast<MenuGroup *>(actionObjects);
    m_window->menuBar()->addActions(group->actions());
}

QString Window::title() const
{
    return m_window->windowTitle();
}

void Window::setTitle(const QString &title)
{
    m_window->setWindowTitle(title);
}

WindowStack *Window::windowStack()
{
    return m_stack;
}

void Window::setWindowStack(WindowStack *stack)
{
    m_stack = stack;
}

void Window::updateSize(QSize newSize)
{
    QDeclarativeItem::setSize(newSize);
}
