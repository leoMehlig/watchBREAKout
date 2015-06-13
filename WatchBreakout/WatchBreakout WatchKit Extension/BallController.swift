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
    
    //MARK: Initizializers
    
    init(gameRect:CGRect, ball: WKInterfaceImage, ballSize: CGSize, group: WKInterfaceGroup) {
        self.ball = ball
        self.gameRect = gameRect
        self.ballGroup = group
        self.ballSize = ballSize
        
        
//        let leftWall = CGRect(x: -1, y: -1, width: 1, height: gameRect.height + 2)
//        let rightWall = CGRect(x: gameRect.origin.x, y: -1, width: 1, height: gameRect.height + 2)
//        let topWall = CGRect(x: -1, y: -1, width: gameRect.width + 2, height: 1)
//        let bottomWall = CGRect(x: -1, y: gameRect.origin.y, width: gameRect.width + 2, height: 1)
//        
//        obstacles += [leftWall, rightWall, topWall, bottomWall]
        
        // fixed 10fps for development
        NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("gameLoop"), userInfo: nil, repeats: true)
    }
    
    //MARK: Private vars
    
    var ballDirection: Float = 0 // radian
    var ballSpeed: Float = 0 // pixels per millisecond
    
    
    var obstacles = [CGRectZero]
    
    
    private var lastFrameUpdate: NSDate = NSDate()
    private var lastNotCollidedPoint = CGPointZero
    //MARK: main game loop
    
    @objc func gameLoop() { //called every frame
        
        //TODO: move calculations out of main loop to improve performance
        print(ballDirection)
        print(lastNotCollidedPoint)
        let timeDeltaSinceLastFrame = Float(lastFrameUpdate.timeIntervalSinceNow * -1000.0) // milliseconds
        lastFrameUpdate = NSDate()
        let deltaX = cos(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        let deltaY = sin(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        
        let delta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
        
        let possiblyNewBallPosition = currentBallPosition + delta
        
        
        for obstacle in obstacles {
            if let wallCollisionPosition = ballCollides(atPoint: possiblyNewBallPosition, withWall: obstacle) {
                
                ballDirection = newDirectionAfterCollision(ballDirection, wallDirection: wallCollisionPosition)
                currentBallPosition = lastNotCollidedPoint
                return
            }
        }
        
        
        currentBallPosition = possiblyNewBallPosition
        lastNotCollidedPoint = possiblyNewBallPosition
        
    }
    
    
    
    // Update real ball position on var change
    private var currentBallPosition: CGPoint = CGPoint(x: 30, y: 30) {
        didSet {
            // compute insets
            var insets = UIEdgeInsets()
            insets.left = currentBallPosition.x + self.ballSize.width / 2
            insets.top = currentBallPosition.y + self.ballSize.height / 2
            
            self.ballGroup.setContentInset(insets)
            
            //print(NSStringFromCGPoint(self.currentBallPosition))
            
        }
    }
    
    
    
    //MARK: Collision Detection 
    
    private func ballCollides(atPoint position: CGPoint, withWall wall: CGRect) -> WallPosition? {
        
        // check for gamerect bounds
        if position.x > gameRect.width {
            print("\(NSStringFromCGPoint(position)) is inside \(NSStringFromCGRect(wall))")
            return .Right
        }
        if position.y > gameRect.height {
            return .Down
        }
        if position.y < 0 {
            return .Up
        }
        if position.x < 0 {
            return .Left
        }
        
        
        
        if CGRectContainsPoint(wall, position) {
            
            if position.x > wall.origin.x {
                return .Right // there is a wall on the right
                //     |||
                //   -> *|
                //     |||
            }
            else if position.x < wall.origin.x + wall.size.width {
                return .Left
            }
            else if position.y < wall.origin.y + wall.size.height {
                return .Up
            }
            else if position.y > wall.origin.y {
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
    
    
    private func newDirectionAfterCollision(originalDirection: Float, wallDirection: WallPosition) -> Float{
        switch wallDirection {
        case .Right:
            return originalDirection - Float(M_PI / 2)
        case .Left:
            return originalDirection - Float(M_PI / 2)
        case .Up:
            return originalDirection - Float(M_PI / 2)
        case .Down:
            return originalDirection - Float(M_PI / 2)
        }
    }
    
    private enum WallPosition {
        case Up, Down, Left, Right
    }
    
    
    
}

//MARK: helper functions

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}