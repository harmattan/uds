import QtQuick 1.0
import com.nokia.meego 1.0
import "WeekDay.js" as WeekDay

Button {
    property int weekDay: 0
    property variant page: undefined

    visible: page !== undefined && page.model !== undefined && page.model.length > 1

    text: WeekDay.numberToString(weekDay)
    onClicked: pageStack.push(page)
}
