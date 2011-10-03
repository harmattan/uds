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

/**
 * @returns cpp Settings wrapper object without parent (i.e. lifetime depends on scope)
 */
function settings() {
    return Qt.createComponent("../core/Settings.qml").createObject(null)
}

function updateFromCache() {
    __updateInternal(true)
}

function update() {
    __updateInternal(false)
}

// -------------------------------- PRIVATE --------------------------------- //

function __updateInternal(fromCache)
{
    if (fromCache)
        mainCalendar.updateFromCache("http://summit.ubuntu.com/uds-o.ical")
    else
        mainCalendar.update("http://summit.ubuntu.com/uds-o.ical")

    var username = Qt.createComponent("../core/Settings.qml").createObject(null).value("lpuser")
    if (username) {
        if (fromCache)
            userCalendar.updateFromCache("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
        else
            userCalendar.update("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
    }
}
