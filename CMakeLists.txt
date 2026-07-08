
cmake_minimum_required(VERSION 3.16)

project(windowpager)


set(QT_QML_GENERATE_QMLLS_INI ON)
set(QT_MIN_VERSION "6.10.0")
set(KF6_MIN_VERSION "6.24.0")
set(KDE_COMPILERSETTINGS_LEVEL "6.0.0")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)



find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})



include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Plasma REQUIRED)

find_package(Qt6 REQUIRED COMPONENTS
   CONFIG REQUIRED
    Core
    Qml
    DBus
    Widgets
)

find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    Config
    # I18n
)

find_package(Plasma ${PROJECT_DEP_VERSION} REQUIRED)


plasma_install_package(package dev.hunterwhite.pager)

add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_dev.hunterwhite.pager\")

set(DBUS_INTERFACES_INSTALL_DIR /usr/share/dbus-1/interfaces)

set(windowpager_SRCS
    plugin/pager.cpp
    plugin/pagerItem.cpp
    plugin/DBusService.cpp
    plugin/cJSON.cpp
)

add_library(windowpager SHARED ${windowpager_SRCS})

# target_link_libraries(windowpager
#     Qt::Core
#     Qt::Qml
#     # KF5::Plasma
#     # KF5::I18n
# )

target_link_libraries(windowpager
    PRIVATE
        Qt6::Qml
        Qt6::Quick
        Qt6::Widgets
        Qt6::DBus
        KF6::ConfigCore
        Plasma::Plasma
)

qt_add_qml_module(windowpager
    URI dev.hunterwhite.pager
    VERSION 1.0
    OUTPUT_DIRECTORY
        ${CMAKE_BINARY_DIR}/dev/hunterwhite/pager
    SOURCES
        plugin/pager.cpp
        plugin/pagerItem.cpp
        plugin/DBusService.cpp
        plugin/cJSON.cpp
    QML_FILES
        package/contents/ui/main.qml
        package/contents/ui/configGeneral.qml
    RESOURCES
       package/contents/config/main.xml
)




set(HOME_DIR $ENV{HOME})

file(MAKE_DIRECTORY ${HOME_DIR}/.local/share/window-pager)


install(TARGETS windowpager DESTINATION ${KDE_INSTALL_QMLDIR}/dev/hunterwhite/pager)
install(FILES plugin/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/dev/hunterwhite/pager)
