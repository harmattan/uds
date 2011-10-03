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

var __id = 'uds-o'

function __ical() {
    return 'http://summit.ubuntu.com/' + __id + '.ical'
}

function __icalParticipant(participant) {
    return 'http://summit.ubuntu.com/' + __id + '/participant/' + participant + '.ical'
}

function __updateInternal(fromCache)
{
    var url = __ical()
    if (fromCache)
        mainCalendar.updateFromCache(url)
    else
        mainCalendar.update(url)

    var username = Qt.createComponent("../core/Settings.qml").createObject(null).value("lpuser")
    if (username) {
        url = __icalParticipant(username)
        if (fromCache)
            userCalendar.updateFromCache(url)
        else
            userCalendar.update(url)
    }
}
