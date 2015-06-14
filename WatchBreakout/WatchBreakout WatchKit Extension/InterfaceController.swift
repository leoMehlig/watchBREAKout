//
//  InterfaceController.swift
//  WatchBreakout WatchKit Extension
//
//  Created by Leo Mehlig on 6/13/15.
//  Copyright © 2015 Scholar Watch Hackathon. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, BallControllerDelegate {

    @IBOutlet var paddle: WKInterfaceGroup!
    @IBOutlet var picker: WKInterfacePicker!
    var items = [WKPickerItem]()
    @IBOutlet var paddleGroup: WKInterfaceGroup!
    @IBOutlet var ball: WKInterfaceImage!
    
    
    var ballController: BallController!
    let screenWidth = Int(WKInterfaceDevice.currentDevice().screenBounds.size.width)

    @IBOutlet var ballGroup: WKInterfaceGroup!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let editedScreenWidth = screenWidth - 30
        print(editedScreenWidth)
        for _ in 0...editedScreenWidth/2{
            let item = WKPickerItem()
            item.contentImage = WKImage(image: UIImage(named: "Pixel")!)
            items.append(item)
        }
        
        picker.setItems(items)
        
        ballController = BallController(gameRect: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 120)), ball: ball, ballSize: CGSize(width: 20, height: 20), group: ballGroup)
        ballController.delegate = self
        ballController.ballSpeed = 20 / 500
        ballController.ballDirection = Float(M_PI * 1.6)
        
        ballController.paddleRect = CGRect(x: 0, y: 0, width: 30, height: 0)
        
        ballGroup.setBackgroundImage(WBUserDefaults.breakoutImageOfSize(CGSize(width: screenWidth, height:  20), inSize: CGSize(width: screenWidth, height: 131), ballcontroller: ballController))
        

        
        
        print(ballController.obstacles)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        picker.focusForCrownInput()
//        var scale = WKInterfaceDevice.currentDevice().screenScale
//        var screenWidth = Int(WKInterfaceDevice.currentDevice().screenBounds.size.width-30)
//        var screenHeight = Int(WKInterfaceDevice.currentDevice().screenBounds.size.height)

        
        ballController.startGame()
        
        //ballController.obstacles.append(CGRect(x: 20, y: 20, width: 30, height: 10))
        
        
    }
    
    //MARK: BallControllerDelegate
    
    func ballDidMissPaddle() {
        ballController.pauseGame()
        WKInterfaceDevice.currentDevice().playHaptic(.Failure)
    }
    
    
    

    
    func ballDidHitObstacle(obstacle: CGRect, atIndex: Int) {
        print("did hit obstacle: \(NSStringFromCGRect(obstacle))")
        
        let i = atIndex / 4
        var ary = WBUserDefaults.bricksStatusAry
        ary[i][atIndex % 5].visible = false
        WBUserDefaults.bricksStatusAry = ary
        
        ballController.obstacles.removeAtIndex(atIndex)
        
        ballGroup.setBackgroundImage(WBUserDefaults.breakoutImageOfSize(CGSize(width: screenWidth, height: 20), inSize: CGSize(width: screenWidth, height: 131)))
    
        
        
    }
    
    func ballDidHitWall() {
        
    }
    
    func ballDidHitPaddle() {
        WKInterfaceDevice.currentDevice().playHaptic(.Success)
    }
    
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pickerValueChanged(value: Int) {
        paddleGroup.setContentInset(UIEdgeInsetsMake(0, CGFloat(value)*2, 0, 0))
        ballController.paddleRect = CGRect(x: CGFloat(value)*2, y: 0, width: 30, height: 0)
    }
    
    var blueBrick = UIColor(red:0.204, green:0.596, blue:0.859, alpha:1.0)
    var redBrick = UIColor(red:0.906, green:0.298, blue:0.235, alpha:1.0)
    var purpleBrick = UIColor(red:0.608, green:0.349, blue:0.714, alpha:1.0)
    var greenBrick = UIColor(red:0.086, green:0.627, blue:0.522, alpha:1.0)
    var whiteBrick = UIColor.whiteColor()

    var whiteBricks = 0
    func randomBrickImage() -> UIColor! {
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
            return UIColor.whiteColor()
        }
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
