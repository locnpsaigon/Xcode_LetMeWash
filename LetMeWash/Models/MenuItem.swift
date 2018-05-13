//
//  MenuItem.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/14/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class MenuItem {
    var id:String = ""
    var name:String = ""
    var icon:String?
    
    init(id:String, name:String, icon:String?) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
