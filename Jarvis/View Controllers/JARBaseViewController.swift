//
//  JARBaseViewController.swift
//  Jarvis
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class JARBaseViewController: UIViewController {
    // Keep only one multipeer controller across the board
    let multipeerController = JARMultipeerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start looking for connection as soon as view loads
        self.multipeerController.startBrowsing()
        self.multipeerController.delegate = self
    }
    
    @IBAction func pressedRefresh() {
        // Attempt to reestablish connection
        self.multipeerController.sendMessage(MessagePayload.Restart)
        self.multipeerController.restartBrowsing()
    }
    
}

extension JARBaseViewController: JARMultipeerDelegate {
  
    func didFoundPeer(peerID: MCPeerID, forSession session: MCSession) {
        let foundPeerAlert = UIAlertController(title: JARLocalizedStrings.foundPeerAlertTitle(),
                                               message: JARLocalizedStrings.foundPeerAlertMessageWithPeerName(peerID.displayName),
                                               preferredStyle: .Alert)
        
        foundPeerAlert.addAction(
            UIAlertAction(title: JARLocalizedStrings.cancel(),
                style: .Cancel,
                handler: { action in
                    foundPeerAlert.dismissViewControllerAnimated(true, completion: nil)
            })
        )
        
        foundPeerAlert.addAction(
            UIAlertAction(title: JARLocalizedStrings.connect(),
                style: .Default,
                handler: { action in
                    if let browser = self.multipeerController.browser.browser {
                        self.multipeerController.browser.currentPeer = peerID
                        browser.invitePeer(peerID,
                            toSession: self.multipeerController.session.session,
                            withContext: nil,
                            timeout: 10)
                    }
                    
            }))
        
        self.presentViewController(foundPeerAlert,
                                   animated: true,
                                   completion: nil)
    }
    
    func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        // Implmentation done down at subclass.
    }
    
}
