//
//  JARJARMultipeerController.swift
//  Jarvis
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol JARMultipeerDelegate {
    
    func didFoundPeer(peerID: MCPeerID, forSession session: MCSession)
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession)
    
}

class JARMultipeerController {
    
    private let jarvisServiceType = "yoonapps-jarvis"
    private let displayName: String = UIDevice.currentDevice().name
    let session: JARSession
    let browser: JARBrowser
    var delegate: JARMultipeerDelegate?
    
    init() {
        self.session = JARSession(displayName: displayName)
        self.browser = JARBrowser(session: session.session)
        
        self.session.delegate = self
        self.browser.delegate = self
    }
    
    func startBrowsing() {
        self.browser.startBrowsing(jarvisServiceType)
    }
    
    func stopBrowsing() {
        self.browser.stopBrowsing()
    }
    
    func restartBrowsing() {
        self.stopBrowsing()
        self.startBrowsing()
    }

    func sendMessage(message: String) -> Bool {
        var isQueued = false
        if session.currentState == .Connected && browser.currentPeer != nil {
            // Faking successful queue of data
            if JARTestHelper.sharedInstance.isUnitTesting {
                isQueued = true
                return isQueued
            }
            // Since we checked that browser.currentPeer isn't nil, force unwrap.
            let currentPeer = browser.currentPeer!
            let payload = message.dataUsingEncoding(NSUTF8StringEncoding)
            // If we got payload data, use it.
            if let payload = payload {
                do {
                    try self.session.session.sendData(payload, toPeers: [currentPeer], withMode: MCSessionSendDataMode.Reliable)
                    isQueued = true
                    print("Sending data \(message)")
                } catch {
                    isQueued = false
                    print("Error sending data")
                }
            }
        }
        
        return isQueued
    }
    
    func setIdleTimerForState(state: MCSessionState) {
        if state == MCSessionState.Connected {
            UIApplication.sharedApplication().idleTimerDisabled = true
        } else {
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
    }
    
}

extension JARMultipeerController: JARSessionDelegate {
    
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        if let delegate = self.delegate {
            delegate.didChangeState(state, peer: peerID, forSession: session)
            self.setIdleTimerForState(state)
            if state == .NotConnected {
                self.browser.currentPeer = nil
            }
        }
    }
    
}

extension JARMultipeerController: JARBrowserDelegate {
    
    func foundPeer(peerID: MCPeerID) {
        if let delegate = self.delegate {
            delegate.didFoundPeer(peerID, forSession: session.session)
        }
    }
    
}
