//
//  User.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/16/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class User {
    var phone:String?
    var fullname:String?
    var email:String?
    var address:String?
    
    /**
     * Get User instance from a dictonary
     **/
    class func fromDictionary(dict: NSDictionary) -> User? {
        guard let phone = dict["phone"] as? String else { return nil }
        let fullname = dict["fullname"]as? String
        let email = dict["email"]as? String
        let address = dict["address"]as? String
        
        return User(phone: phone, fullname: fullname, email: email, address: address)
    }
    
    /**
     * Get users from an array
     **/
    class func fromArray(arr: NSArray) -> [User] {
        var users:[User] = []
        for item in arr {
            if let dict = item as? NSDictionary {
                if let user = User.fromDictionary(dict: dict) {
                    users.append(user)
                }
            }
        }
        return users
    }
    
    init(phone:String, fullname:String?, email:String?, address:String?) {
        self.phone = phone
        self.fullname = fullname
        self.email = email
        self.address = address
    }
}
