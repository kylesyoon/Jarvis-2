//
//  JARBrowser.swift
//  Jarvis
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol JARBrowserDelegate {
    func foundPeer(peerID: MCPeerID)
}

// MCNearbyServiceBrowserDelegate requires NSObjectProtocol confirmity.
// Not worth implementing requirements for NSObjectProtocol, so going with subclassing NSObject.
class JARBrowser: NSObject {
    
    let session: MCSession
    var delegate: JARBrowserDelegate?
    var currentPeer: MCPeerID?
    var browser: MCNearbyServiceBrowser?
    
    init(session: MCSession) {
        self.session = session
    }
    
    func startBrowsing(serviceType: String) {
        self.browser = MCNearbyServiceBrowser(peer: session.myPeerID, serviceType: serviceType)
        if let browser = self.browser {
            browser.delegate = self
            browser.startBrowsingForPeers()
        }
    }
    
    func stopBrowsing() {
        if let browser = self.browser {
            browser.delegate = nil
            browser.stopBrowsingForPeers()
        }
    }
    
}

extension JARBrowser: MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let delegate = self.delegate where self.currentPeer != peerID {
            delegate.foundPeer(peerID)
        }
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // FIXME: Need to let the user know we lost a peer
    }
    
}
