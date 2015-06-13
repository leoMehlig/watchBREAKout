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
        
        // fixed 10fps for development
        NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: Selector("gameLoop"), userInfo: nil, repeats: true)
    }
    
    //MARK: Private vars
    
    var ballDirection: Float = 0 // radian
    var ballSpeed: Float = 0 // pixels per millisecond
    
    private var lastFrameUpdate: NSDate = NSDate()
    
    //MARK: main game loop
    
    @objc func gameLoop() { //called every frame
        
        let timeDeltaSinceLastFrame = Float(lastFrameUpdate.timeIntervalSinceNow * -1000.0) // milliseconds
        lastFrameUpdate = NSDate()
        let deltaX = cos(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        let deltaY = sin(ballDirection) *  (ballSpeed * timeDeltaSinceLastFrame)//...
        
        let delta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
        
        let possiblyNewBallPosition = currentBallPosition + delta
        
        currentBallPosition = possiblyNewBallPosition
        

    }
    
    
    // Update real ball position on var change
    private var currentBallPosition: CGPoint = CGPointZero {
        didSet {
            // compute insets
            var insets = UIEdgeInsets()
            insets.left = currentBallPosition.x + self.ballSize.width / 2
            insets.top = currentBallPosition.y + self.ballSize.height / 2
            
            self.ballGroup.setContentInset(insets)
            
            print(NSStringFromCGPoint(self.currentBallPosition))
            
        }
    }
    
    
    
    
    
}


public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}