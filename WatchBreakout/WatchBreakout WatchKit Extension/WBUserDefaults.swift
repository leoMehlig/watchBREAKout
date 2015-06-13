//
//  WBUserDefaults.swift
//  WatchBreakout
//
//  Created by Leo Mehlig on 6/13/15.
//  Copyright © 2015 Scholar Watch Hackathon. All rights reserved.
//

import Foundation


struct WBUserDefaults {
    private struct Keys {
        static let HighscoreHistory = "HighscoreHistory"
    }
    private static let userDefault = NSUserDefaults.standardUserDefaults()
    private static let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
        }()
    
    static var highscoreHistory: [NSDate : Int] {
        get {
        var dict: [NSDate : Int] = [:]
        for (str, number) in userDefault.dictionaryForKey(Keys.HighscoreHistory) ?? [:] {
        if let date = dateFormatter.dateFromString(str), let i = number as? Int {
        dict[date] = i
        }
        }
        return dict
        }
        set {
            var dict: [String : NSNumber] = [:]
            for (date, i) in newValue {
                dict[dateFormatter.stringFromDate(date)] = NSNumber(integer: i)
                
            }
            userDefault.setObject(dict, forKey: Keys.HighscoreHistory)
        }
    }
}