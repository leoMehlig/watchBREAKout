//
//  BallController.swift
//  WatchBreakout
//
//  Created by Bastian Aigner on 6/13/15.
//  Copyright © 2015 Scholar Watch Hackathon. All rights reserved.
//

import Foundation
import CoreGraphics
import WatchKit

class BallController {
    
    //MARK: Properties
    
    let ball: WKInterfaceImage
    let ballSize: CGSize
    let ballGroup: WKInterfaceGroup
    let gameRect: CGRect
    
    
    var ballDirection: Float = 0 // radian
    var ballSpeed: Float = 0 // pixels per millisecond
    
    var obstacles = [CGRect]()
    var paddleRect = CGRectZero // has to be updated
    
    
    var delegate: BallControllerDelegate?
    
    //MARK: Initizializers
    
    init(gameRect:CGRect, ball: WKInterfaceImage, ballSize: CGSize, group: WKInterfaceGroup) {
        self.ball = ball
        self.gameRect = gameRect
        self.ballGroup = group
        self.ballSize = ballSize
        
    }
    
    
    //MARK: game flow
    
    func startGame() {
        lastFrameUpdate = NSDate()
        let screenSize = WKInterfaceDevice.currentDevice().screenBounds.size
        currentBallPosition = CGPointMake(screenSize.width/2, screenSize.height/2)
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("gameLoop"), userInfo: nil, repeats: true)
    }
    
    func pauseGame() {
        gameTimer?.invalidate()
    }
    
    
    //MARK: Private vars
    
    private var gameTimer: NSTimer!
    private var lastFrameUpdate: NSDate = NSDate()
    private var lastNotCollidedPoint = CGPoint(x: 50, y: 90)
    //MARK: main game loop
    
    @objc func gameLoop() { //called every frame
        let timeDeltaSinceLastFrame = Float(lastFrameUpdate.timeIntervalSinceNow * -1000.0) // milliseconds
        lastFrameUpdate = NSDate()
        let deltaX = cos(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        let deltaY = sin(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        
        let delta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
        
        let possiblyNewBallPosition = currentBallPosition + delta
        
        
        for (index, obstacle) in obstacles.enumerate() {
            if let wallCollisionPosition = ballCollides(atPoint: possiblyNewBallPosition, withWall: obstacle, index: index) {
                
                
                    ballDirection = (newDirectionAfterCollision(ballDirection, wallDirection: wallCollisionPosition) % Float(M_PI * 2))
                    currentBallPosition = lastNotCollidedPoint
                    //print("did set new ball direction: \(ballDirection)")
                    movingoutside = true
                    return
                
                
                break
                
            }
        }
        
        //print(currentBallPosition)
        
        currentBallPosition = possiblyNewBallPosition
        lastNotCollidedPoint = possiblyNewBallPosition
        movingoutside = false
        //print(currentBallPosition)
        //print(ballDirection)
    }
    
    
<<<<<<< HEAD
            // Update real ball position on var change
    private var currentBallPosition: CGPoint = CGPoint(x: 15, y: 30) {
=======
    var movingoutside = false
    
    
    
    // Update real ball position on var change
    private var currentBallPosition: CGPoint = CGPoint(x: 50, y: 90) {
>>>>>>> origin/master
        didSet {
            // compute insets
            var insets = UIEdgeInsets()
            insets.left = currentBallPosition.x - self.ballSize.width / 2
            insets.top = currentBallPosition.y - self.ballSize.height / 2
            
            self.ballGroup.setContentInset(insets)
            
        }
    }
    
    
    
    //MARK: Collision Detection
    
    private func ballCollides(atPoint position: CGPoint, withWall wall: CGRect, index: Int) -> WallPosition? {
        
        // check for gamerect bounds
        if position.x + ballSize.width / 2 > gameRect.width {
            self.delegate?.ballDidHitWall?()
            return .Right
        }
        if position.y + ballSize.height / 2 > gameRect.height{
            // check if we hit the paddle
            if position.x + ballSize.width + 5 >= paddleRect.origin.x && position.x + ballSize.width <= paddleRect.origin.x + paddleRect.size.width + 5 {
                print("did hit paddle")
                self.delegate?.ballDidHitPaddle?()
                return .Paddle
            }
            else {
                // game over
                
                self.delegate?.ballDidMissPaddle?()
                
                currentBallPosition = CGPoint(x: 50, y: 90)
                lastNotCollidedPoint = CGPoint(x: 50, y: 90)
                lastFrameUpdate = NSDate()
                return .Down
            }
            
            
        }
        if position.y - ballSize.height / 2 < 0 {
            self.delegate?.ballDidHitWall?()
            return .Up
        }
        if position.x - ballSize.width / 2 < 0 {
            self.delegate?.ballDidHitWall?()
            return .Left
        }
        
        
        
        if CGRectContainsPoint(wall, position) { //TODO: change to CGRectIntersetsRect:
            
            
            //TODO: actually wrong, will only catch Right & Up - works surprisingly well though
            
            if position.x + ballSize.width / 2 > wall.origin.x && (position.y + ballSize.height / 2 < wall.origin.y + wall.size.height && position.y + ballSize.height / 2 > wall.origin.y){
                
                self.delegate?.ballDidHitObstacle?(wall, atIndex: index)
                
                return .Right // there is a wall on the right
                //     |||
                //   -> *|
                //     |||
            }
            else if position.x - ballSize.width / 2 < wall.origin.x + wall.size.width && (position.y + ballSize.height / 2 < wall.origin.y + wall.size.height && position.y + ballSize.height / 2 > wall.origin.y) {
                self.delegate?.ballDidHitObstacle?(wall, atIndex: index)
                return .Left
            }
            else if position.y - ballSize.height / 2 < wall.origin.y + wall.size.height {
                self.delegate?.ballDidHitObstacle?(wall, atIndex: index)
                return .Up
            }
            else if position.y +  ballSize.height / 2 > wall.origin.y {
                self.delegate?.ballDidHitObstacle?(wall, atIndex: index)
                return .Down
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    // compute
    
    private func newDirectionAfterCollision(originalDirection: Float, wallDirection: WallPosition) -> Float{
        
        
        var straightDirection: Float!
        
        switch wallDirection {
        case .Left:
            straightDirection = Float(M_PI)
            
        case .Right:
            straightDirection = 0
            
        case .Up:
            straightDirection = Float(M_PI * 1.5)
            
        case .Down:
            straightDirection = Float(M_PI * 0.5)
            
            // paddle
        case .Paddle:
            let ballCenterX = currentBallPosition.x
            let paddleWidth = paddleRect.size.width
            let paddleCenterX = paddleRect.origin.x + paddleWidth / 2
            
            let percentage = (paddleCenterX - ballCenterX) / (paddleWidth / 2)
            
            straightDirection = Float(M_PI * 1.5)
            
            let offsetFromStraight = (originalDirection % Float(M_PI * 2)) - straightDirection
            return abs(straightDirection - Float(M_PI)) - offsetFromStraight - Float(percentage / 3)
            
            
        }
        
        
        if let straightDirection = straightDirection {
            let offsetFromStraight = (originalDirection % Float(M_PI * 2)) - straightDirection
            return abs(straightDirection - Float(M_PI)) - offsetFromStraight
        }
        else {
            return Float(M_PI / 2) // should never be executed
        }
        
    }
    
    private enum WallPosition {
        case Up, Down, Left, Right, Paddle
    }
    
    
    
}


@objc protocol BallControllerDelegate {
    optional func ballDidHitPaddle()
    optional func ballDidHitWall()
    optional func ballDidMissPaddle()
    optional func ballDidHitObstacle(obstacle: CGRect, atIndex: Int)
}


//MARK: helper functions

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}