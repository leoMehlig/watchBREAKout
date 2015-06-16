//
//  GameOverInterfaceController.swift
//  WatchBreakout
//
//  Created by Matthijs Logemann on 16/06/15.
//  Copyright © 2015 Scholar Watch Hackathon. All rights reserved.
//

import WatchKit
import Foundation


class GameOverInterfaceController: WKInterfaceController {

    @IBOutlet var scoreTextLabal: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        scoreTextLabal.setText("Your score was:\n\(context!)")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setTitle("")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
