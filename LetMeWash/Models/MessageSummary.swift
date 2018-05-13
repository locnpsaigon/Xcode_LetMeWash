//
//  MessageSummary.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/24/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class MessageSummary {
    var read:Int = 0
    var unread:Int = 0
    
    init(read:Int, unread:Int) {
        self.read = read
        self.unread = unread
    }
    
    /**
     * Get MessageSummary instance from NSDictionary
     **/
    class func fromDictionary(dict: NSDictionary) -> MessageSummary? {
        guard let read = dict["Read"] as? Int else {
            return nil
        }
        guard let unread = dict["Unread"] as? Int else {
            return nil
        }
        return MessageSummary(read: read, unread: unread)
    }
    
    /**
     * Get MessageSummary array instance from NSArray
     **/
    class func fromArray(arr: NSArray) -> [MessageSummary] {
        var arrMessageSummary:[MessageSummary] = []
        for item in arr {
            if let dict = item as? NSDictionary {
                if let summary = MessageSummary.fromDictionary(dict: dict) {
                    arrMessageSummary.append(summary)
                }
            }
        }
        return arrMessageSummary
    }

}
