//
//  OrderDetails.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/17/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class OrderDetails {
    var id:Int = 0
    var orderId:Int = 0
    var itemId:Int = 0
    var itemName:String = ""
    var serviceId:Int = 0
    var serviceName:String = ""
    var groupId:Int = 0
    var groupName:String = ""
    var unit:String = ""
    var quantity:Int = 0
    var price:Double = 0
    var priceOriginal:Double = 0
    
    init(id:Int, orderId:Int, itemId:Int, itemName:String?, serviceId:Int, serviceName:String?, groupId:Int, groupName:String?, unit:String?, quantity:Int, price:Double, priceOriginal:Double) {
        self.id = id
        self.orderId = orderId
        self.itemId = itemId
        self.itemName = itemName ?? ""
        self.serviceId = serviceId
        self.serviceName = serviceName ?? ""
        self.groupId = groupId
        self.groupName = groupName ?? ""
        self.unit = unit ?? ""
        self.quantity = quantity
        self.price = price
        self.priceOriginal = priceOriginal
    }
    
    /**
     * Get order instance from a dictionary
     */
    class func fromDictionary(dict:NSDictionary) -> OrderDetails? {
        guard let id = dict["id"] as? Int else {
            return nil
        }
        guard let orderId = dict["orderId"] as? Int else {
            return nil
        }
        guard let itemId = dict["itemId"] as? Int else {
            return nil
        }
        guard let serviceId = dict["serviceId"] as? Int else {
            return nil
        }
        guard let groupId = dict["groupId"] as? Int else {
            return nil
        }
        guard let quantity = dict["quantity"] as? Int else {
            return nil
        }
        guard let price = dict["price"] as? Double else {
            return nil
        }
        guard let priceOriginal = dict["priceOriginal"] as? Double else {
            return nil
        }
        let itemName = dict["itemName"] as? String
        let serviceName = dict["serviceName"]  as? String
        let groupName = dict["groupName"] as? String
        let unit = dict["unit"] as? String
        
        return OrderDetails(id: id, orderId: orderId, itemId: itemId, itemName: itemName, serviceId: serviceId, serviceName: serviceName, groupId: groupId, groupName: groupName, unit: unit, quantity: quantity, price: price, priceOriginal: priceOriginal)
    }
    
    /**
     * Get order list from NSArray
     */
    class func fromArray(arr: NSArray) -> [OrderDetails] {
        var orders:[OrderDetails] = []
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
