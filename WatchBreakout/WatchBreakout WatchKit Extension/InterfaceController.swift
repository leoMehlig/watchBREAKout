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
        let editedScreenWidth = screenWidth - 60
        print(editedScreenWidth)
        for _ in 0...editedScreenWidth/2{
            let item = WKPickerItem()
            item.contentImage = WKImage(image: UIImage(named: "Pixel")!)
            items.append(item)
        }
        
        picker.setItems(items)
        
        ballController = BallController(gameRect: CGRect(origin: CGPointZero, size: CGSize(width: 152, height: 161)), ball: ball, ballSize: CGSize(width: 20, height: 20), group: ballGroup)
        ballController.delegate = self
        ballController.ballSpeed = 70 / 1000
        ballController.ballDirection = Float(M_PI * 1.2)
        
        ballController.paddleRect = CGRect(x: 0, y: 0, width: 60, height: 0)
        
        ballGroup.setBackgroundImage(WBUserDefaults.breakoutImageOfSize(CGSize(width: 152, height:  80), inSize: CGSize(width: 152, height: 161), ballcontroller: ballController, add: true))
        

        //ballController.obstacles.removeAtIndex(0)
        
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
        ballController.startGame()
    }
    
    
    

    
    func ballDidHitObstacle(obstacle: CGRect, atIndex: Int) {
        //print("did hit obstacle: \(NSStringFromCGRect(obstacle))")
        
        
        var ary = WBUserDefaults.bricksStatusAry
        if ballController.obstacles.count > atIndex {
           ballController.obstacles[atIndex] = CGRectZero
        }
        
        print("index: \(atIndex)")
        
        if (ary[Int(atIndex / 4)]).count > atIndex % 4 {
            
           ary[Int(atIndex / 4)][atIndex % 4].visible = false
        }
        else {
           // print("hello")
        }
        
       
        WBUserDefaults.bricksStatusAry = ary
        
        let image = WBUserDefaults.breakoutImageOfSize(CGSize(width: 151, height:  80), inSize: CGSize(width: 151, height: 162), ballcontroller: self.ballController, add: false)
        //print(WBUserDefaults.bricksStatusAry)
        self.ballGroup.setBackgroundImage(image)
        
        
        
        
    
        
        
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
        ballController.paddleRect = CGRect(x: CGFloat(value)*2, y: 0, width: 60, height: 0)
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
