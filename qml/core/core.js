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
