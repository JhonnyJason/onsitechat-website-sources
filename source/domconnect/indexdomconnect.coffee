indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.chatButton = document.getElementById("chat-button")
    global.peerDisplayTemplate = document.getElementById("peer-display-template")
    global.chatElementTemplate = document.getElementById("chat-element-template")
    global.chatframe = document.getElementById("chatframe")
    global.incomingVideoStreamsBlock = document.getElementById("incoming-video-streams-block")
    global.opacitySlider = document.getElementById("opacity-slider")
    global.showPeersButton = document.getElementById("show-peers-button")
    global.showTextchatButton = document.getElementById("show-textchat-button")
    global.showWebcamButton = document.getElementById("show-webcam-button")
    global.hangupButton = document.getElementById("hangup-button")
    global.myVideoStreamsBlock = document.getElementById("my-video-streams-block")
    global.desktopCaptureBlock = document.getElementById("desktop-capture-block")
    global.webCamBlock = document.getElementById("web-cam-block")
    global.peerDisplayBlock = document.getElementById("peer-display-block")
    global.textChatBlock = document.getElementById("text-chat-block")
    global.chatHistoryBlock = document.getElementById("chat-history-block")
    global.chatInputBlock = document.getElementById("chat-input-block")
    global.chatInput = document.getElementById("chat-input")
    return
    
module.exports = indexdomconnect