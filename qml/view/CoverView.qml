import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property url cover
    property alias status: coverImage.status

    id: cover

    states: [
        State {
            name: "ready"
            when: status === Image.Ready
            PropertyChanges {
                target: coverImage
                opacity: 1
            }
            PropertyChanges {
                target: coverDefault
                opacity: 0
            }
        },
        State {
            name: "error"
            when: status === Image.Error
            PropertyChanges {
                target: coverImage
                opacity: 0
            }
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

        opacity: 1
    }

    // in case station's cover can not be loaded
    Image {
        id: coverDefault

        anchors.fill: cover

        // TODO: add default podcast cover
        source: ("image://theme/icon-l-play?" +
                 (element.highlighted
                  ? Theme.highlightColor
                  : Theme.primaryColor))

        opacity: 1
    }

    BusyIndicator {
        anchors.centerIn: cover

        size: BusyIndicatorSize.Medium
        running: ! (status === Image.Error || status === Image.Ready)
    }
}
