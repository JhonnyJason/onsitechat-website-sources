indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.peerDisplayTemplate = document.getElementById("peer-display-template")
    global.chatElementTemplate = document.getElementById("chat-element-template")
    global.chatframe = document.getElementById("chatframe")
    global.incomingVideoStreamsBlock = document.getElementById("incoming-video-streams-block")
    global.hangupButton = document.getElementById("hangup-button")
    global.desktopCaptureBlock = document.getElementById("desktop-capture-block")
    global.webCamBlock = document.getElementById("web-cam-block")
    global.peerDisplayBlock = document.getElementById("peer-display-block")
    global.chatHistoryBlock = document.getElementById("chat-history-block")
    global.chatInput = document.getElementById("chat-input")
    return
    
module.exports = indexdomconnect