//
//  ServiceGroup.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 12/27/17.
//  Copyright © 2017 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class ServiceGroup  {
    var groupId: Int?
    var groupName: String?
    var iconURL: String?
    var description: String?
    var fullDescription: String?
    
    init(groupId: Int, groupName: String, iconUrl: String?, description: String?, fullDescription: String?) {
        self.groupId = groupId
        self.groupName = groupName
        self.iconURL = iconUrl
        self.description = description
        self.fullDescription = fullDescription
    }
    
    /**
        Get service group from a dictionary
    */
    class func fromDictionary(dict: NSDictionary) -> ServiceGroup? {
        guard let groupId = dict["groupId"] as? Int else {
            return nil
        }
        guard let groupName = dict["groupName"] as? String else {
            return nil
        }
        var iconURL:String? = dict["iconURL"] as? String
        var description:String? = dict["description"] as? String
        var fullDescription:String? = dict["fullDescription"] as? String
        iconURL = iconURL ?? ""
        description = description ?? ""
        fullDescription = fullDescription ?? ""
        
        return ServiceGroup(
            groupId: groupId,
            groupName: groupName,
            iconUrl: iconURL,
            description: description,
            fullDescription: fullDescription
        )
    }
    
    /**
        Get service group array from a dictionary array
     */
    class func fromArray(arr: NSArray) -> [ServiceGroup] {
        var groups:[ServiceGroup] = []
        for item in arr {
            if let dict = item as? NSDictionary {
                if let group = fromDictionary(dict: dict) {
                    groups.append(group)
                }
            }
        }
        return groups
    }
    
}
