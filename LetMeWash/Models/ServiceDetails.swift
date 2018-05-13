//
//  ServiceDetails.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 12/28/17.
//  Copyright © 2017 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class ServiceDetails {
    var itemId:Int?
    var itemName:String?
    var serviceId:Int?
    var serviceName:String?
    var groupId:Int?
    var groupName:String?
    var unit:String?
    var price:Double = 0
    var priceOriginal:Double = 0
    var quantity:Int = 1
    var selected:Bool = false
    
    init(itemId:Int, itemName:String?, serviceId:Int, serviceName:String?, groupId:Int, groupName:String?, unit:String?, price:Double, priceOriginal:Double) {
        self.itemId = itemId
        self.itemName = itemName
        self.serviceId = serviceId
        self.serviceName = serviceName
        self.groupId = groupId
        self.groupName = groupName
        self.unit = unit
        self.price = price
        self.quantity = 1
        self.priceOriginal = priceOriginal
    }
    
    /**
        Get service details from dictionary
    */
    class func fromDictionary(dict:NSDictionary) -> ServiceDetails? {
        guard let itemId = dict["itemId"] as? Int else {
            return nil
        }
        guard let serviceId = dict["serviceId"] as? Int else {
            return nil
        }
        guard let groupId = dict["groupId"] as? Int else {
            return nil
        }
        let itemName = dict["itemName"] as? String
        let serviceName = dict["serviceName"] as? String
        let groupName = dict["groupName"] as? String
        let unit = dict["unit"] as? String
        let price = (dict["price"] as? Double) ?? 0
        let priceOriginal = (dict["priceOriginal"] as? Double) ?? 0
        
        return ServiceDetails(itemId: itemId, itemName: itemName, serviceId: serviceId, serviceName: serviceName, groupId: groupId, groupName: groupName, unit: unit, price: price, priceOriginal: priceOriginal)
    }
    
    /**
        GET service details from array
    */
    class func fromArray(arr:NSArray) -> [ServiceDetails] {
        var serviceDetails:[ServiceDetails] = []
        for item in arr {
            if let dict = item as? NSDictionary {
                if let obj = ServiceDetails.fromDictionary(dict: dict) {
                    serviceDetails.append(obj)
                }
            }
        }
        return serviceDetails

    }
    
}
