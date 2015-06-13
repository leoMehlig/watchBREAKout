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

    @IBOutlet var paddle: WKInterfaceGroup!
    @IBOutlet var picker: WKInterfacePicker!
    var items = [WKPickerItem]()
    @IBOutlet var paddleGroup: WKInterfaceGroup!
    
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

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pickerValueChanged(value: Int) {
        paddleGroup.setContentInset(UIEdgeInsetsMake(0, CGFloat(value)*2, 0, 0))
    }
}
