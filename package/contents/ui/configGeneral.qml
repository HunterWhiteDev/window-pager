import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    property alias cfg_showActiveIcon: showActiveIcon.checked
    property alias cfg_showInactiveIcon: showInactiveIcon.checked
    property alias cfg_showActiveIndex: showActiveIndex.checked
    property alias cfg_showInactiveIndex: showInactiveIndex.checked

    Kirigami.FormLayout {
        id: page

        QQC2.CheckBox {
            id: showActiveIcon

            Kirigami.FormData.label: "Section:"
            text: "Show icon in the active window"
        }

        QQC2.CheckBox {
            id: showInactiveIcon

            text: "Show icons in inactive windows"
        }

        QQC2.CheckBox {
            id: showActiveIndex

            Kirigami.FormData.label: "Label:"
            text: "Show the index of the active window"
        }

        QQC2.CheckBox {
            id: showInactiveIndex

            Kirigami.FormData.label: "Label:"
            text: "Show the index of inactive windows"
        }

    }

}
