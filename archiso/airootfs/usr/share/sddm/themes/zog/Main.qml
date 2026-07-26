import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root
    color: "#1a1c26"
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30
        width: 400
        
        // Logo
        Text {
            text: "Zog"
            font.pointSize: 48
            font.bold: true
            color: "#5a60c8"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Username field
        Rectangle {
            width: parent.width
            height: 50
            color: "#2d2e3f"
            radius: 8
            border.color: "#5a60c8"
            border.width: 1
            
            TextInput {
                id: usernameInput
                anchors.fill: parent
                anchors.margins: 12
                font.pixelSize: 14
                color: "#c8c8d2"
                text: "User"
            }
        }
        
        // Password field
        Rectangle {
            width: parent.width
            height: 50
            color: "#2d2e3f"
            radius: 8
            border.color: "#5a60c8"
            border.width: 1
            
            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.margins: 12
                font.pixelSize: 14
                color: "#c8c8d2"
                echoMode: TextInput.Password
                text: ""
            }
        }
        
        // Login button
        Rectangle {
            width: parent.width
            height: 50
            color: "#5a60c8"
            radius: 8
            
            Text {
                anchors.centerIn: parent
                text: "Sign In"
                color: "#ffffff"
                font.pointSize: 14
                font.bold: true
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: sddm.login(usernameInput.text, passwordInput.text, 0)
            }
        }
    }
}
