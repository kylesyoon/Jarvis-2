//
//  MultipeerConnectivityTests.swift
//  Jarvis
//
//  Created by Yoon, Kyle on 4/12/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import XCTest
import MultipeerConnectivity
@testable import Jarvis

class MultipeerConnectivityTests: JarvisBaseTests {
    
    var multipeerController = JARMultipeerController.sharedInstance
    
    func testBrowserValidServiceType() {
        XCTAssertEqual(self.multipeerController.jarvisServiceType, "yoonapps-jarvis")
    }
    
    func testLocalPeerIDDisplayNameIsDeviceName() {
        if let displayName = self.multipeerController.browser.mcBrowser?.myPeerID.displayName {
            XCTAssertEqual(displayName, UIDevice.currentDevice().name)
        }
    }
    
    func testSendingMessageFailsWithNoCurrentPeer() {
        self.multipeerController.session.currentState = MCSessionState.Connected
        self.multipeerController.browser.currentPeer = nil
        let isQueued = self.multipeerController.sendMessage(JARMessagePayload.Next)
        XCTAssertFalse(isQueued)
    }
    
    func testSendingMessageWithCurrentPeer() {
        self.multipeerController.session.currentState = MCSessionState.Connected
        self.multipeerController.browser.currentPeer = MCPeerID(displayName: "Tester")
        let isQueued = self.multipeerController.sendMessage(JARMessagePayload.Next)
        XCTAssert(isQueued)
    }
    
}
