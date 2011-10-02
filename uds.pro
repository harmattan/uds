include(libqcalparser/libqcalparser.pro)
INCLUDEPATH += $$PWD/libqcalparser/src
DEPENDPATH += $$PWD/libqcalparser/src

TEMPLATE = app
TARGET = uds
QT += gui network

contains(MEEGO_EDITION, harmattan) {                                 # Harmattan
    DEFINES += Q_WS_HARMATTAN
    DEFINES += MEEGO_EDITION_HARMATTAN
    CONFIG  += qdeclarative-boostable

    desktopfile.files = $${TARGET}_harmattan.desktop
    desktopfile.path = /usr/share/applications
    INSTALLS += desktopfile

    icon.files = $${TARGET}.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon

    harmattan_qml.source = qml/harmattan
    harmattan_qml.target = qml
    DEPLOYMENTFOLDERS += harmattan_qml
} else:maemo5 {                                                      # Fremantle
    DEFINES += Q_WS_MAEMO_5
    SOURCES += \
        src/maemo5/Window.cpp \
        src/maemo5/DeclarativeShell.cpp
    HEADERS += \
        src/maemo5/Window.h \
        src/maemo5/DeclarativeShell.h

    maemo_5_qml.source = qml/maemo5
    maemo_5_qml.target = qml
    DEPLOYMENTFOLDERS += maemo_5_qml
} else:symbian {                                                       # Symbian
    DEFINES += Q_WS_SYMBIAN

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
} else:!isEmpty(ANDROID) {                                             # Android
    DEFINES += Q_WS_ANDROID

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
} else {                                                               # Desktop
    desktop_qml.source = qml/desktop
    desktop_qml.target = qml
    DEPLOYMENTFOLDERS += desktop_qml
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
    src/RemoteManager.h \
    src/DesktopServices.h \
    src/SessionModel.h \
    src/Settings.h



# Qt Creator Deployment Helpers
include(src/qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
