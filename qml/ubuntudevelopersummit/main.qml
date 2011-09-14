import QtQuick 1.1
import com.nokia.meego 1.0
import "."

//import "ical.js" as ICalParser

PageStackWindow {
    id: appWindow

    function onItemsChanged(manager) {
        console.debug("SDFSDF")
        parser.parse(manager);
        mainPage.model = parser.ical.events
    }

    showToolBar: true
    showStatusBar: true

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    ICalParser { id: parser }

    Component.onCompleted: {
        remoteManager.itemsChanged.connect(onItemsChanged)
        remoteManager.update()

//        console.debug(ICalParser.ical.version)
    }

//    ToolBarLayout {
//        id: commonTools
//        visible: true
//        ToolIcon {
//            platformIconId: "toolbar-view-menu"
//            anchors.right: (parent === undefined) ? undefined : parent.right
//            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
//        }
//    }

//    Menu {
//        id: myMenu
//        visualParent: pageStack
//        MenuLayout {
//            MenuItem { text: qsTr("Sample menu item") }
//        }
//    }
}
