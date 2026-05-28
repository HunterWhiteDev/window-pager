import QtQml
import QtQuick
import QtQuick.Layouts
import dev.hunterwhite.pager 1.0
import org.kde.kirigami as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    property bool cfg_showActiveIcon: Plasmoid.configuration.showActiveIcon
    property bool cfg_showInactiveIcon: Plasmoid.configuration.showInactiveIcon
    property bool cfg_showActiveIndex: Plasmoid.configuration.showActiveIndex
    property bool cfg_showInactiveIndex: Plasmoid.configuration.showInactiveIndex

    Component.onCompleted: {
        console.log("FormFactor", Plasmoid.formFactor);
        console.log("CFG:");
        console.log(cfg_showActiveIcon);
    }

    preferredRepresentation: compactRepresentation

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

                property int activeIndex

                model: 0

                Rectangle {
                    required property int index

                    width: windowRow.width + 15
                    height: 25
                    border.width: 1
                    border.color: index == repeater.activeIndex ? "pink" : "black"
                    radius: 75
                    color: "#291f39"

                    Row {
                        id: windowRow
                        anchors.centerIn: parent
                        spacing: 5
                        Kirigami.Icon {
                            // visible: index === repeater.activeIndex
                            source: repeater.desktopFileNames[index]
                            anchors.verticalCenter: parent.verticalCenter
                            width: 20
                            height: 20
                        }

                        Text {
                            color: "white"
                            text: Math.floor(repeater.xPositions[index])
                            // text: () => {
                            //     if (activeIndex === index) {
                            //         if (showActiveIndex)
                            //             return index + 1;
                            //         else
                            //             return "";
                            //     } else {
                            //         if (showInctiveIndex) {
                            //             return index + 1;
                            //         }
                            //         return "";
                            //     }
                            // }
                        }
                    }
                }
            }
            Pager {
                id: pager
                onUpdate: (activeIndex, windowArr, desktopFileNames, xPositions) => {
                    console.log(desktopFileNames);
                    console.log(xPositions);
                    repeater.desktopFileNames = desktopFileNames;
                    repeater.model = windowArr.length || 0;
                    repeater.activeIndex = activeIndex;
                    repeater.xPositions = xPositions;
                }
            }
        }
    }
}
