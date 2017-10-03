import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as Plasma
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.kwin 0.1 as KWin

Item {
	anchors.fill: parent	
    property int cellSize : 250
	property int columns
	property int rows
	property int thumbsInside
	property int tempCellSize
	
	width: parent.width
	height: parent.height
	
    ListView {
        id: grid
        clip: false
		width: parent.width
		height: parent.height
        spacing : 10
        orientation: ListView.Horizontal
        model: windowThumbs
        delegate: Flickable {
            id: thumbdelegate
            flickableDirection: Flickable.VerticalFlick
            property int clientWidth: client.width
            property int clientHeight: client.height
            property real ratio : clientWidth / clientHeight
            property int maxWidth : item.height
            property int maxHeight : item.height
            onFlickingVerticallyChanged:  client.closeWindow()
            width: cellSize
            height: cellSize
            Item {
                id: item
                anchors.fill:parent
                KWin.ThumbnailItem {
                    id: thumb
                    anchors {
                        verticalCenter:parent.verticalCenter
                        horizontalCenter:parent.horizontalCenter
                    }
                    width: (clientWidth < clientHeight) ? maxWidth : item.width
                    height: (clientWidth < clientHeight) ? maxHeight : item.width / ratio
                    parentWindow:  miniScreenControlContent.windowId
                    clip: false
                    wId: windowId
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentId = -1;
                        workspace.slotToggleShowDesktop();
                        workspace.activeClient = windowThumbs.get(index).client;
                    }
                }
            }
            Connections {
                target: client
                onGeometryChanged: {
                    clientHeight = client.height;
                    clientWidth = client.width;
                }
            }
        }
    }
    // get clients from KWin and add to model
    Component.onCompleted: {
        // add data to model
        var clients = workspace.clientList();
        var i = 0;
        for (i = 0; i < clients.length; i++) {
            if(visibleClient(clients[i])) {
                windowThumbs.append({
                                        "windowId": clients[i].windowId,
                                        "gridId": windowThumbs.count,
                                        "client": clients[i]
                                    });
            }
        }
    }
    // adding and removing clients
    Connections {
        target: workspace
        // connections for when clients are added and removed
        onClientAdded: {
            if(visibleClient(client)) {
                windowThumbs.append({
                                        "windowId": client.windowId,
                                        "gridId": windowThumbs.count,
                                        "client": client
                                    });
            }
        }
        onClientRemoved: {
            var i;
            for(i = 0; i < windowThumbs.count; i++) {
                if(windowThumbs.get(i).client == client) {
                    windowThumbs.remove(i);
                    // hide windows button
                    if(!windowThumbs.count) {
                        dashboardCategories.currentIndex = 1;
                        dashboardCategories.contentItem.children[1].state = "hide";
                    }
                    return false;
                }
            };
        }
    }
}
