//
//  CartItem.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/19/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class CartItem {
    var service:Service?
    var serviceDetails:[ServiceDetails] = []
    
    /**
     *  Get total amount
     */
    func getTotalAmount() -> Double {
        var total = Double(0)
        for item in serviceDetails {
            total += item.priceOriginal * Double(item.quantity)
        }
        return total
    }
    
    /**
     *  Get discount amount
     */
    func getDiscountAmount() -> Double {
        var discount = Double(0)
        for item in serviceDetails {
            if item.price < item.priceOriginal && item.priceOriginal > 0 {
                discount += (item.priceOriginal - item.price) * Double(item.quantity)
            }
        }
        return discount
    }
    
    /**
     *  Get payment amount
     */
    func getPaymentAmount() -> Double {
        var payment = Double(0)
        for item in serviceDetails {
            payment += item.price * Double(item.quantity)
        }
        return payment
    }
}
