//
//  AppSharedInstance.swift
//  ServiceBook
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class AppSharedInstance: NSObject {
    
    static let sharedInstance = AppSharedInstance()
    
   let appdelegate = UIApplication.shared.delegate as! AppDelegate

    let myDateFormatter = "dd MMM yyyy"
    
    func getTimeDuration(startDate : String, endDate : String, formatterType : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formatterType
        
        let sd = dateFormatterGet.date(from: startDate)
        let ed = dateFormatterGet.date(from: endDate)
        
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 0
        form.unitsStyle = .full
        form.allowedUnits = [.year, .month, .day]
        let finalStr = form.string(from: sd!, to: ed!)
        
        return finalStr!
    }
    
    func getFormattedStr(formatterType : String, dateObj : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterType
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: dateObj as Date)
    }

    
   
}
