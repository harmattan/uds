import QtQuick 1.1
import "../core/core.js" as Core

Timer {
    interval: 5000; running: true; repeat: false
    onTriggered: { Core.update(); destroy() }
}
