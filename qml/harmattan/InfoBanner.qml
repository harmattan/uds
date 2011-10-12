import QtQuick 1.1
import com.nokia.extras 1.0

InfoBanner {
    property bool __wasVisible: false

    anchors.top: parent.top
    anchors.topMargin: 64

    onVisibleChanged: {
        if (__wasVisible && !visible)
            destroy()
        else if (!__wasVisible && visible)
            __wasVisible = true
    }
}
