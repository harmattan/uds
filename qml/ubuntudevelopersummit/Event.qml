import QtQuick 1.0
import "WeekDay.js" as WeekDay

QtObject {
    property int uid: 0
    property date start: new Date
    property date end: new Date
    property variant categories: []
    property string summary: ''
    property string location: ''
    property string description: ''
    property string x_type: ''
    property string x_roomname: ''
    property variant weekDay: ''
    property int weekDayNumber: start.getDay()

    onStartChanged: weekDay = WeekDay.numberToString(start.getDay())
}
