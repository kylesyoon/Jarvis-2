//
//  TouchViewController.swift
//  Jarvis
//
//  Created by Kyle Yoon on 4/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class JARTouchViewController: JARBaseViewController {
   
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet var swipeUpGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var swipeDownGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateViewsForState(self.multipeerController.session.currentState, peer: self.multipeerController.browser.currentPeer)
    }

    func updateViewsForState(state: MCSessionState, peer peerID: MCPeerID?) {
        switch state {
        case MCSessionState.Connected:
            if let peer = peerID {
                self.connectionLabel.text = JARLocalizedStrings.connectedFormatWithPeerName(peer.displayName)
            }
        case MCSessionState.Connecting:
            self.connectionLabel.text = JARLocalizedStrings.connecting()
        case MCSessionState.NotConnected:
            self.connectionLabel.text = JARLocalizedStrings.notConnected()
        }
    }
    
    // MARK: MultipeerDelegate
    
    override func didChangeState(state: MCSessionState, peer peerID: MCPeerID, forSession session: MCSession) {
        self.updateViewsForState(state, peer: peerID)
    }
    
    // MARK: IBActions

    @IBAction func didSwipe(swipe: UISwipeGestureRecognizer) {
        if swipe.state == UIGestureRecognizerState.Ended {
            switch swipe.direction {
            case UISwipeGestureRecognizerDirection.Up:
                self.multipeerController.sendMessage(MessagePayload.Next)
            case UISwipeGestureRecognizerDirection.Down:
                self.multipeerController.sendMessage(MessagePayload.Back)
            default:
                print("Unrecognized swipe direction")
            }
            self.showAnimationForSwipeGestureDirection(swipe.direction)
        }
    }

    @IBAction func pressedPresent() {
        self.multipeerController.sendMessage(MessagePayload.Present)
    }
    
    @IBAction func pressedESC() {
        self.multipeerController.sendMessage(MessagePayload.ESC)
    }
    
    // MARK: Animation
    
    func showAnimationForSwipeGestureDirection(direction: UISwipeGestureRecognizerDirection!) {
        var transitionText: String?
        var animationOption: UIViewAnimationOptions?
        // Set up for animation based on swipe direction
        switch direction {
        case UISwipeGestureRecognizerDirection.Up:
            transitionText = JARLocalizedStrings.next().uppercaseString
            animationOption = UIViewAnimationOptions.TransitionFlipFromTop
        case UISwipeGestureRecognizerDirection.Down:
            transitionText = JARLocalizedStrings.back().uppercaseString
            animationOption = UIViewAnimationOptions.TransitionFlipFromBottom
        default:
            print("Unidentified swipe gesture direction!")
        }
        // Do animation if successful set up
        if let transitionText = transitionText, animationOption = animationOption {
            // No swipes while animating
            self.swipeDownGestureRecognizer.enabled = false
            self.swipeUpGestureRecognizer.enabled = false

            UIView.transitionWithView(self.swipeLabel, duration: 0.3, options: animationOption.union(UIViewAnimationOptions.CurveEaseOut), animations: { () -> Void in
                self.swipeLabel.transform = CGAffineTransformMakeScale(2.0, 2.0)
                self.swipeLabel.text = transitionText
            }, completion: { (finished) -> Void in
                UIView.transitionWithView(self.swipeLabel, duration: 0.15, options: animationOption.union(UIViewAnimationOptions.CurveEaseIn), animations: { () -> Void in
                    self.swipeLabel.transform = CGAffineTransformIdentity
                    self.swipeLabel.text = JARLocalizedStrings.swipe().uppercaseString
                    // Swipe again
                    self.swipeDownGestureRecognizer.enabled = true
                    self.swipeUpGestureRecognizer.enabled = true
                }, completion:nil)
            })
        }
    }

    
}
