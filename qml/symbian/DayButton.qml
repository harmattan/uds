import QtQuick 1.0
import com.nokia.symbian 1.0

import "../core/weekday.js" as WeekDay

Button {
    property int weekDay: 0
    property variant page: undefined

    visible: page !== undefined && page.model !== undefined && page.itemCount > 0

    text: WeekDay.numberToString(weekDay)
    onClicked: pageStack.push(page)
}
