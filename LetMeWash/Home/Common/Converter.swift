//
//  Converter.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 1/12/18.
//  Copyright © 2018 Nguyen Phuoc Loc. All rights reserved.
//

import Foundation

class Converter {
    class func getDate(dateString:String) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        if(dateString.count == 19)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss" //This is the format returned by .Net website
        }
        else if(dateString.count == 21)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.S" //This is the format returned by .Net website
        }
        else if(dateString.count == 22)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SS" //This is the format returned by .Net website
        }
        else if(dateString.count == 23)
        {
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS"
        }
        
        let date = dateFormatter.date(from: dateString as String)
        
        return date
        
    }
}

