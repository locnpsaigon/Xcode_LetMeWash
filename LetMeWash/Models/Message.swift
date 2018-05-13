//
//  Message.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/14/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class Message {
    
    static let STATUS_UNREAD = 1
    static let STATUS_READ = 2
    static let STATUS_REMOVED = 3
    
    var messageId:Int
    var date:String?
    var phone:String?
    var title:String?
    var message:String?
    var status:Int
    
    /**
     * Get message instance from Dictionary and Array
     **/
    class func fromDictionary(dict: NSDictionary) -> Message? {
        guard let messageId = dict["messageId"] as? Int else {
            return nil
        }
        guard let title = dict["title"] as? String else {
            return nil
        }
        guard let status = dict["status"] as? Int else {
            return nil
        }
        let date = dict["date"] as? String
        let phone = dict["phone"] as? String
        let message = dict["message"] as? String
    
        return Message(messageId: messageId, date: date, phone: phone, title: title, message: message, status: status)
    }
    
    class func fromArray(arr: NSArray) -> [Message] {
        var messages:[Message] = []
        for item in arr {
            if let dict = item as? NSDictionary {
                if let message = Message.fromDictionary(dict: dict) {
                    messages.append(message)
                }
            }
        }
        return messages
    }
    
    /**
     * Constructors
     **/
    init() {
        self.messageId = 0
        self.date = ""
        self.phone = ""
        self.title = ""
        self.message = ""
        self.status = 1
    }
    
    init(messageId:Int?, date:String?, phone:String?, title:String?, message:String?, status:Int?) {
        self.messageId = messageId ?? 0
        self.date = date
        self.phone = phone
        self.title  = title
        self.message = message
        self.status = status ?? 0
    }
}
