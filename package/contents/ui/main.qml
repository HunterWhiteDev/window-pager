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
    property string cfg_activeIndexColor: Plasmoid.configuration.activeIndexColor
    property string cfg_inActiveIndexColor: Plasmoid.configuration.inActiveIndexColor

    preferredRepresentation: compactRepresentation

    toolTipMainText: "" // set to empty to prevent automatic tooltip generation through compactRepresentation
    toolTipSubText: ""

    fullRepresentation: Item {
        // Layout.preferredWidth: 1200 * PlasmaCore.Units.devicePixelRatio
        // Layout.preferredHeight: 480 * PlasmaCore.Units.devicePixelRatio
    }

    compactRepresentation: Item {
        Layout.minimumWidth: row.implicitWidth 

        Row {
            id: row
            spacing: 5
            height: parent.height
            anchors.centerIn: parent
            Repeater {
                id: repeater
                anchors.centerIn: parent
                width: parent.width
                
                model: null

                delegate: Rectangle {

                    //Column
                    id: rect
                    required property int index
                    required property string xPosStart 
                    required property var windows 
                    property bool active: {
                        for(const window of windows) {
                            if(window.active) return true;
                        }
                       return false; 
                    } 
                    

                    implicitWidth: column.implicitWidth + 15
                    implicitHeight: column.implicitHeight + 7.5
                    border.width: 1
                    border.color:  rect.active ? cfg_activeBorderColor : cfg_inActiveBorderColor 
                    radius: 75
                    color:  rect.active? cfg_activeBackgroundColor : cfg_inActiveBackgroundColor 
                    PlasmaComponents3.ToolButton {
                        anchors.fill: parent
                        anchors.centerIn: parent

                        PlasmaCore.ToolTipArea {
                            anchors.fill: parent
                            mainText: "ToolTip" 
                            subText: `subtext`
                        }
 

                        Column {
                          anchors.centerIn: parent
                          id: column
                          spacing: 2

                         Row {
                          Text {
                            visible: {
                                if(!cfg_showInactiveIndex && !rect.active) return false;
                                if(cfg_showActiveIndex && rect.active) return true;
                                if(cfg_showActiveIndex && !rect.active) return false;
                                if(!cfg_showInactiveIndex && rect.active) return false;
                            }
                            text: index
                            color: rect.active ? cfg_activeIndexColor : cfg_inActiveIndexColor
                          }

                          Repeater {

                            id: windowRepeater
                            model: rect.windows


                            delegate: Row { 


                            required property int index
                            id: windowRow
                            visible: index === 0 ? true : false

                            required property string desktopFileName
                            required property string resourceName 
                            // property bool active: false


                             Kirigami.Icon {
                                source: windowRow.desktopFileName 
                                width: 20
                                height: 20
                             }
                             Text {
                                color: rect.active ? cfg_activeTextColor : cfg_inActiveTextColor  
                                text: windowRow.resourceName 
                               }
                             }
                          }

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
            onUpdate: (data) => {
                const jsonData = JSON.parse(data).data;
                repeater.model = jsonData;
            }
        }
    }
}
