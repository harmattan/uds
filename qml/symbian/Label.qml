import QtQuick 1.0

Text {
    color: (root.role == "SelectionSubTitle" || root.role == "SubTitle")
           ? platformStyle.colorNormalMid : platformStyle.colorNormalLight

    font {
        family: platformStyle.fontFamilyRegular
        pixelSize: (role == "Title" || role == "SelectionTitle") ? platformStyle.fontSizeLarge : platformStyle.fontSizeSmall
        weight: (role == "SubTitle" || role == "SelectionSubTitle") ? Font.Light : Font.Normal
    }
}
