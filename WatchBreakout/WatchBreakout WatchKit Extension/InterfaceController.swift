//
//  InterfaceController.swift
//  WatchBreakout WatchKit Extension
//
//  Created by Leo Mehlig on 6/13/15.
//  Copyright © 2015 Scholar Watch Hackathon. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var brick1: WKInterfaceGroup!
    @IBOutlet var brick2: WKInterfaceGroup!
    @IBOutlet var brick3: WKInterfaceGroup!
    @IBOutlet var brick4: WKInterfaceGroup!
    @IBOutlet var brick5: WKInterfaceGroup!
    @IBOutlet var brick6: WKInterfaceGroup!
    @IBOutlet var brick7: WKInterfaceGroup!
    @IBOutlet var brick8: WKInterfaceGroup!
    @IBOutlet var brick9: WKInterfaceGroup!
    @IBOutlet var brick10: WKInterfaceGroup!
    @IBOutlet var brick11: WKInterfaceGroup!
    @IBOutlet var brick12: WKInterfaceGroup!
    @IBOutlet var brick13: WKInterfaceGroup!
    @IBOutlet var brick14: WKInterfaceGroup!
    @IBOutlet var brick15: WKInterfaceGroup!
    @IBOutlet var brick16: WKInterfaceGroup!
    @IBOutlet var brick17: WKInterfaceGroup!
    @IBOutlet var brick18: WKInterfaceGroup!
    @IBOutlet var brick19: WKInterfaceGroup!
    @IBOutlet var brick20: WKInterfaceGroup!

    @IBOutlet var paddle: WKInterfaceGroup!
    @IBOutlet var picker: WKInterfacePicker!
    var items = [WKPickerItem]()
    @IBOutlet var paddleGroup: WKInterfaceGroup!
    @IBOutlet var ball: WKInterfaceImage!
    
    @IBOutlet var ballGroup: WKInterfaceGroup!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        var screenWidth = Int(WKInterfaceDevice.currentDevice().screenBounds.size.width)
        screenWidth -= 30
        print(screenWidth)
        for _ in 0...screenWidth/2{
            let item = WKPickerItem()
            item.contentImage = WKImage(image: UIImage(named: "Pixel")!)
            items.append(item)
        }
        
        picker.setItems(items)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        picker.focusForCrownInput()
        
        
//        let controller = BallController(gameRect: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 100)), ball: ball, ballSize: CGSize(width: 20, height: 20), group: ballGroup)
//        controller.ballSpeed = 20 / 1000
//        controller.ballDirection = Float(0.5)

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pickerValueChanged(value: Int) {
        paddleGroup.setContentInset(UIEdgeInsetsMake(0, CGFloat(value)*2, 0, 0))
    }
}
