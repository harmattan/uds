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
import com.ubuntu.summit.maemo 5.0
import "../core/introspect.js" as Introspect

WindowBase {
    function createWindow(window, properties) {
        var windowInstance

        var comp
        if (window.createObject) {
            comp = window
        } else if (typeof window === "string") {
            comp = Qt.createComponent(window)
        }

        if (comp) {
            if (comp.status == Component.Error) {
                throw new Error("Error while loading page: " + comp.errorString());
            } else {
                windowInstance = comp.createObject(null);
            }
        }

        windowInstance["title"] = properties["title"]
        console.debug(properties["title"])
        console.debug(windowInstance["title"])

        for (var attr in properties || {}) {
            windowInstance[attr] = properties[attr]
        }

        return windowInstance
    }
}
