import QtQuick 2.7
import QtContacts 5.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0
import org.gka.GKAToolkit 1.0
import "dateExt.js" as DateExt

ApplicationWindow {
    id: app

    property real appFontSize

    title: i18n.tr("Contacts")

    //Fullscreen on device
    height: {
        if (Screen.height === 1080 && Screen.width === 2160) {
            Screen.height
        } else {
            432
        }
    }
    width: {
        if (Screen.height === 1080 && Screen.width === 2160) {
            Screen.width
        } else {
            864
        }
    }
    visible: true

    Settings {
        id: settings
        property alias x: app.x
        property alias y: app.y
        property alias width: app.width
        property alias height: app.height
        property real appFontSize
    }

    Binding {
        target: app
        property: "appFontSize"
        value: settings.appFontSize
        when: settings
    }

    UnionFilter {
        id: filter

        property string searchString: ""

        filters: [
            DetailFilter {
                detail: ContactDetail.Name
                field: Name.FirstName
                matchFlags: Filter.MatchContains
                value: filter.searchString
            },
            DetailFilter {
                detail: ContactDetail.Name
                field: Name.LastName
                matchFlags: Filter.MatchContains
                value: filter.searchString
            },
            DetailFilter {
                detail: ContactDetail.DisplayLabel
                field: DisplayLabel.Label
                matchFlags: Filter.MatchContains
                value: filter.searchString
            }
        ]
    }

    PeopleListModel {
        id: contactsModel
        filter: filter
    }

    menuBar: MainMenu {
        id: menu
        model: contactsModel
        settings: settings
    }

    Action {
        id: quitAction
        text: i18n.tr("&Quit")
        shortcut: StandardKey.Quit
        onTriggered: Qt.quit()
    }

    Action {
        id: zoomOutAction
        text: i18n.tr("Zoom &Out")
        shortcut: "Ctrl+Shift+m"
        onTriggered: {
            console.log (">appFontSize: " + app.appFontSize)
            if (settings.appFontSize > 8) {
                settings.appFontSize -= 1
            }
            console.log ("<appFontSize: " + app.appFontSize)
        }
    }

    Action {
        id: zoomInAction
        text: i18n.tr("Zoom &In")
        shortcut: "Ctrl+m"
        onTriggered: {
            console.log (">appFontSize: " + app.appFontSize);
            settings.appFontSize += 1;
            if (settings.appFontSize < 8) {
                settings.appFontSize = 8;
            }
            console.log ("<appFontSize: " + app.appFontSize);
        }
    }

    FocusScope {
        id: mainView
        anchors.fill: parent

        Loader {
            id: alternateViewLoader
            source: "ContactsView.qml"
            visible: status == Loader.Ready
        }

        Loader {
            id: dialogLoader
            anchors.fill: parent
            visible: status == Loader.Ready
            State {
                name: 'loaded';
                when: loader.status === Loader.Ready
            }
        }
        Connections {
            target: dialogLoader.item
        }
    }

    Label {
        id: defaultLabel
        visible: false
    }

    Component.onCompleted: {
        if (app.appFontSize == 0) {
            app.appFontSize = defaultLabel.font.pixelSize;
        }

        print("Screen.pixelDensity: "+Screen.pixelDensity);
        print("Screen.devicePixelRatio: "+Screen.devicePixelRatio);

    }
}
