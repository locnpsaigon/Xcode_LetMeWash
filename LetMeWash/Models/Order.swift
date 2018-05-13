//
//  Order.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/9/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class Order {
    
    static let STATUS_OPENED  = 1
    static let STATUS_PENDING = 2
    static let STATUS_PROCESSING  = 3
    static let STATUS_FINSIHED  = 4
    static let STATUS_CLOSED  = 5
    
    var orderId:Int = 0
    var date:String?
    var phone:String?
    var fullname:String?
    var address:String?
    var amount:Double
    var status:Int
    var note:String?
    var title:String?
    
    init(orderId:Int, date:String?, phone:String?, fullname:String?, address:String?, amount:Double, status:Int, note:String?, title:String?) {
        self.orderId = orderId
        self.date = date
        self.phone = phone
        self.fullname = fullname
        self.address = address
        self.amount = amount
        self.status  = status
        self.note = note
        self.title = title
    }
    
    /**
     * Get order instance from a dictionary
     */
    class func fromDictionary(dict:NSDictionary) -> Order? {
        guard let orderId = dict["orderId"] as? Int else {
            return nil
        }
        guard let amount = dict["amount"] as? Double else {
            return nil
        }
        guard let status = dict["status"] as? Int else {
            return nil
        }
        let date = dict["date"] as? String
        let phone = dict["phone"] as? String
        let fullname = dict["fullname"] as? String
        let address = dict["address"] as? String
        let note = dict["note"] as? String
        let title = dict["title"] as? String
        
        return Order(orderId: orderId, date: date, phone: phone, fullname: fullname, address: address, amount: amount, status: status, note: note, title: title)
    }
    
    /**
     * Get order list from NSArray
     */
    class func fromArray(arr: NSArray) -> [Order] {
        var orders:[Order] = []
        for item in arr {
            if let dict = item as? NSDictionary {
                if let order = fromDictionary(dict: dict) {
                    orders.append(order)
                }
            }
        }
        return orders
    }
}
