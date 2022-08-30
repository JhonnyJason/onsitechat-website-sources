############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("chatframemodule")
#endregion

############################################################
import * as webRTC from "./webrtcmodule"
import * as WS from "./websocketmodule.js"
import M from "mustache"

############################################################
peerTemplate = null
chatTemplate = null


allChatMessages = []
maxMessageNr = 12
deletionIntervalMS = 30000 

myMessages = []

############################################################
export initialize = ->
    log "initialize"
    locationHashChanged()
    window.onhashchange = locationHashChanged
    
    chatInput.addEventListener("keydown", inputKeyDowned)
    chatInput.addEventListener("blur", inputBlurred)

    opacitySlider.addEventListener("change", opacitySliderChanged)
    hangupButton.addEventListener("click", hangupClicked)

    showPeersButton.addEventListener("click", showPeersButtonClicked)
    peerDisplayBlock.addEventListener("click", showPeersButtonClicked)


    showTextchatButton.addEventListener("click", showTextchatButtonClicked)
    textChatBlock.addEventListener("click", showTextchatButtonClicked)
    chatInputBlock.addEventListener("click", (evnt) -> evnt.stopPropagation())

    showWebcamButton.addEventListener("click", showWebcamButtonClicked)    
    webCamBlock.addEventListener("click", showWebcamButtonClicked)


    ##default 
    # webcam always shown
    myVideoStreamsBlock.classList.add("here")
    showWebcamButton.classList.add("is-shown")
    # peerdisplay always shown
    peerDisplayBlock.classList.add("here")
    showPeersButton.classList.add("is-shown")
    # chat only shown when we are big enough
    if window.screen.width > 620
        textChatBlock.classList.add("here")
        showTextchatButton.classList.add("is-shown")

    peerTemplate = peerDisplayTemplate.innerHTML
    log peerTemplate
    chatTemplate = chatElementTemplate.innerHTML
    log chatTemplate

    setInterval(deleteMessage, deletionIntervalMS)
    return

############################################################
locationHashChanged = ->
    log "locationHashChanged"
    if location.hash == "#chat" then pullChatIn()
    else pushChatOut()
    return

inputKeyDowned = (evnt) ->
    if evnt.keyCode == 13 
        if chatInput.value 
            sendInputAsMessage()
            chatInput.value = ""
    return

inputBlurred = (evnt) ->
    if chatInput.value 
        sendInputAsMessage()
        chatInput.value = ""
    return

############################################################
hangupClicked = ->
    log "hangupClicked"
    webRTC.breakAllConnections()
    hangupButton.classList.remove("here")
    return

############################################################
opacitySliderChanged = ->
    log "opacitySliderChanged"
    log opacitySlider.value
    value = opacitySlider.value / 100

    # chatframe.style.backgroundColor = "rgba(255, 255, 255, "+value+")"
    incomingVideoStreamsBlock.style.opacity = ""+value
    return

############################################################
showPeersButtonClicked = ->
    log "showPeersButtonClicked"
    peerDisplayBlock.classList.toggle("here")
    here = peerDisplayBlock.classList.contains("here")
    if here and window.screen.width < 620 
        textChatBlock.classList.remove("here")
        showTextchatButton.classList.remove("is-shown")
    if here then showPeersButton.classList.add("is-shown")
    else showPeersButton.classList.remove("is-shown")
    return

showTextchatButtonClicked = ->
    log "showTextchatButtonClicked"
    textChatBlock.classList.toggle("here")
    here = textChatBlock.classList.contains("here")
    if here and window.screen.width < 620 
        peerDisplayBlock.classList.remove("here")
        showPeersButton.classList.remove("is-shown")
    if here then showTextchatButton.classList.add("is-shown")
    else showTextchatButton.classList.remove("is-shown")
    return

showWebcamButtonClicked = ->
    log "showWebcamButtonClicked"
    myVideoStreamsBlock.classList.toggle("here")
    here = myVideoStreamsBlock.classList.contains("here")
    if here then showWebcamButton.classList.add("is-shown")
    else showWebcamButton.classList.remove("is-shown")
    return



############################################################
sendInputAsMessage = ->
    text = chatInput.value
    message = "to all #{text}"
    myMessages.push(text)
    olog myMessages
    WS.sendMessage(message)
    return

############################################################
pullChatIn = ->
    log "pullChatIn"
    # document.body.style.height = "100%"
    # document.body.style.overflowY = "hidden"
    chatframe.classList.add("here")
    WS.connect()
    return

pushChatOut = ->
    log "pushChatOut"
    # document.body.style.height = "auto"
    # document.body.style.overflowY = "scroll"
    chatframe.classList.remove("here")
    WS.disconnect()
    chatHistoryBlock.innerHTML = ""
    peerDisplayBlock.innerHTML = ""
    allChatMessages = []
    return







############################################################
getUUIDFromTree = (node) ->
    counter = 0
    while !node.classList.contains("peer-display-element")
        node = node.parentNode
        counter++
        if counter > 3 then throw new Error("No nearby parent having class peer-display-element")
    return node.getAttribute("uuid")
############################################################
peerCallClicked = (evnt) ->
    log "peerCallClicked"
    uuid = getUUIDFromTree(evnt.target)
    log uuid
    webRTC.initiateConnection(uuid, "call")
    return

peerVideoClicked = (evnt) ->
    log "peerVideoClicked"
    uuid = getUUIDFromTree(evnt.target)
    log uuid
    webRTC.initiateConnection(uuid, "video")
    return

############################################################
renderChatMessages = ->
    chatHTML = ""
    for cObj in allChatMessages
        chatHTML += M.render(chatTemplate, cObj)
    chatHistoryBlock.innerHTML = chatHTML
    return

deleteMessage = ->
    return unless allChatMessages.length > 0
    allChatMessages.pop()
    renderChatMessages()
    return

############################################################
export displayPeers = (uuids) ->
    peersHTML = ""
    for uuid in uuids
        cObj = {uuid}
        peersHTML += M.render(peerTemplate, cObj)
    peerDisplayBlock.innerHTML = peersHTML

    ownDisplayBlock = peerDisplayBlock.querySelector("[uuid='#{WS.getUUID()}']")
    if ownDisplayBlock? then ownDisplayBlock.classList.add("self")

    callButtons = peerDisplayBlock.getElementsByClassName("peer-call-button")
    btn.addEventListener("click", peerCallClicked) for btn in callButtons

    videoButtons = peerDisplayBlock.getElementsByClassName("peer-video-button")
    btn.addEventListener("click", peerVideoClicked) for btn in videoButtons
    return


export addChatMessage = (message) ->
    log message
    for msg,i in myMessages when msg == message
        isMine = true
        myMessages.splice(i, 1)
        break

    olog myMessages
    now = new Date()
    hours = "#{now.getHours()}"
    minutes = "#{now.getMinutes()}"
    if hours.length < 2 then hours = "0"+hours
    if minutes.length < 2 then minutes = "0"+minutes
    timeNow = "#{hours}:#{minutes}"
    cObj = {
        text: message
        time: timeNow,
        isMine: isMine
    }
    allChatMessages.unshift(cObj)
    if allChatMessages.length > maxMessageNr then allChatMessages.length = maxMessageNr
    log allChatMessages.length
    renderChatMessages()
    return

export showHangupButton = ->
    hangupButton.classList.add("here")
    return