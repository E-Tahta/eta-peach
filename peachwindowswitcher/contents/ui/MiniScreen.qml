import QtQuick 1.1
import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: miniscreen

    //property Component compactRepresentation : PeachButton {}
    property int screenWidth: 0
    property int screenHeight: 0
    property int dashHeight: 0

    width: screenWidth - 12

    Item {
        id: viewsContainer
        width: miniscreen.width
        height: dashHeight + closeAllSection.height
        focus: true
        anchors.rightMargin: 0

        Item {
            id:closeAllSection
            width: viewsContainer.width
            height: dashHeight / 5
            anchors.top: viewsContainer.top

            Rectangle {
                id:closeAllBackground
                color: "#C2352A"
                anchors.fill: closeAllSection
                Text {
                    id:closeTxt
                    text: "Tüm Pencereleri Kapat"
                    font.bold: true
                    font.pointSize: 9
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "#FAFAFA"
                    anchors.centerIn: closeAllBackground
                }
                MouseArea {
                    id:maCloseArea
                    anchors.fill:closeAllBackground
                    onPressed: {
                        closeTxt.color = maCloseArea.containsMouse ?
                                    "#cccccc" : "#FAFAFA"
                        closeAllBackground.color = maCloseArea.containsMouse ?
                                    "#f39595" : "#C2352A"
                    }
                    onPressAndHold: {
                        closeTxt.color = maCloseArea.containsMouse ?
                                    "#cccccc" : "#FAFAFA"
                        closeAllBackground.color = maCloseArea.containsMouse ?
                                    "#f39595" : "#C2352A"
                    }
                    onReleased: {
                        closeTxt.color = "#FAFAFA";
                        closeAllBackground.color = "#C2352A";
                        var i = 0;
                        for (i = 0; i < windowThumbs.count; i++) {
                            windowThumbs.get(i).client.closeWindow()
                        }
                    }
                }
            }
        }

        Item {
            id:arrowContainer
            width: 65
            height: dashHeight
            anchors {
                top: parent.top
                topMargin: closeAllSection.height
                left:parent.left
                leftMargin: 0
            }
            clip:false

            Image {
                id:arrow
                width: 55
                height: dashHeight - 10
                source: "../images/3arrow.png"
                smooth: true
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
        WindowSwitcher {
            id: windowsView
            opacity: 1
            visible: true
            anchors {
                top: parent.top
                topMargin: 10 + closeAllSection.height
                left: arrowContainer.right
                leftMargin: arrowContainer.width
                right: parent.right
                rightMargin: 10
                bottom: parent.bottom
                bottomMargin : 0
            }
        }
    }
    PlasmaCore.Dialog {
        id: miniScreenControlContent
        x: 269
        windowFlags: Qt.Popup
        visible: false
        mainItem: viewsContainer
    }
    ListModel {
        id: windowThumbs
    }

    function toggleBoth() {
        if(miniScreenControlContent.visible == true) {
            miniScreenControlContent.visible = false;
            workspace.slotToggleShowDesktop();
        } else {
            miniScreenControlContent.visible = true;
            miniScreenControlContent.activateWindow();
            viewsContainer.forceActiveFocus();
            if(workspace.activeClient && workspace.activeClient.normalWindow) {
                workspace.slotToggleShowDesktop();
            }
        }
    }
    // check if the client/window should be visible in the windowSwitcher
    function visibleClient(client) {
        if(client.dock || client.skipSwitcher || client.skipTaskbar || !client.normalWindow) {
            return false;
        } else {
            return true;
        }
    }
    Component.onCompleted: {
        var screen = workspace.clientArea(KWin.MaximizedArea, workspace.activeScreen, workspace.currentDesktop);
        screenWidth = 1650
        screenHeight = screen.height
        dashHeight = screenHeight / 4
        miniScreenControlContent.y = screenHeight * 77 / 100
        miniScreenControlContent.x = screenWidth * 29 / 100
        miniScreenControlContent.visible = false
        registerShortcut("Run Peach", "", "Meta+Shift+Right", function() {toggleBoth()})
    }
}
