//
//  Service.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 12/28/17.
//  Copyright © 2017 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class Service {
    var serviceId:Int?
    var serviceName:String?
    var groupId:Int?
    var groupName:String?
    var iconUrl:String?
    var description:String?
    
    init(serviceId:Int, serviceName:String, groupId:Int, groupName:String, iconUrl:String?, description:String?) {
        self.serviceId = serviceId
        self.serviceName = serviceName
        self.groupId = groupId
        self.groupName = groupName
        self.iconUrl = iconUrl
        self.description = description
    }
    
    /**
        GET service instance from an dictionary
    */
    class func fromDistionary(dict: NSDictionary) -> Service? {
        guard let serviceId = dict["serviceId"] as? Int else {
            return nil
        }
        guard let serviceName = dict["serviceName"] as? String else {
            return nil
        }
        guard let groupId = dict["groupId"] as? Int else {
            return nil
        }
        guard let groupName = dict["groupName"] as? String else {
            return nil
        }
        let iconUrl = dict["iconURL"] as? String
        let description = dict["description"] as? String
        
        return Service(serviceId: serviceId, serviceName: serviceName, groupId: groupId, groupName: groupName, iconUrl: iconUrl, description: description)
    }
    
    /**
        GET service instance array from NSArray
    */
    class func fromArray(arr: NSArray) -> [Service] {
        var services:[Service] = []
        for item in arr {
            if let dict = item as? NSDictionary {
                if let service = Service.fromDistionary(dict: dict) {
                    services.append(service)
                }
            }
        }
        return services
    }
    
}
