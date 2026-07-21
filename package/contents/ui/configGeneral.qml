import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    //States
    property alias cfg_showActiveIcon: showActiveIcon.checked
    property alias cfg_showInactiveIcon: showInactiveIcon.checked
    property alias cfg_showActiveIndex: showActiveIndex.checked
    property alias cfg_showInactiveIndex: showInactiveIndex.checked
    //Colors
    property alias cfg_activeBackgroundColor: activeBackgroundColor.text
    property alias cfg_inActiveBackgroundColor: inActiveBackgroundColor.text
    property alias cfg_activeBorderColor: activeBorderColor.text
    property alias cfg_inActiveBorderColor: inActiveBorderColor.text
    property alias cfg_activeTextColor: activeTextColor.text
    property alias cfg_inActiveTextColor: inActiveTextColor.text

    property alias cfg_activeIndexColor: activeIndexColor.text
    property alias cfg_inActiveIndexColor: inActiveIndexColor.text

    Kirigami.FormLayout {
        id: page

        QQC2.CheckBox {
            id: showActiveIcon

            Kirigami.FormData.label: "Show icon in the active window"
        }

        QQC2.CheckBox {
            id: showInactiveIcon

            Kirigami.FormData.label: "Show icons in inactive windows"
        }

        QQC2.CheckBox {
            id: showActiveIndex

            Kirigami.FormData.label: "Show the index of the active window"
        }

        QQC2.CheckBox {
            id: showInactiveIndex

            Kirigami.FormData.label: "Show the index of inactive windows"
        }

        QQC2.TextField {
            id: activeBackgroundColor

            Kirigami.FormData.label: "Background color for the active window"
        }

        QQC2.TextField {
            id: inActiveBackgroundColor

            Kirigami.FormData.label: "Background color for inactive windows"
        }

        QQC2.TextField {
            id: activeBorderColor

            Kirigami.FormData.label: "Border color for the active window"
        }

        QQC2.TextField {
            id: inActiveBorderColor

            Kirigami.FormData.label: "Border color for the inactive windows"
        }

        QQC2.TextField {
            id: activeTextColor

            Kirigami.FormData.label: "Color for the text in the active window"
        }

        QQC2.TextField {
            id: inActiveTextColor

            Kirigami.FormData.label: "Color for the text in the inactive windows"
        }


        QQC2.TextField {
            id: activeIndexColor

            Kirigami.FormData.label: "Color for the index in the active window"
        }

        QQC2.TextField {
            id: inActiveIndexColor

            Kirigami.FormData.label: "Color for the index in the inactive windows"
        }

    }

}
