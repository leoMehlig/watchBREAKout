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
    var score = 0
    var countdownSeconds = 3

    var ballController: BallController!
    let screenWidth = Int(WKInterfaceDevice.currentDevice().screenBounds.size.width)
    let screenHeight = Int(WKInterfaceDevice.currentDevice().screenBounds.size.height)
    private var countdownTimer: NSTimer!

    @IBOutlet var ballGroup: WKInterfaceGroup!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let editedScreenWidth = screenWidth - 40
        print(editedScreenWidth)
        for _ in 0...editedScreenWidth/2{
            let item = WKPickerItem()
            item.contentImage = WKImage(image: UIImage(named: "Pixel")!)
            items.append(item)
        }
        
        picker.setItems(items)
        
        ballController = BallController(gameRect: CGRect(origin: CGPointZero, size: CGSize(width: screenWidth, height: screenHeight-25)), ball: ball, ballSize: CGSize(width: 20, height: 20), group: ballGroup)
        ballController.delegate = self
        ballController.ballSpeed = 70 / 1000
        ballController.ballDirection = Float(M_PI * 1.2)
        
        ballController.paddleRect = CGRect(x: 0, y: 0, width: 45, height: 0)
        
        ballGroup.setBackgroundImage(WBUserDefaults.breakoutImageOfSize(CGSize(width: 151, height:  80), inSize: CGSize(width: 151, height: screenHeight-25), ballcontroller: self.ballController, add: true))
        
        print(ballController.obstacles)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        WBUserDefaults.bricksStatusAry = WBUserDefaults.randomBreakoutStatusAry
        let image = WBUserDefaults.breakoutImageOfSize(CGSize(width: 151, height:  80), inSize: CGSize(width: 151, height: screenHeight-25), ballcontroller: self.ballController, add: true)
        //print(WBUserDefaults.bricksStatusAry)
        self.ballGroup.setBackgroundImage(image)
        countdownSeconds = 3
        picker.focusForCrownInput()
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdown"), userInfo: nil, repeats: true)
        ballController.pauseGame()
    }
    
    func countdown(){
        countdownSeconds -= 1
        if (countdownSeconds == 0){
            countdownTimer.invalidate()
            ballController.startGame()
        }
//        print(countdownSeconds)
    }
    //MARK: BallControllerDelegate
    
    func ballDidMissPaddle() {
        ballController.pauseGame()
        WKInterfaceDevice.currentDevice().playHaptic(.Failure)
        self.presentControllerWithName("gameOver", context: score)
        //        ballController.startGame()
    }
    
    
    var totalHitPaddles = 0.0
    func ballDidHitObstacle(obstacle: CGRect, atIndex: Int) {
        print("did hit obstacle: \(NSStringFromCGRect(obstacle))")
        
        
        var ary = WBUserDefaults.bricksStatusAry
        if ballController.obstacles.count > atIndex {
            ballController.obstacles[atIndex] = CGRectZero
        }
        
        print("index: \(atIndex)")
        
        if (ary[Int(atIndex / 5)]).count > atIndex % 5 {
            let brick = ary[Int(atIndex / 5)][atIndex % 5]
            brick.visible = false
            switch (brick.color){
            case WBUserDefaults.BrickTypes.SpeedUp:
                score += 5
                ballController.ballSpeed *= 1.25
                break;
                
            case WBUserDefaults.BrickTypes.BonusPoints:
                score += 20
                break;
                
            case WBUserDefaults.BrickTypes.SlowDown:
                score += 2
                ballController.ballSpeed *= 0.75
                break;
                
            case WBUserDefaults.BrickTypes.Normal:
                score += 1
                break;
                
            default:
                break;
            }
        }
        else {
            // print("hello")
        }
        
        
        WBUserDefaults.bricksStatusAry = ary
        
        let image = WBUserDefaults.breakoutImageOfSize(CGSize(width: 151, height:  80), inSize: CGSize(width: 151, height: screenHeight-25), ballcontroller: self.ballController, add: false)
        //print(WBUserDefaults.bricksStatusAry)
        self.ballGroup.setBackgroundImage(image)
        
        
        totalHitPaddles += 1
        print (totalHitPaddles / 16)
        print (((totalHitPaddles / 16)  % 1))
        print (((totalHitPaddles / 16)  % 1) == 0)
        if (((totalHitPaddles / 16)  % 1) == 0){
            WBUserDefaults.bricksStatusAry = WBUserDefaults.randomBreakoutStatusAry
            let image = WBUserDefaults.breakoutImageOfSize(CGSize(width: 151, height:  80), inSize: CGSize(width: 151, height: screenHeight-25), ballcontroller: self.ballController, add: true)
            //print(WBUserDefaults.bricksStatusAry)
            self.ballGroup.setBackgroundImage(image)
        }
        setTitle("Score: \(score)")
    }
    
    func ballDidHitWall() {
        
    }
    
    func ballDidHitPaddle() {
        WKInterfaceDevice.currentDevice().playHaptic(.Success)
    }
    
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        ballController.pauseGame()
        
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
