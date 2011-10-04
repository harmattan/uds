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
import "../core/core.js" as Core

/**
 * Timer to call update after 5 seconds.
 * The timer is active right after creation, should different behavior be
 * desired the interval property needs to be modified *at* object creation.
 *
 * @code
 * Qt.createComponent("../core/UpdateTimer.qml").createObject(parent)
 * @endcode
 */
Timer {
    interval: 5000
    running: true
    repeat: false
    onTriggered: { Core.update(); destroy() }
}
