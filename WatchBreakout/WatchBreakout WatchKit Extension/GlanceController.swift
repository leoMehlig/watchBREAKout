//
//  GlanceController.swift
//  WatchBreakout WatchKit Extension
//
//  Created by Leo Mehlig on 6/13/15.
//  Copyright © 2015 Scholar Watch Hackathon. All rights reserved.
//

import WatchKit
import Foundation
import CoreGraphics

class GlanceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    @IBOutlet var highscoreLabel: WKInterfaceLabel! {
        didSet {
            highscoreLabel.setText(String(WBUserDefaults.highscore))
        }
    }
    @IBOutlet var glanceImage: WKInterfaceImage! {
        didSet {
            glanceImage.setImage(WBUserDefaults.breakoutImageOfSize(CGSize(width: 130, height: 100)))
        }
    }
    @IBOutlet var levelLabel: WKInterfaceLabel!
    @IBOutlet var footerLabel: WKInterfaceLabel!
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
}
