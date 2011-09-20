import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: page

    anchors.fill: parent
    tools: commonTools

//    ScrollDecorator { flickableItem: flickable }

    Flickable {
        id: flickable

        clip: true
        boundsBehavior: Flickable.DragOverBounds
        anchors.fill: parent
        contentHeight: map.width; contentWidth: map.height;

//        onWidthChanged: { console.debug("width: "+width)  }
//        onHeightChanged: { console.debug("height: "+height) }

//        onContentHeightChanged: console.log("ch "+contentHeight)
//        onContentWidthChanged: console.log("cw "+contentWidth)

        Image {
            id: map

            property real zoom: 1
            property real zoomWidth: page.width * zoom
            property real zoomHeight: page.height * zoom

            onPaintedGeometryChanged: {
                console.debug(paintedWidth)
                console.debug(paintedHeight)
            }

            width:  zoomWidth
            height: zoomHeight
            source: "../images/room-map.jpg"
            fillMode: Image.PreserveAspectFit

//            onPaintedWidthChanged: { console.debug("width: "+width + " | paintedWidth: "+paintedWidth); }
//            onPaintedHeightChanged: { console.debug("height: "+height + " | paintedHeight: " +paintedHeight) }
//            onWidthChanged: { console.debug("width: "+width + " | paintedWidth: "+paintedWidth); }
//            onHeightChanged: { console.debug("height: "+height + " | paintedHeight: " +paintedHeight) }

//            Image {
//                id: pin
//                source: "image://theme/icon-m-common-location-selected"
//                x: 745
//                y: 391
//            }
        }

        PinchArea {
            property real __oldZoom

            anchors.fill: parent
            pinch.maximumScale: 10
            pinch.minimumScale: 1

            function calcZoomDelta(zoom, percent) {
                var z = zoom + Math.log(percent)/Math.log(2)
                return z < 1.0 ? 1.0 : z
            }

            onPinchStarted: {
                __oldZoom = map.zoom
            }

            onPinchUpdated: {
                console.debug(pinch.scale)
                map.zoom = calcZoomDelta(__oldZoom, pinch.scale)
            }

            onPinchFinished: {
                console.debug(pinch.scale)
                map.zoom = calcZoomDelta(__oldZoom, pinch.scale)
                flickable.returnToBounds()
            }
        }
    }
}
