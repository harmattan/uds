#include "Window.h"

void WindowStack::push(QObject *object)
{
    Window *window = qobject_cast<Window *>(object);
    Q_ASSERT(window);
    MainWindow *mainWindow = window->mainWindow();
    Q_ASSERT(mainWindow);

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
        m_stack.pop();
    }
    // standard event processing
    return QObject::eventFilter(obj, event);
}

// -------------------------------------------------------------------------- //

Window::Window(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    m_window(new MainWindow),
    m_stack(0)
{
    qDebug() << Q_FUNC_INFO;
    connect(this, SIGNAL(parentChanged(QDeclarativeItem*)),
            this, SLOT(updateMainWindowParent(QDeclarativeItem*)));
}

Window::~Window()
{
    delete m_window;
    // Leaking stacks
}

void Window::componentComplete()
{
//    m_window->show();
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
    // If no stack is set, we simply create one for the lolz of it.
    if (!m_stack)
        return m_stack = new WindowStack;
    return m_stack;
}

void Window::setWindowStack(WindowStack *stack)
{
    if (m_stack)
        m_stack->deleteLater();
    m_stack = stack;
}

void Window::updateMainWindowParent(QDeclarativeItem *parent)
{
    MainWindow *parentWindow = qobject_cast<MainWindow *>(parent);
    if (parentWindow)
        m_window->setParent(parentWindow);
}
