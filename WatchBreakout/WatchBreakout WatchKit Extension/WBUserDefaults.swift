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
        static let ScoreHistory = "HighscoreHistory"
        static let BricksStatus = "BricksStatus"

    }
    private static let userDefault = NSUserDefaults.standardUserDefaults()
    private static let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
        }()
    
    static var scoreHistory: [NSDate : Int] {
        get {
        var dict: [NSDate : Int] = [:]
        for (str, number) in userDefault.dictionaryForKey(Keys.ScoreHistory) ?? [:] {
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
            userDefault.setObject(dict, forKey: Keys.ScoreHistory)
        }
    }
    
    static var earliestScoreDate: NSDate? {
        let sortedDateAry = Array(scoreHistory.keys).sort { (first, last) -> Bool in
            return first.earlierDate(last) == first
        }
        return sortedDateAry.first
        
    }
    
    static var highscore: Int {
        let sortedDateAry = Array(scoreHistory.values).sort { (first, last) -> Bool in
            return first < last
        }
        return sortedDateAry.last ?? 0
    }
    
    
    
    static var bricksStatusAry: [[Bool]] {
        get {
            return (userDefault.arrayForKey(Keys.BricksStatus) as? [[Bool]]) ?? Array<Array<Bool>>(count: 5, repeatedValue: Array<Bool>(count: 4, repeatedValue: true))
        }
        set {
            if newValue.count == 5 {
                if newValue.filter({ $0.count != 4 }).isEmpty {
                    userDefault.setObject(newValue, forKey: Keys.BricksStatus)
                }
            }
        }
    }
}