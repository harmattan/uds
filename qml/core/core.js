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

function hasCache() {
    return mainCalendar.hasCache(__ical())
}

function clearCache() {
    mainCalendar.clearCache(__ical())

    var username = settings().value("lpuser")
    if (username)
        userCalendar.clearCache(__icalParticipant())
}

function updateFromCache() {
    __updateInternal(true)
}

function update() {
    __updateInternal(false)
}

// -------------------------------- PRIVATE --------------------------------- //

var __id = 'uds-p'
var __name = 'UDS-P'
var __location = 'Orlando, Florida, USA'
var __time = '31 October - 4 November, 2011'
var __location_latitude = 28.3586255
var __location_longitude = -81.4874438

function __ical() {
    return 'http://summit.ubuntu.com/' + settings().value("name") + '.ical'
}

function __icalParticipant() {
    return 'http://summit.ubuntu.com/' + settings().value("name") + '/participant/' + settings().value("lpuser") + '.ical'
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
        url = __icalParticipant()
        if (fromCache)
            userCalendar.updateFromCache(url)
        else
            userCalendar.update(url)
    }
}
