import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtMultimedia 5.0
import Sailfish.Silica 1.0

BackgroundItem {
    property bool isCurrent: Qt.resolvedUrl(model.enclosure).toString() == player.source.toString()

    id: element

    width: parent.width
    height: Theme.iconSizeLarge

    RowLayout {
        anchors.fill: parent
        spacing: Theme.paddingMedium

        Item {
            id: cover

            Layout.minimumWidth: parent.height
            Layout.preferredWidth: parent.height
            Layout.maximumWidth: parent.height
            Layout.minimumHeight: parent.height

            states: [
                State {
                    name: "coverLoading"
                    when: coverImage.status === Image.Loading
                },
                State {
                    name: "coverReady"
                    when: coverImage.status === Image.Ready
                    PropertyChanges {
                        target: coverImage
                        opacity: 1
                    }
                },
                State {
                    name: "coverError"
                    when: coverImage.status === Image.Error || element.state === "stationError"
                    PropertyChanges {
                        target: coverDefault
                        opacity: 1
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation {
                    targets: [coverImage, coverDefault]
                    property: "opacity"
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
            }

            Image {
                id: coverImage
                fillMode: Image.PreserveAspectCrop
                anchors.fill: cover
                source: model.cover
                opacity: 0
            }

            // in case station's cover can not be loaded
            Image {
                id: coverDefault
                anchors.centerIn: cover

                // TODO: add default podcast cover
                source: ("image://theme/icon-l-play?" +
                         (element.highlighted
                          ? Theme.highlightColor
                          : Theme.primaryColor))
                opacity: 0
            }

            BusyIndicator {
                size: BusyIndicatorSize.Small
                anchors.centerIn: cover
                running: coverImage.status === Image.Loading
            }
        }

        Label {
            id: title

            Layout.fillWidth: true
            Layout.fillHeight: true

            text: model.title ? model.title : "Loading..."

            color: isCurrent ? Theme.highlightColor : Theme.primaryColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeMedium
            truncationMode: TruncationMode.Elide
        }
        Image {
            Layout.minimumWidth: Theme.iconSizeMedium
            Layout.preferredWidth: Theme.iconSizeMedium
            Layout.maximumWidth: Theme.iconSizeMedium
            Layout.minimumHeight: Theme.iconSizeMedium
            Layout.preferredHeight: Theme.iconSizeMedium
            Layout.maximumHeight: Theme.iconSizeMedium
            source: ("image://theme/icon-l-" +
                     (isCurrent && player.playbackState === MediaPlayer.PlayingState ? "pause" : "play"))
        }

    }
}
