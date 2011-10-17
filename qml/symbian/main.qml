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

import QtQuick 1.0
import com.nokia.symbian 1.0
import "../core"
import "../core/core.js" as Core

Window {
    id: window

    function onMainEventsChanged() {
        if (pageStack.currentPage.objectName === 'splash')
            pageStack.replace(mainPage)
        allPage.busy = false

        statusBar.visible = true
        toolBar.visible = true
    }

    function onUserEventsChanged() {
        userPage.title = Qt.createComponent("../core/Settings.qml").createObject(null).value("lpuser")
    }

    StatusBar { id: statusBar; anchors.top: window.top }

    PageStack {
        id: pageStack
        anchors { left: parent.left; right: parent.right; top: statusBar.bottom; bottom: toolBar.top }
    }

    Page {
        id: mainPage

        TabBar {
            id: tabBar
            anchors { left: parent.left; right: parent.right; top: parent.top }
            TabButton { tab: allPage; text: "All" }
            TabButton { tab: userPage; text: "User" }
        }

        TabGroup {
            id: tabGroup
            anchors { left: parent.left; right: parent.right; top: tabBar.bottom; bottom: parent.bottom }
            MainPage { id: allPage; pageStack: mainPage.pageStack }
            ListPage { id: userPage; pageStack: mainPage.pageStack; model: userCalendar.sessionModel }
        }
    }

    Menu {
        id: menu
        content: MenuLayout {
            MenuItem { text: qsTr("Clear Cache"); onClicked: Core.clearCache() }
            MenuItem { text: qsTr("Settings"); onClicked: pageStack.push(Qt.resolvedUrl("SettingsDialog.qml")) }
            MenuItem { text: qsTr("About"); onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml")) }
        }
    }

    ToolBar {
        id: toolBar
        anchors.bottom: window.bottom
        tools: ToolBarLayout {
            id: toolBarLayout
            ToolButton {
                iconSource: "toolbar-back"
                onClicked: pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
            }
            ToolButton {
                enabled: !(pageStack.currentPage == mainPage)
                iconSource: "toolbar-home"
                onClicked: { pageStack.clear(); pageStack.push(mainPage) }
            }
            ToolButton {
                iconSource: "toolbar-refresh"
                onClicked: Core.update()
            }
            ToolButton {
                flat: true
                iconSource: "toolbar-list"
                onClicked: menu.open()
            }
        }
    }

    Component.onCompleted: {
        mainCalendar.eventsChanged.connect(onMainEventsChanged)
        userCalendar.eventsChanged.connect(onUserEventsChanged)

        if (Core.hasCache()) {
            pageStack.push(mainPage)
            Core.updateFromCache();
            Qt.createComponent("../core/UpdateTimer.qml").createObject(null)
        } else {
            statusBar.visible = false
            toolBar.visible = false
            pageStack.push(Qt.resolvedUrl('SplashPage.qml'), { objectName: 'splash' })
        }
    }
}
