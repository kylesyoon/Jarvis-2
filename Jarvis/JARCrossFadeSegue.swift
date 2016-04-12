//
//  JARCrossFadeSegue.swift
//  Jarvis
//
//  Created by Kyle Yoon on 4/22/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

import UIKit

class JARCrossFadeSegue: UIStoryboardSegue {
    
    override func perform() {
        let destinationSubviewsArray = self.destinationViewController.view.subviews
        let allSubviewsArray = self.sourceViewController.view.subviews + destinationSubviewsArray
        // Fade out both source and destination views
        UIView.animateWithDuration(0.5,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {
                                    for view in allSubviewsArray {
                                        view.alpha = 0.0
                                    }
            },
                                   completion: {
                                    finished in
                                    // Fade in destination views
                                    self.sourceViewController.presentViewController(self.destinationViewController,
                                        animated: false,
                                        completion: {
                                            UIView.animateWithDuration(0.5,
                                                delay: 0.0,
                                                options: UIViewAnimationOptions.CurveEaseOut,
                                                animations: {
                                                    for view in destinationSubviewsArray {
                                                        view.alpha = 1.0
                                                    }
                                                },
                                                completion: nil)
                                    })
        })
        
    }
    
}
