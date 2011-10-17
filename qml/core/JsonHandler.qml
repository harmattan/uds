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

QtObject {
    property ListModel listModel: ListModel {}
    signal listModelChanged

    function load(url) {
        listModel.clear();
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState == xhr.DONE) {
//                if (xhr.status == 200) {
                console.debug("xhr status: " + xhr.status)
                    __loaded(JSON.parse(xhr.responseText))
//                }
            }
        }
        xhr.send();
    }

    function __loaded(jsonArray) {
        for (var i = 0; i < jsonArray.length; ++i) {
            listModel.append(jsonArray[i]);
        }
        listModelChanged()
    }
}
