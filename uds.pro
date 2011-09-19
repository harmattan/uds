include(libqcalparser/libqcalparser.pro)
INCLUDEPATH += $$PWD/libqcalparser/src
DEPENDPATH += $$PWD/libqcalparser/src

TEMPLATE = app
TARGET = uds
QT += gui network

#!isEmpty(MEEGO_VERSION_MAJOR) {
contains(MEEGO_EDITION,harmattan) {
    DEFINES += Q_WS_MAEMO_6
    DEFINES += MEEGO_EDITION_HARMATTAN
    CONFIG  += qdeclarative-boostable

    desktopfile.files = $${TARGET}_harmattan.desktop
    desktopfile.path = /usr/share/applications
    INSTALLS += desktopfile

    icon.files = $${TARGET}.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon
}

maemo5 {
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
}

symbian {
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
}

folder_01.source = qml/ubuntudevelopersummit
folder_01.target = qml
folder_02.source = qml/desktop
folder_02.target = qml
DEPLOYMENTFOLDERS = folder_01 folder_02

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
