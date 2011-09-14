QT += network
CONFIG += mobility versit
MOBILITY = organizer versit

!isEmpty(MEEGO_VERSION_MAJOR) {
    DEFINES += Q_WS_MAEMO_6
    DEFINES += MEEGO_EDITION_HARMATTAN
    CONFIG  += qdeclarative-boostable
    CONFIG  += meegotouch
    CONFIG  += mkcal
}

# Add more folders to ship with the application, here
folder_01.source = qml/ubuntudevelopersummit
folder_01.target = qml
folder_02.source = qml/desktop
folder_02.target = qml
DEPLOYMENTFOLDERS = folder_01 folder_02

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE054205C

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Add dependency to symbian components
# CONFIG += qtquickcomponents

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    RemoteManager.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/ubuntudevelopersummit/ical.js \
    qml/ubuntudevelopersummit/script.js \
    qml/desktop/main.qml

HEADERS += \
    banner.h \
    RemoteManager.h







