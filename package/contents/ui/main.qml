import QtQml
import QtQuick
import QtQuick.Layouts
import dev.hunterwhite.pager 1.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    id: base
    //States
    property bool cfg_showActiveIcon: Plasmoid.configuration.showActiveIcon
    property bool cfg_showInactiveIcon: Plasmoid.configuration.showInactiveIcon
    property bool cfg_showActiveIndex: Plasmoid.configuration.showActiveIndex
    property bool cfg_showInactiveIndex: Plasmoid.configuration.showInactiveIndex

    //Colors
    property string cfg_activeBackgroundColor: Plasmoid.configuration.activeBackgroundColor
    property string cfg_inActiveBackgroundColor: Plasmoid.configuration.inActiveBackgroundColor
    property string cfg_activeBorderColor: Plasmoid.configuration.activeBorderColor
    property string cfg_inActiveBorderColor: Plasmoid.configuration.inActiveBorderColor
    property string cfg_activeTextColor: Plasmoid.configuration.activeTextColor
    property string cfg_inActiveTextColor: Plasmoid.configuration.inActiveTextColor
    //Ignore list
    property list<string> cfg_ignoreList: Plasmoid.configuration.ignoreList

    preferredRepresentation: compactRepresentation

    toolTipMainText: "" // set to empty to prevent automatic tooltip generation through compactRepresentation
    toolTipSubText: ""

    fullRepresentation: Item {
        Layout.preferredWidth: 1200 * PlasmaCore.Units.devicePixelRatio
        Layout.preferredHeight: 480 * PlasmaCore.Units.devicePixelRatio
    }

    compactRepresentation: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight
        Layout.minimumWidth: 200
        anchors.verticalCenter: parent.verticalCenter

        Row {
            id: row
            spacing: 5
            height: parent.height
            anchors.centerIn: parent
            Repeater {
                id: repeater
                anchors.centerIn: parent
                width: parent.width
                property list<string> desktopFileNames: [""]
                property list<double> xPositions: []
                property list<string> captions: []
                property list<string> resourceClasses: []

                property int activeIndex

                model: 0

                Rectangle {

                    required property int index

                    width: windowRow.width + 15
                    height: 25
                    border.width: 1
                    border.color: index == repeater.activeIndex ? cfg_activeBorderColor : cfg_inActiveBorderColor

                    radius: 75
                    color: index == repeater.activeIndex ? cfg_activeBackgroundColor : cfg_inActiveBackgroundColor

                    PlasmaComponents3.ToolButton {
                        anchors.fill: parent
                        anchors.centerIn: parent

                        PlasmaCore.ToolTipArea {
                            anchors.fill: parent
                            mainText: repeater.captions[index]
                            subText: `Resource Class: ${repeater.resourceClasses[index]}`
                        }

                        Row {
                            id: windowRow
                            anchors.centerIn: parent
                            spacing: 5
                            Kirigami.Icon {
                                visible: index == repeater.activeIndex ? cfg_showActiveIcon : cfg_showInactiveIcon
                                source: repeater.desktopFileNames[index]
                                anchors.verticalCenter: parent.verticalCenter
                                width: 20
                                height: 20
                            }

                            Text {
                                color: repeater.activeIndex === index ? cfg_activeTextColor : cfg_inActiveTextColor
                                //For Debugging
                                // text: Math.floor(repeater.xPositions[index])
                                text: index === repeater.activeIndex ? cfg_showActiveIndex ? index + 1 : "" : cfg_showInactiveIndex ? index + 1 : ""
                            }
                        }
                    }
                }
            }
        }
        Pager {
            id: pager
            Component.onCompleted: {
                pager.setIgnoreList(cfg_ignoreList);
            }
            onUpdate: (activeIndex, windowArr, desktopFileNames, xPositions, captions, resourceClasses) => {
                console.log(captions);
                repeater.desktopFileNames = desktopFileNames;
                repeater.model = windowArr.length || 0;
                repeater.activeIndex = activeIndex;
                repeater.xPositions = xPositions;
                repeater.captions = captions;
                repeater.resourceClasses = resourceClasses;
            }
        }
    }
}
