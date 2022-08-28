import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = 
    unbreaker: true
    # chatframemodule: true
    # configmodule: true
    # statemodule: true
    websocketmodule: true
    webrtcmodule: true

addModulesToDebug(modulesToDebug)