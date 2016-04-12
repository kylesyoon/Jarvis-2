//
//  JARSession.swift
//  Jarvis
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol JARSessionDelegate {
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession)
}

class JARSession: NSObject {
    
    var myPeerID: MCPeerID
    var delegate: JARSessionDelegate?
    var session: MCSession
    var currentState: MCSessionState = .NotConnected
    
    init(displayName: String) {
        self.myPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: myPeerID)
        // Need to init super first to set self as the MCSession delegate
        super.init()
        self.session.delegate = self;
    }

}

extension JARSession: MCSessionDelegate {
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        dispatch_async(dispatch_get_main_queue(), {
            self.currentState = state
            if let delegate = self.delegate {
                delegate.didChangeState(state, peer: peerID, forSession: session)
            }
        })
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        // Unused
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Unused
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        // Unused
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        // Unused
    }
    
}
