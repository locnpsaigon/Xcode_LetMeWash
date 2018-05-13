//
//  ServiceBooking.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/23/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class ServiceBooking {
    var groupId:Int = 0
    var groupName:String = ""
    var serviceId:Int = 0
    var serviceName:String = ""
    var totalAmount:Double = 0
    var discountAmount:Double = 0
    var paymentAmount:Double = 0
    var details:[ServiceDetails] = []
}
