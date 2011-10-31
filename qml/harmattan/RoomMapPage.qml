/*
    Copyright (C) 2011 Harald Sitter <apachelogger@ubuntu.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: page

    property double currentWidth;
    property double currentHeight;

    property double originalWidth;
    property double originalHeight;

    property bool imageHandled: false;
    property bool imageFlicked: false;

    property bool resizeToFit;

    //property list<string> images;

    property int listID;
    property int currentID;

    property int totalImages;

    ///////////

    property alias currentImage: map

    ///////////////////////////////

    anchors.fill: parent
    tools: commonTools

    Flickable {
        id: flickable

        anchors.fill: parent

        contentWidth: map.width * map.scale
        contentHeight: map.height * map.scale

        onFlickStarted: flicked()

        onHeightChanged: adjustImage()
        onWidthChanged: adjustImage()

        Image {
            id: map

            fillMode: Image.PreserveAspectFit
            scale: 1
            smooth: true
            source: "../images/maps/uds-p.jpeg"
            transformOrigin: Item.TopLeft
        }

        MouseArea {
            id: areaZoomDown
            x: 0 + flickable.contentX
            y: page.height - 80 + flickable.contentY
            width: 80
            height: 80
            onClicked: zoomDown();
            Image {
                id: zoomDownIcon
                source: "image://theme/icon-m-common-remove"
                anchors.centerIn: parent
            }
        }

        MouseArea {
            id: areaZoomUp
            x: page.width - 80 + flickable.contentX
            y: page.height - 80 + flickable.contentY
            width: 80
            height: 80
            onClicked: zoomUp();
            Image {
                id: zoomUpIcon
                source: "image://theme/icon-m-common-add"
                anchors.centerIn: parent
            }
        }
    }

    function flicked() {
        imageHandled = true;
        imageFlicked = true;
    }

    function adjustImage() {
        if (imageHandled == false && resizeToFit == true) fitToScreen();
    }

    function zoomUp() {
        imageHandled = true;
        var flickX = flickable.contentX;
        var flickY = flickable.contentY;
        currentImage.scale += 0.1;
        if (currentImage.scale >= 1.5) currentImage.scale = 1.5;
        if (currentImage.scale != 1.5 && imageFlicked === true) {
            flickable.contentX = 1.1 * flickX;
            flickable.contentY = 1.1 * flickY;
        }
        else if (imageFlicked == false) {
            if (currentImage.width > page.width || currentImage.height > page.height) {
                if (currentImage.width > page.width) flickable.contentX = (originalWidth * currentImage.scale) / 2 - page.width / 2;
                if (currentImage.height > page.height) flickable.contentY = (originalHeight * currentImage.scale) / 2 - page.height / 2;
            }
        }
        if (currentImage.width <= page.width) flickable.contentX = 0;
        if (currentImage.height <= page.height) flickable.contentY = 0;

        resize();
    }

    function zoomDown() {
        imageHandled = true;
        var flickX = flickable.contentX;
        var flickY = flickable.contentY;
        currentImage.scale -= 0.1;
        if (currentImage.scale <= 0.1) currentImage.scale = 0.1;
        if (currentImage.scale != 0.1 && imageFlicked == true) {
            flickable.contentX = 0.9 * flickX;
            flickable.contentY = 0.9 * flickY;
        }
        else if (imageFlicked == false) {
            if ((originalWidth * currentImage.scale) > page.width || (originalHeight * currentImage.scale) > page.height) {
                if ((originalWidth * currentImage.scale) > page.width) flickable.contentX = (originalWidth * currentImage.scale) / 2 - page.width / 2;
                if ((originalHeight * currentImage.scale) > page.height) flickable.contentY = (originalHeight * currentImage.scale) / 2 - page.height / 2;
            }
        }
        if (originalWidth * currentImage.scale <= page.width) flickable.contentX = 0;
        if (originalHeight * currentImage.scale <= page.height) flickable.contentY = 0;

        resize();
    }

    function centerOnZoom() {
        var contentX = flickable.contentX;
        var contentY = flickable.contentY;
        if (currentImage.scale > 1.0) {
            if (currentImage.width > flickable.width) flickable.contentX = contentX + (originalWidth - originalWidth * currentImage.scale) / 2;
            if (currentImage.height > flickable.height) flickable.contentY = contentY + (originalHeight - originalHeight * currentImage.scale) / 2;
        }
        else if (currentImage.scale < 1.0) {
            if (currentImage.width > flickable.width) flickable.contentX = contentX - (originalWidth - originalWidth * currentImage.scale) / 2;
            if (currentImage.height > flickable.height) flickable.contentY = contentY - (originalHeight - originalHeight * currentImage.scale) / 2;
        }
    }

    function showImage(string, id) {
        imageHandled = false;
        imageFlicked = false;
        currentID = id;
        base.getImageID(string);
        setTotalText();
        currentImage.scale = 1;
        currentImage.source = string;
        resize();
    }

    function fitToScreen() {
        var resizeScale;

        currentImage.scale = Math.min( page.width/currentImage.width, page.height/currentImage.height);
        resize();
        centerInResized();
    }

    function centerInResized() {
        flickable.contentX = 0;
        flickable.contentY = 0;
    }

    function centerIn() {
        if (currentImage.width >= flickable.width) {
            flickable.contentX = currentImage.width / 2 - flickable.width / 2;
        }
        if (currentImage.height >= flickable.height) {
            flickable.contentY = currentImage.height / 2 - flickable.height / 2;
        }
    }

    function resize() {
//        flickable.resizeContent()
        flickable.returnToBounds()
        if (currentImage.status == Image.Ready) {
            currentImage.x = 0;
            currentImage.y = 0;

            currentWidth = currentImage.width * currentImage.scale;
            currentHeight = currentImage.height * currentImage.scale;

            if (scale != 1) return;

            if (currentWidth < page.width) {
                currentImage.x = page.x + page.width - (page.width / 2) - currentWidth / 2;
            }
            if (currentHeight < page.height) {
                currentImage.y = page.y + page.height - (page.height / 2) - currentHeight / 2;
            }
        }
        else {
            return;
        }
    }
}
