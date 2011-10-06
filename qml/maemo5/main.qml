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
//import QtDesktop 0.1
import com.ubuntu.summit.maemo 5.0
import "../core/core.js" as Core
import "../core/weekday.js" as WeekDay
import "../core/introspect.js" as Introspect

StackedWindow {
    id: appWindow

    property bool initialized: false

    function init() {
        for (var i = 0; i < 7; ++i) {
            mainWindow.model.append({"dayOfWeek": i})
        }
        initialized = true
    }

    function onMainEventsChanged() {
        if (!initialized)
            init()
    }

    MenuGroup {
        id: menuGroup
        MenuItem {
            text: qsTr("Schedule");
            checkable: true;
            checked: true
        }
        MenuItem { text: qsTr("You Schedule"); checkable: true; }
    }
    MenuItem { id: setting; text: qsTr("Settings") }

    ListWindow {
        id: mainWindow

        model: ListModel {}
        delegate: ListDelegate {
            title.text: WeekDay.numberToString(dayOfWeek)
            onClicked: {
                var c = Qt.createComponent("SessionListWindow.qml")
                var o = c.createObject(null)
                o.dayOfWeek = dayOfWeek
                o.model = mainCalendar.sessionModel
                windowStack.push(o)
//                windowStack.push(mainWindow.createWindow(
//                                     "SessionListWindow.qml",
//                                     {
//                                         dayOfWeek: dayOfWeek,
//                                         model: mainCalendar.sessionModel
//                                     }))
            }
        }

        Component.onCompleted: {
            mainWindow.addActions(menuGroup)
            mainWindow.addAction(setting)
        }
    }

    Component.onCompleted: {
        mainCalendar.eventsChanged.connect(onMainEventsChanged)
//        userCalendar.eventsChanged.connect(onUserEventsChanged)

        windowStack.push(mainWindow)

        Core.settings().setValue("name", "uds-p")
        Core.updateFromCache();
//        Core.update();
    }
}
