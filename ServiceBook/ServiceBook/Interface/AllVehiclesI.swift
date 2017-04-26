//
//  AllVehiclesI.swift
//  ServiceBook
//
//  Created by Apple on 24/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class AllVehiclesI: NSObject {
    
    //setter and getters
    public var vehicleID: String
    public var vehicleType: String?
    public var vehicleName: String?
    public var vehicleNo: String?
    public var serviceRequiredAfter: Int?
    public var averageRun: Int?
    public var lastServiceDate: Date?
    public var notes: String?
    public var serviceDueDate : Date?
    
    override init()
    {
        self.vehicleID = ""
        self.vehicleType = ""
        self.vehicleName = ""
        self.vehicleNo = ""
//        self.serviceRequiredAfter = 0
//        self.averageRun = 0
        self.notes = ""
    }
}
