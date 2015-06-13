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

    @IBOutlet var brickRow1: WKInterfaceGroup!
    @IBOutlet var brick1: WKInterfaceGroup!
    @IBOutlet var brick2: WKInterfaceGroup!
    @IBOutlet var brick3: WKInterfaceGroup!
    @IBOutlet var brick4: WKInterfaceGroup!
    
    @IBOutlet var brickRow2: WKInterfaceGroup!
    @IBOutlet var brick5: WKInterfaceGroup!
    @IBOutlet var brick6: WKInterfaceGroup!
    @IBOutlet var brick7: WKInterfaceGroup!
    @IBOutlet var brick8: WKInterfaceGroup!
    
    @IBOutlet var brickRow3: WKInterfaceGroup!
    @IBOutlet var brick9: WKInterfaceGroup!
    @IBOutlet var brick10: WKInterfaceGroup!
    @IBOutlet var brick11: WKInterfaceGroup!
    @IBOutlet var brick12: WKInterfaceGroup!
    
    @IBOutlet var brickRow4: WKInterfaceGroup!
    @IBOutlet var brick13: WKInterfaceGroup!
    @IBOutlet var brick14: WKInterfaceGroup!
    @IBOutlet var brick15: WKInterfaceGroup!
    @IBOutlet var brick16: WKInterfaceGroup!
    
    @IBOutlet var brickRow5: WKInterfaceGroup!
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
        
        brick1.setBackgroundImage(randomBrickImage())
        brick2.setBackgroundImage(randomBrickImage())
        brick3.setBackgroundImage(randomBrickImage())
        brick4.setBackgroundImage(randomBrickImage())
        brick5.setBackgroundImage(randomBrickImage())
        brick6.setBackgroundImage(randomBrickImage())
        brick7.setBackgroundImage(randomBrickImage())
        brick8.setBackgroundImage(randomBrickImage())
        brick9.setBackgroundImage(randomBrickImage())
        brick10.setBackgroundImage(randomBrickImage())
        brick11.setBackgroundImage(randomBrickImage())
        brick12.setBackgroundImage(randomBrickImage())
        brick13.setBackgroundImage(randomBrickImage())
        brick14.setBackgroundImage(randomBrickImage())
        brick15.setBackgroundImage(randomBrickImage())
        brick16.setBackgroundImage(randomBrickImage())
        brick17.setBackgroundImage(randomBrickImage())
        brick18.setBackgroundImage(randomBrickImage())
        brick19.setBackgroundImage(randomBrickImage())
        brick20.setBackgroundImage(randomBrickImage())
        let image = GlanceController.creatBreakoutImageForSize(CGSize(width: 130, height: 100))

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
    
    var blueBrick = UIImage(named: "BlueBrick")
    var redBrick = UIImage(named: "RedBrick")
    var purpleBrick = UIImage(named: "PurpleBrick")
    var greenBrick = UIImage(named: "GreenBrick")
    var whiteBrick = UIImage(named: "WhiteBrick")

    var whiteBricks = 0
    func randomBrickImage() -> UIImage? {
        var rnd = 0
        if (whiteBricks < 4){
            rnd = randomInt(0, max: 4)
        }else{
            rnd = randomInt(0, max: 3)
        }
        if (rnd == 0){
            return blueBrick
        }
        if (rnd == 1){
            return redBrick
        }
        if (rnd == 2){
            return purpleBrick
        }
        if (rnd == 3){
            return greenBrick
        }
        if (rnd == 4){
            return whiteBrick
        }
        else{
            return UIImage()
        }
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
