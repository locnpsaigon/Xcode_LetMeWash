//
//  Cart.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/19/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class Cart {
    
    static var cartItems:[CartItem] = []
    
    /**
        Remove all cart items
     */
    static func removeAllItems() {
        self.cartItems.removeAll()
    }
    
    /**
        Remove a cart item details
     */
    static func removeCartItemServiceDetails(itemId: Int) {
        var count = cartItems.count - 1
        // remove item details
        while count >= 0 {
            let item = cartItems[count]
            var count2 = item.serviceDetails.count - 1
            while count2 >= 0 {
                let detail = item.serviceDetails[count2]
                if detail.itemId == itemId {
                    item.serviceDetails.remove(at: count2)
                }
                count2 = count2 - 1
            }
            count = count - 1
        }
        // remove empty card items
        count = cartItems.count - 1
        while count >= 0 {
            let item = cartItems[count]
            if item.serviceDetails.count == 0 {
                cartItems.remove(at: count)
            }
            count = count - 1
        }
    }
    
    /**
        Remove cart item by service id
     */
    static func removeCartItemService(serviceId: Int) {
        var count = cartItems.count - 1
        while count >= 0 {
            let item = cartItems[count]
            if item.service?.serviceId == serviceId {
                cartItems.remove(at: count)
            }
            count = count - 1
        }
    }

    /** 
        Check cart item already existed
     */
    static func cartItemServiceExisted(serviceId:Int) -> Bool {
        var wasExisted = false
        for item in cartItems {
            if item.service?.serviceId == serviceId {
                wasExisted = true
                break
            }
        }
        return wasExisted
    }
    
    /**
        Get total cart items
     */
    static func getItemsCount() -> Int {
        var count = 0
        for item in cartItems {
            count += item.serviceDetails.count
        }
        return count
    }
    
    /**
        Get total cart amount
     */
    static func getTotalAmount() -> Double {
        var amount = Double(0)
        for item in cartItems {
            for details in item.serviceDetails {
                amount += Double(details.price) * Double(details.quantity)
            }
        }
        return amount
    }
}
