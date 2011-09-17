import QtQuick 1.0
import com.ubuntu.summit.maemo 5.0

StackedWindow {
    id: appWindow

    initialWindow: Window {
        id: mainWindow
        title: "Ubuntu Developer Summit"
    }

    Window {
        id: otherWindow
        title: "Less Ubuntu"
    }

    Window {
        id: otherotherWindow
        title: "/dev/null"
    }

    Component.onCompleted: {
        windowStack.push(mainWindow)
        windowStack.push(otherWindow)
        windowStack.push(otherotherWindow)
    }
}
