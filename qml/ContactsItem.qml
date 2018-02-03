import QtQuick 2.7
import QtOrganizer 5.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import "dateExt.js" as DateExt

FocusScope {
    id: contactsItem
    width: ListView.view.width
    height: contactsRectangle.height

    MouseArea {
        anchors.fill: parent

        onReleased: {
            console.log("dayItemRel i:" + index);
            contactsSelectedIndex = index;
            contactSelected = contact;
            contactsListView.currentIndex = index;
            contactsListView.currentItem.forceActiveFocus();

            console.log("Note: "+contactSelected.note.note);
        }
    }

    onFocusChanged: {
        if (activeFocus) {
            if (contactsSelectedIndex !== index) {
                contactsSelectedIndex = index;
                contactSelected = contact;
            }
        }
    }

    Rectangle {
        clip: true
        id: contactsRectangle
        anchors.left: parent.left
        anchors.right: parent.right
        height: contactsItemLabel.height
        color: activeFocus ? "black" : "#edeeef"
        opacity: 0.9
        focus: index === contactsSelectedIndex

        Text {
            id: contactsItemLabel
            padding: app.appFontSize/2
            anchors.verticalCenter: contactsRectangle.verticalCenter
            width: contactsRectangle.width
            wrapMode: Text.Wrap
            font.pixelSize: app.appFontSize
            text: contact.displayLabel.label
            color: contactsRectangle.activeFocus ? "white" : "black"
        }
    }

    Component.onCompleted: {
        console.log("cditemcell.onCompleted i:"+index)
    }
}
