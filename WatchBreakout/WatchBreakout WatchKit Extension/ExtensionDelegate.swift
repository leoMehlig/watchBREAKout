//
//  ExtensionDelegate.swift
//  WatchBreakout WatchKit Extension
//
//  Created by Leo Mehlig on 6/13/15.
//  Copyright © 2015 Scholar Watch Hackathon. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        let array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
        
        
        for number in array {
            print("Item \(number): [\(Int(number / 4)) : \(number % 4)]")
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
