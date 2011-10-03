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
import com.nokia.meego 1.0
import "../core/weekday.js" as WeekDay

Button {
    property int weekDay: 0
    property variant page: undefined

    visible: page !== undefined && page.model !== undefined && page.itemCount > 0

    text: WeekDay.numberToString(weekDay)
    onClicked: pageStack.push(page)
}
