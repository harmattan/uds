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

.pragma library

/**
 * Provides a fakelist implemenation.
 * A fake list is a plain JavaScript Array. This is necessary because in QML one
 * can only have QML lists, and those are rather limited when it comes to
 * adding or removing QObject pointers.
 *
 * Whenever a QML list does not work a fakelist can be used by simply importing
 * this file and using its identifier as if it were a static object in C++.
 */

/** The actual internal Array */
var __array = new Array()

/** @returns the current internal array */
function getList() {
    return __array
}

/** @param item adds a new item to the internal array */
function addItem(item) {
    __array.push(item)
}
