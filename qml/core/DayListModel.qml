import QtQuick 1.0
import "../core/weekday.js" as WeekDay

ListModel {
    id: model

    Component.onCompleted: {
        for (var i = 0; i < WeekDay.weekday.length; ++i) {
            if (i == 0 || i == 6)
                continue;
            model.append({"name": WeekDay.numberToString(i), "number": i})
        }
    }
}
