#include "Window.h"

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

MainWindow::MainWindow() :
    m_view(new QDeclarativeView)
{
    setAttribute(Qt::WA_Maemo5StackedWindow);
    setCentralWidget(m_view);
}

MainWindow::~MainWindow()
{
    delete m_view;
}

bool MainWindow::event(QEvent *event)
{
    switch (event->type()) {
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

Window::Window(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    m_window(new MainWindow),
    m_stack(0)
{
    connect(this, SIGNAL(parentChanged(QDeclarativeItem*)),
            this, SLOT(updateMainWindowParent(QDeclarativeItem*)));
    connect(m_window, SIGNAL(sizeChanged(QSize)),
            this, SLOT(updateSize(QSize)));
    m_window->view()->setResizeMode(QDeclarativeView::SizeRootObjectToView);
}

Window::~Window()
{
    delete m_window;
}

void Window::componentComplete()
{
    m_window->scene()->addItem(this);
    QDeclarativeItem::componentComplete();
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

void Window::updateMainWindowParent(QDeclarativeItem *parent)
{
    MainWindow *parentWindow = qobject_cast<MainWindow *>(parent);
    if (parentWindow)
        m_window->setParent(parentWindow);
}

void Window::updateSize(QSize newSize)
{
    QDeclarativeItem::setSize(newSize);
}
