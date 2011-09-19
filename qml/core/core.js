//.pragma library

function updateFromCache() {
    __updateInternal(true)
}

function update() {
    __updateInternal(false)
}

function __updateInternal(fromCache)
{
    if (fromCache)
        mainCalendar.updateFromCache("http://summit.ubuntu.com/uds-o.ical")
    else
        mainCalendar.update("http://summit.ubuntu.com/uds-o.ical")

    var username = Qt.createComponent("Settings.qml").createObject(null).value("lpuser")
    if (username) {
        if (fromCache)
            userCalendar.updateFromCache("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
        else
            userCalendar.update("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
    }
}
