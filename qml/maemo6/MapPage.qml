import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2

Page {
    id: page
    tools: commonTools

    property real defaultLatitude: 47.50272
    property real defaultLongitude: 19.0687939
    property int  defaultZoomLevel: 20
    property alias mapType: map.mapType

    anchors.fill: parent

    Map {
        id: map

        anchors.fill: parent
        zoomLevel: page.defaultZoomLevel
        plugin: Plugin { name: "nokia" }
        mapType: Map.StreetMap

        center: Coordinate {
            latitude: page.defaultLatitude
            longitude: page.defaultLongitude
        }
    }

    PinchArea {
        id: pincharea

        property real __oldZoom

        anchors.fill: parent

        function calcZoomDelta(zoom, percent) {
            return zoom + Math.log(percent)/Math.log(2)
        }

        onPinchStarted: {
            __oldZoom = map.zoomLevel
        }

        onPinchUpdated: {
            map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
        }

        onPinchFinished: {
            map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
        }
    }

    MouseArea {
        id: mousearea

        property bool __isPanning: false
        property int __lastX: -1
        property int __lastY: -1

        anchors.fill : parent

        onPressed: {
            __isPanning = true
            __lastX = mouse.x
            __lastY = mouse.y
        }

        onReleased: {
            __isPanning = false
        }

        onPositionChanged: {
            if (__isPanning) {
                var dx = mouse.x - __lastX
                var dy = mouse.y - __lastY
                map.pan(-dx, -dy)
                __lastX = mouse.x
                __lastY = mouse.y
            }
        }

        onCanceled: {
            __isPanning = false;
        }
    }

}
