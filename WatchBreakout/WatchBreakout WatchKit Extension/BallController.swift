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
    
    var obstacles = [CGRectZero]
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
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("gameLoop"), userInfo: nil, repeats: true)
    }
    
    func pauseGame() {
        gameTimer?.invalidate()
    }
    
    
    //MARK: Private vars
    
    private var gameTimer: NSTimer!
    private var lastFrameUpdate: NSDate = NSDate()
    private var lastNotCollidedPoint = CGPointZero
    //MARK: main game loop
    
    @objc func gameLoop() { //called every frame
        
        let timeDeltaSinceLastFrame = Float(lastFrameUpdate.timeIntervalSinceNow * -1000.0) // milliseconds
        lastFrameUpdate = NSDate()
        let deltaX = cos(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        let deltaY = sin(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        
        let delta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
        
        let possiblyNewBallPosition = currentBallPosition + delta
        
        
        for obstacle in obstacles {
            if let wallCollisionPosition = ballCollides(atPoint: possiblyNewBallPosition, withWall: obstacle) {
                
                ballDirection = (newDirectionAfterCollision(ballDirection, wallDirection: wallCollisionPosition) % Float(M_PI * 2))
                currentBallPosition = lastNotCollidedPoint
                return
            }
        }
        
        
        currentBallPosition = possiblyNewBallPosition
        lastNotCollidedPoint = possiblyNewBallPosition
        
    }
    
    
    
    // Update real ball position on var change
    private var currentBallPosition: CGPoint = CGPoint(x: 15, y: 30) {
        didSet {
            // compute insets
            var insets = UIEdgeInsets()
            insets.left = currentBallPosition.x + self.ballSize.width / 2
            insets.top = currentBallPosition.y + self.ballSize.height / 2
            
            self.ballGroup.setContentInset(insets)
            
        }
    }
    
    
    
    //MARK: Collision Detection
    
    private func ballCollides(atPoint position: CGPoint, withWall wall: CGRect) -> WallPosition? {
        
        // check for gamerect bounds
        if position.x - ballSize.width / 2 > gameRect.width {
            self.delegate?.ballDidHitWall?()
            print("\(NSStringFromCGPoint(position)) is inside \(NSStringFromCGRect(wall))")
            return .Right
        }
        if position.y - ballSize.height / 2 > gameRect.height{
            // check if we hit the paddle
            if position.x + ballSize.width + 5 >= paddleRect.origin.x && position.x + ballSize.width <= paddleRect.origin.x + paddleRect.size.width + 5 {
                print("did hit paddle")
                self.delegate?.ballDidHitPaddle?()
                return .Paddle
            }
            else {
                // game over
                
                self.delegate?.ballDidMissPaddle?()
                
                currentBallPosition = CGPoint(x: 30, y: 30)
                lastNotCollidedPoint = CGPoint(x: 30, y: 30)
                lastFrameUpdate = NSDate()
                return nil
            }
            
            
        }
        if position.y + ballSize.height / 2 < 0 {
            self.delegate?.ballDidHitWall?()
            return .Up
        }
        if position.x + ballSize.width / 2 < 0 {
            self.delegate?.ballDidHitWall?()
            return .Left
        }
        
        
        
        if CGRectContainsPoint(wall, position) {
            
            if position.x > wall.origin.x {
                
                self.delegate?.ballDidHitObstacle?(wall)
                
                return .Right // there is a wall on the right
                //     |||
                //   -> *|
                //     |||
            }
            else if position.x < wall.origin.x + wall.size.width {
                self.delegate?.ballDidHitObstacle?(wall)
                return .Left
            }
            else if position.y < wall.origin.y + wall.size.height {
                self.delegate?.ballDidHitObstacle?(wall)
                return .Up
            }
            else if position.y > wall.origin.y {
                self.delegate?.ballDidHitObstacle?(wall)
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
            return abs(straightDirection - Float(M_PI)) - offsetFromStraight - Float(percentage / 2)
            
            
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
    optional func ballDidHitObstacle(obstacle: CGRect)
}


//MARK: helper functions

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}