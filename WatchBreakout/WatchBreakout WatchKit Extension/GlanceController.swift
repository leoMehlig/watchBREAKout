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
            glanceImage.setImage(GlanceController.creatBreakoutImageForSize(CGSize(width: 130, height: 100)))
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
    
    
    class func creatBreakoutImageForSize(size: CGSize) -> UIImage {
        let bricksStatus = WBUserDefaults.bricksStatusAry
        let brickHeight = (size.height - CGFloat(bricksStatus.count) * 2) / CGFloat(bricksStatus.count)
        let brickWidth = (size.width - CGFloat(bricksStatus.first?.count ?? 0) * 2) / CGFloat(bricksStatus.first?.count ?? 0)
        UIGraphicsBeginImageContext(size)
        for (row, rowAry) in WBUserDefaults.bricksStatusAry.enumerate() {
            for (column, brick) in rowAry.enumerate() {
                if brick {
                    let x = CGFloat(row) * brickWidth + CGFloat(row) * 2
                    let y = CGFloat(column) * brickHeight + CGFloat(column) * 2
                    print("\(x), \(y)")
                    let path = UIBezierPath(rect: CGRect(x: x, y: y, width: brickWidth, height: brickHeight))
                    UIColor.greenColor().setFill()
                    path.fill()
                }
            }
        }
        
      
        
        let image =  UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        
        return image
        
    }

}
