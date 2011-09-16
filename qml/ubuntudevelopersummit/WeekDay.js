.pragma library

var weekday = new Array("Sunday",
                        "Monday",
                        "Tuesday",
                        "Wednesday",
                        "Thursday",
                        "Friday",
                        "Saturday")

function stringToNumber(string) {
    console.debug("weekDayStringToNumber")
    for (var i = 0; i < weekday.length; ++i) {
        console.debug("iter")
        if (string === weekday[i])
            return i
    }
    console.debug("zomg")
    return null
}

function numberToString(number) {
    return weekday[number]
}
