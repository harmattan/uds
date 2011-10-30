include(libqcalparser/libqcalparser.pro)
INCLUDEPATH += $$PWD/libqcalparser/src
DEPENDPATH += $$PWD/libqcalparser/src

TEMPLATE = app
TARGET = UDS
QT += gui network

# OS components can be forced by adding CONFIG+=os_name to the qmake call.
# Options are: os_harmattan, os_maemo5, os_symbian, os_android, os_desktop.
contains(MEEGO_EDITION, harmattan)|!isEmpty(HARMATTAN) {
    CONFIG += os_harmattan
} else:maemo5 {
    CONFIG += os_maemo5
} else:symbian {
    CONFIG += os_symbian
} else:android {
    CONFIG += os_android
} else {
    CONFIG += os_desktop
}

os_harmattan {                                                       # Harmattan
    message("Building for Harmattan")
    DEFINES += Q_WS_HARMATTAN
    DEFINES += MEEGO_EDITION_HARMATTAN
    CONFIG  += qdeclarative-boostable

    desktopfile.files = $${TARGET}_harmattan.desktop
    desktopfile.path = /usr/share/applications
    INSTALLS += desktopfile

    harmattan_qml.source = qml/harmattan
    harmattan_qml.target = qml
    DEPLOYMENTFOLDERS += harmattan_qml
} else:os_maemo5 {                                                   # Fremantle
    message("Building for Maemo 5")
    DEFINES += Q_WS_MAEMO_5
    SOURCES += \
        src/maemo5/DeclarativeShell.cpp \
        src/maemo5/MenuGroup.cpp \
        src/maemo5/MenuItem.cpp \
        src/maemo5/Window.cpp
    HEADERS += \
        src/maemo5/DeclarativeShell.h \
        src/maemo5/MenuGroup.h \
        src/maemo5/MenuItem.h \
        src/maemo5/Window.h

    maemo_5_qml.source = qml/maemo5
    maemo_5_qml.target = qml
    DEPLOYMENTFOLDERS += maemo_5_qml
} else:os_symbian {                                                    # Symbian
    message("Building for Symbian")
    DEFINES += Q_WS_SYMBIAN
    VERSION = 12.04.0

    symbian:TARGET.UID3 = 0xE054205C

    # Smart Installer package's UID
    # This UID is from the protected range and therefore the package will
    # fail to install if self-signed. By default qmake uses the unprotected
    # range value if unprotected UID is defined for the application and
    # 0x2002CCCF value if protected UID is given to the application
    #symbian:DEPLOYMENT.installer_header = 0x2002CCCF

    # Allow network access on Symbian
    symbian:TARGET.CAPABILITY += NetworkServices

    # Add dependency to symbian components
    CONFIG += qtquickcomponents

    symbian_qml.source = qml/symbian
    symbian_qml.target = qml
    DEPLOYMENTFOLDERS += symbian_qml
} else:os_android {                                                    # Android
    message("Building for Android")
    DEFINES += Q_WS_ANDROID

    SOURCES += \
        src/android/AndroidQmlAppViewer.cpp

    HEADERS += \
        src/android/AndroidQmlAppViewer.h \
        src/android/PageStatus.h

    OTHER_FILES += \
        android/res/drawable-mdpi/icon.png \
        android/res/values/strings.xml \
        android/res/values/libs.xml \
        android/res/drawable-ldpi/icon.png \
        android/res/drawable-hdpi/icon.png \
        android/AndroidManifest.xml \
        android/src/eu/licentia/necessitas/ministro/IMinistro.aidl \
        android/src/eu/licentia/necessitas/ministro/IMinistroCallback.aidl \
        android/src/eu/licentia/necessitas/industrius/QtApplication.java \
        android/src/eu/licentia/necessitas/industrius/QtSurface.java \
        android/src/eu/licentia/necessitas/industrius/QtActivity.java \
        android/src/eu/licentia/necessitas/industrius/QtLayout.java \
        android/src/eu/licentia/necessitas/mobile/QtMediaPlayer.java \
        android/src/eu/licentia/necessitas/mobile/QtLocation.java \
        android/src/eu/licentia/necessitas/mobile/QtFeedback.java \
        android/src/eu/licentia/necessitas/mobile/QtAndroidContacts.java \
        android/src/eu/licentia/necessitas/mobile/QtSensors.java \
        android/src/eu/licentia/necessitas/mobile/QtSystemInfo.java \
        android/src/eu/licentia/necessitas/mobile/QtCamera.java

    RESOURCES += \
        qml/android.qrc

    android_qml.source = qml/android
    android_qml.target = qml
    DEPLOYMENTFOLDERS += android_qml
} else:os_desktop {                                                         # Desktop
    message("Building for Desktop")
    desktop_qml.source = qml/desktop
    desktop_qml.target = qml
    DEPLOYMENTFOLDERS += desktop_qml
} else {
    error("No viable QtQuick target found.")
}

core_qml.source = qml/core
core_qml.target = qml
images_qml.source = qml/images
images_qml.target = qml
DEPLOYMENTFOLDERS += core_qml images_qml

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

SOURCES += \
    src/main.cpp \
    src/RemoteManager.cpp \
    src/SessionModel.cpp

HEADERS += \
    src/DesktopServices.h \
    src/RemoteManager.h \
    src/SessionModel.h \
    src/Settings.h

# Qt Creator Deployment Helpers
include(src/qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

# Icon deployment rules MUST BE after the qtc deployment
os_harmattan {
    icon.files = icons/harmattan/uds80.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon
} else:os_maemo5{
    icon.files = icons/harmattan/uds64.png
    icon.path = /usr/share/icons/hicolor/64x64/apps
    INSTALLS += icon
} else:os_symbian {
    ICON = icons/symbian/uds.svg
}
